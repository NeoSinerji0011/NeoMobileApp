import 'package:sigortadefterim/models/Policy/DamagePolicyResponse.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/utils/Utils.dart';

class AllDamagePolicyResponse {
  bool isOffer = false;
  AllDamagePolicyResponse(this.isOffer) {
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
    "diger": 0
  };
  //static var kaskoPolicyList = null;
  static List<DamagePolicyResponse> staticAracPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticTrafikPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticKaskoPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticKonutPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticDaskPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticSaglikPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticGenelSaglikPolicyList =
      List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticTamamlayiciSaglikPolicyList =
      List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticSeyahatPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticDigerPolicyList = List<DamagePolicyResponse>();
  static List<DamagePolicyResponse> staticTumuPolicyList = List<DamagePolicyResponse>();
  List<DamagePolicyResponse> staticGeciciManuelList = List<DamagePolicyResponse>();

  Future getKullaniciInfo() async {
    Utils.getKullaniciInfo().then((value) {
      kullaniciInfo = value;
    });
  }

  Future<Null> getAllPoliciesCount() async {
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
                        })))))));
  }

  Future<Null> getAracPoliciesCount() async {
    await WebAPI.getHasarList(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "1")
        .then((responseList) {
      staticTrafikPolicyList.clear();
      staticTrafikPolicyList = responseList;
    }).then((value) {
      WebAPI.getHasarList(
              token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "2")
          .then((responseList) {
        staticKaskoPolicyList.clear();
        staticKaskoPolicyList = responseList;
        staticKaskoPolicyList = staticKaskoPolicyList;
      }).then((value) {
        staticAracPolicyList.clear();
        staticAracPolicyList
            .addAll(staticKaskoPolicyList + staticTrafikPolicyList);
      });
    });
  }

  Future<Null> setPolicyIsOffer(
      List<DamagePolicyResponse> trafikPolicyList,
      List<DamagePolicyResponse> kaskoPolicyList,
      List<DamagePolicyResponse> aracPolicyList,
      List<DamagePolicyResponse> konutPolicyList,
      List<DamagePolicyResponse> daskPolicyList,
      List<DamagePolicyResponse> seyahatPolicyList,
      List<DamagePolicyResponse> genelSaglikPolicyList,
      List<DamagePolicyResponse> tamamlayiciSaglikPolicyList,
      List<DamagePolicyResponse> saglikPolicyList,
      List<DamagePolicyResponse> digerPolicyList,
      List<DamagePolicyResponse> tumuPolicyList) async {
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
    aracPolicyList.addAll(kaskoPolicyList + trafikPolicyList);

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

    staticGeciciManuelList.clear();
    staticGeciciManuelList.addAll(tumuPolicyList);

    tumuPolicyList.clear();
    staticGeciciManuelList.sort((item1, item2) => item1.baslangicTarihi
        .toString()
        .compareTo(item2.baslangicTarihi.toString()));

    //geciciManuelList.map((e) => print(e.baslangicTarihi));

    tumuPolicyList.addAll(staticGeciciManuelList.reversed.toList());
    // print(aracPolicyList.length);
    countList["arac"] = aracPolicyList.length;
    countList["konut"] = konutPolicyList.length;
    countList["saglik"] = saglikPolicyList.length;
    countList["dask"] = kaskoPolicyList.length;
    countList["seyahat"] = seyahatPolicyList.length;
    countList["diger"] = digerPolicyList.length;
    countList["toplam"] = tumuPolicyList.length;
  }

  Future<Null> getKonutPoliciesCount() async {
    await WebAPI.getHasarList(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "22")
        .then((responseList) {
      staticKonutPolicyList.clear();
      staticKonutPolicyList = responseList;
    });
  }

  Future<Null> getDaskPoliciesCount() async {
    await WebAPI.getHasarList(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "11")
        .then((responseList) {
      staticDaskPolicyList.clear();
      staticDaskPolicyList = responseList;
    });
  }

  Future<Null> getSaglikPoliciesCount() async {
    await WebAPI.getHasarList(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "4")
        .then((responseList) {
      staticGenelSaglikPolicyList.clear();
      staticGenelSaglikPolicyList = responseList;
    }).then((value) {
      WebAPI.getHasarList(
              token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "8")
          .then((responseList) {
        staticTamamlayiciSaglikPolicyList.clear();
        staticTamamlayiciSaglikPolicyList = responseList;
      }).then((value) {
        staticSaglikPolicyList.clear();
        staticSaglikPolicyList.addAll(
            staticGenelSaglikPolicyList + staticTamamlayiciSaglikPolicyList);
        return null;
      });
    });
  }

  Future<Null> getSeyahatPoliciesCount() async {
    await WebAPI.getHasarList(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "21")
        .then((responseList) {
      staticSeyahatPolicyList.clear();
      staticSeyahatPolicyList = responseList;
    });
  }

  Future<Null> getDigerPoliciesCount() async {
    await WebAPI.getHasarList(
            token: kullaniciInfo[3], tckn: kullaniciInfo[2], brans: "-1")
        .then((responseList) {
      staticDigerPolicyList.clear();
      staticDigerPolicyList = responseList; 

    });
  }
 
}
