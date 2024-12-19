import 'dart:async';
import 'dart:ui';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/User/LoginResponse.dart';
import 'package:sigortadefterim/screens/MainScreen.dart';

import 'package:sigortadefterim/screens/MyProfile.dart';
import 'package:sigortadefterim/screens/FeedBack.dart';
import 'package:sigortadefterim/screens/MessageScreen.dart';
import 'package:sigortadefterim/screens/NotificationScreen.dart';
import 'package:sigortadefterim/screens/PolicyScreen.dart';
import 'package:sigortadefterim/screens/ReportDamageScreen.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';

import 'package:sigortadefterim/screens/OnboardingScreen.dart';
import 'package:sigortadefterim/screens/WelcomeScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/utils/TextFileProcess.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:pdf/widgets.dart' as PDF;
import 'package:image/image.dart' as ResizedImage;
import 'package:sigortadefterim/widgets/PdfViewPage.dart';

class MenuDrawer extends StatelessWidget {
  final String adSoyad;
  BuildContext _buildContext;
  String kullaniciKilavuzPDF = "";

  MenuDrawer({this.adSoyad});

  @override
  Widget build(BuildContext context) {
    _ListViewDrawerState()
        .getFileFromAsset(
            "KullaniciKilavuzu", "assets/pdf/KullaniciKilavuzu.pdf")
        .then((f) {
      kullaniciKilavuzPDF = f.path;
    });
    _buildContext = context;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [ColorData.renkMavi, Color(0xFF00247F)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: 5,
                        child: VerticalDivider(
                            color: ColorData.renkYesil, thickness: 5)),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 5,
                        child: Container(
                            child: new SingleChildScrollView(
                                child: new Column(children: <Widget>[
                          DrawerHeader(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(adSoyad,
                                    style: TextStyleData.standartYesil24),
                              ],
                            ),
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_profile.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("PROFİL",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(1);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_offer.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("TEKLİF TALEP LİSTEM",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(2);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_damage.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("HASAR LİSTEM",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(3);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_menu_noti.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("BİLDİRİMLER",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(4);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_help2.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("KULLANIM KILAVUZU",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(5);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/message.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("MESAJLARIM",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(16);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_message.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("BİZE YAZIN",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(15);
                            },
                          ),
                          _getDivider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/tanitim.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text("TANITIM",
                                  style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(18);
                            },
                          ),
                           SizedBox(height: 5,),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/ic_exit.png",
                              width: 30,
                              height: 30,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child:
                                  Text("ÇIKIŞ", style: TextStyleData.boldBeyaz),
                            ),
                            onTap: () {
                              _navigateMenuItem(0);
                            },
                          ),
                          _getDivider(),
                        ])))),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              color: Colors.white54,
              width: MediaQuery.of(context).size.width / 2,
            ),
            onTap: () {
              Navigator.of(context).pop(null);
            },
          ),
        ],
      ),
    );
  }

  void _navigateMenuItem(int index) {
    switch (index) {
      case 0:
        //ÇIKIŞ İŞLEMİ
        TextFileProcess().writeCounter("").whenComplete(() {
          Utils.hesapCikis();
          Navigator.pushReplacement(_buildContext,
              MaterialPageRoute(builder: (context) => WelcomeScreen()));
        });
        break;
      case 1:
        //PROFİL SAYFASI
        Navigator.push(_buildContext,
            MaterialPageRoute(builder: (context) => MyProfile()));
        break;
      case 2:
        //TEKLİF LİSTEM
        Navigator.push(
            _buildContext,
            MaterialPageRoute(
                builder: (context) => PolicyScreen(
                      currentIndex: 1,
                      isOffer: true,
                    )));

        break;
      case 3:
        //HASAR LİSTEM SAYFASI

        Navigator.push(
            _buildContext,
            MaterialPageRoute(
                builder: (context) => ReportDamageScreen(
                      currentIndex: 1,
                      isOffer: false,
                    )));
        break;
      case 4:
        //BİLDİRİMLER
        Navigator.push(
            _buildContext,
            MaterialPageRoute(
                builder: (context) => NotificationScreen(
                      isMenu: false,
                    )));
        break;
      case 5:
        //PolicyResponse test=PolicyResponse;
        Navigator.push(
            _buildContext,
            MaterialPageRoute(
                builder: (context) => PdfViewPage(path: UtilsPolicy.kullanimKilavuzu)));
        break;
      case 6:
        // Navigator.pushReplacement(
        //     _buildContext,
        //     MaterialPageRoute(
        //         builder: (context) => ReportDamageScreen()));
        break;
      case 7:
        Utils.launchURL("https://www.google.com.tr/maps/search/sgk+hastane");
        break;
      case 8:
        Utils.launchURL("https://www.google.com.tr/maps/search/poliklinik");
        break;
      case 9:
        Utils.launchURL("https://www.google.com.tr/maps/search/eczane");
        break;
      case 10:
        Utils.launchURL("https://www.google.com.tr/maps/search/nöbetçi+eczane");
        break;
      case 11:
        Utils.launchURL(
            "https://www.google.com.tr/maps/search/anlaşmalı+eczane");
        break;
      case 12:
        Utils.launchURL("https://www.google.com.tr/maps/search/oto+tamirhane");
        break;
      case 13:
        Utils.launchURL(
            "https://www.google.com.tr/maps/search/anlaşmalı+oto+tamirhane");
        break;
      case 14:
        Navigator.pushReplacement(
            _buildContext,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                    loginResponse: LoginResponse(), currentIndex: 3)));
        break;
      case 15:
        Navigator.push(
            _buildContext, MaterialPageRoute(builder: (context) => FeedBack()));
        break;
      case 16:
        Navigator.push(_buildContext,
            MaterialPageRoute(builder: (context) => MessageScreen()));
        break;
      case 17:
        Navigator.pushReplacement(
            _buildContext,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                    loginResponse: LoginResponse(), currentIndex: 4)));
        break;
      case 18:
        Navigator.push(_buildContext,
            MaterialPageRoute(builder: (context) => OnboardingScreen.isLogin(true))); //ONBOARDSCREEN
        break;
      case 19:
        break;
      case 20:
        break;
      case 21:
        break;
      default:
        Navigator.of(_buildContext).pop();
        break;
    }
  }

  Widget _getDivider() {
    return Divider(
      height: 1,
      color: ColorData.renkYesil,
      indent: 16,
    );
  }
}

