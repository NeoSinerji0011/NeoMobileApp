import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; //directory File
import 'dart:async';
import 'package:flutter/services.dart'; //rootBundle

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/Destek.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/screens/EmergencyScreen.dart';
import 'package:sigortadefterim/screens/SupportScreen.dart';
import 'package:sigortadefterim/screens/MessageScreen.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/models/Policy/AllPolicyResponse.dart';
import 'package:sigortadefterim/widgets/PdfViewPage.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  final Function(int index, bool isAdd) navigateMenu;
  final Map<String, int> policyCountList;
  const HomeScreen({@required this.navigateMenu, this.policyCountList});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _counterAnimationController;
  double _riskPercentage = 0.0;
  int _newMessageCount = 0;
  Color _riskColor;
  List<PolicyResponse> _aracPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _trafikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _kaskoPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _konutPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _daskPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _saglikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _genelSaglikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _tamamlayiciSaglikPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _seyahatPolicyList = List<PolicyResponse>();
  List<PolicyResponse> _digerPolicyList = List<PolicyResponse>();

  List<String> _kullaniciInfo = List<String>();
  //String kullaniciKilavuzPDF = "";
  Image profilPhoto;
  @override
  void initState() {
    super.initState();

    _kullaniciInfo.addAll(["", "", "", "", ""]);

    _counterAnimationController =
        AnimationController(vsync: this, duration: new Duration(seconds: 2));

    _getKullaniciInfo().whenComplete(() {
      /*  profilPhoto = _kullaniciInfo[4].contains("noavatar.png")
          ? Image.asset("assets/images/noavatar.png",
              fit: BoxFit.contain, width: 105, height: 105)
          : Image.network(_kullaniciInfo[4],
              fit: BoxFit.contain, width: 105, height: 105); */
    });
    if (UtilsPolicy.kullaniciInfo != null) {
      WebAPI.getNewMessageCount(
              token: UtilsPolicy.kullaniciInfo[3],
              user_id: int.parse(UtilsPolicy.kullaniciInfo[7]))
          .then((value) {
        setState(() {
          _newMessageCount = value;
        });
      });
    } else {
      UtilsPolicy().getKullaniciInfo().whenComplete(() {
        profilPhoto = UtilsPolicy.kullaniciInfo[4].contains("noavatar.png")
            ? Image.asset("assets/images/noavatar.png",
                fit: BoxFit.contain, width: 105, height: 105)
            : Image.network(UtilsPolicy.kullaniciInfo[4],
                fit: BoxFit.contain, width: 105, height: 105);
        WebAPI.getNewMessageCount(
                token: UtilsPolicy.kullaniciInfo[3],
                user_id: int.parse(UtilsPolicy.kullaniciInfo[7]))
            .then((value) {
          setState(() {
            _newMessageCount = value;
          });
        });
      });
    }
  }

  Widget riskSkoru() {
    _counterAnimationController.forward();
    setState(() {});
    _counterAnimationController.addListener(() {
      setState(() {
        _riskPercentage = lerpDouble(0, UtilsPolicy.countList["riskSkoru"],
            _counterAnimationController.value);
      });
    });
    if (_riskPercentage <= 33)
      _riskColor = ColorData.renkYesil;
    else if (_riskPercentage > 33 && _riskPercentage <= 66)
      _riskColor = Color(0xFFFFE700);
    else
      _riskColor = ColorData.renkKirmizi;
    var res = Text("%${_riskPercentage.toStringAsFixed(1)}",
        style: TextStyleData.boldLacivert24);

    return res;
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

  @override
  void dispose() {
    _counterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        primary: false,
        backgroundColor: ColorData.renkBeyaz,
        key: _scaffoldKey,
        drawer:
            MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
        body: SafeArea(
            top: false,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 26, left: 16, right: 16, bottom: 16),
                    child: IconButton(
                        icon: Image.asset(
                          "assets/images/ic_menu.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        }),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 26,
                  child: IconButton(
                      icon: Image.asset(
                        "assets/images/message.png",
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MessageScreen()));
                        //showDialog(
                        //  context: context,
                        //  builder: (BuildContext context) => MyDialog(
                        //      imageUrl: "assets/images/ic_info.png",
                        //      dialogKind: "AlertDialogInfo",
                        //      body: "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.\nNeque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.\nThe End.",
                        //      buttonText: "KAPAT")
                        //  );
                      }),
                ),
                Positioned(
                    right: 20,
                    top: 30,
                    child: Text(
                        WebAPI.newMessageCount > 0
                            ? WebAPI.newMessageCount.toString()
                            : "",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.white))),
                /*   Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 26, left: 16, right: 16, bottom: 16),
                      child: Column(
                        children: [],
                      )),
                ), */
                Positioned(
                  right: 1,
                  left: 1,
                  bottom: 10,
                  child: FittedBox(
                    child: Container(
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: ColorData.renkBeyaz,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                          boxShadow: [BoxDecorationData.shadow]),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                                iconSize: 70,
                                icon: Image.asset(
                                    "assets/images/destek_button.png"),
                                onPressed: () {
                                  destekDataList();
                                }),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                              child: InkWell(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text("Destek",
                                          style: TextStyleData.boldLacivert24),
                                      Text("Eczane, Hastene,\nTamirhane vb.",
                                          textAlign: TextAlign.left,
                                          style: TextStyleData.boldSiyah12)
                                    ],
                                  ),
                                  onTap: () => destekDataList())),
                          SizedBox(
                              height: 100,
                              child: VerticalDivider(
                                  color: ColorData.renkSiyah, thickness: 0.8)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                            child: InkWell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Acil",
                                      style: TextStyleData.boldKirmizi24),
                                  Text("Acil Servis,\nPolis, İtfaiye vb.",
                                      textAlign: TextAlign.right,
                                      style: TextStyleData.boldSiyah12)
                                ],
                              ),
                              onTap: () => acilNumaraList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                                iconSize: 70,
                                icon: Image.asset(
                                    "assets/images/acil_button.png"),
                                onPressed: () {
                                  acilNumaraList();
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  top: 75,
                  right: 1,
                  left: 1,
                  child: Container(
                    height: screenHeight - 200,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: ColorData.renkLacivert,
                        //image: DecorationImage(image: AssetImage("assets/images/ikonlar.png")),
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [
                              0.1,
                              0.7
                            ],
                            colors: [
                              Color(0xff0047FC),
                              Color(0xff0B1A3D),
                            ]),
                        boxShadow: [BoxDecorationData.shadow]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 16, 16, 16),
                              child: RichText(
                                maxLines: 3,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Merhaba\n",
                                      style: TextStyleData.boldBeyaz),
                                  TextSpan(
                                      text: "${_kullaniciInfo[0]}\n",
                                      style: TextStyleData.boldYesil18),
                                  TextSpan(
                                      text: "${_kullaniciInfo[1]}",
                                      style: TextStyleData.boldYesil18)
                                ]),
                              ),
                            ),
                            Container(
                              height: 75,
                              width: screenWidth / 2,
                              decoration: BoxDecoration(
                                  color: _riskColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(35),
                                      bottomRight: Radius.circular(5))),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 32, 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Risk Skoru",
                                          style:
                                              TextStyleData.standartLacivert),
                                      UtilsPolicy.countList["riskSkoru"] == 0
                                          ? Text(
                                              "%${_riskPercentage.toStringAsFixed(1)}",
                                              style:
                                                  TextStyleData.boldLacivert24)
                                          : riskSkoru()
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Text("Menü",
                              style: TextStyleData.standartYesil36),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              _getMenuItem(
                                  "ARAÇ",
                                  Image.asset("assets/images/ic_car.png",
                                      fit: BoxFit.contain),
                                  UtilsPolicy.countList["arac"].toString()),
                              Divider(
                                indent: 40,
                                height: 0,
                                color: ColorData.renkSiyah,
                              ),
                              _getMenuItem(
                                  "KONUT",
                                  Image.asset("assets/images/ic_apartment.png",
                                      fit: BoxFit.contain),
                                  UtilsPolicy.countList["konut"].toString()),
                              Divider(
                                indent: 40,
                                height: 0,
                                color: ColorData.renkSiyah,
                              ),
                              _getMenuItem(
                                  "SAĞLIK",
                                  Image.asset("assets/images/ic_healt.png",
                                      fit: BoxFit.contain),
                                  UtilsPolicy.countList["saglik"].toString()),
                              Divider(
                                indent: 40,
                                height: 0,
                                color: ColorData.renkSiyah,
                              ),
                              _getMenuItem(
                                  "SEYAHAT",
                                  Image.asset("assets/images/ic_travel.png",
                                      fit: BoxFit.contain),
                                  UtilsPolicy.countList["seyahat"].toString()),
                              Divider(
                                indent: 40,
                                height: 0,
                                color: ColorData.renkSiyah,
                              ),
                              _getMenuItem(
                                  "DASK",
                                  Image.asset("assets/images/ic_dask.png",
                                      fit: BoxFit.contain),
                                  UtilsPolicy.countList["dask"].toString()),
                              Divider(
                                indent: 40,
                                height: 0,
                                color: ColorData.renkSiyah,
                              ),
                              _getMenuItem(
                                  "DİĞER",
                                  Image.asset("assets/images/ic_other.png",
                                      fit: BoxFit.contain),
                                  UtilsPolicy.countList["diger"].toString()),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: screenWidth / 2 - 60,
                    top: 50,
                    //"https://localhost:44346/Userphoto/noavatar.png"
                    child: CircleBar(
                        newPercentage: UtilsPolicy.countList["riskSkoru"] == 0
                            ? 0
                            : double.parse(
                                UtilsPolicy.countList["riskSkoru"].toString()),
                        filePath: UtilsPolicy.kullaniciInfo != null
                            ? UtilsPolicy.kullaniciInfo[4].isEmpty
                                ? "https://localhost:44346/Userphoto/noavatar.png"
                                : UtilsPolicy.kullaniciInfo[4]
                            : "https://localhost:44346/Userphoto/noavatar.png"))
              ],
            )),
      ),
    );
  }

  Future acilNumaraList() async {
    List<String> _listAcilName = List<String>();
    List<String> _listTelNo = List<String>();

    List listUtil = await Utils.getAcilList();
    listUtil.forEach((temp) {
      _listAcilName.add(temp.acilIsim);
      _listTelNo.add(temp.telefonNo);
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListViewAcil(
              title: 'Acil',
              listAcilIsim: _listAcilName,
              listAcilNo: _listTelNo,
            )));
  }

  Future destekDataList() async {
    List<Destek> _listDestekName = List<Destek>();

    List listUtil = await Utils.getDestekList();
    listUtil.forEach((temp) {
      _listDestekName.add(temp);
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListViewDestek(
              listDestekIsim: _listDestekName,
            )));
  }

  Widget _getMenuItem(String title, Image icon, String number) {
    return Padding(
      padding: const EdgeInsets.only(left: 62),
      child: Row(
        children: <Widget>[
          SizedBox(height: 24, width: 24, child: icon),
          SizedBox(width: 38),
          Expanded(
              child: InkWell(
            child: Text(title, style: TextStyleData.boldBeyaz),
            onTap: () => _handleTap(title, false),
          )),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: 36),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: ColorData.renkYesil),
                  color:
                      number != "0" ? ColorData.renkYesil : Colors.transparent),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(number == "0" ? "+" : number,
                      style: number != "0"
                          ? TextStyleData.boldLacivert
                          : TextStyleData.boldYesil),
                ),
              ),
            ),
            onTap: () => _handleTap(title, true),
          ),
        ],
      ),
    );
  }

  void _handleTap(String bransAdi, bool isAdd) {
    switch (bransAdi) {
      case "ARAÇ":
        widget.navigateMenu(1, isAdd);
        break;
      case "KONUT":
        widget.navigateMenu(2, isAdd);
        break;
      case "SAĞLIK":
        widget.navigateMenu(4, isAdd);
        break;
      case "SEYAHAT":
        widget.navigateMenu(5, isAdd);
        break;
      case "DASK":
        widget.navigateMenu(3, isAdd);
        break;
      default:
        widget.navigateMenu(6, isAdd);
        break;
    }
  }

  Future _getKullaniciInfo() async {
    Utils.getKullaniciInfo().then((value) {
      _kullaniciInfo = value;
    });
  }
}

