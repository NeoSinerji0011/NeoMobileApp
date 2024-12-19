import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class AllPolicyResponse {
  bool isOffer = false;
  AllPolicyResponse(this.isOffer) {
    //getKullaniciInfo().whenComplete(() => getAllPoliciesCount());
  }

  Future<Null> getAracPolicyList() async {
    await getKullaniciInfo().whenComplete(() => getAracPoliciesCount());
  }

  Future<Null> getKonutPolicyList() async {
    await getKullaniciInfo().whenComplete(() => getKonutPoliciesCount());
  }

  Future<Null> getDaskPolicyList() async {
    getKullaniciInfo().whenComplete(() => getDaskPoliciesCount());
  }

  Future<Null> getSaglikPolicyList() async {
    getKullaniciInfo().whenComplete(() => getSaglikPoliciesCount());
  }

  Future<Null> getSeyahatPolicyList() async {
    getKullaniciInfo().whenComplete(() => getSeyahatPoliciesCount());
  }

  Future<Null> getDigerPolicyList() async {
    await getKullaniciInfo().whenComplete(() => getDigerPoliciesCount());
  }

  List<String> kullaniciInfo = List<String>();
  var countList = {
    "arac": 0,
    "konut": 0,
    "dask": 0,
    "saglik": 0,
    "seyahat": 0,
    "diger": 0,
    "riskSkoru": 0
  };
  //static var kaskoPolicyList = null;
  static List<PolicyResponse> staticAracPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticTrafikPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticKaskoPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticKonutPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticDaskPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticSaglikPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticGenelSaglikPolicyList =
      List<PolicyResponse>();
  static List<PolicyResponse> staticTamamlayiciSaglikPolicyList =
      List<PolicyResponse>();
  static List<PolicyResponse> staticSeyahatPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticDigerPolicyList = List<PolicyResponse>();
  static List<PolicyResponse> staticTumuPolicyList = List<PolicyResponse>();
  List<PolicyResponse> staticGeciciManuelList = List<PolicyResponse>();

  Future getKullaniciInfo() async {
    Utils.getKullaniciInfo().then((value) {
      kullaniciInfo = value;
    });
  }

  Future<Null> getAllPoliciesCount() async {
    CalculateRisk();
    await getKullaniciInfo().whenComplete(() => getAracPoliciesCount()
        .whenComplete(() => getKonutPoliciesCount().whenComplete(() =>
            getDaskPoliciesCount().whenComplete(() => getSaglikPoliciesCount()
                .whenComplete(() => getSeyahatPoliciesCount().whenComplete(
                    () => getDigerPoliciesCount().whenComplete(() {
                          // print(digerPolicyList.length);
                          //setPolicyIsOffer();
                          staticTumuPolicyList.addAll(staticAracPolicyList +
                              staticDaskPolicyList +
                              staticDigerPolicyList +
                              staticKonutPolicyList +
                              staticSaglikPolicyList +
                              staticSeyahatPolicyList);
                          CalculateRisk.calcPolicy(); 
                          countList["riskSkoru"] = CalculateRisk.riskSkoru;
                          UtilsPolicy.countList["riskSkoru"] =
                              CalculateRisk.riskSkoru;
                        })))))));
  }

  Future<Null> getAracPoliciesCount() async {
    await WebAPI.policiesRequest(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "1")
        .then((responseList) {
      staticTrafikPolicyList.clear();
      staticTrafikPolicyList = responseList;
    }).then((value) {
      WebAPI.policiesRequest(
              token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "2")
          .then((responseList) {
        staticKaskoPolicyList.clear();
        staticKaskoPolicyList = responseList;
        staticKaskoPolicyList = staticKaskoPolicyList;
      }).then((value) {
        staticAracPolicyList.clear();
        staticGeciciManuelList.clear();
        staticGeciciManuelList
            .addAll(staticKaskoPolicyList + staticTrafikPolicyList);

        staticGeciciManuelList.sort((item1, item2) => item1.bitisTarihi
            .toString()
            .compareTo(item2.bitisTarihi.toString()));

        staticAracPolicyList.addAll(staticGeciciManuelList.reversed.toList());
      });
    });
  }

  Future<Null> setPolicyIsOffer(
      List<PolicyResponse> trafikPolicyList,
      List<PolicyResponse> kaskoPolicyList,
      List<PolicyResponse> aracPolicyList,
      List<PolicyResponse> konutPolicyList,
      List<PolicyResponse> daskPolicyList,
      List<PolicyResponse> seyahatPolicyList,
      List<PolicyResponse> genelSaglikPolicyList,
      List<PolicyResponse> tamamlayiciSaglikPolicyList,
      List<PolicyResponse> saglikPolicyList,
      List<PolicyResponse> digerPolicyList,
      List<PolicyResponse> tumuPolicyList) async {
    staticGeciciManuelList.clear();
    for (var item in staticTrafikPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        staticGeciciManuelList.add(item);
      }
    }
    trafikPolicyList.clear();
    trafikPolicyList.addAll(staticGeciciManuelList);

    staticGeciciManuelList.clear();
    for (var item in staticKaskoPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        staticGeciciManuelList.add(item);
      }
    }
    kaskoPolicyList.clear();
    kaskoPolicyList.addAll(staticGeciciManuelList);

    aracPolicyList.clear();

    aracPolicyList.addAll(trafikPolicyList + kaskoPolicyList);

    staticGeciciManuelList.clear();
    for (var item in staticKonutPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        staticGeciciManuelList.add(item);
      }
    }
    konutPolicyList.clear();
    konutPolicyList.addAll(staticGeciciManuelList);

    staticGeciciManuelList.clear();
    for (var item in staticDaskPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        staticGeciciManuelList.add(item);
      }
    }
    daskPolicyList.clear();
    daskPolicyList.addAll(staticGeciciManuelList);

    staticGeciciManuelList.clear();
    genelSaglikPolicyList.clear();
    tamamlayiciSaglikPolicyList.clear();
    for (var item in staticSaglikPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        staticGeciciManuelList.add(item);
        if (item.bransKodu == 8)
          tamamlayiciSaglikPolicyList.add(item);
        else
          genelSaglikPolicyList.add(item);
      }
    }
    saglikPolicyList.clear();

    saglikPolicyList.addAll(staticGeciciManuelList);

    staticGeciciManuelList.clear();
    for (var item in staticSeyahatPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        item.baslangicTarihi = item.seyahatGidisTarihi;
        item.bitisTarihi = item.seyahatDonusTarihi;
        staticGeciciManuelList.add(item);
      }
    }
    seyahatPolicyList.clear();
    seyahatPolicyList.addAll(staticGeciciManuelList);

    staticGeciciManuelList.clear();
    for (var item in staticDigerPolicyList) {
      if (item.teklifPolice == (isOffer ? 1 : 0)) {
        staticGeciciManuelList.add(item);
      }
    }
    digerPolicyList.clear();
    digerPolicyList.addAll(staticGeciciManuelList);

    tumuPolicyList.clear();
    tumuPolicyList.addAll(aracPolicyList +
        konutPolicyList +
        daskPolicyList +
        saglikPolicyList +
        digerPolicyList +
        seyahatPolicyList);
    if (isOffer)
      tumuPolicyList = UtilsPolicy.sortArrayList(tumuPolicyList); 
    else
      tumuPolicyList.sort((item2, item1) =>
          item1.bitisTarihi.toString().compareTo(item2.bitisTarihi.toString()));
    //tumuPolicyList=tumuPolicyList.reversed.toList();

    /*  staticGeciciManuelList.clear();
    staticGeciciManuelList.addAll(tumuPolicyList);

    tumuPolicyList.clear();
    staticGeciciManuelList.sort((item1, item2) =>
        item1.bitisTarihi.toString().compareTo(item2.bitisTarihi.toString()));

    tumuPolicyList.addAll(staticGeciciManuelList.reversed.toList()); */

    countList["arac"] = aracPolicyList.length;
    countList["konut"] = konutPolicyList.length;
    countList["saglik"] = saglikPolicyList.length;
    countList["dask"] = daskPolicyList.length;
    countList["seyahat"] = seyahatPolicyList.length;
    countList["diger"] = digerPolicyList.length;
    countList["toplam"] = tumuPolicyList.length;
  }

  Future<Null> getKonutPoliciesCount() async {
    await WebAPI.policiesRequest(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "22")
        .then((responseList) {
      staticKonutPolicyList.clear();
      staticKonutPolicyList = responseList;
    });
  }

  Future<Null> getDaskPoliciesCount() async {
    await WebAPI.policiesRequest(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "11")
        .then((responseList) {
      staticDaskPolicyList.clear();
      staticDaskPolicyList = responseList;
    });
  }

  Future<Null> getSaglikPoliciesCount() async {
    await WebAPI.policiesRequest(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "4")
        .then((responseList) {
      staticGenelSaglikPolicyList.clear();
      staticGenelSaglikPolicyList = responseList;
    }).then((value) {
      WebAPI.policiesRequest(
              token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "8")
          .then((responseList) {
        staticTamamlayiciSaglikPolicyList.clear();
        staticTamamlayiciSaglikPolicyList = responseList;
      }).then((value) {
        staticSaglikPolicyList.clear();
        staticGeciciManuelList.clear();

        staticGeciciManuelList.addAll(
            staticGenelSaglikPolicyList + staticTamamlayiciSaglikPolicyList);

        staticGeciciManuelList.sort((item1, item2) => item1.bitisTarihi
            .toString()
            .compareTo(item2.bitisTarihi.toString()));

        staticSaglikPolicyList.addAll(staticGeciciManuelList.reversed.toList());
        return null;
      });
    });
  }

  Future<Null> getSeyahatPoliciesCount() async {
    await WebAPI.policiesRequest(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "21")
        .then((responseList) {
      staticSeyahatPolicyList.clear();
      staticSeyahatPolicyList = responseList;
    });
  }

  Future<Null> getDigerPoliciesCount() async {
    await WebAPI.policiesRequest(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "-1")
        .then((responseList) {
      staticDigerPolicyList.clear();
      staticDigerPolicyList = responseList;
    });
  }
}

