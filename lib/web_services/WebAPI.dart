import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/models/Bildirim.dart';
import 'package:sigortadefterim/models/HasarPostMessage.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/Policy/MessageResponse.dart';
import 'package:sigortadefterim/models/User/LoginResponse.dart';
import 'package:sigortadefterim/models/Policy/DamageFileResponse.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/Destek.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/TVMDetay.dart';

class WebAPI {
  static const baseURL = "https://localhost:44346/api/";
  //static const baseURL = "https://localhost:44346/api/";
  static const oldBaseUrl = "https://mobilwebservice.azurewebsites.net";

  static Future loginRequest(
      {@required String email, @required String password}) async {
    String requestUrl = baseURL + "User/Login?Email=$email&Password=$password";
    LoginResponse loginResponse = LoginResponse(token: "");

    Map<String, String> headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip"
    };

    await http.post(requestUrl, headers: headers).then((value) {
      if (value.statusCode == 200) {
        loginResponse = LoginResponse.fromJson(json.decode(value.body));
      } else {
        loginResponse.token = "-200";
      }
    }).timeout(Duration(minutes: 1), onTimeout: () {
      loginResponse.token = "timeout";
    }).catchError((error, statu) {
      loginResponse.token = "error";
    });

    return loginResponse;
  }

  static Future passwordResetRequest({@required String email}) async {
    GlobalResponse globalResponse = GlobalResponse();
    String requestUrl = baseURL + "User/ResetPassword?email=" + email;

    Map<String, String> _headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip"
    };
    // Map<String, dynamic> _formmap = {
    //   "email": email,
    // };

    //var _body = json.encode(_formmap);
    var res;
    try {
      res = await http.post(
        requestUrl,
        //body: _body,
        headers: _headers,
      );
    } catch (e) {
      return new GlobalResponse(
          message: "Bağlantı problemi.Bağlantınızı kontrol ediniz.",
          statusCode: 111);
    }
    if (res.statusCode != 200) {
      dynamic resDynamic = json.decode(res.body);
      return new GlobalResponse(
          message: resDynamic["message"], statusCode: res.statusCode);
    } else {
      globalResponse = GlobalResponse.fromJson(json.decode(res.body));
    }
    return globalResponse;
  }

  static Future refreshToken({@required String token}) async {
    String requestUrl = baseURL + "User/RefreshToken";

    Map<String, String> _headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip"
    };
    Map<String, dynamic> _formmap = {
      "Guvenlik": token,
    };
    var _body = json.encode(_formmap);
    var response;
    try {
      response = await http.post(
        requestUrl,
        body: _body,
        headers: _headers,
      );
    } catch (e) {
      return {
        "message": "Bağlantı problemi",
        "status": false,
        "statusCode": 111
      };
    }
    // print(_body);

    if (response.statusCode != 200)
      return {"message": "", "status": true, "statusCode": 401};

    Map resultData = json.decode(response.body);

    return {
      "message": resultData["message"],
      "status": resultData["statusCode"] == 500 ? false : true,
      "statusCode": resultData["statusCode"]
    };
  }

  static Future registerRequest(
      {@required String adsoyad,
      @required String email,
      @required String tckn,
      String digertckn,
      @required String telefon,
      @required String adres,
      @required String password,
      String resim}) async {
    String requestUrl = baseURL + "User/Register";

    Map<String, String> _headers = {
      "Content-type": "application/json",
      "charset": "utf-8"
    };
    Map<String, String> _formmap = {
      "AdSoyad": adsoyad,
      "Adres": adres,
      "Tc": tckn,
      "Eposta": email,
      "Telefon": telefon,
      "Sifre": password,
      "Resim": resim
    };
    var _body = json.encode(_formmap);
    var response;
    try {
      response = await http.post(
        requestUrl,
        body: _body,
        headers: _headers,
      );
    } catch (e) {
      return {
        "message": "Bağlantı problemi",
        "status": false,
        "statusCode": 111
      };
    }

    if (response.statusCode != 200)
      return {
        "message": "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
        "status": false
      };

    Map resultData = json.decode(response.body);

    return {
      "message": resultData["message"],
      "status": resultData["statusCode"] == 200 ? true : false
    };
  }

  static Future userUpdateRequest(
      {@required String adsoyad,
      @required String token,
      @required String tckn,
      @required String tckn_diger,
      @required String tckn_es,
      @required String tckn_cocuk,
      @required String gsm,
      @required String gsm1,
      @required String gsm2,
      @required String adres,
      @required String password,
      String resim}) async {
    String requestUrl = baseURL + "User/UserUpdate";

    Map<String, String> _headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    Map<String, String> _formmap = {
      "AdSoyad": adsoyad,
      "Adres": adres,
      "Tc": tckn,
      "Tc_Cocuk": tckn_cocuk,
      "Tc_Es": tckn_es,
      "Tc_Diger": tckn_diger,
      "Telefon": gsm,
      "gsm_1": gsm1,
      "gsm_2": gsm2,
      "Sifre": password,
      "Resim": resim
    };
    var _body = json.encode(_formmap);
    var response;
    try {
      response = await http.post(
        requestUrl,
        body: _body,
        headers: _headers,
      );
    } catch (e) {
      return {
        "message": "Bağlantı problemi",
        "status": false,
        "statusCode": 111
      };
    }

    ///* print(response.statusCode); */
    if (response.statusCode != 200)
      return {
        "message": "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
        "status": false
      };

    Map resultData = json.decode(response.body);

    return {
      "data": resultData["kullanici"],
      "message": resultData["message"],
      "status": resultData["statusCode"] == 200 ? true : false
    };
  }

  static Future sendMessage(
      {@required String adsoyad,
      @required String token,
      @required String email,
      @required String konu,
      @required String mesaj}) async {
    String requestUrl = baseURL + "User/SendFeedBack";

    Map<String, String> _headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    Map<String, String> _formmap = {
      "adsoyad": adsoyad,
      "email": email,
      "message": konu,
      "subject": mesaj,
    };
    var _body = json.encode(_formmap);
    var response;
    try {
      response = await http.post(
        requestUrl,
        body: _body,
        headers: _headers,
      );
    } catch (e) {
      return {
        "message": "Bağlantı problemi",
        "status": false,
        "statusCode": 111
      };
    }

    ///* print(response.statusCode); */
    if (response.statusCode != 200)
      return {
        "message": "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
        "status": false
      };

    Map resultData = json.decode(response.body);

    return {
      "message": resultData["message"],
      "status": resultData["statusCode"] == 200 ? true : false
    };
  }

  static Future sendIletisim(
      {@required String token, MessageInput messageinput}) async {
    String requestUrl = baseURL + "MobileApp/SetUserMessage";

    Map<String, String> _headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    Map<String, dynamic> _formmap = {
      "oturumId": messageinput.policeId,
      "mesaj": messageinput.kullanici_Mesaj,
    };
    var _body = json.encode(_formmap);
    var response;
    try {
      response = await http.post(
        requestUrl,
        body: _body,
        headers: _headers,
      );
    } catch (e) {
      return {
        "message": "Bağlantı problemi",
        "status": false,
        "statusCode": 111
      };
    }

    /* print(response.statusCode); */

    if (response.statusCode != 200)
      return {
        "message": "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
        "status": false
      };

    Map resultData = json.decode(response.body);

    return {
      "message": resultData["message"],
      "status": resultData["statusCode"] == 200 ? true : false
    };
  }

  static Future policiesRequest(
      {@required token, @required tckn, @required brans}) async {
    String requestUrl =
        baseURL + "Policy/GetPolicies?KimlikNo=$tckn&BransKodu=$brans";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    final response = await http.get(requestUrl, headers: headers);

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);

      List _policy =
          result.map((policy) => PolicyResponse.fromJson(policy)).toList();

      _policy.sort((item1, item2) =>
          item1.bitisTarihi.toString().compareTo(item2.bitisTarihi.toString()));
      List _reversedPolicy = _policy.reversed.toList();

      return _reversedPolicy;
    } else {
      throw Exception('Poliçe yükleme isteği başarısız oldu!');
    }
  }

  static List<PolicyResponse> bildirimList;
  static List<Bildirim> bildirimDisableList;
  static Future getBildirimList({@required token, @required tckn}) async {
    bildirimList = List<PolicyResponse>();
    bildirimDisableList = List<Bildirim>();
    String requestUrl = baseURL + "/MobileApp/GetBildirim";
    Map<String, String> _formmap = {"tc": tckn};

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);
    final response = await http.post(requestUrl,
        headers: _headers, body: _body, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);

      List<PolicyResponse> policyList = List<PolicyResponse>();

      for (var item in result["bildirimPoliceList"]) {
        policyList.add(PolicyResponse.fromJson(item));
      }
      for (var item in result["bildirimDisableList"]) {
        bildirimDisableList.add(Bildirim.fromJson(item));
      }
      for (var item in policyList) {
        if (item.seyahatDonusTarihi != null) {
          item.bitisTarihi = item.seyahatDonusTarihi;
        }
      }
      policyList.sort((item1, item2) =>
          item1.bitisTarihi.toString().compareTo(item2.bitisTarihi.toString()));
      List<PolicyResponse> _reversedPolicy = policyList.reversed.toList();
      bildirimList.addAll(_reversedPolicy);

      // return _reversedPolicy;
    } else {
      throw Exception('İstek başarısız oldu!');
    }
  }

  static Future setBildirimDisable(
      {@required token, @required tckn, PolicyResponse policyResponse}) async {
    String requestUrl = baseURL + "/MobileApp/SetBildirimDisable";

    Map<String, String> _formmap = {
      "KimlikNo": tckn,
      "PoliceNumarasi": policyResponse.policeNumarasi,
      "BitisTarihi": policyResponse.bitisTarihi,
    };

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);
    final response = await http.post(requestUrl,
        headers: _headers, body: _body, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map resultData = json.decode(response.body);
      return resultData["message"] != null
          ? resultData["message"]
          : "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz";
    } else {
      return "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz";
    }
  }

  static List<MessageResponse> messageList1;
  static MessageGlobal messageGlobal;
  static Future getMessageList({@required token, @required user_id}) async {
    messageGlobal = MessageGlobal();
    //messageList = List<MessageResponse>();
    String requestUrl = baseURL + "/MobileApp/GetUserMessage";
    Map<String, int> _formmap = {"Id": user_id};

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);

    final response = await http.post(requestUrl,
        headers: _headers, body: _body, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var rest = result["iletisimResponse"] as List;

      messageGlobal.messageSessionResponseList = rest
          .map<MessageResponse>((json) => MessageResponse.fromJson(json))
          .toList();

      rest = result["messageList"] as List;

      messageGlobal.mobilMessageResponseList = rest
          .map<MobilMessageResponse>(
              (json) => MobilMessageResponse.fromJson(json))
          .toList();

      rest = result["messageDosyaList"] as List;

      messageGlobal.mobilMessageDosyaList = rest
          .map<MobilMessageDosyaResponse>(
              (json) => MobilMessageDosyaResponse.fromJson(json))
          .toList();

      for (var item in messageGlobal.mobilMessageResponseList) {
        item.tarih_Saat =
            DateTime.parse(item.tarih_Saat).add(Duration(hours: 3)).toString();
      }
    } else {
      throw Exception('İstek başarısız oldu!');
    }
  }

  static int newMessageCount = 0;

  static Future<int> getNewMessageCount(
      {@required token, @required user_id}) async {
    messageGlobal = MessageGlobal();
    //messageList = List<MessageResponse>();
    String requestUrl = baseURL + "/MobileApp/GetUserNewMessageCount";
    Map<String, int> _formmap = {"Id": user_id};

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);

    final response = await http.post(requestUrl,
        headers: _headers, body: _body, encoding: Encoding.getByName("utf-8"));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      newMessageCount = int.parse(result["message"]);
      return newMessageCount;
    } else {
      return 0;
    }
  }

  static Future setReadMessage(
      {@required token, @required oturumId, userid}) async {
    String requestUrl = baseURL + "/MobileApp/SetReadMessage";
    Map<String, int> _formmap = {"oturumId": oturumId};

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);

    final response = await http.post(requestUrl,
        headers: _headers, body: _body, encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body);
      getNewMessageCount(token: token, user_id: userid);
    } else {
      throw Exception('İstek başarısız oldu!');
    }
  }

  static Future getOldBildirimList(
      {@required token, @required tckn, @required userid}) async {
    String requestUrl = oldBaseUrl + "/police/getbildirimlist";

    Map<String, String> _formmap = {
      "token": token,
      "kimlikno": tckn,
      "userid": userid
    };

    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    final response = await http.post(requestUrl,
        headers: headers,
        body: _formmap,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['sayac'];

      List _bildirim =
          result.map((bildirim) => Bildirim.fromJson(bildirim)).toList();

      _bildirim.sort((item1, item2) =>
          item1.bitisTarihi.toString().compareTo(item2.bitisTarihi.toString()));
      List<Bildirim> _reversedPolicy = _bildirim.reversed.toList();

      return _reversedPolicy;
    } else {
      throw Exception('Poliçe yükleme isteği başarısız oldu!');
    }
  }

  static Future aracMarkaRequest({@required token}) async {
    String requestUrl = baseURL + "Car/GetAracMarka";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    final response = await http.get(requestUrl, headers: headers);
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((marka) => AracMarka.fromJson(marka)).toList();
    } else {
      throw Exception('Araç markaları yükleme isteği başarısız oldu!');
    }
  }

  static Future aracTipRequest({@required token, @required markaKodu}) async {
    String requestUrl = baseURL + "Car/GetAracTip?MarkaKodu=$markaKodu";

    Map<String, String> headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    final response = await http.get(requestUrl, headers: headers);
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((tip) => AracTip.fromJson(tip)).toList();
    } else {
      throw Exception('Araç Tipleri yükleme isteği başarısız oldu!');
    }
  }

  static Future getHasarList(
      {@required token, @required tckn, @required brans}) async {
    String requestUrl = baseURL +
        "/Policy/GetDamagePolicies?KimlikNo=" +
        tckn +
        "&BransKodu=" +
        brans;

    Map<String, String> headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip",
      "Authorization": "Bearer $token"
    };

    final response = await http.get(requestUrl, headers: headers);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      /*  List _policy =
          result.map((policy) => PolicyResponse.fromJson(policy)).toList(); */
      var rest = result["mobilPoliceHasarList"] as List;

      List _policy = rest
          .map<PolicyResponse>((json) => PolicyResponse.fromJson(json))
          .toList();

      var restFile = result["mobilPoliceDosyaList"] as List;
      //print(restFile.length);
      List<DamageFileResponse> _policy2 = restFile
          .map<DamageFileResponse>((json) => DamageFileResponse.fromJson(json))
          .toList();

      _policy.sort((item1, item2) => item1.baslangicTarihi
          .toString()
          .compareTo(item2.baslangicTarihi.toString()));
      List<PolicyResponse> _reversedPolicy = _policy.reversed.toList();

      return [_reversedPolicy, _policy2];
    } else {
      throw Exception('Poliçe yükleme isteği başarısız oldu!');
    }
  }

  static Future createUser(
      {@required token, @required tckn, @required userid}) async {
    String requestUrl = oldBaseUrl + "/kullanici/userCreate";

    Map<String, String> _formmap = {
      "token": token,
      "kimlikno": tckn,
      "userid": userid
    };

    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    final response = await http.post(requestUrl,
        headers: headers,
        body: _formmap,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['message'];

      List _getHasarList =
          result.map((hasarlist) => Bildirim.fromJson(hasarlist)).toList();

      _getHasarList.sort((item1, item2) =>
          item1.bitisTarihi.toString().compareTo(item2.bitisTarihi.toString()));
      List<Bildirim> _reversedPolicy = _getHasarList.reversed.toList();

      return _reversedPolicy;
    } else {
      throw Exception('Poliçe yükleme isteği başarısız oldu!');
    }
  }

  static Future isthereTcNoVergiNo(
      {@required String tcno, int kimlikSecimi}) async {
    String requestUrl = baseURL +
        "User/GetAdSoyad?Tc=$tcno" +
        "&" +
        "Durum=" +
        kimlikSecimi.toString();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "charset": "utf-8",
      "content-encoding": "gzip"
    };

    final response = await http.get(requestUrl, headers: headers);

    if (response.statusCode == 200) {
      var resultData = jsonDecode(response.body);

      return resultData["kimlikNo"] != null
          ? {"message": resultData, "status": true}
          : {"message": "", "status": false};
    } else {
      return {"message": "Hata", "status": false};
    }
  }

  static Future addHasarDask(
      //PoliceResponse modeli parametre olarak belirlenecek diğer parametreler silinecek
      {@required token,
      @required tckn,
      @required userid,
      binakatsayisi,
      yenilemeno,
      basTarih,
      bitTarih,
      selectacente,
      yapitarzi,
      dairem2,
      binakullanimsekli,
      selectil,
      selectilce,
      yapimyili,
      adres,
      branskodu,
      policetur,
      policeid,
      paylasimresimb64,
      gidisbitTarih,
      hasartalepno,
      sigortasirket,
      policeNumarasi,
      latitude,
      longitude,
      aciklama}) async {
    String requestUrl = oldBaseUrl + "/hasar/dask";

    Map<String, String> _formmap = {
      "userid": userid,
      "token": token,
      "binakatsayisi": binakatsayisi,
      "yenilemeno": yenilemeno,
      "dairem2": dairem2,
      "basTarih": basTarih,
      "bitTarih": bitTarih,
      "selectacente": selectacente,
      "yapitarzi": yapitarzi,
      "selectil": selectil,
      "selectilce": selectil,
      "yapimyili": yapimyili,
      "binakullanimsekli": binakullanimsekli,
      "adres": binakatsayisi,
      "branskodu": branskodu,
      "policetur": policetur,
      "policeid": policeid,
      "paylasimresimb64": paylasimresimb64,
      "gidisbitTarih": gidisbitTarih,
      "hasartalepno": hasartalepno,
      "sigortasirket": sigortasirket,
      "PoliceNumarasi": policeNumarasi,
      "tcno": tckn,
      "latitude": latitude,
      "longitude": longitude,
      "aciklama": aciklama,
    };

    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    final response = await http.post(requestUrl,
        headers: headers,
        body: _formmap,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);

      List _getHasarMessage =
          result.map((message) => HasarPostMessage.fromJson(message)).toList();

      return _getHasarMessage;
    } else {
      throw Exception('Hasar bildirme işlemi başarısız oldu');
    }
  }

  static Future reportDamage(
      {@required token,
      @required tckn,
      hasartalepno,
      policeNumarasi,
      acentekodu,
      yenilemeno,
      sigortasirket,
      branskodu,
      plakano,
      ruhsatno,
      ruhsatkodu,
      asbisno,
      basTarih,
      bitTarih,
      modelyili,
      aciklama,
      markaid,
      modelid,
      kullanimtarzi,
      latitude,
      longitude,
      resimDosyaList,
      sesDosyaList,
      policetur,
      meslek,
      binakatsayisi,
      binakullanimsekli,
      binayapimyili,
      binayapimtarzi,
      dairembrut,
      adres,
      il,
      ilce,
      seyahatEdenKisiSayisi,
      seyahatUlkeKodu,
      seyahatGidisTarihi,
      seyahatDonusTarihi,
      binaBedeli,
      esyaBedeli,
      kullaniciGonderiTuru}) async {
    String requestUrl = baseURL + "Policy/AddDamagePolicy";
    Map<String, dynamic> _formmap = {
      "KimlikNo": tckn,
      "BransKodu": branskodu,
      "Aciklama": aciklama,
      "SirketKodu": sigortasirket,
      "PoliceNumarasi": policeNumarasi,
      "AcenteUnvani": acentekodu,
      "KoordinatX": latitude.toString(),
      "KoordinatY": longitude.toString(),
      "KullaniciGonderiTuru": kullaniciGonderiTuru,
      "ResimDosyaList": resimDosyaList,
      "SesDosyaList": sesDosyaList,
    };
    if (branskodu != 21) {
      _formmap["BaslangicTarihi"] = basTarih;
      _formmap["BitisTarihi"] = bitTarih;
    } else {
      _formmap["SeyahatGidisTarihi"] = seyahatGidisTarihi;
      _formmap["seyahatDonusTarihi"] = seyahatDonusTarihi;
    }
    switch (branskodu) {
      case 1:
      case 2:
        _formmap["Plaka"] = plakano;
        _formmap["RuhsatSeriKodu"] = ruhsatkodu;
        _formmap["RuhsatSeriNo"] = ruhsatno;
        _formmap["AsbisNo"] = asbisno;
        _formmap["ModelYili"] = modelyili;
        _formmap["MarkaKodu"] = markaid;
        _formmap["TipKodu"] = modelid;
        _formmap["AracKullanimTarzi"] = kullanimtarzi;
        break;
      case 4:
        _formmap["Meslek"] = meslek.toString();
        break;
      case 11:
        _formmap["BinaKatSayisi"] = binakatsayisi;
        _formmap["BinaKullanimSekli"] = binakullanimsekli;
        _formmap["BinaYapimYili"] = binayapimyili;
        _formmap["BinaYapiTarzi"] = binayapimtarzi;
        _formmap["DaireBrut"] = dairembrut;
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;
        break;
      case 21:
        _formmap["SeyahatEdenKisiSayisi"] = seyahatEdenKisiSayisi;
        _formmap["SeyahatUlkeKodu"] = seyahatUlkeKodu;
        break;
      case 22:
        _formmap["BinaBedeli"] = binaBedeli;
        _formmap["EsyaBedeli"] = esyaBedeli;
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;
        break;
      default:
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;
        break;
    }

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );

    /* print(response.statusCode); */
    if (response.statusCode != 200)
      return "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz";

    Map resultData = json.decode(response.body);

    return resultData["message"] != null
        ? resultData["message"]
        : "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz";
  }

  static Future reporRenew(
      {@required token,
      @required tckn,
      policeNumarasi,
      acentekodu,
      yenilemeno,
      teklifPolice,
      sigortasirket,
      branskodu,
      plakano,
      ruhsatno,
      ruhsatkodu,
      asbisno,
      basTarih,
      bitTarih,
      modelyili,
      aciklama,
      markaid,
      modelid,
      kullanimtarzi,
      latitude,
      longitude,
      meslek,
      binakatsayisi,
      binakullanimsekli,
      binayapimyili,
      binayapimtarzi,
      dairembrut,
      adres,
      il,
      ilce,
      seyahatEdenKisiSayisi,
      seyahatUlkeKodu,
      seyahatGidisTarihi,
      seyahatDonusTarihi,
      binaBedeli,
      esyaBedeli,
      emailType,
      kullaniciId}) async {
    String requestUrl = baseURL + "Policy/AddRenewPolicy";

    Map<String, dynamic> _formmap = {
      "KimlikNo": tckn,
      "BransKodu": branskodu,
      "Aciklama": aciklama,
      "SirketKodu": sigortasirket,
      "PoliceNumarasi": policeNumarasi,
      "YenilemeNo": yenilemeno,
      "AcenteUnvani": acentekodu,
      "EmailType": emailType,
      "KullaniciId": int.parse(kullaniciId)
    };
    if (branskodu != 21) {
      _formmap["BaslangicTarihi"] = basTarih;
      _formmap["BitisTarihi"] = bitTarih;
    } else {
      _formmap["SeyahatGidisTarihi"] = seyahatGidisTarihi;
      _formmap["seyahatDonusTarihi"] = seyahatDonusTarihi;
    }

    switch (branskodu) {
      case 1:
      case 2:
        _formmap["Plaka"] = plakano;
        _formmap["RuhsatSeriKodu"] = ruhsatkodu;
        _formmap["RuhsatSeriNo"] = ruhsatno;
        _formmap["AsbisNo"] = asbisno;
        _formmap["ModelYili"] = modelyili;
        _formmap["MarkaKodu"] = markaid;
        _formmap["TipKodu"] = modelid;
        _formmap["AracKullanimTarzi"] = kullanimtarzi;

        break;
      case 4:
        _formmap["Meslek"] = meslek.toString();
        break;
      case 11:
        _formmap["BinaKatSayisi"] = binakatsayisi;
        _formmap["BinaKullanimSekli"] = binakullanimsekli;
        _formmap["BinaYapimYili"] = binayapimyili;
        _formmap["BinaYapiTarzi"] = binayapimtarzi;
        _formmap["DaireBrut"] = dairembrut;
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;
        break;
      case 21:
        _formmap["SeyahatEdenKisiSayisi"] = seyahatEdenKisiSayisi;
        _formmap["SeyahatUlkeKodu"] = seyahatUlkeKodu;

        break;
      case 22:
        _formmap["BinaBedeli"] = binaBedeli;
        _formmap["EsyaBedeli"] = esyaBedeli;
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;
        break;
      default:
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;
        break;
    }

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );
    /* print(response.statusCode); */

    if (response.statusCode != 200)
      return {
        "message": "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
        "status": false
      };
    Map resultData = json.decode(response.body);

    /* return resultData["message"] != null
        ? resultData["message"]
        : "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz"; */
    return resultData["message"] != null
        ? {"message": resultData["message"], "status": true}
        : {
            "message":
                "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
            "status": false
          };
  }

  static Future addPolicy(
      {@required token,
      @required tckn,
      policeNumarasi,
      yenilemeno,
      sigortasirket,
      branskodu,
      plakano,
      ruhsatno,
      ruhsatkodu,
      asbisno,
      basTarih,
      bitTarih,
      modelyili,
      aciklama,
      markaid,
      modelid,
      kullanimtarzi,
      latitude,
      longitude,
      meslek,
      binakatsayisi,
      binakullanimsekli,
      binayapimyili,
      binayapimtarzi,
      dairembrut,
      adres,
      il,
      ilce,
      seyahatEdenKisiSayisi,
      seyahatUlkeKodu,
      seyahatGidisTarihi,
      seyahatDonusTarihi,
      binaBedeli,
      esyaBedeli}) async {
    String requestUrl = baseURL + "Policy/AddPolicy";
    Map<String, dynamic> _formmap;
    switch (branskodu) {
      case 1:
      case 2:
        _formmap = {
          "KimlikNo": tckn,
          "BransKodu": branskodu,
          "Aciklama": aciklama,
          "SirketKodu": sigortasirket,
          "PoliceNumarasi": policeNumarasi,
          "BaslangicTarihi": basTarih,
          "BitisTarihi": bitTarih,
          "Plaka": plakano,
          "RuhsatSeriKodu": ruhsatkodu,
          "RuhsatSeriNo": ruhsatno,
          "AsbisNo": asbisno,
          "ModelYili": modelyili,
          "MarkaKodu": markaid,
          "TipKodu": modelid,
          "AracKullanimTarzi": kullanimtarzi,
        };
        break;
      case 4:
        _formmap = {
          "KimlikNo": tckn,
          "BransKodu": branskodu,
          "Aciklama": aciklama,
          "SirketKodu": sigortasirket,
          "PoliceNumarasi": policeNumarasi,
          "BaslangicTarihi": basTarih,
          "BitisTarihi": bitTarih,
          "Meslek": meslek,
        };
        break;
      case 11:
        _formmap = {
          "KimlikNo": tckn,
          "BransKodu": branskodu,
          "Aciklama": aciklama,
          "SirketKodu": sigortasirket,
          "PoliceNumarasi": policeNumarasi,
          "BaslangicTarihi": basTarih,
          "BitisTarihi": bitTarih,
          "BinaKatSayisi": binakatsayisi,
          "BinaKullanimSekli": binakullanimsekli,
          "BinaYapimYili": binayapimyili,
          "BinaYapiTarzi": binayapimtarzi,
          "DaireBrut": dairembrut,
          "Adres": adres,
          "IlKodu": il,
          "IlceKodu": ilce,
        };
        break;
      case 21:
        _formmap = {
          "KimlikNo": tckn,
          "BransKodu": branskodu,
          "Aciklama": aciklama,
          "SirketKodu": sigortasirket,
          "PoliceNumarasi": policeNumarasi,
          "SeyahatGidisTarihi": seyahatGidisTarihi,
          "SeyahatDonusTarihi": seyahatDonusTarihi,
          "SeyahatEdenKisiSayisi": seyahatEdenKisiSayisi,
          "SeyahatUlkeKodu": seyahatUlkeKodu,
        };
        break;
      case 22:
        _formmap = {
          "KimlikNo": tckn,
          "BransKodu": branskodu,
          "Aciklama": aciklama,
          "SirketKodu": sigortasirket,
          "PoliceNumarasi": policeNumarasi,
          "BaslangicTarihi": basTarih,
          "BitisTarihi": bitTarih,
          "BinaBedeli": binaBedeli,
          "EsyaBedeli": esyaBedeli,
          "Adres": adres,
          "IlKodu": il,
          "IlceKodu": ilce,
        };
        break;
      default:
        _formmap = {
          "KimlikNo": tckn,
          "BransKodu": branskodu,
          "Aciklama": aciklama,
          "SirketKodu": sigortasirket,
          "PoliceNumarasi": policeNumarasi,
          "BaslangicTarihi": basTarih,
          "BitisTarihi": bitTarih,
          "Adres": adres,
          "IlKodu": il,
          "IlceKodu": ilce,
        };
        break;
    }

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );
    /*  /* print(response.statusCode); */ */
    if (response.statusCode != 200)
      return "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz";
    Map resultData = json.decode(response.body);

    return resultData["message"] != null
        ? resultData["message"]
        : "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz";
  }

  static Future addGetNewOffer(
      {@required token,
      @required tckn,
      policeNumarasi,
      acentekodu,
      yenilemeno,
      sigortasirket,
      branskodu,
      plakano,
      ruhsatno,
      ruhsatkodu,
      asbisno,
      basTarih,
      bitTarih,
      modelyili,
      aciklama,
      markaid,
      modelid,
      kullanimtarzi,
      latitude,
      longitude,
      meslek,
      binakatsayisi,
      binakullanimsekli,
      binayapimyili,
      binayapimtarzi,
      dairembrut,
      adres,
      il,
      ilce,
      seyahatEdenKisiSayisi,
      seyahatUlkeKodu,
      seyahatGidisTarihi,
      seyahatDonusTarihi,
      binaBedeli,
      esyaBedeli,
      emailType,
      kullaniciId}) async {
    String requestUrl = baseURL + "Policy/AddGetOfferPolicy";
    Map<String, dynamic> _formmap = {
      "KimlikNo": tckn,
      "BransKodu": branskodu,
      "AcenteUnvani": acentekodu,
      "Aciklama": aciklama,
      "EmailType": emailType,
      "Plaka": plakano,
      "RuhsatSeriKodu": ruhsatkodu,
      "RuhsatSeriNo": ruhsatno,
      "AsbisNo": asbisno,
      "ModelYili": modelyili,
      "MarkaKodu": markaid,
      "TipKodu": modelid,
      "AracKullanimTarzi": kullanimtarzi,
      "kullaniciId": int.parse(kullaniciId)
    };

    if (branskodu != 21) {
      _formmap["BaslangicTarihi"] = basTarih;
      _formmap["BitisTarihi"] = bitTarih;
    } else {
      _formmap["SeyahatGidisTarihi"] = seyahatGidisTarihi;
      _formmap["seyahatDonusTarihi"] = seyahatDonusTarihi;
    }
    switch (branskodu) {
      case 1:
      case 2:
        _formmap["Plaka"] = plakano;
        _formmap["RuhsatSeriKodu"] = ruhsatkodu;
        _formmap["RuhsatSeriNo"] = ruhsatno;
        _formmap["AsbisNo"] = asbisno;
        _formmap["ModelYili"] = modelyili;
        _formmap["MarkaKodu"] = markaid;
        _formmap["TipKodu"] = modelid;
        _formmap["AracKullanimTarzi"] = kullanimtarzi;

        break;
      case 4:
        _formmap["Meslek"] = meslek;

        break;
      case 11:
        _formmap["BinaKatSayisi"] = binakatsayisi;
        _formmap["BinaKullanimSekli"] = binakullanimsekli;
        _formmap["BinaYapimYili"] = binayapimyili;
        _formmap["BinaYapiTarzi"] = binayapimtarzi;
        _formmap["DaireBrut"] = dairembrut;
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;

        break;
      case 21:
        _formmap["SeyahatEdenKisiSayisi"] = seyahatEdenKisiSayisi;
        _formmap["SeyahatUlkeKodu"] = seyahatUlkeKodu;

        break;
      case 22:
        _formmap["BinaBedeli"] = binaBedeli;
        _formmap["EsyaBedeli"] = esyaBedeli;
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;

        break;
      default:
        _formmap["Adres"] = adres;
        _formmap["IlKodu"] = il;
        _formmap["IlceKodu"] = ilce;

        break;
    }

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      return {
        "message": "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
        "status": false
      };
    }
    Map resultData = json.decode(response.body);

    return resultData["message"] != null
        ? {"message": resultData["message"], "status": true}
        : {
            "message":
                "İşlem yapılırken bir hata oluştu lütfen tekrar deneyiniz",
            "status": false
          };
  }

  static List<UlkeTipi> ulkeTipiList = List<UlkeTipi>();
  static List<Ulke> ulkeList = List<Ulke>();
  static List<IL> ilList = List<IL>();
  static List<ILCE> ilceList = List<ILCE>();
  static List<AracMarka> aracMarkaList = List<AracMarka>();
  static List<AracTip> aracTipList = List<AracTip>();
  static List<AracKullanimTarzi> aracKullanimTarziList =
      List<AracKullanimTarzi>();
  static List<Meslek> meslekList = List<Meslek>();
  static List<SigortaTuru> sigortaTuruList = List<SigortaTuru>();
  static List<SigortaSirketi> sigortaSirketiList = List<SigortaSirketi>();
  static List<TVMDetay> acenteList = List<TVMDetay>();

  static Future getGlobalDataRequest(
      {@required String token, @required String kimlikNo}) async {
    String requestUrl = baseURL + "/MobileApp/GetGlobalDataList";

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, dynamic> _formmap = {
      "Tc": kimlikNo,
    };
    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      return null;
    }
    Map resultData = json.decode(response.body);

    ulkeTipiList.clear();
    ulkeList.clear();
    ilList.clear();
    ilceList.clear();
    aracMarkaList.clear();
    meslekList.clear();
    sigortaTuruList.clear();
    aracKullanimTarziList.clear();
    aracTipList.clear();
    acenteList.clear();
    for (var item in resultData["mobilUlkeTipiList"]) {
      ulkeTipiList.add(UlkeTipi.fromJson(item));
    }
    for (var item in resultData["mobilUlkeList"]) {
      ulkeList.add(Ulke.fromJson(item));
    }
    for (var item in resultData["ilList"]) {
      ilList.add(IL.fromJson(item));
    }
    for (var item in resultData["ilceList"]) {
      ilceList.add(ILCE.fromJson(item));
    }
    for (var item in resultData["aracMarkaList"]) {
      aracMarkaList.add(AracMarka.fromJson(item));
    }
    for (var item in resultData["meslekList"]) {
      meslekList.add(Meslek.fromJson(item));
    }
    for (var item in resultData["bransList"]) {
      sigortaTuruList.add(SigortaTuru.fromJson(item));
    }
    for (var item in resultData["aracKullanimTarziList"]) {
      aracKullanimTarziList.add(AracKullanimTarzi.fromJson(item));
    }
    for (var item in resultData["sigortaSirketleriList"]) {
      sigortaSirketiList.add(SigortaSirketi.fromJson(item));
    }
    for (var item in resultData["aracTipList"]) {
      aracTipList.add(AracTip.fromJson(item));
    }
    for (var item in resultData["acenteList"]) {
      acenteList.add(TVMDetay.fromJson(item));
    }
  }

  static Future getAracTipRequest(
      {@required String token, @required String markakodu}) async {
    String requestUrl = baseURL + "/MobileApp/GetAracTipList";

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, dynamic> _formmap = {
      "Markakodu": markakodu,
    };
    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );
    if (response.statusCode != 200) {
      return null;
    }

    List resultData = json.decode(response.body);
    List<AracTip> aracTipList = List<AracTip>();

    for (var item in resultData) {
      aracTipList.add(AracTip.fromJson(item));
    }
    return aracTipList;
  }

  static Future getAcenteDetayRequest(
      {@required String token, @required int kodu}) async {
    String requestUrl = baseURL + "/MobileApp/GetTVMDetay";

    Map<String, String> _headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, dynamic> _formmap = {
      "Kodu": kodu,
    };
    var _body = json.encode(_formmap);

    final response = await http.post(
      requestUrl,
      body: _body,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      return null;
    }

    var resultData = json.decode(response.body);
    Acente acente = Acente.fromJson(resultData);
    return acente;
  }
}
