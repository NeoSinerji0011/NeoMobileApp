import 'dart:async';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

import 'package:flutter/services.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/BinaKullanimSekli.dart';
import 'package:sigortadefterim/models/YapiTarzi.dart';
import 'package:sigortadefterim/models/YapimYili.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';

class UtilsPolicy {
  static List<UlkeTipi> ulkeTipiList = List<UlkeTipi>();

  static List<String> kullaniciInfo = ["", "", "", "", "", "", "", "0"];
  static var countList = {
    "arac": 0,
    "konut": 0,
    "dask": 0,
    "saglik": 0,
    "seyahat": 0,
    "diger": 0,
    "riskSkoru": 0
  };
  static List<String> acilNumaraList = List<String>();
  static String kullanimKilavuzu = "",
      gizlilikPDFPath = "",
      kullaniciPDFPath = "";

  Future getKullaniciInfo() async {
    await Utils.getKullaniciInfo().then((value) {
      try {
        kullaniciInfo = value;
        acilNumaraList = [value[9], value[10]];
      } catch (e) {}
    });
  }

  Future pdfpathLoad() async {
    await getFileFromAsset(
            "KullaniciKilavuzu", "assets/pdf/KullaniciKilavuzu.pdf")
        .then((value) => kullanimKilavuzu = value.path);
    await getFileFromAsset(
            "GizlilikPolitikasi", "assets/pdf/GizlilikPolitikasi.pdf")
        .then((value) => gizlilikPDFPath = value.path);
    await getFileFromAsset(
            "KullaniciSozlesmesi", "assets/pdf/KullaniciSozlesmesi.pdf")
        .then((value) => kullaniciPDFPath = value.path);
  }

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Hata oluştu. $url';
    }
  }

  static String findMarka(String kod) {
    String result = "";
    if (kod.isEmpty) return "Bulunamadı";
    var resultTemp = WebAPI.aracMarkaList
        .firstWhere((x) => x.markaKodu == kod, orElse: () => null);
    result = resultTemp != null ? resultTemp.markaAdi : "Bulunamadı";
    /*  _aracMarka.forEach((item) {
      if (item.markaKodu == kod) result = item.markaAdi;
    }); */
    return result;
  }

  static String findModel(String model, String marka) {
    String result = "";
    if (model.isEmpty || model == null || marka.isEmpty || marka == null)
      return "Bulunamadı";
    var resultTemp = WebAPI.aracTipList.firstWhere(
        (x) => x.markaKodu == marka && x.tipKodu == model,
        orElse: () => null);

    result = WebAPI.aracTipList.length > 0 && resultTemp != null
        ? resultTemp.tipAdi
        : "Bulunamadı";
    /* _aracTip.forEach((item) {
      if (item.tipKodu == model && item.markaKodu == marka)
        result = item.tipAdi;
    }); */
    return result;
  }

  static SigortaSirketi findSirket(String kod) {
    var resultTemp = WebAPI.sigortaSirketiList
        .firstWhere((x) => x.sirketKodu == kod, orElse: () => null);

    SigortaSirketi result = resultTemp != null
        ? resultTemp
        : SigortaSirketi(sirketAdi: "Bulunamadı");

    return result;
  }

  static Object findSigortaTuru(int bransKodu, bool isForTab) {
    String result = "Bulunamadı";
    List filteredList;
    if (isForTab) {
      filteredList = List();
      WebAPI.sigortaTuruList.forEach((item) {
        if (item.bransKodu != 1 &&
            item.bransKodu != 2 &&
            item.bransKodu != 22 &&
            item.bransKodu != 11 &&
            item.bransKodu != 4 &&
            item.bransKodu != 21) filteredList.add(item);
      });
      return filteredList;
    } else {
      WebAPI.sigortaTuruList.forEach((item) {
        if (item.bransKodu == bransKodu) result = item.bransAdi;
      });
      return result;
    }
  }

  static Future findAcente(String token, int kod) async {
    Acente result = Acente(unvani: "Portal Üyesi Değil");

    await WebAPI.getAcenteDetayRequest(token: token, kodu: kod)
        .then((value) => result = value);

    return result;
  }

  static String findIL(String ilKodu) {
    String result = "";
    var resultTemp =
        WebAPI.ilList.firstWhere((x) => x.ilKodu == ilKodu, orElse: () => null);
    result = resultTemp != null ? resultTemp.ilAdi : "Bulunamadı";
    /* _ilList.forEach((item) {
      if (item.ilKodu == ilKodu) result = item.ilAdi;
    }) ;*/
    return result;
  }

  static String findILCE(int ilceKodu) {
    String result = "";
    var resultTemp = WebAPI.ilceList
        .firstWhere((x) => x.ilceKodu == ilceKodu, orElse: () => null);
    result = resultTemp != null ? resultTemp.ilceAdi : "Bulunamadı";
    /*  _ilceList.forEach((item) {
      if (item.ilceKodu == ilceKodu) result = item.ilceAdi;
    }); */
    return result;
  }

  static String findMeslek(String meslekKodu) {
    String result = "";
    var resultTemp = WebAPI.meslekList.firstWhere(
        (x) => x.meslekKodu == int.parse(meslekKodu != "" ? meslekKodu : "0"),
        orElse: () => null);
    result = resultTemp != null ? resultTemp.meslekAdi : "Bulunamadı";
    /* _meslekList.forEach((item) {
      if (item.meslekKodu == int.parse(meslekKodu)) result = item.meslekAdi;
    }); */
    return result;
  }

  static String findUlke(String kod, bool isTur) {
    String result = "Bulunamadı";
    /* _ulkeList.forEach((item) {
      if (item.ulkeKodu == kod)
        result = isTur ? "item.ulkeTipiAdi" : item.ulkeAdi;
    }); */
    var resultTemp = null;
    if (isTur) {
      resultTemp = WebAPI.ulkeList
          .firstWhere((x) => x.ulkeKodu == kod, orElse: () => null);
      var ulketipikodu =
          resultTemp != null ? resultTemp.ulkeTipiKodu : "Bulunamadı";
      resultTemp = WebAPI.ulkeTipiList.firstWhere(
          (x) => x.ulkeTipiKodu == ulketipikodu,
          orElse: () => null);
      result = resultTemp != null ? resultTemp.ulkeTipiAdi : "Bulunamadı";
    } else {
      var resultTemp = WebAPI.ulkeList
          .firstWhere((x) => x.ulkeKodu == kod, orElse: () => null);
      result = resultTemp != null ? resultTemp.ulkeAdi : "Bulunamadı";
    }
    return result;
  }

  static Color chooseDateColor({String bitisTarihi}) {
    DateTime _dateNow = DateTime.now();
    DateTime _bitisTarihi = DateTime.parse(bitisTarihi);

    final difference = _bitisTarihi.difference(_dateNow).inDays;

    if (difference > 32) {
      return ColorData.renkYesil;
    } else if (difference < 0)
      return ColorData.renkKirmizi;
    else if (difference < 32) return Colors.orange;
    return Colors.grey;
  }

  static String chooseTextInfo({String bitisTarihi}) {
    DateTime _dateNow = DateTime.now();
    DateTime _bitisTarihi = DateTime.parse(bitisTarihi);

    final difference = _bitisTarihi.difference(_dateNow).inDays;

    if (difference >= 32) {
      return "Poliçenizin son " + difference.toString() + " günü kalmıştır.";
    } else if (difference < 0)
      return "Poliçenizin süresi " +
          difference.abs().toString() +
          " Gün önce bitmiştir";
    else if (difference < 32)
      return "Son " +
          difference.toString() +
          " gün, poliçenizi lütfen yenileyiniz";
    else
      return "bilgi bulunamadı";
  }

  static SigortaSirketi sigortaSirketiforPDF;
  static SigortaTuru sigortaTuru;
  static AracMarka marka;
  static AracTip aracTipi;
  static AracKullanimTarzi kullanimTarzi;
  static Ulke gidilenUlke;
  static ILCE ilce;
  static IL il;
  static Meslek meslek;
  static UlkeTipi ulkeTuru;
  static BinaKullanimSekli binaKullanimSekli;
  static YapiTarzi yapiTarzi;
  static YapimYili yapimYili;
  static Future getPolicyInformationWithCode(PolicyResponse police) async {
    sigortaSirketiforPDF = SigortaSirketi(sirketAdi: "Bulunamadı");
    sigortaTuru = SigortaTuru(bransAdi: "Bulunamadı");
    marka = AracMarka(markaAdi: "Bulunamadı");
    aracTipi = AracTip(tipAdi: "Bulunamadı");
    kullanimTarzi = AracKullanimTarzi(kullanimTarzi: "Bulunamadı");
    gidilenUlke = Ulke(ulkeAdi: "Bulunamadı");
    ilce = ILCE(ilceAdi: "Bulunamadı");
    il = IL(ilAdi: "Bulunamadı");
    meslek = Meslek(meslekAdi: "Bulunamadı");
    ulkeTuru = UlkeTipi(ulkeTipiAdi: "Bulunamadı");
    binaKullanimSekli = BinaKullanimSekli(binaKullanimTarziAdi: "Bulunamadı");
    yapiTarzi = YapiTarzi(yapiTarziAdi: "Bulunamadı");
    yapimYili = YapimYili(yapimYiliAdi: "Bulunamadı");

    var resultTemp;
    sigortaSirketiforPDF = WebAPI.sigortaSirketiList.firstWhere(
        (x) => x.sirketKodu == police.sirketKodu,
        orElse: () => SigortaSirketi(sirketAdi: "Bulunamadı"));

    sigortaTuru = WebAPI.sigortaTuruList.firstWhere(
        (x) => x.bransKodu == police.bransKodu,
        orElse: () => SigortaTuru(bransAdi: "Bulunamadı"));

    if (police.markaKodu != null) {
      resultTemp = WebAPI.aracMarkaList.firstWhere(
          (x) => x.markaKodu == police.markaKodu,
          orElse: () => null);
      if (resultTemp != null) marka = resultTemp;
    }

    if (police.tipKodu != null) {
      resultTemp = WebAPI.aracTipList.firstWhere(
          (x) => x.markaKodu == police.markaKodu && x.tipKodu == police.tipKodu,
          orElse: () => null);
      if (resultTemp != null) aracTipi = resultTemp;
    }

    if (police.aracKullanimTarzi != null) {
      resultTemp = WebAPI.aracKullanimTarziList.firstWhere(
          (x) => x.kullanimTarziKodu + "+" + x.kod2 == police.aracKullanimTarzi,
          orElse: () => null);
      if (resultTemp != null) kullanimTarzi = resultTemp;
    }

    Utils.getKullaniciInfo().then((value) => kullaniciInfo = value);

    if (police.seyahatUlkeKodu != null) {
      resultTemp = WebAPI.ulkeList.firstWhere(
          (x) => x.ulkeKodu == police.seyahatUlkeKodu,
          orElse: () => null);

      if (resultTemp != null) {
        gidilenUlke = resultTemp;
        resultTemp = WebAPI.ulkeTipiList.firstWhere(
            (x) => x.ulkeTipiKodu == gidilenUlke.ulkeTipiKodu,
            orElse: () => null);
        ulkeTuru = resultTemp != null
            ? resultTemp
            : UlkeTipi(ulkeTipiAdi: "Seyahat Edilicek Ülke Türü");
      }
    }
    if (police.binaYapiTarzi != null) {
      yapiTarzi.yapiTarziAdi = Utils.getYapiTarzi(index: police.binaYapiTarzi);
      yapiTarzi.yapiTarziKodu = police.binaYapiTarzi;
    }
    if (police.binaYapimYili != null) {
      yapimYili.yapimYiliAdi = Utils.getYapimYili(index: police.binaYapimYili);
      yapimYili.yapimYiliKodu = police.binaYapimYili;
    }
    if (police.binaKullanimSekli != null) {
      binaKullanimSekli.binaKullanimTarziAdi =
          Utils.getBinaKullanimSekli(index: police.binaKullanimSekli);
      binaKullanimSekli.binaKullanimTarziKodu = police.binaKullanimSekli;
    }
    if (police.ilKodu != null) {
      resultTemp = WebAPI.ilList
          .firstWhere((x) => x.ilKodu == police.ilKodu, orElse: () => null);
      if (resultTemp != null) il = resultTemp;
    }
    if (police.ilceKodu != null) {
      resultTemp = WebAPI.ilceList
          .firstWhere((x) => x.ilceKodu == police.ilceKodu, orElse: () => null);
      if (resultTemp != null) ilce = resultTemp;
    }
    if (police.meslek != null) {
      resultTemp = WebAPI.meslekList.firstWhere(
          (x) =>
              x.meslekKodu ==
              int.parse(police.meslek != "" ? police.meslek : "0"),
          orElse: () => null);
      if (resultTemp != null) meslek = resultTemp;
    }
  }

  static void showSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message, style: TextStyleData.boldBeyaz),
      duration: Duration(seconds: 2),
    ));
  }

  static void infoAlertBox(String mesaj, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        imageUrl: "assets/images/ic_tick.png",
        body: mesaj,
        buttonText: "TAMAM",
        dialogKind: "AlertDialogInfo",
      ),
    );
  }

  static void onLoading(BuildContext context, {String body = ""}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MyDialog(
              body: body != "" ? body : "",
              buttonText: "",
              dialogKind: "Waiting",
            ));
  }

  static void closeLoader(BuildContext context) {
    Navigator.pop(context);
  }

  static int dateDiff(String bitisTarihi) {
    final bitisTar = DateTime.parse(bitisTarihi);
    final datenow = DateTime.now();
    return bitisTar.difference(datenow).inDays;
  }

  Future<File> getFileFromAsset(String name, String pdfPath) async {
    try {
      var data = await rootBundle.load(pdfPath);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$name");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  static Future<bool> openPdfPrintingFromUrl(String url) async {
    try {
      var data = await http.get(url);

      if (data.statusCode != 200 || data.bodyBytes.lengthInBytes < 1) {
        return false;
      }
      await Printing.layoutPdf(onLayout: (_) => data.bodyBytes);
    } catch (e) {}
    return true;
  }

  static List<PolicyResponse> sortArrayList(List<PolicyResponse> list) {
    var temp = list.where((element) => element.teklifIslemNo == null).toList();
    list = list.where((x) => x.teklifIslemNo != null).toList();
    list.sort((b, a) => a.teklifIslemNo.compareTo(b.teklifIslemNo));
    list.addAll(temp);
    return list;
  }

}
