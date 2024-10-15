import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/Bildirim1.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/widgets/BannerSlider.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyExpansionTile.dart';
import 'package:sigortadefterim/screens/RenewPolicy.dart';
import 'package:sigortadefterim/screens/GetNewOfferScreen.dart';
import 'package:sigortadefterim/models/Policy/AllPolicyResponse.dart';
import 'package:sigortadefterim/models/Bildirim.dart';

import 'package:sigortadefterim/screens/MainScreen.dart';

class NotificationScreen extends StatefulWidget {
  bool isMenu = true;
  NotificationScreen({
    this.isMenu,
  });
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _kullaniciInfo = List<String>();

  //List<Bildirim> _bildirimlist = List<Bildirim>();
  List<PolicyResponse> _policyResponse = List<PolicyResponse>();

  @override
  void initState() {
    super.initState();

    _kullaniciInfo = UtilsPolicy.kullaniciInfo;
    _getBildirimList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorData.renkSolukBeyaz,
        drawer:
            MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
        body: Column(children: [
          Stack(
            children: <Widget>[
              BannerSlider(),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 36, bottom: 16, left: 16, right: 16),
                    child: widget.isMenu == false
                        ? InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Image.asset(
                              "assets/images/circle_arrow.png",
                              height: 30,
                              fit: BoxFit.cover,
                              color: ColorData.renkYesil,
                            ),
                          )
                        : InkWell(
                            onTap: () => _scaffoldKey.currentState.openDrawer(),
                            child: Image.asset(
                              "assets/images/ic_menu.png",
                              height: 17,
                              fit: BoxFit.cover,
                              color: ColorData.renkYesil,
                            ),
                          ),
                  ),
                ),
              ),
              Align(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 46, bottom: 16, left: 16, right: 16),
                    child: Text("Bildirimler",
                        style: TextStyleData.standartBeyaz24)),
              ),
            ],
          ),
         Expanded(
            child: Container( 
                  child: _policyResponse.length > 0 &&
                          AllPolicyResponse.staticTumuPolicyList.length > 0
                      ? ListView.builder(
                          itemCount: _policyResponse.length,
                          itemBuilder: (BuildContext bContext, index) {
                            var _item = _policyResponse[index];

                            if (dateDiff(_item.bitisTarihi) < 0) {
                              return _createExpiredNotification(
                                  _item,
                                  UtilsPolicy.findSigortaTuru(
                                      _item.bransKodu, false),
                                  index);
                            } else if (dateDiff(_item.bitisTarihi) < 32) {
                              return _createReminderNotification(
                                  _item,
                                  UtilsPolicy.findSigortaTuru(
                                      _item.bransKodu, false),
                                  index);
                            }
                          })
                      : Container()),
          )
        ]));
  }

  int dateDiff(String bitisTarihi) {
    final bitisTar = DateTime.parse(bitisTarihi);
    final datenow = DateTime.now();
    return bitisTar.difference(datenow).inDays;
  }

  PolicyResponse getPolicybyPoliceNumarasi(String policeNo) {
    return AllPolicyResponse.staticTumuPolicyList
        .firstWhere((x) => x.policeNumarasi == policeNo, orElse: null);
  }

  Widget _createExpiredNotification(
      PolicyResponse item, String brans, int index) {
    return Dismissible(
        key: Key(index.toString()),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                color: ColorData.renkBeyaz,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxDecorationData.shadow]),
            child: MyExpansionTile(
              key: Key("$index"),
              backgroundColor: Colors.transparent,
              initiallyExpanded: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Poliçenizin süresi bitmiştir.",
                        style: TextStyleData.boldSiyah),
                    Text("Ayrıntılar için dokunun.",
                        style: TextStyleData.boldSiyah12),
                  ],
                ),
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: ColorData.renkGri,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "Sayın ${_kullaniciInfo[0]} ${_kullaniciInfo[1]},",
                                    style: TextStyleData.boldSiyah),
                                TextSpan(
                                    text: " ${item.policeNumarasi} Nolu ",
                                    style: TextStyleData.standartSiyah),
                                TextSpan(
                                    text: brans +
                                        " poliçenizin süresi bitmiştir.",
                                    style: TextStyleData.boldKirmizi),
                                TextSpan(
                                    text:
                                        " Lütfen uygulamadan yenileme teklifi alınız.",
                                    style: TextStyleData.standartSiyah)
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                OutlineButton(
                                  child: Text("Yenile",
                                      style: TextStyleData.boldLacivert),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    if (getPolicybyPoliceNumarasi(
                                            item.policeNumarasi) ==
                                        null) return;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => RenewPolicy(
                                                policyResponse:
                                                    getPolicybyPoliceNumarasi(
                                                        item.policeNumarasi))));
                                  },
                                ),
                                OutlineButton(
                                  child: Text("Yeni Teklif Al",
                                      style: TextStyleData.boldLacivert),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    if (getPolicybyPoliceNumarasi(
                                            item.policeNumarasi) ==
                                        null) return;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GetNewOfferScreen.havePolicy(
                                                    getPolicybyPoliceNumarasi(
                                                        item.policeNumarasi))));
                                  },
                                ),
                                OutlineButton(
                                  child: Text("Sil",
                                      style: TextStyleData.boldLacivert),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    setBildirimDisable(
                                        getPolicybyPoliceNumarasi(
                                            item.policeNumarasi),
                                        index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  Widget _createReminderNotification(
      PolicyResponse item, String brans, int index) {
    return Dismissible(
        key: Key(index.toString()),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                color: ColorData.renkBeyaz,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxDecorationData.shadow]),
            child: MyExpansionTile(
              key: Key("$index"),
              backgroundColor: Colors.transparent,
              initiallyExpanded: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Poliçenizin süresi bitmek üzeredir.",
                        style: TextStyle(
                            color: ColorData.renkSiyah,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'panton')),
                    Text("Ayrıntılar için dokunun.",
                        style: TextStyleData.boldSiyah12),
                  ],
                ),
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: ColorData.renkGri,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "Sayın ${_kullaniciInfo[0]} ${_kullaniciInfo[1]},",
                                    style: TextStyleData.boldSiyah),
                                TextSpan(
                                    text: " ${item.policeNumarasi} Nolu ",
                                    style: TextStyleData.standartSiyah),
                                TextSpan(
                                    text: brans +
                                        " poliçenizin süresi bitmek üzeredir.",
                                    style: TextStyleData.boldKoyuYesil),
                                TextSpan(
                                    text:
                                        " Lütfen uygulamadan yenileme teklifi alınız.",
                                    style: TextStyleData.standartSiyah)
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                OutlineButton(
                                  child: Text("Yenile",
                                      style: TextStyleData.boldLacivert),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    if (getPolicybyPoliceNumarasi(
                                            item.policeNumarasi) ==
                                        null) return;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => RenewPolicy(
                                                policyResponse:
                                                    getPolicybyPoliceNumarasi(
                                                        item.policeNumarasi))));
                                  },
                                ),
                                OutlineButton(
                                  child: Text("Yeni Teklif Al",
                                      style: TextStyleData.boldLacivert),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    if (getPolicybyPoliceNumarasi(
                                            item.policeNumarasi) ==
                                        null) return;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GetNewOfferScreen.havePolicy(
                                                    getPolicybyPoliceNumarasi(
                                                        item.policeNumarasi))));
                                  },
                                ),
                                OutlineButton(
                                  child: Text("Sil",
                                      style: TextStyleData.boldLacivert),
                                  shape: StadiumBorder(),
                                  borderSide: BorderSide(
                                      color: ColorData.renkLacivert,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  onPressed: () {
                                    setBildirimDisable(
                                        getPolicybyPoliceNumarasi(
                                            item.policeNumarasi),
                                        index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  /* void _getKullaniciInfo() {
    Utils.getKullaniciInfo().then((value) {
      setState(() {
        _kullaniciInfo = value;
        _getBildirimList();
      });
    });
  } */

  Future _getBildirimList() async {
    _policyResponse.clear();

    setState(() {
      if (WebAPI.bildirimList != null) if (WebAPI.bildirimDisableList.length ==
          0) {
        _policyResponse = WebAPI.bildirimList;
      } else {
        for (var item in WebAPI.bildirimList) {
          var result = WebAPI.bildirimDisableList.firstWhere(
              (x) =>
                  x.policeNumarasi == item.policeNumarasi &&
                  x.bitisTarihi == item.bitisTarihi,
              orElse: () => null);
          if (result == null) {
            _policyResponse.add(item);
          }
        }
      }
    });
  }

  void setBildirimDisable(PolicyResponse item, int index) {
    WebAPI.setBildirimDisable(
            token: _kullaniciInfo[3],
            tckn: _kullaniciInfo[2],
            policyResponse: item)
        .then((result) {
      UtilsPolicy.showSnackBar(_scaffoldKey, result);
      setState(() {
        _policyResponse.removeAt(index);
      });
      WebAPI.getBildirimList(token: _kullaniciInfo[3], tckn: _kullaniciInfo[2])
          .whenComplete(() => _getBildirimList());
    });
/* 
    WebAPI.bildirimDisableList.add(Bildirim(
        kimlikNo: item.kimlikNo,
        bitisTarihi: item.bitisTarihi,
        policeNumarasi: item.policeNumarasi,
        id: item.id)); */
  }
}
