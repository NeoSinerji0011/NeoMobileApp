import 'dart:io';
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigortadefterim/AppStyle.dart';

import 'package:sigortadefterim/screens/MainScreen.dart';
import 'package:sigortadefterim/screens/VerificationCodeScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/models/User/LoginResponse.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfile createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  File _profileImage = null;
  int fileSelect =
      0; //1:profil fotografı var,0:profil fotografı yok,2:profil fotografı secimi
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _tcFocus = FocusNode();
  final FocusNode _otherTcFocus = FocusNode();
  final FocusNode _wifeTcFocus = FocusNode();
  final FocusNode _childTcFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _phoneFocus2 = FocusNode();
  final FocusNode _phoneFocus3 = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _password2Focus = FocusNode();
  String _name_surname;
  String _email;
  String _tckn;
  String _tckn_other;
  String _tckn_es;
  String _tckn_cocuk;
  String _phoneCode = '+90';
  String _phone;
  String _phoneCode1 = '+90';
  String _phone1;
  String _phoneCode2 = '+90';
  String _phone2;
  String _address;
  String _password;
  String _password_repeat;
  String resim = "";
  bool _passwordIsHide = true;
  int _kimlikSecimi = 0;
  String _kimlikNoLabel = "TCKN/YTCKN";

  String gizlilikPDFPath = "";
  String kullaniciPDFPath = "";
  bool _kullaniciChecked = false;
  bool _gizlilikChecked = false;
  bool _changeUserInfo = false;

  List<String> _kullaniciInfo = List<String>();

  RichText _gizlilikSozlesmesi = RichText(
      text: TextSpan(children: [
    TextSpan(text: "Gizlilik Politikasını ", style: TextStyleData.boldSiyah),
    TextSpan(text: "okudum ", style: TextStyleData.boldUnderLineMavi),
    TextSpan(text: "kabul ediyorum.", style: TextStyleData.boldSiyah)
  ]));

  RichText _kvkkSozlesmesi = RichText(
      text: TextSpan(children: [
    TextSpan(text: "Kullanıcı Sözleşmesini ", style: TextStyleData.boldSiyah),
    TextSpan(text: "okudum ", style: TextStyleData.boldUnderLineMavi),
    TextSpan(
        text:
            "kabul ediyorum. Bu uygulama vasıtasıyla paylaşmış ve giriş yapmış olduğum tüm bilgi ve veriler için 6698 sayılı Kişişel Verilerin Korunması Kanunu(KVKK) ve Ticari Elektronik ileti almak için 6563 sayılı Elektronik Ticaretin Düzenlenmesi Hakkında Kanun ve Mevzuatları çerçevesinde onay veriyorum.",
        style: TextStyleData.boldSiyah),
  ]));

  @override
  void initState() {
    super.initState();
    //_kullaniciInfo.addAll(["", "", "11111111111", "", ""]);
    setState(() {
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
    });
    _getKullaniciInfo();
    /*  UtilsPolicy().getKullaniciInfo().whenComplete(() {
      setState(() {
        _kullaniciInfo = UtilsPolicy.kullaniciInfo;
      });
      _getKullaniciInfo();
    }); */

    /*  getFileFromAsset("GizlilikPolitikasi", "assets/pdf/GizlilikPolitikasi.pdf")
        .then((f) {
      setState(() {
        gizlilikPDFPath = f.path;
        print(gizlilikPDFPath);
      });
    });

    getFileFromAsset(
            "KullaniciSozlesmesi", "assets/pdf/KullaniciSozlesmesi.pdf")
        .then((f) {
      setState(() {
        kullaniciPDFPath = f.path;
        print(kullaniciPDFPath);
      });
    }); */
  }

  double textfieldAraBosluk = 10;
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ColorData.renkMavi, ColorData.renkLacivert],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Container(
                //decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage("assets/images/ikonlar-3.png"), fit: BoxFit.cover)),
                width: MediaQuery.of(context).size.width / 1.2,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/ikonlar-3.png",
                      fit: BoxFit.cover,
                      height: 175,
                      width: MediaQuery.of(context).size.width / 1.3,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 25.0),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 24.0,
                            ),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pop() /* Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen(currentIndex: 0,))) */
                                  ,
                                  child: Image.asset(
                                    "assets/images/circle_arrow.png",
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Profil",
                          style: TextStyleData.standartBeyaz48,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Profilinizi düzenleyiniz.",
                          style: TextStyleData.standartBeyaz18,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                    boxShadow: [BoxDecorationData.shadow]),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 8, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 75,
                            height: 75,
                            child: InkWell(
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: fileSelect == 1
                                    ? NetworkImage(_kullaniciInfo[4])
                                    : fileSelect == 2
                                        ? FileImage(_profileImage)
                                        : AssetImage("assets/images/add-2.png"),
                              ),
                              onTap: () {
                                _pickProfileImage();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("Profil fotoğrafı yükle",
                              style: TextStyleData.boldSiyah)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Form(
                        key: _signUpFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Ad Soyad",
                                enabled: false,
                                contentPadding: EdgeInsets.only(top: 8),
                              ),
                              textInputAction: TextInputAction.next,
                              initialValue:
                                  _kullaniciInfo[0] + " " + _kullaniciInfo[1],
                              style: TextStyleData.boldSiyah,
                              focusNode: _nameFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_nameFocus, _emailFocus);
                              },
                              validator: (value) => value.isEmpty
                                  ? 'Adınızı ve Soyadınızı giriniz'
                                  : null,
                              onSaved: (value) {
                                _name_surname = value;
                              },
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              initialValue: "${_kullaniciInfo[2]}",
                              decoration: InputDecoration(
                                labelText: "Tc Kimlik No",
                                enabled: false,
                                contentPadding: EdgeInsets.only(top: 8),
                                suffixIcon: IconButton(
                                    icon: Image.asset(
                                      "assets/images/ic_soru.png",
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            MyDialog(
                                          dialogKind: "AlertDialogKimlik",
                                        ),
                                      );
                                    }),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _tcFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_tcFocus, _otherTcFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'TC, Vergi Kimlik veya Pasaport No giriniz';
                                } else {
                                  if (_kimlikSecimi == 0) {
                                    bool valid = RegExp(r'(^[[0-9]{11}$)')
                                        .hasMatch(value);
                                    if (!valid)
                                      return 'TCKN/YTCKN 11 haneli olarak giriniz';
                                    else
                                      return null;
                                  } else if (_kimlikSecimi == 1) {
                                    bool valid = RegExp(r'(^[[0-9]{10}$)')
                                        .hasMatch(value);
                                    if (!valid)
                                      return 'VKN 10 haneli olarak giriniz';
                                    else
                                      return null;
                                  } else {
                                    if (value.length == 7 ||
                                        value.length == 9) {
                                      bool valid = RegExp(
                                              r'(^([a-zA-Z]){1}?([[0-9]){6,8}$)')
                                          .hasMatch(value);
                                      if (!valid) {
                                        return 'Pasaport No U123456 veya U12345678 formatta olmalı';
                                      } else
                                        return null;
                                    } else
                                      return 'Pasaport No U123456 veya U12345678 formatta olmalı';
                                  }
                                }
                              },
                              onSaved: (value) {
                                _tckn = value;
                              },
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Tc Kimlik Eş",
                                contentPadding: EdgeInsets.only(top: 8),
                                suffixIcon: IconButton(
                                    icon: Image.asset(
                                      "assets/images/ic_soru.png",
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            MyDialog(
                                          imageUrl:
                                              "assets/images/ic_soru-2.png",
                                          body:
                                              "Poliçesini görmek isterseniz eşinizin poliçesinde sigorta ettiren durumunda olmalısınız.",
                                          buttonText: "TAMAM",
                                          dialogKind: "AlertDialogInfo",
                                        ),
                                      );
                                    }),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              initialValue: _tckn_es,
                              focusNode: _wifeTcFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_wifeTcFocus, _phoneFocus);
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  bool valid =
                                      RegExp(r'(^[[0-9]{11}$)').hasMatch(value);
                                  if (!valid)
                                    return 'TCKN/YTCKN 11 haneli olarak giriniz';
                                  else
                                    return null;
                                } else
                                  return null;
                              },
                              onSaved: (value) => _tckn_es = value,
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Tc Kimlik Çocuk",
                                contentPadding: EdgeInsets.only(top: 8),
                                suffixIcon: IconButton(
                                    icon: Image.asset(
                                      "assets/images/ic_soru.png",
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            MyDialog(
                                          imageUrl:
                                              "assets/images/ic_soru-2.png",
                                          body:
                                              "Poliçesini görmek isterseniz çocuğunuzun poliçesinde sigorta ettiren durumunda olmalısınız.",
                                          buttonText: "TAMAM",
                                          dialogKind: "AlertDialogInfo",
                                        ),
                                      );
                                    }),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              initialValue: _tckn_cocuk,
                              focusNode: _childTcFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_childTcFocus, _phoneFocus);
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  bool valid =
                                      RegExp(r'(^[[0-9]{11}$)').hasMatch(value);
                                  if (!valid)
                                    return 'TCKN/YTCKN 11 haneli olarak giriniz';
                                  else
                                    return null;
                                } else
                                  return null;
                              },
                              onSaved: (value) => _tckn_cocuk = value,
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Diğer TCKN No",
                                contentPadding: EdgeInsets.only(top: 8),
                                suffixIcon: IconButton(
                                    icon: Image.asset(
                                      "assets/images/ic_soru.png",
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            MyDialog(
                                          imageUrl:
                                              "assets/images/ic_soru-2.png",
                                          body:
                                              "Poliçesini görmek isterseniz diğer kişinin poliçesinde sigorta ettiren durumunda olmalısınız.",
                                          buttonText: "TAMAM",
                                          dialogKind: "AlertDialogInfo",
                                        ),
                                      );
                                    }),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _otherTcFocus,
                              initialValue: _tckn_other,
                              onFieldSubmitted: (value) {
                                _focusNextField(_otherTcFocus, _phoneFocus);
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  bool valid =
                                      RegExp(r'(^[[0-9]{11}$)').hasMatch(value);
                                  if (!valid)
                                    return 'TCKN/YTCKN 11 haneli olarak giriniz';
                                  else
                                    return null;
                                } else
                                  return null;
                              },
                              onSaved: (value) => _tckn_other = value,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: CountryCodePicker(
                                    onChanged: (value) {
                                      _phoneCode = value.toString();
                                    },

                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: _phoneCode != ""
                                        ? "+" + _phoneCode
                                        : 'TR',
                                    /*   favorite: ['+90', 'TR'], */
                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,
                                    // optional. aligns the flag and the Text left
                                    alignLeft: true,
                                    textStyle: TextStyleData.boldSiyah,
                                    searchStyle: TextStyleData.boldSiyah,
                                  ),
                                ),
                                SizedBox(
                                  height: textfieldAraBosluk,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'GSM Numaranız',
                                      contentPadding: EdgeInsets.only(top: 8),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    style: TextStyleData.boldSiyah,
                                    focusNode: _phoneFocus,
                                    initialValue: _phone,
                                    onFieldSubmitted: (value) {
                                      _focusNextField(
                                          _phoneFocus, _phoneFocus2);
                                    },
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        bool valid = RegExp(r'(^[[0-9]{10}$)')
                                            .hasMatch(value);
                                        if (!valid)
                                          return 'Telefon numaranızı 10 haneli giriniz';
                                        else
                                          return null;
                                      } else
                                        return null;
                                    },
                                    onSaved: (value) => _phone = value,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: CountryCodePicker(
                                    onChanged: (value) {
                                      _phoneCode1 = value.toString();
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: _phoneCode1 != ""
                                        ? "+" + _phoneCode1
                                        : 'TR',
                                    /*  favorite: ['TR'], */
                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,
                                    // optional. aligns the flag and the Text left
                                    alignLeft: true,
                                    textStyle: TextStyleData.boldSiyah,
                                    searchStyle: TextStyleData.boldSiyah,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Acil durum GSM No 1',
                                      contentPadding: EdgeInsets.only(top: 8),
                                      suffixIcon: IconButton(
                                          icon: Image.asset(
                                            "assets/images/ic_soru.png",
                                            height: 24,
                                            width: 24,
                                            fit: BoxFit.contain,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  MyDialog(
                                                imageUrl:
                                                    "assets/images/ic_soru-2.png",
                                                body:
                                                    "Acil durumda aranacak sevdiklerinizin numarasını giriniz.",
                                                buttonText: "TAMAM",
                                                dialogKind: "AlertDialogInfo",
                                              ),
                                            );
                                          }),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    style: TextStyleData.boldSiyah,
                                    focusNode: _phoneFocus2,
                                    initialValue: _phone1,
                                    onFieldSubmitted: (value) {
                                      _focusNextField(
                                          _phoneFocus2, _phoneFocus3);
                                    },
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        bool valid = RegExp(r'(^[[0-9]{10}$)')
                                            .hasMatch(value);
                                        if (!valid)
                                          return 'Telefon numaranızı 10 haneli giriniz';
                                        else
                                          return null;
                                      } else
                                        return null;
                                    },
                                    onSaved: (value) => _phone1 = value,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: CountryCodePicker(
                                    onChanged: (value) {
                                      _phoneCode2 = value.toString();
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: _phoneCode2 != ""
                                        ? "+" + _phoneCode2
                                        : 'TR',
                                    /* favorite: ['TR'], */
                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,
                                    // optional. aligns the flag and the Text left
                                    alignLeft: true,
                                    textStyle: TextStyleData.boldSiyah,
                                    searchStyle: TextStyleData.boldSiyah,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Acil durum GSM No 2',
                                      contentPadding: EdgeInsets.only(top: 8),
                                      suffixIcon: IconButton(
                                          icon: Image.asset(
                                            "assets/images/ic_soru.png",
                                            height: 24,
                                            width: 24,
                                            fit: BoxFit.contain,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  MyDialog(
                                                imageUrl:
                                                    "assets/images/ic_soru-2.png",
                                                body:
                                                    "Acil durumda aranacak sevdiklerinizin numarasını giriniz.",
                                                buttonText: "TAMAM",
                                                dialogKind: "AlertDialogInfo",
                                              ),
                                            );
                                          }),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    style: TextStyleData.boldSiyah,
                                    focusNode: _phoneFocus3,
                                    initialValue: _phone2,
                                    onFieldSubmitted: (value) {
                                      _focusNextField(
                                          _phoneFocus3, _addressFocus);
                                    },
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        bool valid = RegExp(r'(^[[0-9]{10}$)')
                                            .hasMatch(value);
                                        if (!valid)
                                          return 'Telefon numaranızı 10 haneli giriniz';
                                        else
                                          return null;
                                      } else
                                        return null;
                                    },
                                    onSaved: (value) => _phone2 = value,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Adres",
                                contentPadding: EdgeInsets.only(top: 8),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _addressFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_addressFocus, _passwordFocus);
                              },
                              initialValue: _address,
                              onSaved: (value) => _address = value,
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Şifre",
                                contentPadding: EdgeInsets.only(top: 8),
                                //suffixIcon: InkWell(
                                //  child: Icon(Icons.remove_red_eye),
                                //  onTap: () {
                                //    setState(() {
                                //      _passwordIsHide = !_passwordIsHide;
                                //    });
                                //  },
                                //)
                              ),
                              obscureText: _passwordIsHide,
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _passwordFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(
                                    _passwordFocus, _password2Focus);
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  if (value.length < 6)
                                    return "Şifre en az 6 karakter olmalı";
                                  else if (!validatePassword(value))
                                    return "Şifre en az bir büyük, bir küçük harf ve nümerik karekterlerden oluşmalı";
                                  else
                                    return null;
                                } else
                                  return null;
                              },
                              onSaved: (value) => _password = value,
                            ),
                            SizedBox(
                              height: textfieldAraBosluk,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Şifre Tekrarı",
                                contentPadding: EdgeInsets.only(top: 8),
                                //suffixIcon: InkWell(
                                //  child: Icon(Icons.remove_red_eye),
                                //  onTap: () {
                                //    setState(() {
                                //      _passwordIsHide = !_passwordIsHide;
                                //    });
                                //  },
                                //)
                              ),
                              obscureText: _passwordIsHide,
                              textInputAction: TextInputAction.done,
                              style: TextStyleData.boldSiyah,
                              focusNode: _password2Focus,
                              validator: (value) => value != _password
                                  ? "Şifre Tekrarı Şifreniz ile uyuşmuyor"
                                  : null,
                              onSaved: (value) => _password_repeat = value,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: RaisedButton(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("KAYDET",
                                style: TextStyleData.extraBoldLacivert16),
                          ),
                          color: ColorData.renkYesil,
                          shape: StadiumBorder(),
                          onPressed: () {
                            _userUpdate();
                          }),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _userUpdate() async {
    final _form = _signUpFormKey.currentState;
    _form.save();

    if (_form.validate()) {
      _onLoading();
      var result = await WebAPI.userUpdateRequest(
          adsoyad: _name_surname,
          token: _kullaniciInfo[3],
          tckn: _tckn,
          tckn_diger: _tckn_other,
          tckn_es: _tckn_es,
          tckn_cocuk: _tckn_cocuk,
          gsm: _phoneCode.replaceAll('+', '') + _phone,
          gsm1: _phoneCode1.replaceAll('+', '') + _phone1,
          gsm2: _phoneCode2.replaceAll('+', '') + _phone2,
          adres: _address,
          password: _password,
          resim: resim);
      if (result["status"]) {
        await Utils.setKullaniciInfo(
            result["data"]["adsoyad"].split(" ")[0],
            result["data"]["adsoyad"].split(" ")[1],
            result["data"]["tc"],
            _kullaniciInfo[3],
            result["data"]["resim"],
            result["data"]["eposta"],
            result["data"]["guvenlik"],
            result["data"]["id"],
            result["data"]["telefon"],
            result["data"]["gsm_1"],
            result["data"]["gsm_2"],
            result["data"]["adres"],
            result["data"]["tc_Es"],
            result["data"]["tc_Cocuk"],
            result["data"]["tc_Diger"]);
        await UtilsPolicy().getKullaniciInfo();
      }
      closeLoader();

      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
            imageUrl: !result["status"]
                ? "assets/images/ic_info.png"
                : "assets/images/ic_tick.png",
            dialogKind: "AlertDialogInfo",
            body: result["message"],
            buttonText: "Kapat"),
      );
    }
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            color: ColorData.renkGri,
            height: 100,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  void closeLoader() {
    Navigator.pop(context);
  }

  void _focusNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(_signUpFormKey.currentContext).requestFocus(nextFocus);
  }

  void _pickProfileImage() async {
    final imageSource = await showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
              dialogKind: "ImagePick",
            ));

    if (imageSource != null) {
      List<int> imageFile;
      final file = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 700, maxHeight: 500);

      if (file != null) {
        imageFile = file.readAsBytesSync();
        //String img64 = base64Encode(imageFile);
        setState(() {
          fileSelect = 2;
          _profileImage = file;
          resim = base64Encode(imageFile);
        });
      }
    }
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
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

  void _getKullaniciInfo() {
    /* Utils.getKullaniciInfo().then((value) {
      print(value);
     
    }); */
    setState(() {
      fileSelect = _kullaniciInfo[4] != "noavatar.png" ? 1 : 0;
      _address = _kullaniciInfo[11];
      _tckn = _kullaniciInfo[2];
      _tckn_es = _kullaniciInfo[12];
      _tckn_cocuk = _kullaniciInfo[13];
      _tckn_other = _kullaniciInfo[14];

      _phone = _kullaniciInfo[8] != null
          ? _kullaniciInfo[8].length > 10
              ? _kullaniciInfo[8].substring(_kullaniciInfo[8].length - 10)
              : _kullaniciInfo[8]
          : "";
      _phoneCode = _kullaniciInfo[8] != null
          ? _kullaniciInfo[8].length > 11
              ? _kullaniciInfo[8].substring(0, _kullaniciInfo[8].length - 10)
              : ""
          : "";

      _phone1 = _kullaniciInfo[9] != null
          ? _kullaniciInfo[9].length > 10
              ? _kullaniciInfo[9].substring(_kullaniciInfo[9].length - 10)
              : _kullaniciInfo[9]
          : "";
      _phoneCode1 = _kullaniciInfo[9] != null
          ? _kullaniciInfo[9].length > 11
              ? _kullaniciInfo[9].substring(0, _kullaniciInfo[9].length - 10)
              : ""
          : "";

      _phone2 = _kullaniciInfo[10] != null
          ? _kullaniciInfo[10].length > 10
              ? _kullaniciInfo[10].substring(_kullaniciInfo[10].length - 10)
              : _kullaniciInfo[10]
          : "";
      _phoneCode2 = _kullaniciInfo[10] != null
          ? _kullaniciInfo[10].length > 11
              ? _kullaniciInfo[10].substring(0, _kullaniciInfo[10].length - 10)
              : ""
          : "";
    });
  }
}