class CalculateRisk {
  static int trafik;
  static int kasko;
  static int dask;
  static int konut;
  static int saglik;
  static int tamamlayicisaglik;
  static int diger;
  static int riskSkoru;
  static String riskDurum = "", riskAciklama = "";
  static bool isLoading = true;
  CalculateRisk() {
    riskDurum = "";
    riskSkoru = 0;
    riskAciklama = "";
    trafik = 0;
    kasko = 0;
    dask = 0;
    konut = 0;
    saglik = 0;
    tamamlayicisaglik = 0;
    diger = 0;
  }
  static Future calcPolicy() {
    var currentDate;
    var diffinDays;
    trafik = 0;
    kasko = 0;
    dask = 0;
    konut = 0;
    saglik = 0;
    tamamlayicisaglik = 0;
    diger = 0;
    currentDate = DateTime.now();
    diffinDays = 0;
    for (var item in AllPolicyResponse.staticTrafikPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        trafik = 3;
        break;
      }
    }
    for (var item in AllPolicyResponse.staticKaskoPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        kasko = 7;
        break;
      }
    }
    for (var item in AllPolicyResponse.staticDaskPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        dask = 9;
        break;
      }
    }

    for (var item in AllPolicyResponse.staticKonutPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        konut = 21;
        break;
      }
    }

    for (var item in AllPolicyResponse.staticSaglikPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        saglik = 28;
        break;
      }
    }
    for (var item in AllPolicyResponse.staticTamamlayiciSaglikPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        tamamlayicisaglik = 12;
        break;
      }
    }

    List<int> bransList = List<int>();
    List<int> bransList2 = [1, 2, 4, 8, 11, 22];
    for (var item in AllPolicyResponse.staticDigerPolicyList) {
      // kullanıcıda olan diğer brans listesi
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) if (!bransList.contains(item.bransKodu)) {
        bransList.add(item.bransKodu);
      }
    }

    List<int> digerbransList = List<int>();
    for (var item in WebAPI.sigortaTuruList) {
      if (!bransList2.contains(item.bransKodu)) {
        digerbransList.add(item.bransKodu);
      }
    }

    double digerbransdegeri = 20 /
        digerbransList
            .length; //diğer ürün başı verilecek puan 1,1 -- 20 diğer ürünlerinin toplam puanı

    diger = bransList.length > 0
        ? (bransList.length * digerbransdegeri).round()
        : 0;

    riskSkoru =
        trafik + kasko + konut + saglik + tamamlayicisaglik + dask + diger;

    if (riskSkoru >= 0 && riskSkoru < 25) {
      riskDurum = "Çok Kötü";
    } else if (riskSkoru > 24 && riskSkoru < 50) {
      riskDurum = "Kötü";
    } else if (riskSkoru > 49 && riskSkoru < 75) {
      riskDurum = "İyi";
    } else if (riskSkoru > 74 && riskSkoru < 100) {
      riskDurum = "Çok İyi";
    } else {
      riskDurum = "Mükemmel";
    }

    if (trafik == 0) riskAciklama = "Trafik Yok, ";
    if (kasko == 0) riskAciklama += "Kasko Yok, ";
    if (konut == 0) riskAciklama += "Konut Yok, ";
    if (dask == 0) riskAciklama += "Dask Yok, ";
    if (saglik == 0) riskAciklama += "Sağlık Yok, ";
    if (tamamlayicisaglik == 0) riskAciklama += "T.Sağlık Yok, ";
    if (saglik > 0 || tamamlayicisaglik > 0) {
      riskAciklama = riskAciklama.replaceAll("T.Sağlık Yok, ", "");
      riskAciklama = riskAciklama.replaceAll("Sağlık Yok, ", "");
    }
    if (diger == 0) riskAciklama += "Diğer Yok, ";
    if (riskAciklama.isEmpty) {
      riskAciklama = "Tebrikler. Bilinçli bir sigortalısınız.";
    } else {
      var index = riskAciklama.lastIndexOf(',');

      riskAciklama = riskAciklama.replaceFirst(RegExp(','), '', index - 1);

      if (riskAciklama.split(',').length > 5) {
        riskAciklama = riskAciklama.replaceFirst(RegExp(','), ',\n', index - 1);
        riskAciklama = riskAciklama.replaceFirst(RegExp(' '), '', index - 1);
      }
    }

    isLoading = false;
  }
}
