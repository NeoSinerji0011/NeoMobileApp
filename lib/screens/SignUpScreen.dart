import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/widgets/PdfViewPage.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sigortadefterim/screens/VerificationCodeScreen.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _tcFocus = FocusNode();
  final FocusNode _otherTcFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _password2Focus = FocusNode();

  File _profileImage = null;
  String _name_surname;
  String _name_surnameTempText;
  String _name_surnameTempValue;
  bool _isThereAdSoyad = false;
  String _email;
  String _tckn;
  String _tckn_other;
  String _phoneCode = 'Seçiniz';
  String _phone;
  String _address;
  String _password;
  String _password_repeat;
  String _userPhoto = "";
  TextEditingController _textControllerNameSurname =
      new TextEditingController();
  TextEditingController _textControllerEmail = new TextEditingController();

  bool _passwordIsHide = true;
  int _kimlikSecimi = 0;
  String _kimlikNoLabel = "TC Kimlik No";

  TextEditingController _tcController = TextEditingController();

  /* String gizlilikPDFPath = "";
  String kullaniciPDFPath = ""; */
  bool _kullaniciChecked = false;
  bool _gizlilikChecked = false;

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
    if (UtilsPolicy.gizlilikPDFPath.isEmpty) {
      UtilsPolicy().pdfpathLoad();
    }

    /* getFileFromAsset("GizlilikPolitikasi", "assets/pdf/GizlilikPolitikasi.pdf")
        .then((f) {
      setState(() {
        gizlilikPDFPath = f.path; 
      });
    });

    getFileFromAsset(
            "KullaniciSozlesmesi", "assets/pdf/KullaniciSozlesmesi.pdf")
        .then((f) {
      setState(() {
        kullaniciPDFPath = f.path;
        
      });
    }); */
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

  @override
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
                        SizedBox(height: 30),
                        Text(
                          "Merhaba",
                          style: TextStyleData.standartBeyaz48,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Devam etmek için lütfen üye olunuz.",
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
                                backgroundImage: _profileImage != null
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Radio(
                                      activeColor: ColorData.renkMavi,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: 0,
                                      groupValue: _kimlikSecimi,
                                      onChanged: (value) {
                                        setState(() {
                                          _kimlikSecimi = value;
                                          print(_kimlikSecimi.toString());
                                          _kimlikNoLabel = "TC Kimlik No";
                                          _tcController.clear();
                                        });
                                      },
                                    ),
                                    Text("TC Kimlik No",
                                        style: TextStyleData.boldSiyah)
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Radio(
                                        activeColor: ColorData.renkMavi,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: 1,
                                        groupValue: _kimlikSecimi,
                                        onChanged: (value) {
                                          setState(() {
                                            _kimlikSecimi = value;
                                            print(_kimlikSecimi.toString());
                                            _kimlikNoLabel =
                                                "Yabancı TC Kimlik No";
                                            _tcController.text = '800';
                                          });
                                        }),
                                    Text("Yabancı TC Kimlik No",
                                        style: TextStyleData.boldSiyah)
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Radio(
                                        activeColor: ColorData.renkMavi,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: 2,
                                        groupValue: _kimlikSecimi,
                                        onChanged: (value) {
                                          setState(() {
                                            _kimlikSecimi = value;
                                            print(_kimlikSecimi.toString());
                                            _kimlikNoLabel = "Vergi Kimlik No";
                                            _tcController.clear();
                                          });
                                        }),
                                    Text("Vergi Kimlik No",
                                        style: TextStyleData.boldSiyah)
                                  ],
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: _tcController,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(11),
                              ],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                labelText: _kimlikNoLabel,
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
                                _focusNextField(_tcFocus, _nameFocus);
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
                                  } else if (_kimlikSecimi == 2) {
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
                              onSaved: (value) => _tckn = value,
                              onChanged: (value) {
                                if (value.length == 11)
                                  isthereTcNoVergiNo(value);
                              },
                            ),
                            _isThereAdSoyad
                                ? TextFormField(
                                    readOnly: true,
                                    controller: _textControllerNameSurname,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 2),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    style: TextStyleData.boldSiyah,
                                    focusNode: _nameFocus,
                                  )
                                : Container(),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Ad Soyad",
                                contentPadding: EdgeInsets.only(top: 8),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _nameFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_nameFocus, _emailFocus);
                              },
                              validator: (value) => value.isEmpty
                                  ? 'Adınızı ve Soyadınızı giriniz'
                                  : _isThereAdSoyad
                                      ? _name_surnameTempValue.toLowerCase() !=
                                              _name_surname.toLowerCase()
                                          ? "Kimlik-Ad Soyad uyuşmuyor, lütfen doğru giriniz"
                                          : null
                                      : null,
                              onSaved: (value) => _name_surname = value,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "E-posta",
                                contentPadding: EdgeInsets.only(top: 8),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _emailFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_emailFocus, _otherTcFocus);
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(value);
                                  if (!emailValid)
                                    return 'Lütfen geçerli bir e-posta adresi giriniz';
                                  else
                                    return null;
                                } else
                                  return 'E-posta adresinizi giriniz';
                              },
                              onSaved: (value) => _email = value,
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
                                              "Sigorta Defterim uygulamasına kayıt olan ve size takip izni verecek olan kişinin TC Kimlik Numarası girerek poliçeleri takip edebilirsiniz.",
                                          buttonText: "TAMAM",
                                          dialogKind: "AlertDialogInfo",
                                        ),
                                      );
                                    }),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _otherTcFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_otherTcFocus, _phoneFocus);
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
                                    initialSelection: 'TR',
                                    favorite: ['TR'],
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
                                      new LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: "Telefon",
                                      contentPadding: EdgeInsets.only(top: 8),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    style: TextStyleData.boldSiyah,
                                    focusNode: _phoneFocus,
                                    onFieldSubmitted: (value) {
                                      _focusNextField(
                                          _phoneFocus, _addressFocus);
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
                                        return 'Telefon numaranızı giriniz';
                                    },
                                    onSaved: (value) => {
                                      if (value.length <= 11) {_phone = value}
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
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
                                          dialogKind: "AlertDialogAdres",
                                        ),
                                      );
                                    }),
                                labelText: "Adres",
                                contentPadding: EdgeInsets.only(top: 8),
                              ),
                              textInputAction: TextInputAction.next,
                              style: TextStyleData.boldSiyah,
                              focusNode: _addressFocus,
                              onFieldSubmitted: (value) {
                                _focusNextField(_addressFocus, _passwordFocus);
                              },
                              validator: (value) =>
                                  value.isEmpty ? 'Adresinizi giriniz' : null,
                              onSaved: (value) => _address = value,
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
                                if (value.isEmpty) {
                                  return "Şifrenizi giriniz";
                                } else if (value.length < 6) {
                                  return "Şifre en az 6 karakter olmalıdır.";
                                } else if (!validatePassword(value)) {
                                  return "Şifre en az bir büyük, bir küçük harf ve nümerik karekterlerden oluşmalı";
                                } else
                                  return null;
                              },
                              onSaved: (value) => _password = value,
                            ),
                            SizedBox(
                              height: 16,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorData.renkMavi,
                              checkColor: ColorData.renkBeyaz,
                              value: _gizlilikChecked,
                              onChanged: (value) {
                                setState(() {
                                  _gizlilikChecked = value;
                                });
                              }),
                          InkWell(
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 1.2 - 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: _gizlilikSozlesmesi,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewPage(
                                          path: UtilsPolicy.gizlilikPDFPath)));
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: ColorData.renkMavi,
                              checkColor: ColorData.renkBeyaz,
                              value: _kullaniciChecked,
                              onChanged: (value) {
                                setState(() {
                                  _kullaniciChecked = value;
                                  print(_kullaniciChecked);
                                });
                              }),
                          InkWell(
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 1.2 - 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: _kvkkSozlesmesi,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewPage(
                                          path: UtilsPolicy.kullaniciPDFPath)));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: RaisedButton(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("ÜYE OL",
                                style: TextStyleData.extraBoldLacivert16),
                          ),
                          color: ColorData.renkYesil,
                          shape: StadiumBorder(),
                          onPressed: () {
                            _signUp();
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

  void _focusNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(_signUpFormKey.currentContext).requestFocus(nextFocus);
  }

  void _signUp() {
    final _form = _signUpFormKey.currentState;
    _form.save();
    /*  bool validate = true;
    if (_isThereAdSoyad) {
      print(_name_surnameTempValue.toLowerCase());
      print(_name_surname.toLowerCase());
      if (_name_surnameTempValue.toLowerCase() == _name_surname.toLowerCase()) {
        validate = true;
      } else {
        validate = false; 
      }
    } */
    if (_form.validate()) {
      if (_gizlilikChecked && _kullaniciChecked) {
        FocusScope.of(context).unfocus();
        WebAPI.registerRequest(
                adsoyad: _name_surname,
                email: _email,
                tckn: _tckn,
                digertckn: _tckn_other,
                telefon: _phone,
                adres: _address,
                password: _password,
                resim: _userPhoto)
            .then((result) {
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
                imageUrl: !result["status"]
                    ? "assets/images/ic_info.png"
                    : "assets/images/ic_tick.png",
                dialogKind: "AlertDialogInfo",
                body: result["message"],
                buttonText: "Kapat"),
          ).then((value) {
            if (result["status"]) Navigator.of(context).pop();
          });
        });
      } else {
        bottomMessageBox("Gizlilik sözleşmelerini kabul ediniz");
      }
    } else {
      /* showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          dialogKind: "AlertConfirmAccountCode",
          imageUrl: "assets/images/ic_info.png",
        ),
      ); */
      bottomMessageBox("Lütfen boş alanları doldurunuz.");
    }
  }

  void bottomMessageBox(String mesaj) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(duration: Duration(seconds: 3), content: Text(mesaj)));
  }

  void _pickProfileImage() async {
    final imageSource = await showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
              dialogKind: "ImagePick",
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(
          source: imageSource, maxHeight: 600, maxWidth: 800);
      if (file != null)
        setState(() {
          _profileImage = file;
        });
      final List<int> imageFile = file.readAsBytesSync();

      _userPhoto = base64Encode(imageFile);
    }
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void isthereTcNoVergiNo(String tcNoVergiNo) {
    if (_kimlikSecimi != 0) return;
    WebAPI.isthereTcNoVergiNo(tcno: tcNoVergiNo, kimlikSecimi: _kimlikSecimi)
        .then((result) {
      if (result["status"]) {
        String adi =
            result["message"]["adiUnvan"].toString().split(" ").length > 1
                ? result["message"]["adiUnvan"].toString().split(" ")[0]
                : result["message"]["adiUnvan"].toString();
        String adiTemp2 =
            result["message"]["adiUnvan"].toString().split(" ").length > 1
                ? result["message"]["adiUnvan"].toString().split(" ")[0]
                : result["message"]["adiUnvan"].toString();
        String soyadiTemp =
            result["message"]["adiUnvan"].toString().split(" ").length > 1
                ? result["message"]["adiUnvan"].toString().split(" ")[1]
                : "";
        String soyadi = result["message"]["soyadiUnvan"] != null
            ? result["message"]["soyadiUnvan"]
            : soyadiTemp;
        String soyadiTemp2 = result["message"]["soyadiUnvan"] != null
            ? result["message"]["soyadiUnvan"]
            : soyadiTemp;
        //ad edit

        switch (adi.length) {
          case 3:
          case 4:
            adi = adi.substring(0, 1) + "****" + adi.substring(adi.length - 1);
            break;
          default:
            adi = adi.substring(0, 2) +
                "****" +
                adi.toString().substring(adi.length - 2);
        }
        //soyad edit
        switch (soyadi.length) {
          case 0:
            break;
          case 3:
          case 4:
            soyadi = soyadi.substring(0, 1) +
                "****" +
                soyadi.substring(soyadi.length - 1);
            break;
          default:
            soyadi = soyadi.substring(0, 2) +
                "****" +
                soyadi.toString().substring(soyadi.length - 2);
        }
        setState(() {
          _name_surnameTempText = adi + " " + soyadi;
          _textControllerNameSurname.text = adi + " " + soyadi;
          _name_surnameTempValue = adiTemp2 + " " + soyadiTemp2;

          _isThereAdSoyad = true;
        });
      } else {
        print(12331);
        setState(() {
          _name_surnameTempText = "";
          _name_surnameTempValue = "";
          _isThereAdSoyad = false;
        });
      }
    });
  }
}