class CircleBar extends StatefulWidget {
  final Image imageFile;
  final double newPercentage;
  final String filePath;
  CircleBar({this.imageFile, this.newPercentage, this.filePath});

  @override
  _CircleBarState createState() => _CircleBarState();
}

class _CircleBarState extends State<CircleBar>
    with SingleTickerProviderStateMixin {
  double percentage = 0.0;
  Color lineColor = Colors.transparent;
  AnimationController percentageAnimationController;

  @override
  void initState() {
    super.initState();
    percentageAnimationController =
        AnimationController(vsync: this, duration: new Duration(seconds: 5));
  }

  @override
  void dispose() {
    percentageAnimationController.dispose();
    super.dispose();
  }

  MyPainter pageLoad() {
    percentageAnimationController.forward();
    percentageAnimationController.addListener(() {
      setState(() {
        percentage = lerpDouble(percentage, widget.newPercentage,
            percentageAnimationController.value);
      });
    });
    if (percentage <= 33)
      lineColor = ColorData.renkYesil;
    else if (percentage > 33 && percentage <= 66)
      lineColor = Color(0xFFFFE700);
    else
      lineColor = ColorData.renkKirmizi;
    var res = MyPainter(
        lineColor: Colors.transparent,
        completeColor: lineColor,
        completePercent: percentage,
        width: 2.0);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: ColorData.renkLacivert, shape: BoxShape.circle),
        margin: EdgeInsets.only(top: 4),
        width: 120,
        /* height: 130,
        width: 130, */
        child: CustomPaint(
          foregroundPainter: widget.newPercentage != 0
              ? pageLoad()
              : MyPainter(
                  lineColor: Colors.transparent,
                  completeColor: Colors.transparent,
                  completePercent: 0,
                  width: 2.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipOval(
              child: Image.network(
                widget.filePath,
                fit: BoxFit.contain,
                width: 105,
                height: 105,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ), //Image.network(widget.imageUrl),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2.2, size.height / 2.2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
