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

class FeedBack extends StatefulWidget {
  @override
  _FeedBack createState() => _FeedBack();
}

class _FeedBack extends State<FeedBack> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  int fileSelect =
      0; //1:profil fotografı var,0:profil fotografı yok,2:profil fotografı secimi

  final FocusNode _messageFocus = FocusNode();
  final FocusNode _subjectFocus = FocusNode();
  String _message = "";
  String _subject = "";

  List<String> _kullaniciInfo = List<String>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
    });
  }

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
                          "Bize Yazın",
                          style: TextStyleData.standartBeyaz48,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Uygulamanın geliştirilmesi için değerli görüş ve önerilerinizi bize iletin.",
                          style: TextStyleData.standartBeyaz18,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      color: ColorData.renkBeyaz,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(33),
                          topRight: Radius.circular(33)),
                      boxShadow: [BoxDecorationData.shadow]),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 32, left: 15),
                        child: Form(
                          key: _signUpFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Konu",
                                  contentPadding: EdgeInsets.only(top: 8),
                                ),
                                textInputAction: TextInputAction.next,
                                style: TextStyleData.boldSiyah,
                                focusNode: _messageFocus,
                                onFieldSubmitted: (value) {
                                  _focusNextField(_messageFocus, _subjectFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Konu yazınız.";
                                  } else
                                    return null;
                                },
                                onSaved: (value) => _message = value,
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                focusNode: _subjectFocus,
                                decoration: InputDecoration(
                                  labelText: "Mesaj",
                                  contentPadding: EdgeInsets.only(top: 8),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 12,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Önerinizi yazınız.";
                                  } else
                                    return null;
                                },
                                onSaved: (value) => _subject = value,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(33),
                        bottomRight: Radius.circular(33)),
                    boxShadow: [BoxDecorationData.shadow]),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: RaisedButton(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("GÖNDER",
                            style: TextStyleData.extraBoldLacivert16),
                      ),
                      color: ColorData.renkYesil,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _sendMessage();
                      }),
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

  void _sendMessage() async {
    final _form = _signUpFormKey.currentState;
    _form.save();
 
    if (_form.validate()) {
      _onLoading(); 
      var result = await WebAPI.sendMessage(
          adsoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1],
          token: _kullaniciInfo[3],
          email: _kullaniciInfo[5],
          konu: _subject,
          mesaj: _message);
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
      ).whenComplete(() {
        if (result["status"]) _form.reset();
      });
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
}
