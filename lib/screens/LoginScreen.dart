import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/User/LoginResponse.dart';
import 'package:sigortadefterim/screens/ForgotPasswordScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';

import 'MainScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _email;
  String _password;
  bool _passwordIsHide = true;
  bool checkedValue = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff0047FD), Color(0xff0B1A3D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.7])),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 2.2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: ExactAssetImage(
                                      "assets/images/ikonlar.png"),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Text(
                                "Merhaba",
                                style: TextStyleData.standartBeyaz48,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Devam etmek için lütfen giriş yapınız.",
                                style: TextStyleData.standartBeyaz18,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(48, 0, 48, 0),
                          decoration: BoxDecoration(
                              color: ColorData.renkBeyaz,
                              borderRadius: BorderRadius.circular(33)),
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _loginFormKey,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          32, 16, 0, 8),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "E-posta",
                                          contentPadding:
                                              EdgeInsets.only(top: 8),
                                        ),
                                        textInputAction: TextInputAction.next,
                                        style: TextStyleData.boldSiyah,
                                        focusNode: _emailFocus,
                                        onFieldSubmitted: (value) {
                                          _focusNextField(
                                              _emailFocus, _passwordFocus);
                                        },
                                        validator: (value) {
                                          if (value.isNotEmpty) {
                                            bool emailValid = RegExp(
                                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                .hasMatch(value);
                                            if (!emailValid)
                                              return 'Lütfen geçerli bir e-posta adresi giriniz.';
                                            else
                                              return null;
                                          } else
                                            return 'E-posta adresinizi giriniz';
                                        },
                                        onSaved: (value) => _email = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          32, 16, 0, 8),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: "Şifre",
                                          contentPadding:
                                              EdgeInsets.only(top: 8),
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
                                        focusNode: _passwordFocus,
                                        validator: (value) => value.isEmpty
                                            ? "Şifrenizi giriniz"
                                            : null,
                                        onSaved: (value) => _password = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            tristate: false,
                                            value: checkedValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                checkedValue = newValue;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Beni Hatırla',
                                            style: TextStyleData.boldAcikSiyah,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 16, 32, 16),
                                        child: InkWell(
                                          child: Text(
                                            "Şifremi Unuttum",
                                            style: TextStyleData
                                                .boldUnderlineSiyah,
                                          ),
                                          onTap: () {
                                            //showDialog(
                                            //  context: context,
                                            //  builder: (BuildContext context) => MyDialog(
                                            //    imageUrl: "assets/images/logo-3.png",
                                            //    body: "E-posta adresinizi girerek şifrenizi sıfırlayın",
                                            //    buttonText: "GÖNDER",
                                            //    dialogKind: "ForgotPassword",
                                            //  ),
                                            //);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPasswordScreen()));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: RaisedButton(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("GİRİŞ",
                                        style:
                                            TextStyleData.extraBoldLacivert16),
                                  ),
                                  shape: StadiumBorder(),
                                  color: ColorData.renkYesil,
                                  onPressed: () {
                                    final _form = _loginFormKey.currentState;
                                    _form.save();
                                    if (_form.validate()) { 
                                      _login();
                                    } else {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text(
                                            "Lütfen boş alanları doldurunuz."),
                                      ));
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  void _focusNextField(FocusNode currentFocus, FocusNode nextFocus) {
    FocusScope.of(context).requestFocus(new FocusNode());
    currentFocus.unfocus();
    FocusScope.of(_loginFormKey.currentContext).requestFocus(nextFocus);
  }

  void _login() async {
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MyDialog(
              body: "Giriş yapılıyor, lütfen bekleyin..",
              buttonText: "",
              dialogKind: "Waiting",
            ));

    LoginResponse result =
        await WebAPI.loginRequest(email: _email, password: _password);
    Navigator.of(context).pop();
    if (result.token == "timeout") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
              "Giriş yapma işlemi zaman aşımına uğradı, lütfen tekrar deneyin.")));
    } else if (result.token == "error") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
              "Bağlantınızı kontrol ediniz.")));
      print(result.token);
    } else if (result.token == "-200") {
      //Navigator.of(context).pop();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          content: Text("E-posta veya şifre yanlış.")));
    } else {
      if (checkedValue == true) {
        Utils.setRememberMe(check: true);
      } else {
        Utils.setRememberMe(check: false);
      }
      Utils.setKullaniciInfo(
          result.kullanici.adsoyad.split(" ")[0],
          result.kullanici.adsoyad.split(" ")[1],
          result.kullanici.tc,
          result.token,
          result.kullanici.resim,
          result.kullanici.eposta,
          result.kullanici.guvenlik,
          result.kullanici.id,
          result.kullanici.telefon,
          result.kullanici.gsm1,
          result.kullanici.gsm2,
          result.kullanici.adres,
          result.kullanici.tc_es,
          result.kullanici.tc_cocuk,
          result.kullanici.tc_diger);

      //Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainScreen(loginResponse: result, currentIndex: 0)));
    }
  }
}
