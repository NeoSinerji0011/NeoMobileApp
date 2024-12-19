import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/screens/SplashScreen2.dart';
import 'package:sigortadefterim/screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart'; 

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen2> {
  startTime() async {
    var _duration = new Duration(seconds:2);

    return new Timer(_duration, navigationPage);
  }

  
  
  Future navigationPage() async { 
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  @override
  void initState() {
    super.initState(); 
   startTime(); 
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage("assets/images/ikonlar.png")),
            gradient: LinearGradient(
                colors: [Color(0xff0047FD), Color(0xff0B1A3D)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.1, 0.7])),
        child: Center(
          child: Image.asset(
            "assets/images/logo-2.png",
          ),
        ),
      ),
    );
  }
}