class WebViewTest extends StatefulWidget {
  @override
  _WebViewTestState createState() => _WebViewTestState();
}

class _WebViewTestState extends State<WebViewTest> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: WebView(
          initialUrl:
              "https://pub.dev/packages/webview_flutter#-installing-tab-",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller = controller;
          },
        ),
        onWillPop: () async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
          } else {
            Navigator.of(context).pop();
          }
          return Future.value(false);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Image.asset("assets/images/ic_home.png"),
      ),
    );
  }
}

class ListViewDrawer extends StatefulWidget {
  final String title;
  final List<String> itemList;

  ListViewDrawer({@required this.title, @required this.itemList});

  @override
  _ListViewDrawerState createState() => _ListViewDrawerState();
}

class _ListViewDrawerState extends State<ListViewDrawer> {
  List<String> items = List<String>();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    items.addAll(widget.itemList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: ColorData.renkSolukBeyaz.withOpacity(0.5),
        body: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width / 3,
              ),
              onTap: () {
                Navigator.of(context).pop(null);
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: ListView(
                children: <Widget>[
                  Container(
                    color: ColorData.renkLacivert,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 36),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(width: 16),
                                    IconButton(
                                        icon: Image.asset(
                                            "assets/images/circle_arrow.png"),
                                        onPressed: () {
                                          Navigator.of(context).pop(null);
                                        }),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(widget.title,
                                          textAlign: TextAlign.end,
                                          style: TextStyleData.standartYesil36),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(right: 36),
                                child: TextField(
                                  textInputAction: TextInputAction.search,
                                  style: TextStyleData.boldYesil,
                                  cursorColor: ColorData.renkYesil,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 16, top: 24),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Image.asset(
                                          "assets/images/ic_search.png",
                                          width: 16,
                                          height: 16),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorData.renkYesil),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorData.renkYesil),
                                    ),
                                  ),
                                  controller: _searchController,
                                  onChanged: (value) {
                                    _filterSearchResults(value);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height - 200,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 36, 8),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(items[index],
                                              textAlign: TextAlign.end,
                                              style: TextStyleData
                                                  .standartBeyaz18),
                                        ),
                                        onTap: () {
                                          _handleTap(items[index]);
                                        },
                                      );
                                    }))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(widget.itemList);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.itemList);
      });
    }
  }

  void _handleTap(String item) {
    var baseIndex = widget.itemList.indexOf(item);
    Navigator.of(context).pop(baseIndex);
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
