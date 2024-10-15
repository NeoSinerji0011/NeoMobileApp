import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigortadefterim/AppStyle.dart';

import 'package:sigortadefterim/screens/SplashScreen2.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/utils/TextFileProcess.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class NotificationResponse {
  String policeNumarasi;
  String yayinTarihi;
  String bitisTarihi;
  String kalangun;
  String birgunkalagosterildimi;
  NotificationResponse(
      {this.policeNumarasi,
      this.yayinTarihi,
      this.bitisTarihi,
      this.kalangun,
      this.birgunkalagosterildimi});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      policeNumarasi: json['policeNumarasi'],
      yayinTarihi: json['yayinTarihi'],
      bitisTarihi: json['bitisTarihi'],
      kalangun: json['kalangun'],
      birgunkalagosterildimi: json['birgunkalagosterildimi'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policeNumarasi'] = this.policeNumarasi;
    data['yayinTarihi'] = this.yayinTarihi;
    data['bitisTarihi'] = this.bitisTarihi;
    data['kalangun'] = this.kalangun;
    data['birgunkalagosterildimi'] = this.birgunkalagosterildimi;
    return data;
  }
}

Future getBildirimList({@required token, @required tckn}) async {
  String requestUrl =
      "https://sigortadefterimv2api.azurewebsites.net/api/MobileApp/GetBildirim";
  Map<String, String> _formmap = {"tc": tckn};

  Map<String, String> _headers = {
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token"
  };
  var _body = json.encode(_formmap);

  var response = await http.post(requestUrl,
      headers: _headers, body: _body, encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    Map result = jsonDecode(response.body);

    List<PolicyResponse> policyList = List<PolicyResponse>();

    for (var item in result["bildirimPoliceList"]) {
      policyList.add(PolicyResponse.fromJson(item));
    }
    for (var item in policyList) {
      if (item.bransKodu == 21) {
        item.bitisTarihi = item.seyahatDonusTarihi;
      }
    }
    var sonuc = "";
    await checkNotificationData(policyList).then((value) => sonuc = value);
    return sonuc;
  } else {
    return "";
    //throw Exception('İstek başarısız oldu!');
  }
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@drawable/ic_stat_app_icon');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android, IOS);
    flip.initialize(settings);
    await _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  var result = null;
  await UtilsPolicy().getKullaniciInfo().whenComplete(() async {
    if (UtilsPolicy.kullaniciInfo != null) {
      await getBildirimList(
              token: UtilsPolicy.kullaniciInfo[3],
              tckn: UtilsPolicy.kullaniciInfo[2])
          .then((value) => result = value);
    }
  });
 
  if (result == null || result == "") return;
  String message = result != null ? result : "result";

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: BigTextStyleInformation(message));
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //print(DateTime.now().toString());
  await flip.show(0, 'Sigorta Defterim', message, platformChannelSpecifics,
      payload: 'Default_Sound');
}

