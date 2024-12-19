import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/User/LoginResponse.dart';
import 'package:sigortadefterim/screens/HomeScreen.dart';
import 'package:sigortadefterim/screens/RiskProfileScreen.dart';
import 'package:sigortadefterim/screens/PolicyScreen.dart';
import 'package:sigortadefterim/screens/NotificationScreen.dart';
import 'package:sigortadefterim/widgets/FABMenu.dart';
import 'package:sigortadefterim/models/Policy/AllPolicyResponse.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/User/UserResponse.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';

class MainScreen extends StatefulWidget {
  LoginResponse loginResponse;
  var currentIndex = 0;
  var policyListIndex = 0;
  List<int> notificationIdList = List<int>();
  var countList = {
    "arac": 0,
    "konut": 0,
    "dask": 0,
    "saglik": 0,
    "seyahat": 0,
    "diger": 0,
    "riskSkoru": 0
  };
  MainScreen({this.loginResponse, this.currentIndex});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    UtilsPolicy().getKullaniciInfo().whenComplete(() {
      WebAPI.getBildirimList(
          token: UtilsPolicy.kullaniciInfo[3],
          tckn: UtilsPolicy.kullaniciInfo[2]);
      WebAPI.getGlobalDataRequest(
          token: UtilsPolicy.kullaniciInfo[3],
          kimlikNo: UtilsPolicy.kullaniciInfo[2]);
    });
    if (UtilsPolicy.gizlilikPDFPath.isEmpty) {
      UtilsPolicy().pdfpathLoad();
    }

    /*  Utils.getKullaniciInfo().then((value) { 
      WebAPI.getGlobalDataRequest(token: value[3],kimlikNo: value[2]);
    }); */

    _tabController = TabController(
        length: 5, initialIndex: widget.currentIndex, vsync: this);
    loadData();
  }

  /* void setCountList() {
    setState(() {
      /* widget.countList["arac"] = AllPolicyResponse.staticAracPolicyList.length;
      widget.countList["konut"] = AllPolicyResponse.staticKonutPolicyList.length;
      widget.countList["saglik"] = AllPolicyResponse.staticSaglikPolicyList.length;
      widget.countList["dask"] = AllPolicyResponse.staticDaskPolicyList.length;
      widget.countList["seyahat"] = AllPolicyResponse.staticSeyahatPolicyList.length;
      widget.countList["diger"] = AllPolicyResponse.staticDigerPolicyList.length;
      widget.countList["toplam"] = AllPolicyResponse.staticTumuPolicyList.length; */
    });
  } */

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future loadData() async {
    var allpolicyresponse = new AllPolicyResponse(false);

    await allpolicyresponse.getAllPoliciesCount().whenComplete(() =>
        allpolicyresponse
            .setPolicyIsOffer(
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>(),
                List<PolicyResponse>())
            .whenComplete(() {
          UtilsPolicy.countList = allpolicyresponse.countList;
          setState(() {
            widget.countList = allpolicyresponse.countList;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: ColorData.renkBeyaz,
            body: Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(child: _getCurrentPage(widget.currentIndex)),
              ),
              _myBottomNavigationBar(),
            ])),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (widget.currentIndex == 0) {
      return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Uyarı'),
              content: Text('Uygulama Kapatılsın mı?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Hayır'),
                ),
                FlatButton(
                  onPressed: () => exit(0),
                  child: Text('Evet'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      setState(() {
        _tabController.index = 0;
        widget.currentIndex = 0;
      });
    }
  }

  Widget _myBottomNavigationBar() {
    return SizedBox(
      height: 75,
      child: TabBar(
        key: Key("Main"),
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyleData.boldLacivert,
        labelColor: ColorData.renkMavi,
        unselectedLabelColor: ColorData.renkLacivert,
        labelPadding: EdgeInsets.symmetric(horizontal: 4),
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4.0, color: ColorData.renkMavi),
            insets: EdgeInsets.symmetric(horizontal: 16.0)),
        tabs: <Widget>[
          Tab(
              text: "Ana Sayfa",
              icon: Image.asset("assets/images/ic_home.png",
                  color: widget.currentIndex == 0
                      ? ColorData.renkMavi
                      : ColorData.renkLacivert)),
          /*   Tab(
              text: "Risk Profili",
              icon: Image.asset("assets/images/ic_risk_profile.png",
                  color: widget.currentIndex == 1
                      ? ColorData.renkMavi
                      : ColorData.renkLacivert)), */
          Container(
            height: 50,
            margin: EdgeInsets.all(2.0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset("assets/images/ic_risk_profile.png",
                    color: widget.currentIndex == 1
                        ? ColorData.renkMavi
                        : ColorData.renkLacivert),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Risk Profili",
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: false,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          /* Container() */
          Container(
            width: 60,
            padding: const EdgeInsets.only(bottom: 13.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(75, 1, 1, 1),
                    blurRadius: 20.0,
                    offset: Offset(0, 10))
              ],
            ),
            child: InkWell(
                child: Image.asset(
                  "assets/images/add.png",
                  height: 60,
                ),
                onTap: () {
                  _floatButtonMenu();
                }),
          ),
          Tab(
              text: "Poliçeler",
              icon: Image.asset("assets/images/ic_policy.png",
                  color: widget.currentIndex == 3
                      ? ColorData.renkMavi
                      : ColorData.renkLacivert)),
          Tab(
              text: "Bildirimler",
              icon: Image.asset("assets/images/ic_notification.png",
                  color: widget.currentIndex == 4
                      ? ColorData.renkMavi
                      : ColorData.renkLacivert)),
        ],
        onTap: (index) {
          // print(index);
          setState(() {
            if (index == 2)
              _tabController.index = widget.currentIndex;
            else
              widget.currentIndex = index;
          });
        },
      ),
    );
  }

  void _floatButtonMenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) => FABMenu(
              navigationIndex: widget.currentIndex,
            ));
  }

  Widget _getCurrentPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeScreen(
            navigateMenu: (index, isAdd) {
              if (isAdd) {
                _floatButtonMenu();
              } else {
                setState(() {
                  widget.currentIndex = 3;
                  widget.policyListIndex = index;
                  _tabController.index = 3;
                });
              }
            },
            policyCountList: widget.countList);
      case 1:
        return RiskProfileScreen();
      case 3:
        return PolicyScreen(
          currentIndex: widget.policyListIndex,
          isOffer: false,
        );
      case 4:
        return NotificationScreen(
          isMenu: true,
        );
      default:
        return HomeScreen(navigateMenu: (index, isAdd) {});
    }
  }
}
