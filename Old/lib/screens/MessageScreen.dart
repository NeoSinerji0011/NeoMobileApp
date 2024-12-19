import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigortadefterim/AppStyle.dart';

import 'package:sigortadefterim/screens/MainScreen.dart';
import 'package:sigortadefterim/screens/MessageDetailScreen.dart';
import 'package:sigortadefterim/screens/VerificationCodeScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/Policy/MessageResponse.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreen createState() => _MessageScreen();
}

class _MessageScreen extends State<MessageScreen> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  int fileSelect =
      0; //1:profil fotografı var,0:profil fotografı yok,2:profil fotografı secimi

  final FocusNode _messageFocus = FocusNode();
  final FocusNode _subjectFocus = FocusNode();
  String _message = "";
  String _subject = "";
  final GlobalKey<RefreshIndicatorState> _tumuRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<String> _kullaniciInfo = List<String>();
  ScrollController scrollControllerMessage = new ScrollController();

  //List<MessageResponse> messageTempList = List<MessageResponse>();
  MessageGlobal tempMessageGlobal = MessageGlobal();

  String firmaAdi = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageLoad();
    });
  }

  Future pageLoad() async {
    UtilsPolicy.onLoading(context);

    await WebAPI.getMessageList(
            token: _kullaniciInfo[3], user_id: int.parse(_kullaniciInfo[7]))
        .whenComplete(() async {
      for (var item in WebAPI.messageGlobal.mobilMessageResponseList) {
        var tempMs = WebAPI.messageGlobal.messageSessionResponseList
            .firstWhere((x) => x.policeId == item.oturumId, orElse: () => null);

        var temp = tempMessageGlobal.messageSessionResponseList.firstWhere(
            (element) => element.policeId == tempMs.policeId,
            orElse: () => null);

        if (temp == null) {
          if (tempMs.acenteKodu != null)
            await acenteVeyaSirketAdi(tempMs.acenteKodu).then((value) {
              tempMs.firmaAdiDisplay = value;
            });
          else
            tempMs.firmaAdiDisplay =
                UtilsPolicy.findSirket(tempMs.sirketKodu).sirketAdi;
          tempMs.isNewMessage = false;
          tempMessageGlobal.messageSessionResponseList.add(tempMs);
        }
      }
      setState(() {
        tempMessageGlobal = tempMessageGlobal;
      });
    });

    UtilsPolicy.closeLoader(context);
  }

  void sortTempList() {
    List<MessageResponse> tempMg = List<MessageResponse>();
    for (var item in tempMessageGlobal.mobilMessageResponseList) {
      var tempMs = tempMessageGlobal.messageSessionResponseList
          .firstWhere((x) => x.policeId == item.oturumId, orElse: () => null);

      var temp = tempMg.firstWhere(
          (element) => element.policeId == tempMs.policeId,
          orElse: () => null);
      if (temp == null) tempMg.add(temp);
    }

    setState(() {
      //  tempMessageGlobal.messageSessionResponseList = tempMg;
    });
  }

  Future acenteVeyaSirketAdi(int acentekodu) async {
    String res = "";
    await UtilsPolicy.findAcente(_kullaniciInfo[3], acentekodu)
        .then((value) => res = value.unvani);
    return res;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/ikonlar-3.png"),
                fit: BoxFit.contain,
                alignment: Alignment.topCenter),
            gradient: LinearGradient(
                colors: [ColorData.renkMavi, ColorData.renkLacivert],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Container(
            /*  decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ), */
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 10, right: 10, bottom: 5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    icon: Image.asset(
                                        "assets/images/circle_arrow.png",
                                        color: ColorData.renkBeyaz,
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.contain),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, left: 10, right: 10, bottom: 5),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Mesajlarım",
                                    style: TextStyleData.standartBeyaz24,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RefreshIndicator(
                        key: _tumuRefreshIndicatorKey,
                        onRefresh: () => refresh(),
                        child: listView()),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ), //Column
            //Padding
          ),
        ),
      ),
    );
  }

  Future<Null> refresh() async {
    pageLoad();
  }

  void startTimer() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (scrollControllerMessage.hasClients) {
        scrollControllerMessage
            .jumpTo(scrollControllerMessage.position.maxScrollExtent);
        timer.cancel();
      }
    });
  }

  var checkgoruldumu = false;

  Widget listView() {
    var resultWidget = ListView.builder(
        controller: scrollControllerMessage,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: tempMessageGlobal.messageSessionResponseList.length,
        itemBuilder: (BuildContext bContext, index) {
          var item = tempMessageGlobal.messageSessionResponseList[index];
          var checknewmesssage = WebAPI.messageGlobal.mobilMessageResponseList
              .where((x) => x.goruldumu == "0" && x.gonderici_Tip=="1" && x.oturumId == item.policeId)
              .toList();

          item.isNewMessage = false;
          if (checknewmesssage != null) {
            if (checknewmesssage.length > 0) {
              item.isNewMessage = true;
            }
          }

          return InkWell(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                    boxShadow: [BoxDecorationData.shadow]),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        ColorData.renkLacivert,
                                        ColorData.renkMavi
                                      ])),
                              child: Image.asset(
                                "assets/images/message.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      item.firmaAdiDisplay != null
                                          ? item.firmaAdiDisplay
                                          : "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyleData.boldMavi18),
                                ],
                              ),
                            ),
                            item.isNewMessage
                                ? Container(
                                    padding: EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorData.renkYesil,
                                    ),
                                    child: Text("Yeni",
                                        style: TextStyleData.boldSiyah12),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            SizedBox(
                                width: 100,
                                child: Text("Talep No",
                                    style: TextStyleData.boldSolukGri)),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 48),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: ColorData.renkGri,
                                    borderRadius: BorderRadius.circular(33)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(item.talepNo.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyleData.boldAcikSiyah),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            SizedBox(
                                width: 100,
                                child: Text("Branş Adı",
                                    style: TextStyleData.boldSolukGri)),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 48),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: ColorData.renkGri,
                                    borderRadius: BorderRadius.circular(33)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                      UtilsPolicy.findSigortaTuru(
                                          item.bransKodu, false),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyleData.boldAcikSiyah),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            SizedBox(
                                width: 100,
                                child: Text("Poliçe No",
                                    style: TextStyleData.boldSolukGri)),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 48),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: ColorData.renkGri,
                                    borderRadius: BorderRadius.circular(33)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                      item.policeNumarasi != null
                                          ? item.policeNumarasi
                                          : "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyleData.boldAcikSiyah),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/images/ic_right_arrow.png",
                      fit: BoxFit.contain,
                      width: 12,
                      height: 12,
                      color: ColorData.renkMavi,
                    ),
                  ],
                )),
            onTap: () {
              if (checknewmesssage != null) {
                for (var item in checknewmesssage) {
                  item.goruldumu = "1";
                }
              }
              setState(() {  
              });
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessageDetailScreen(
                        messageInput: null,
                        messageResponse: item,
                      )));
            },
          );
        });

    return resultWidget;
  }
}
