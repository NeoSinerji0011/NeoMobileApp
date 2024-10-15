import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;

  @override
  void initState() {
    super.initState();
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
                  colors: [Color(0xff0047FD), Color(0xff0B1A3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.7])),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 48),
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ExactAssetImage("assets/images/ikonlar.png"),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text(
                          "Şifre Sıfırlama",
                          style: TextStyleData.standartBeyaz48,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Şifrenizi sıfırlama yönergeleri e-posta adresinize gönderilecektir.",
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
                              SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 16, 0, 8),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      labelText: "E-posta",
                                      contentPadding: EdgeInsets.only(top: 8)),
                                  textInputAction: TextInputAction.next,
                                  style: TextStyleData.boldSiyah,
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
                            ],
                          ),
                        ),
                        SizedBox(height: 48),
                        Container(
                          //decoration: BoxDecoration(boxShadow: [BoxDecorationData.shadow]),
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: RaisedButton(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("GÖNDER",
                                  style: TextStyleData.extraBoldLacivert16),
                            ),
                            shape: StadiumBorder(),
                            color: ColorData.renkYesil,
                            onPressed: () {
                              final _form = _loginFormKey.currentState;
                              _form.save();
                              if (_form.validate()) {
                                _sendMail();
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  duration: Duration(seconds: 3),
                                  content:
                                      Text("Lütfen boş alanları doldurunuz."),
                                ));
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 36,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void _sendMail() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MyDialog(
              body: "İşlem yapılıyor, lütfen bekleyin.",
              buttonText: "",
              dialogKind: "Waiting",
            ));

    var result = await WebAPI.passwordResetRequest(email: _email);
    Navigator.of(context).pop(); 
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MyDialog(
              body: result.message,
              buttonText: "Ok",
              dialogKind: "AlertDialogInfo",
              imageUrl: result.statusCode!=200
                ? "assets/images/ic_info.png"
                : "assets/images/ic_tick.png",
            ));
  }
}
