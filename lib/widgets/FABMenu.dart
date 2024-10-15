import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/screens/AddPolicy.dart';
import 'package:sigortadefterim/screens/GetNewOfferScreen.dart';

class FABMenu extends StatefulWidget {
  final int navigationIndex;

  FABMenu({this.navigationIndex});

  @override
  _FABMenuState createState() => _FABMenuState();
}

class _FABMenuState extends State<FABMenu> with TickerProviderStateMixin {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: ColorData.renkBeyaz.withOpacity(0.6),
        body: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 75,
            padding: EdgeInsets.fromLTRB(64, 0, 0, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    child: Text("Yeni Teklif Al", style: TextStyleData.standartMavi36),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GetNewOfferScreen()));
                    }),
                Divider(color: ColorData.renkMavi, thickness: 1.5),
                SizedBox(height: 32),
                InkWell(
                    child: Text("Poliçe Ekle", style: TextStyleData.standartMavi36),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicy()));
                    }),
                Divider(color: ColorData.renkMavi, thickness: 1.5),
                SizedBox(height: 32),
                //InkWell(
                //    child: Text("Şirket/Acente Ara", style: TextStyleData.standartMavi36),
                //    onTap: () {
                //      Navigator.of(context).pop();
                //      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCompanyAgent()));
                //    }),
                //Divider(color: ColorData.renkMavi, thickness: 1.5),
              ],
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _myBottomNavigationBar(widget.navigationIndex),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: InkWell(child: Image.asset("assets/images/add-3.png", height: 60), onTap: (){
                Navigator.of(context).pop();
              }),
              ),
            )
        ])


        ),
      );
  }

  Widget _myBottomNavigationBar(int index) {
    
    return SizedBox(
      height: 75,
      child: TabBar(
        key: Key("FAB"),
        controller: TabController(initialIndex: index,length: 5,vsync: this),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyleData.boldLacivert,
        labelColor: ColorData.renkMavi,
        unselectedLabelColor: ColorData.renkLacivert,
        labelPadding: EdgeInsets.symmetric(horizontal: 4),
        indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4.0, color: ColorData.renkMavi), insets: EdgeInsets.symmetric(horizontal: 16.0)),
        tabs: <Widget>[
          Tab(text: "Ana Sayfa", icon: Image.asset("assets/images/ic_home.png", color: index == 0 ? ColorData.renkMavi : ColorData.renkLacivert)),
          /* Tab(text: "Risk Profili", icon: Image.asset("assets/images/ic_risk_profile.png", color: index == 1 ? ColorData.renkMavi : ColorData.renkLacivert)), */
           Container(
            height: 50,
            margin: EdgeInsets.all(2.0), 
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset("assets/images/ic_risk_profile.png",
                    color: index == 1
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
                  style: TextStyle (fontSize: 12),
                ),
              ],
            ),
          ),
          Container(),
         /*  Container(child:  Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: InkWell(child: Image.asset("assets/images/add-3.png", height: 60), onTap: (){
                Navigator.of(context).pop();
              }),
              ),), */
          Tab(text: "Poliçeler", icon: Image.asset("assets/images/ic_policy.png", color: index == 3 ? ColorData.renkMavi : ColorData.renkLacivert)),
          Tab(text: "Bildirimler", icon: Image.asset("assets/images/ic_notification.png", color: index == 4 ? ColorData.renkMavi : ColorData.renkLacivert)),
        ],
        onTap: (index) {
           Navigator.of(context).pop();
         /*  setState(() {
            Navigator.of(context).pop();
          }); */
        },
        ),
      );
  }
}
