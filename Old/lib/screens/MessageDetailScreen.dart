import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/Policy/MessageResponse.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:flutter/services.dart' show rootBundle;

class MessageDetailScreen extends StatefulWidget {
  final MessageResponse messageResponse;
  final MessageInput messageInput;
  MessageDetailScreen({this.messageInput, this.messageResponse});
  @override
  _MessageDetailScreen createState() => _MessageDetailScreen();
}

class _MessageDetailScreen extends State<MessageDetailScreen> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  final FocusNode _messageFocus = FocusNode();
  String _message = "";
  var _firma = {"id": 0, "adi": ""};
  Acente _acente = Acente();

  List<String> _kullaniciInfo = List<String>();
  ScrollController scrollControllerMessage = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _tumuRefreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  //List<MessageResponse> messageTempList = List<MessageResponse>();
  MessageGlobal tempMessageGlobal = MessageGlobal();
  bool sessionIsActive = true;
  MessageInput messageInput = MessageInput();
  @override
  void initState() {
    super.initState();

    setState(() {
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
    });
    if (widget.messageInput != null) {
      messageInput = widget.messageInput;
      if (messageInput.acenteObject.kodu != null) {
        setState(() {
          _firma["id"] = messageInput.acenteObject.kodu;
          _firma["adi"] = messageInput.acenteObject.unvani;
        });
      } else if (widget.messageInput.sigortaSirketi.sirketKodu != null) {
        SigortaSirketi temp = UtilsPolicy.findSirket(
            widget.messageInput.sigortaSirketi.sirketKodu);
        _firma["id"] = temp.sirketKodu;
        _firma["adi"] = temp.sirketAdi;
      }
    } else {
      messageInput.policeId = widget.messageResponse.policeId;
      messageInput.policeNumarasi = widget.messageResponse.policeNumarasi;
      messageInput.policeTip = widget.messageResponse.policeTip;
      messageInput.talepNo = widget.messageResponse.talepNo;
      messageInput.kullaniciId = int.parse(_kullaniciInfo[7]);
      messageInput.acenteObject.unvani = widget.messageResponse.firmaAdiDisplay;
      messageInput.acenteObject.kodu = widget.messageResponse.acenteKodu;
      _firma["id"] = widget.messageResponse.acenteKodu;
      _firma["adi"] = widget.messageResponse.firmaAdiDisplay;
    }

    /*  scrollControllerMessage.addListener(() {
      if (scrollControllerMessage.position.pixels ==
          scrollControllerMessage.position.maxScrollExtent) {
        // print('Slide to the bottom ${scrollControllerMessage.position.pixels}');
        /* setState(() {
          showMore = true;
        }); */
      }
    }); */

    var checkmessageList = WebAPI.messageGlobal == null
        ? true
        : WebAPI.messageGlobal.mobilMessageResponseList.length < 1
            ? true
            : false;
    if (checkmessageList) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageLoad();
      });
    } else
      fillMessage();
  }

  void gorulduOlarakIsaretle(int oturumId) {
    var res = WebAPI.messageGlobal.mobilMessageResponseList
        .where((x) => x.goruldumu == "0" && x.oturumId == oturumId)
        .toList();
    for (var item in res) {
      item.goruldumu = "1";
    }
  }

  void fillMessage() async {
    var policeId = messageInput.policeId;

    setState(() {
      tempMessageGlobal.mobilMessageResponseList = WebAPI
          .messageGlobal.mobilMessageResponseList
          .where((element) => element.oturumId == policeId)
          .toList();
      var tempRes = WebAPI.messageGlobal.messageSessionResponseList
          .firstWhere((x) => x.policeId == policeId, orElse: () => null);
      sessionIsActive = tempRes != null ? tempRes.isActive : false;
      tempMessageGlobal.mobilMessageResponseList =
          tempMessageGlobal.mobilMessageResponseList.reversed.toList();
      tempMessageGlobal.mobilMessageDosyaList =
          WebAPI.messageGlobal.mobilMessageDosyaList;
    });
    readMessage(policeId);
  }

  Future readMessage(int policeId) async {
    await WebAPI.setReadMessage(
        token: _kullaniciInfo[3],
        oturumId: policeId,
        userid: int.parse(_kullaniciInfo[7]));
  }

  Future pageLoad() async {
    UtilsPolicy.onLoading(context);
    tempMessageGlobal.mobilMessageResponseList = List<MobilMessageResponse>();

    await WebAPI.getMessageList(
            token: _kullaniciInfo[3], user_id: int.parse(_kullaniciInfo[7]))
        .whenComplete(() async {
      fillMessage();
    });
    UtilsPolicy.closeLoader(context);
  }

  Future acenteVeyaSirketAdi(int acentekodu) async {
    String res = "";
    await UtilsPolicy.findAcente(_kullaniciInfo[3], acentekodu)
        .then((value) => res = value.unvani);
    return res;
  }

  var textStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16);
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
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
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 24.0,
                                        ),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: InkWell(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: Image.asset(
                                                "assets/images/circle_arrow.png",
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.loose,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, left: 8, right: 8),
                                              alignment: Alignment.center,
                                              child: Text(
                                                _firma["adi"],
                                                style: textStyle,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.loose,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, left: 8, right: 8),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Poliçe Numarası:",
                                                style: textStyle,
                                              )),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.loose,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, left: 8, right: 8),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                messageInput.policeNumarasi !=
                                                        null
                                                    ? messageInput
                                                        .policeNumarasi
                                                    : "",
                                                style: textStyle,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.loose,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, left: 8, right: 8),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Talep No:",
                                                style: textStyle,
                                              )),
                                        ),
                                        Flexible(
                                          flex: 3,
                                          fit: FlexFit.loose,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, left: 8, right: 8),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                messageInput.talepNo != null
                                                    ? messageInput.talepNo
                                                        .toString()
                                                    : "",
                                                style: textStyle,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                          onTap: FocusScope.of(context).unfocus,
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
                          )),
                    ),
                    Form(
                      key: _formStateKey,
                      child: Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 8,
                              fit: FlexFit.loose,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                margin:
                                    EdgeInsets.only(left: 5, right: 5, top: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: sessionIsActive
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                child: TextFormField(
                                  enabled: sessionIsActive,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: sessionIsActive
                                        ? "Mesajınızı yazınız"
                                        : "Bu mesajlaşmanın süresi bitmiştir!",
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  /*  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Mesajınızı Yazınız";
                                    }
                                    return null;
                                  }, */
                                  onSaved: (value) => _message = value,
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 5, top: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  child: InkWell(
                                    child: Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Image.asset(
                                        "assets/images/send_message.png",
                                        height: 35,
                                        color: ColorData.renkAcikSiyah,
                                      ),
                                    ),
                                    onTap: () {
                                      if (sessionIsActive) {
                                        _sendMessage();
                                      }
                                    },
                                  ),
                                ))
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ), //Column
                //Padding
              ),
            ),
          ),
        ));
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

  Future<Null> refresh() async {
    pageLoad();
  }

  Widget listView() {
    var resultWidget = ListView.builder(
        controller: scrollControllerMessage,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: tempMessageGlobal.mobilMessageResponseList.length,
        itemBuilder: (BuildContext bContext, index) {
          var item = tempMessageGlobal.mobilMessageResponseList[index];
          var itemFile = tempMessageGlobal.mobilMessageDosyaList
              .where((element) => element.mobilMessageId == item.id)
              .toList();

          return Column(children: [
            item.gonderici_Tip == "0"
                ? Row(children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, right: 10, left: 50),
                        decoration: BoxDecoration(
                            color: ColorData.renkKoyuGri,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorData.renkKoyuGri,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                      "Siz : " +
                                          (item.tarih_Saat != null
                                              ? DateFormat("yyyy-MM-dd HH:mm")
                                                  .format(DateTime.parse(
                                                      item.tarih_Saat))
                                                  .toString()
                                              : "") +
                                          "\n" +
                                          item.mesaj,
                                      style: TextStyleData.boldAcikSiyah),
                                ),
                              ),
                            ])),
                      ),
                    ),
                  ])
                : Row(children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            top: 10,
                            bottom: itemFile != null ? 5 : 10,
                            right: 50,
                            left: 10),
                        decoration: BoxDecoration(
                            color: ColorData.renkBeyaz,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorData.renkBeyaz,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                      (item.tarih_Saat != null
                                              ? DateFormat("yyyy-MM-dd HH:mm")
                                                  .format(DateTime.parse(
                                                      item.tarih_Saat))
                                                  .toString()
                                              : "") +
                                          "\n" +
                                          item.mesaj,
                                      style: TextStyleData.boldAcikSiyah),
                                ),
                              ),
                            ])),
                      ),
                    ),
                  ]),
            itemFile != null
                ? itemFile.length > 0
                    ? Row(children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                top: 0, bottom: 10, right: 50, left: 10),
                            decoration: BoxDecoration(
                                color: ColorData.renkBeyaz,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 0, left: 5, right: 5, bottom: 0),
                                padding: EdgeInsets.only(
                                    top: 2, left: 8, right: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  color: ColorData.renkBeyaz,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Wrap(
                                  children: createFileContent(itemFile),
                                )),
                          ),
                        ),
                      ])
                    : Container()
                : Container(),
          ]);
        });
    startTimer();
    return resultWidget;
  }

  List<Widget> createFileContent(List<MobilMessageDosyaResponse> itemFile) {
    List<Widget> list = List<Widget>();
    list.add(Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
      child: Text('Ekler : ', style: TextStyleData.boldAcikSiyah),
    ));
    var dosyaimage = "doc";
    for (var item in itemFile) {
      dosyaimage = item.dosyaTip.toLowerCase().contains("png")
          ? "picture"
          : item.dosyaTip.toLowerCase().contains("doc")
              ? "word"
              : item.dosyaTip.toLowerCase().contains("xls")
                  ? "excel"
                  : item.dosyaTip.toLowerCase().contains("pdf")
                      ? "pdf"
                      : item.dosyaTip.toLowerCase().contains("ppt")
                          ? "powerpoint"
                          : "doc";

      list.add(Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
        child: InkWell(
          child: Image.asset(
            "assets/images/" + dosyaimage + ".png",
            height: 25.0,
            width: 25.0,
          ),
          onTap: () {
            launch(item.dosyaUrl);
          },
        ),
      ));
    }
    return list;
  }

  void _sendMessage() async {
    final _form = _formStateKey.currentState;
    _form.save();

    if (_message == "") {
      UtilsPolicy.showSnackBar(_scaffoldKey, "Mesajınızı yazınız.");
      return;
    }
    messageInput.kullanici_Mesaj = _message;
    if (_form.validate()) {
      _onLoading();
      var result = await WebAPI.sendIletisim(
          token: _kullaniciInfo[3], messageinput: messageInput);
      if (result["status"]) newMessageAddList(messageInput);
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

  void newMessageAddList(MessageInput item) {
    setState(() {
      tempMessageGlobal.mobilMessageResponseList.add(MobilMessageResponse(
          mesaj: item.kullanici_Mesaj,
          gonderici_Tip: "0",
          oturumId: item.policeId,
          tarih_Saat: DateFormat("yyyy-MM-dd HH:mm")
              .format(DateTime.now())
              .toString()));
    });
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
}
