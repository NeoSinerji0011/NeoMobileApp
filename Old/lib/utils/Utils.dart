import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/AcilArama.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/Destek.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class Utils {
  static List<UlkeTipi> ulkeTipiList = List<UlkeTipi>();

  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Hata oluştu. $url';
    }
  }

  /* static Future<Position> getCurrentLocation() async {
    Geolocator geolocator = Geolocator();
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  } */

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  /* static Future<Placemark> getCurrentPlacemark(
      double latitude, double longitude) async {
    Placemark placemark;
    try {
      List<Placemark> placemarkList =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);
      placemark = placemarkList[0];
    } catch (e) {
      placemark = null;
    }
    return placemark;
  } */
  static Future<Placemark> getCurrentPlacemark(
      double latitude, double longitude) async {
    Placemark placemark;
    try {
      List<Placemark> placemarkList =
          await placemarkFromCoordinates(latitude, longitude);
      placemark = placemarkList[0];
    } catch (e) {
      placemark = null;
    }
    return placemark;
  }

  static Future<List> getSigortaSirketi() async {
    var data =
        await rootBundle.loadString("assets/json/sigorta_sirketleri.json");
    var encodeData = jsonDecode(data);
    List sorted =
        encodeData.map((item) => SigortaSirketi.fromJson(item)).toList();
    sorted.sort((item1, item2) => item1.sirketAdi
        .toString()
        .toLowerCase()
        .compareTo(item2.sirketAdi.toString().toLowerCase()));
    return sorted;
  }

  static Future<SigortaSirketi> getSigortaSirketiByCode(String kod) async {
    SigortaSirketi sirket = SigortaSirketi(sirketAdi: "Sigorta Şirketi");
    var data =
        await rootBundle.loadString("assets/json/sigorta_sirketleri.json");
    var encodeData = jsonDecode(data);
    List temp =
        encodeData.map((item) => SigortaSirketi.fromJson(item)).toList();
    temp.forEach((item) {
      if (item.sirketKodu == kod) sirket = item;
    });
    return sirket;
  }

  static Future<List> getSigortaTuru() async {
    var data = await rootBundle.loadString("assets/json/sigorta_turu.json");
    var encodeData = jsonDecode(data);
    return encodeData.map((item) => SigortaTuru.fromJson(item)).toList();
  }

  static Future<SigortaTuru> getSigortaTuruByCode(int kod) async {
    SigortaTuru tur = SigortaTuru(bransAdi: "Sigorta Türü");
    var data = await rootBundle.loadString("assets/json/sigorta_turu.json");
    var encodeData = jsonDecode(data);
    List temp = encodeData.map((item) => SigortaTuru.fromJson(item)).toList();
    temp.forEach((item) {
      if (item.bransKodu == kod) tur = item;
    });
    return tur;
  }

  static Future<List> getAracMarka() async {
    var data = await rootBundle.loadString("assets/json/arac_marka.json");
    var encodeData = jsonDecode(data);
    List sorted = encodeData.map((item) => AracMarka.fromJson(item)).toList();
    sorted.sort((item1, item2) => item1.markaAdi
        .toString()
        .toLowerCase()
        .compareTo(item2.markaAdi.toString().toLowerCase()));
    return sorted;
  }

  static Future<List> getAcilList() async {
    var data = await rootBundle.loadString("assets/json/acil.json");
    var encodeData = jsonDecode(data);
    List sorted = encodeData.map((item) => AcilArama.fromJson(item)).toList();
    //sorted.sort((item1, item2) => item1.acilIsim.toString().toLowerCase().compareTo(item2.acilIsim.toString().toLowerCase()));
    return sorted;
  }

  static Future<List> getDestekList() async {
    var data = await rootBundle.loadString("assets/json/destek.json");
    var encodeData = jsonDecode(data);
    List sorted = encodeData.map((item) => Destek.fromJson(item)).toList();
    /* sorted.sort((item1, item2) => item1.destekIsim
        .toString()
        .toLowerCase()
        .compareTo(item2.destekIsim.toString().toLowerCase())); */
    return sorted;
  }

  static Future<AracMarka> getAracMarkaByCode(String kod) async {
    AracMarka marka = AracMarka(markaAdi: "Marka");
    var data = await rootBundle.loadString("assets/json/arac_marka.json");
    var encodeData = jsonDecode(data);
    List temp = encodeData.map((item) => AracMarka.fromJson(item)).toList();
    temp.forEach((item) {
      if (item.markaKodu == kod) marka = item;
    });
    return marka;
  }

  static Future<List> getAracTip(AracMarka marka) async {
    var isSelected = marka.markaAdi != "Marka";
    var data = await rootBundle.loadString("assets/json/arac_tip.json");
    var encodeData = jsonDecode(data);

    if (isSelected) {
      List baseList = encodeData.map((item) => AracTip.fromJson(item)).toList();
      var filteredList = List();
      baseList.forEach((item) {
        if (item.markaKodu == marka.markaKodu) filteredList.add(item);
      });
      filteredList.sort((item1, item2) =>
          item1.tipAdi.toString().compareTo(item2.tipAdi.toString()));
      return filteredList;
    } else {
      return marka.markaKodu == "-1"
          ? encodeData.map((item) => AracTip.fromJson(item)).toList()
          : [];
    }
  }

  static Future<AracTip> getAracTipByCode(String kod, String markakodu) async {
    AracTip tip = AracTip(tipAdi: "Model");
    var data = await rootBundle.loadString("assets/json/arac_tip.json");
    var encodeData = jsonDecode(data);
    List baseList = encodeData.map((item) => AracTip.fromJson(item)).toList();
    baseList.forEach((item) {
      if (item.tipKodu == kod && item.markaKodu == markakodu) tip = item;
    });
    return tip;
  }

  static Future<List> getAracKullanimTarzi() async {
    var data =
        await rootBundle.loadString("assets/json/arac_kullanim_tarzi.json");
    var encodeData = jsonDecode(data);
    return encodeData.map((item) => AracKullanimTarzi.fromJson(item)).toList();
  }

  static Future<AracKullanimTarzi> getAracKullanimTarziByCode(
      String kod) async {
    AracKullanimTarzi tarz = AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");
    var data =
        await rootBundle.loadString("assets/json/arac_kullanim_tarzi.json");
    var encodeData = jsonDecode(data);
    List temp =
        encodeData.map((item) => AracKullanimTarzi.fromJson(item)).toList();
    temp.forEach((item) {
      if ("${item.kullanimTarziKodu}+${item.kod2}" == kod) tarz = item;
    });
    return tarz;
  }

  static Future<List> getAcente() async {
    var data = await rootBundle.loadString("assets/json/acente.json");
    var encodeData = jsonDecode(data);
    List sorted = encodeData.map((item) => Acente.fromJson(item)).toList();
    sorted.sort((item1, item2) => item1.unvani
        .toString()
        .toLowerCase()
        .compareTo(item2.unvani.toString().toLowerCase()));
    return sorted;
  }

  static Future<Acente> getAcenteByCode(String kod) async {
    Acente acente = Acente(unvani: "Acente");
    var data = await rootBundle.loadString("assets/json/acente.json");
    var encodeData = jsonDecode(data);
    List temp = encodeData.map((item) => Acente.fromJson(item)).toList();
    temp.forEach((item) {
      if (item.kodu == kod) acente = item;
    });
    return acente;
  }

  static Future<List> getMeslek() async {
    var data = await rootBundle.loadString("assets/json/meslek.json");
    var encodeData = jsonDecode(data);
    List sorted = encodeData.map((item) => Meslek.fromJson(item)).toList();
    sorted.sort((item1, item2) => item1.meslekAdi
        .toString()
        .toLowerCase()
        .compareTo(item2.meslekAdi.toString().toLowerCase()));
    return sorted;
  }

  static Future<Meslek> getMeslekByCode(String meslekKodu) async {
    Meslek meslek = Meslek(meslekAdi: "Meslek");
    var data = await rootBundle.loadString("assets/json/meslek.json");
    var encodeData = jsonDecode(data);
    List sorted = encodeData.map((item) => Meslek.fromJson(item)).toList();
    sorted.forEach((item) {
      if (item.meslekKodu.toString() == meslekKodu) meslek = item;
    });
    return meslek;
  }

  static Future<List> getIL() async {
    var data = await rootBundle.loadString("assets/json/il.json");
    var encodeData = jsonDecode(data);
    return encodeData.map((item) => IL.fromJson(item)).toList();
  }

  static Future<IL> getILByCode(String ilKodu) async {
    IL result = IL(ilAdi: "İl");
    var data = await rootBundle.loadString("assets/json/il.json");
    var encodeData = jsonDecode(data);
    List list = encodeData.map((item) => IL.fromJson(item)).toList();

    list.forEach((item) {
      if (item.ilKodu == ilKodu) result = item;
    });
    return result;
  }

  static Future<List> getILCE(IL il) async {
    var isSelected = il.ilAdi != "İl";
    var data = await rootBundle.loadString("assets/json/ilce.json");
    var encodeData = jsonDecode(data);

    if (isSelected) {
      List baseList = encodeData.map((item) => ILCE.fromJson(item)).toList();
      var filteredList = List();
      baseList.forEach((item) {
        if (item.ilKodu == il.ilKodu) filteredList.add(item);
      });
      filteredList.sort((item1, item2) =>
          item1.ilceAdi.toString().compareTo(item2.ilceAdi.toString()));
      return filteredList;
    } else {
      return il.ilKodu == "-1"
          ? encodeData.map((item) => ILCE.fromJson(item)).toList()
          : [];
    }
  }

  static Future<ILCE> getILCEByCode(int ilceKodu) async {
    ILCE result = ILCE(ilceAdi: "İlçe");
    var data = await rootBundle.loadString("assets/json/ilce.json");
    var encodeData = jsonDecode(data);

    List baseList = encodeData.map((item) => ILCE.fromJson(item)).toList();

    baseList.forEach((item) {
      if (item.ilceKodu == ilceKodu) result = item;
    });
    return result;
  }

  static Future<List> getUlke(String ulke) async {
    var data = await rootBundle.loadString("assets/json/ulkeler.json");
    var encodeData = jsonDecode(data);
    List baseList = encodeData.map((item) => Ulke.fromJson(item)).toList();
    var filteredList = List();

    switch (ulke) {
      case "SCHENGEN":
        baseList.forEach((item) {
          if (item.ulkeTipiAdi == "Schengen") filteredList.add(item);
        });
        filteredList
            .sort((item1, item2) => item1.ulkeAdi.compareTo(item2.ulkeAdi));
        return filteredList;
      case "DİĞER AVRUPA":
        baseList.forEach((item) {
          if (item.ulkeTipiAdi == "Diğer Avrupa") filteredList.add(item);
        });
        filteredList
            .sort((item1, item2) => item1.ulkeAdi.compareTo(item2.ulkeAdi));
        return filteredList;
      case "DÜNYA":
        baseList.forEach((item) {
          if (item.ulkeTipiAdi == "Dünya") filteredList.add(item);
        });
        filteredList
            .sort((item1, item2) => item1.ulkeAdi.compareTo(item2.ulkeAdi));
        return filteredList;
      case "TÜRKİYE":
        baseList.forEach((item) {
          if (item.ulkeTipiAdi == "Türkiye") filteredList.add(item);
        });
        filteredList
            .sort((item1, item2) => item1.ulkeAdi.compareTo(item2.ulkeAdi));
        return filteredList;
      case "-1":
        return baseList;
      default:
        return [];
    }
  }

  static Future<Ulke> getUlkeByCode(String ulkeKodu) async {
    Ulke result = Ulke(ulkeAdi: "Seyahat Edilicek Ülke");
    var data = await rootBundle.loadString("assets/json/ulkeler.json");
    var encodeData = jsonDecode(data);
    List baseList = encodeData.map((item) => Ulke.fromJson(item)).toList();

    baseList.forEach((ulke) {
      if (ulke.ulkeKodu == ulkeKodu) result = ulke;
    });
    return result;
  }

  static Object getYapiTarzi({int index}) {
    List<String> itemList = [
      "ÇELİK, BETORNARME, KARKAS",
      "YIĞMA KAGİR",
      "DİĞER"
    ];
    if (index == null)
      return itemList;
    else
      return itemList[index];
  }

  static Object getYapimYili({int index}) {
    List<String> itemList = [
      "1975 - ÖNCESİ",
      "1976 - 1996",
      "1997 - 1999",
      "2000 - 2006",
      "2007 - SONRASI"
    ];
    if (index == null)
      return itemList;
    else
      return itemList[index];
  }

  static Object getBinaKullanimSekli({int index}) {
    List<String> itemList = ["MESKEN", "BÜRO", "TİCARETHANE", "DİĞER"];
    if (index == null)
      return itemList;
    else
      return itemList[index];
  }

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future setKullaniciInfo(
      String ad,
      String soyad,
      String tc,
      String token,
      imageUrl,
      String email,
      String guvenlik,
      int id,
      String telefon,
      String gsm1,
      String gsm2,
      String adres,
      String tc_es,
      String tc_cocuk,
      String tc_diger) async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    prefs.setStringList("kullanici", [
      ad,
      soyad,
      tc,
      token,
      imageUrl,
      email,
      guvenlik,
      id.toString(),
      telefon,
      gsm1,
      gsm2,
      adres,
      tc_es,
      tc_cocuk,
      tc_diger
    ]);
  }

  static Future<bool> setRememberMe({bool check}) async {
    SharedPreferences remember = await getSharedPreferencesInstance();
    remember.setBool('remember', check);
    return remember.getBool('remember');
  }

  static Future<bool> setCloseOnBoardScreen({bool check}) async {
    SharedPreferences remember = await getSharedPreferencesInstance();
    remember.setBool('onboard', check);
    return remember.getBool('onboard');
  }

  static Future<List<String>> getKullaniciInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("kullanici");
  }

  static Future hesapCikis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('remember');
    UtilsPolicy.countList["riskSkoru"]=0;
  }
}
