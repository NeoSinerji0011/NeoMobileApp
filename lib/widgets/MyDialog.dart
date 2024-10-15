import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/screens/LoginScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class MyDialog extends StatefulWidget {
  final String imageUrl, body, buttonText, button2Text, dialogKind;
  final Color color;
  Function(int) createPDF;

  MyDialog(
      {this.body = "",
      this.buttonText = "",
      @required this.dialogKind,
      this.button2Text = "",
      this.imageUrl = "",
      this.color,
      this.createPDF});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    switch (widget.dialogKind) {
      case "AlertDialogInfo":
        return _infoDialog(context);

      case 'AlertDialogAdres':
        return _adresDialogInfo(context);
      case "AlertDialogKimlik":
        return _infoKimlikDialog(context);
      case "ForgotPassword":
        return _forgotPasswordDialog(context);
      case "SignUpEnd":
        return _signUpEndDialog(context);
      case "ImagePick":
        return _imagePickDialog(context);
      case "RuhsatImage":
        return _infoRuhsatOrnek(context);
      case "Waiting":
        return _waitingDialog(context);
      case 'PoliceDayInfo':
        return _infoPoliceDay(context, widget.body, widget.color);
      case 'ManuelPoliceInfo':
        return _infoPoliceManuel(context);
      case 'PdfSoru':
        return _pdfSoru(context);

      case 'AlertConfirmAccountCode':
        return _alertConfirmAccountCode(context);
      case 'DamageReport':
        return _damageReportDailog(context);
      default:
        return _infoDialog(context);
    }
  }

  Widget _damageReportDailog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: ColorData.renkBeyaz,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(33),
                          topRight: Radius.circular(33))),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 15, right: 15, left: 15),
                          padding: EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Text(
                                      "Poliçe Acentesi portal üyesi değildir.\nBilgileri " +
                                          widget.body +
                                          " e-mailine gönderiniz veya telefon açınız.Hiçbiri için İPTAL'e basınız.",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      maxLines: 5,
                                      style: TextStyleData.boldSiyah),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(1); 
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 15, left: 15),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: ColorData.renkGri,
                                borderRadius: BorderRadius.circular(33)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: Text(widget.buttonText,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyleData.boldSiyah),
                                  ),
                                ),
                                InkWell(
                                  child: Image.asset(
                                    "assets/images/mail.png",
                                    height: 24,
                                    width: 24,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(2); 
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 15, left: 15),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: ColorData.renkGri,
                                borderRadius: BorderRadius.circular(33)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: Text(widget.button2Text,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyleData.boldSiyah),
                                  ),
                                ),
                                InkWell(
                                  child: Image.asset(
                                    "assets/images/ic_phone.png",
                                    height: 24,
                                    width: 24,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ColorData.renkBeyaz,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(33),
                          bottomLeft: Radius.circular(33))),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 15, right: 15, left: 15, bottom: 15),
                          padding: EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: OutlineButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text("İPTAL",
                                              style: TextStyleData
                                                  .extraBoldLacivert16),
                                        ),
                                        shape: StadiumBorder(),
                                        borderSide: BorderSide(
                                            color: ColorData.renkLacivert,
                                            style: BorderStyle.solid,
                                            width: 2),
                                        onPressed: () {
                                          Navigator.of(context).pop(null);
                                        })),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 3,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 75),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        child: Text(widget.body,
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(widget.buttonText,
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alertConfirmAccountCode(BuildContext context) {
    String _code;
    bool _onEditing;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30),
                      SizedBox(height: 16),
                      Text(
                        "Kodu giriniz",
                        style: TextStyleData.extraBoldLacivert16,
                      ),
                      VerificationCode(
                        itemSize: 35.0,
                        textStyle: TextStyle(
                            fontSize: 20.0, color: ColorData.renkKoyuYesil),
                        underlineColor: Colors.green,
                        keyboardType: TextInputType.number,
                        length: 6,
                        // clearAll is NOT required, you can delete it
                        // takes any widget, so you can implement your design
                        clearAll: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\nTEMİZLE',
                            style: TextStyleData.extraBoldLacivert16,
                          ),
                        ),
                        onCompleted: (String value) {
                          setState(() {
                            _code = value;
                          });
                        },
                        onEditing: (bool value) {
                          setState(() {
                            _onEditing = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("ONAYLA",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                if (_code.length < 6) {
                                  print("6 dan küçük kod girdin");
                                }
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 150),
                    ],
                  ),
                ),

                //   Positioned(
                //     top: MediaQuery.of(context).size.height / 3 - 75,
                //     right: 0,
                //     left: 0,
                //     child: Container(
                //       width: 150,
                //       height: 150,
                //       alignment: Alignment.center,
                //       padding: const EdgeInsets.all(16.0),
                //       decoration: BoxDecoration(
                // color: ColorData.renkMavi, shape: BoxShape.circle),
                //       child: Padding(
                //         padding: const EdgeInsets.all(16.0),
                //         child: Image.asset(
                // widget.imageUrl,
                // fit: BoxFit.contain,
                // height: 75,
                // width: 75,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoKimlikDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("TC Kimlik No",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldMavi18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            "Türkiye Cumhuriyeti Kimlik Numarası(11 hane)",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      Divider(
                        color: ColorData.renkLacivert,
                        indent: 30,
                        endIndent: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Yabancı TC Kimlik No ",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldMavi18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            "Yabancı Türkiye Cumhuriyeti Kimlik Numarası(11 hane ve 800 ile başlamalıdır.)",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      Divider(
                        color: ColorData.renkLacivert,
                        indent: 30,
                        endIndent: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Vergi Kimlik No",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldMavi18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Vergi Kimlik Numarası(10 hane)",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      Divider(
                        color: ColorData.renkLacivert,
                        indent: 30,
                        endIndent: 30,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Text("Pasaport No", textAlign: TextAlign.center,style: TextStyleData.boldMavi18),
                      //   ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Text("U123456 formatta 7 hane veya U12345678 formatta 9 haneli pasaport numarası", textAlign: TextAlign.center,style: TextStyleData.boldLacivert),
                      //   ),

                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("TAMAM",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_soru-2.png",
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adresDialogInfo(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            "Gerektiğinde sizinle iletişim kurabilmemiz için açık adresinizi yazınız veya sadece İlçe / İl şeklinde giriniz.",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("TAMAM",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_soru-2.png",
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRuhsatOrnek(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 90.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/ornekKimlik.jpg',
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("TAMAM",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_soru-2.png",
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordDialog(BuildContext context) {
    String _email;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
      elevation: 0.0,
      backgroundColor: ColorData.renkBeyaz,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(widget.imageUrl,
                      fit: BoxFit.contain, height: 100),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.body, style: TextStyleData.boldLacivert),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          InputDecoration(labelText: "E-posta", isDense: true),
                      textInputAction: TextInputAction.done,
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
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: OutlineButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(widget.buttonText,
                            style: TextStyleData.extraBoldMavi),
                      ),
                      shape: StadiumBorder(),
                      borderSide: BorderSide(
                          color: ColorData.renkMavi,
                          style: BorderStyle.solid,
                          width: 2),
                      onPressed: () {
                        final _form = _formKey.currentState;
                        _form.save();
                        if (_form.validate()) {
                        } else {}
                      }),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpEndDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 3,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 75),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        child: Text(
                            "Üyeliğiniz başarıyla oluşturuldu.\nEpostanıza gelen üyelik doğrulamasını yaparak Uygulamaya giriş yapabilirsiniz.",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("GİRİŞ YAP",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              })),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("KAPAT",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePickDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 3,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 75),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        child: Text("Devam etmek için seçim yapınız.",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text("FOTOĞRAF ÇEK",
                                      style: TextStyleData.extraBoldLacivert16),
                                ),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.pop(context, ImageSource.camera);
                              })),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text("GALERİDEN SEÇ",
                                      style: TextStyleData.extraBoldLacivert16),
                                ),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.pop(context, ImageSource.gallery);
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_photo.png",
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _waitingDialog(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(33),
            ),
            backgroundColor: Colors.transparent,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.body,
                  style: TextStyleData.boldYesil,
                ),
              )
            ])),
      ),
    );
  }

  Widget _infoPoliceDay(BuildContext context, String text, Color color) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style:
                              TextStyleData.boldMavi18,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("TAMAM",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_info-2.png",
                      fit: BoxFit.contain,
                      color: Colors.red,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoPoliceManuel(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Sizin girdiğiniz poliçe",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("TAMAM",
                                    style: TextStyleData.extraBoldLacivert16),
                              ),
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: ColorData.renkLacivert,
                                  style: BorderStyle.solid,
                                  width: 2),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_soru-2.png",
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pdfSoru(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Color(0xff0B1A3D).withOpacity(.5),
        body: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 5,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("PDF olarak görmek için devam edin.",
                            textAlign: TextAlign.center,
                            style: TextStyleData.boldLacivert),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                    shape: StadiumBorder(),
                                    color: ColorData.renkMavi),
                                child: OutlineButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text("DEVAM",
                                          style: TextStyleData.boldBeyaz18),
                                    ),
                                    shape: StadiumBorder(), 
                                    onPressed: () {
                                      widget.createPDF(1);

                                      Navigator.of(context).pop();
                                    }),
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: OutlineButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text("İPTAL",
                                        style:
                                            TextStyleData.extraBoldLacivert16),
                                  ),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    widget.createPDF(0);
                                    Navigator.of(context).pop();
                                  })),
                        ],
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 75,
                right: 0,
                left: 0,
                child: Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: ColorData.renkMavi, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/images/ic_soru-2.png",
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