Future<String> checkNotificationData(List<PolicyResponse> bildirimList) async {
  TextFileProcess storage = TextFileProcess();
  List<Map<String, String>> _formmap = List<Map<String, String>>();

  Map<String, String> _formmapData;
  List<NotificationResponse> _policyList = List<NotificationResponse>(),
      _policyListTemp = List<NotificationResponse>();

  String message = "", readTemp = "";

  /* await storage.writeCounter("");
  print(13); */

  await storage.readCounter().then((value) {
    readTemp = value;
  });

  if (readTemp.length > 0) {
    List result = jsonDecode(readTemp);
    if (result.length > 0) {
      _policyList = result
          .map((policy) => NotificationResponse.fromJson(policy))
          .toList();

      for (var item in bildirimList) {
        //yeni bildirim listesi varsa yeni poliçeler ekleniyor
        var temp = _policyList.firstWhere(
            (x) =>
                x.policeNumarasi == item.policeNumarasi &&
                x.bitisTarihi == item.bitisTarihi,
            orElse: () => null);
        if (dateDiff(item.bitisTarihi) >= 0) {
          if (temp == null) {
            temp = NotificationResponse();
            temp.policeNumarasi = item.policeNumarasi;
            temp.bitisTarihi = item.bitisTarihi;
            temp.yayinTarihi = DateFormat("dd/MM/yyyy")
                .format(DateTime.parse(DateTime.now().toString()));
            temp.kalangun = "";
            _policyList.add(temp);
          }
        }
      }

      for (var item in _policyList) { 
        if (dateDiff(item.bitisTarihi) == 1 && item.birgunkalagosterildimi != "1") {
          message += item.policeNumarasi + ", ";
          item.yayinTarihi = DateFormat("dd/MM/yyyy").format(
              DateTime.parse(DateTime.now().add(Duration(days: 7)).toString()));
          item.birgunkalagosterildimi = "1";
        } else if (dateDiff2(item.yayinTarihi) >= 0) {
          item.yayinTarihi = DateFormat("dd/MM/yyyy").format(
              DateTime.parse(DateTime.now().add(Duration(days: 7)).toString()));
          item.kalangun = "";
          message += item.policeNumarasi + ", ";
        }
      }

      if (message.length > 3) {
        message = message.substring(0, message.length - 2);

        message += " numaralı " +
            (message.split(",").length > 1
                ? "poliçelerinizin"
                : "poliçenizin") +
            " süresi dolmak üzeredir.Lütfen yenilemenizi uygulamadan yapınız.";
      } else
        message = "";

      for (var item in _policyList) {
        //ESKİ kayıtlari silmek için kontrol yapılıyor
        if (dateDiff(item.bitisTarihi) >= 0) _policyListTemp.add(item);
      }

      for (var item in _policyListTemp) {
      
        _formmapData = Map<String, String>();
        _formmapData.putIfAbsent("policeNumarasi", () => item.policeNumarasi);
        _formmapData.putIfAbsent("bitisTarihi", () => item.bitisTarihi);
        _formmapData.putIfAbsent("yayinTarihi", () => item.yayinTarihi);
        _formmapData.putIfAbsent("kalangun", () => "");
        _formmapData.putIfAbsent("birgunkalagosterildimi", () => item.birgunkalagosterildimi);

        _formmap.add(_formmapData);
      }
    }
  } else {
     
    //ilk işlem , veri ekleme ve notification mesajı verir
    for (var item in bildirimList) {
      if (dateDiff(item.bitisTarihi) >= 0) {
        _formmapData = Map<String, String>();
        _formmapData.putIfAbsent("policeNumarasi", () => item.policeNumarasi);
        _formmapData.putIfAbsent("bitisTarihi", () => item.bitisTarihi);
        _formmapData.putIfAbsent(
            "yayinTarihi",
            () => DateFormat("dd/MM/yyyy").format(DateTime.parse(DateTime.now()
                .add(Duration(days: 7))
                .toString()))); //mesajın notification da cıkma tarihi
        _formmapData.putIfAbsent("kalangun", () => "");
        _formmapData.putIfAbsent("birgunkalagosterildimi", () => "");

        message += item.policeNumarasi + ", ";
        _formmap.add(_formmapData);
      }
    }

    if (message.length > 3) {
      message = message.substring(0, message.length - 2);
      message += " numaralı " +
          (message.split(",").length > 1 ? "poliçelerinizin" : "poliçenizin") +
          " süresi dolmak üzeredir.Lütfen yenilemenizi uygulamadan yapınız.";
    } else
      message = "";
  }
  await txtEkle(null, _formmap);
  return message;
}

Future<bool> txtEkle(Map<String, String> formmapData,
    List<Map<String, String>> formmapList) async {
  TextFileProcess storage = TextFileProcess();
  List<Map<String, String>> _formmap = List<Map<String, String>>();
  var _body = "";
  if (formmapData != null) {
    _formmap.add(formmapData);
  }
  if (formmapList != null) {
    _formmap.addAll(formmapList);
  }

  _body = json.encode(_formmap);
  
  await storage.writeCounter(_body);
  return true;
}

int dateDiff(String bitisTarihi) {
  final bitisTar = DateTime.parse(bitisTarihi);
  DateTime datenow = DateTime.now();
  datenow = new DateTime(datenow.year, datenow.month, datenow.day);
  return bitisTar.difference(datenow).inDays;
}

int dateDiff2(String yayinTarihi) {
  var temp = yayinTarihi.split("/");
  yayinTarihi = temp[2] + "-" + temp[1] + "-" + temp[0];
  final bitisTar = DateTime.parse(yayinTarihi);
  var datenow = DateTime.now();
  datenow = DateTime(datenow.year, datenow.month, datenow.day);
  return datenow.difference(bitisTar).inDays;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks / debug modda ikinci bildirimde workmanager bilgileri getiriyor normal de kapalı "false" olmalı
      );
  Workmanager.registerPeriodicTask("1", "simplePeriodicTask",
      frequency: Duration(minutes: 15), initialDelay: Duration(seconds: 3));
    
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('tr')],
        theme: ThemeData(
            primaryColor: ColorData.renkMavi,
            accentColor: ColorData.renkYesil,
            primaryColorDark: ColorData.renkLacivert,
            cursorColor: ColorData.renkMavi,
            splashColor: Colors.transparent,
            textSelectionColor: ColorData.renkYesil,
            textSelectionHandleColor: ColorData.renkYesil,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyleData.solukMavi,
              errorStyle: TextStyleData.boldKirmizi,
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorData.renkKirmizi),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorData.renkMavi),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorData.renkYesil),
              ),
            )),
        debugShowCheckedModeBanner: false,
        home: SplashScreen2() //OnboardingScreen() ,
        );
  }
}
