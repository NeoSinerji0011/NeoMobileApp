import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/screens/LoginScreen.dart';
import 'package:sigortadefterim/screens/SignUpScreen.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class WelcomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0047FD), Color(0xff0B1A3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.6])),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.6,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage("assets/images/ikonlar.png"),
                      fit: BoxFit.contain)),
              child: Image.asset(
                "assets/images/logo-2.png",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration:
                        BoxDecoration(boxShadow: [BoxDecorationData.shadow]),
                    child: OutlineButton(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("ÜYE OL",
                                style: TextStyleData.extraBoldYesil16)),
                        shape: StadiumBorder(),
                        borderSide: BorderSide(
                            color: ColorData.renkYesil,
                            style: BorderStyle.solid,
                            width: 2),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        }),
                  ),
                  SizedBox(height: 18),
                  Container(
                    decoration:
                        BoxDecoration(boxShadow: [BoxDecorationData.shadow]),
                    child: RaisedButton(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("GİRİŞ YAP",
                                style: TextStyleData.extraBoldLacivert16)),
                        shape: StadiumBorder(),
                        color: ColorData.renkYesil,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
