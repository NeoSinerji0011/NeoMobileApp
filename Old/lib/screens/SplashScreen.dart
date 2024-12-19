import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/screens/OnboardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/screens/MainScreen.dart';
import 'package:sigortadefterim/screens/WelcomeScreen.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  bool checkisLoginProcess = false, checkisLoginResult = false;
  Future getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember') == null) {
      prefs.setBool('remember', false);
    }
  }

  Future navigationPage() async {
    await getSharedPreferences();
    print(prefs.getBool("onboard"));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => prefs.getBool("onboard")
                ? OnboardingScreen()
                : prefs.getBool('remember')
                    ? checkisLoginResult
                        ? MainScreen(
                            currentIndex: 0,
                          )
                        : WelcomeScreen()
                    : WelcomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    pageLoadData();
  }

  Future test() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('onboard') != null) {
      prefs.setBool('onboard', true);
    }
  }

  Future pageLoadData() async {
    // await UtilsPolicy().getKullaniciInfo();

    getSharedPreferences().whenComplete(() {
      if (prefs.getBool('onboard') == null)
        Utils.setCloseOnBoardScreen(check: true).whenComplete(() {
          pageLoad();
        });
      else
        pageLoad();
    });
  }

  Future pageLoad() async {
    //await getSharedPreferences();
    if (prefs.getBool('remember') != null) {
      if (prefs.getBool('remember')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          UtilsPolicy.onLoading(context,
              body: "Giriş yapılıyor, lütfen bekleyin..");

          UtilsPolicy().getKullaniciInfo().whenComplete(() {
            WebAPI.refreshToken(token: UtilsPolicy.kullaniciInfo[3])
                .then((value) {
                  print(value);
              if (value["statusCode"] == 111) {
                // _scaffoldKey.currentState.showSnackBar(SnackBar(
                //   duration: Duration(seconds: 3),
                //   content: Text(value["message"]),
                // ));
              } else if (value["message"] != "")
                Utils.setKullaniciInfo(
                  UtilsPolicy.kullaniciInfo[0],
                  UtilsPolicy.kullaniciInfo[1],
                  UtilsPolicy.kullaniciInfo[2],
                  value["message"],
                  UtilsPolicy.kullaniciInfo[4],
                  UtilsPolicy.kullaniciInfo[5],
                  UtilsPolicy.kullaniciInfo[6],
                  int.parse(UtilsPolicy.kullaniciInfo[7]),
                  UtilsPolicy.kullaniciInfo[8],
                  UtilsPolicy.kullaniciInfo[9],
                  UtilsPolicy.kullaniciInfo[10],
                  UtilsPolicy.kullaniciInfo[11],
                  UtilsPolicy.kullaniciInfo[12],
                  UtilsPolicy.kullaniciInfo[13],
                  UtilsPolicy.kullaniciInfo[14],
                );
              checkisLoginResult = value["status"];

              UtilsPolicy.closeLoader(context);
              UtilsPolicy().pdfpathLoad().whenComplete(() => navigationPage());
            });
          });
        });
      } else {
        selectNextPage();
      }
    } else {
      selectNextPage();
    }
  }

  void selectNextPage() {
    UtilsPolicy().getKullaniciInfo().whenComplete(() {
      UtilsPolicy().pdfpathLoad().whenComplete(() => navigationPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(),
    );
  }
}
