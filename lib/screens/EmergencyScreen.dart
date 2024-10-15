import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';

class ListViewAcil extends StatelessWidget {
  final String title;
  final List<String> listAcilIsim;
  final List<String> listAcilNo;
  final ScrollController _scrollController = ScrollController();

  ListViewAcil(
      {@required this.title,
      @required this.listAcilIsim,
      @required this.listAcilNo}) {
    acilNoList();
  }

  String acilnoListem = "", acilnoIsim = "";

  void acilNoList() {
    print(UtilsPolicy.acilNumaraList);
    acilnoListem = UtilsPolicy.acilNumaraList.length > 0
        ? UtilsPolicy.acilNumaraList[0] != null
            ? "0" + UtilsPolicy.acilNumaraList[0]
            : ""
        : "";
    acilnoListem += "/";

    acilnoListem += UtilsPolicy.acilNumaraList.length > 1
        ? UtilsPolicy.acilNumaraList[1] != null
            ? "0" + UtilsPolicy.acilNumaraList[1]
            : ""
        : "";

    acilnoIsim = "No 1/No 2";
    listAcilIsim.add(acilnoIsim);
    listAcilNo.add(acilnoListem);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: ColorData.renkSolukBeyaz.withOpacity(0.1),
        body: SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: Container(
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
                        padding: const EdgeInsets.only(right: 0),
                        child: IntrinsicHeight(
                          child: Row(
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
                                child: Text(title,
                                    textAlign: TextAlign.end,
                                    style: TextStyleData.standartkirmizi36),
                              )),
                              SizedBox(width: 16),
                              SizedBox(
                                  width: 10,
                                  child: VerticalDivider(
                                      color: ColorData.renkKirmizi,
                                      thickness: 5)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Divider(
                            color: Colors.white.withOpacity(0.9),
                          )),
                    ],
                  ),
                ),
              /*   ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Acil Durumda Aranacak Numaralarım",
                        textAlign: TextAlign.end,
                        style: TextStyleData.boldKirmizi24),
                  ),
                  trailing: Image.asset(
                    "assets/images/ic_right_arrow.png",
                    fit: BoxFit.contain,
                    width: 16,
                    height: 16,
                    color: ColorData.renkYesil,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AcilArama(
                            title: acilnoIsim, acilNo: acilnoListem)));
                  },
                ), */
                Expanded(child: 
                  Scrollbar(
                          controller: _scrollController,
                          isAlwaysShown: true,
                          child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: listAcilIsim.length,
                              itemBuilder: (BuildContext context, int index) {
                                
                                if (index!=0) { 
                                 
                                  return ListTile( 
                                    title: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(listAcilIsim[index-1],
                                          textAlign: TextAlign.end,
                                          style: TextStyleData.standartBeyaz36),
                                    ),
                                    trailing: Image.asset(
                                      "assets/images/ic_right_arrow.png",
                                      fit: BoxFit.contain,
                                      width: 12,
                                      height: 12,
                                      color: ColorData.renkYesil,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => AcilArama(
                                                  title: listAcilIsim[index-1],
                                                  acilNo: listAcilNo[index-1])));
                                    },
                                  );
                                } else {
                                   
                                  return ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          "Acil Durumda Aranacak Numaralarım",
                                          textAlign: TextAlign.end,
                                          style: TextStyleData.boldKirmizi24),
                                    ),
                                    trailing: Image.asset(
                                      "assets/images/ic_right_arrow.png",
                                      fit: BoxFit.contain,
                                      width: 16,
                                      height: 16,
                                      color: ColorData.renkYesil,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => AcilArama(
                                                  title: acilnoIsim,
                                                  acilNo: acilnoListem)));
                                    },
                                  );
                                }
                              }),
                        ), 
                 ) ,
                 ],
            ),
          ),
        ),
      ),
    );
  }
}

class AcilArama extends StatelessWidget {
  final String title;
  final String acilNo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AcilArama({this.title, this.acilNo});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorData.renkSolukBeyaz.withOpacity(0.1),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 1,
          child: Container(
            color: ColorData.renkLacivert,
            child: SingleChildScrollView(
              child: Column(
                children: createCallContainer(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createCallContainer(BuildContext context) {
    List<Widget> listWidget = List<Widget>();
    List numbers = acilNo.split("/");
    List titles = title.split("/");

    listWidget.add(Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 16),
                  IconButton(
                      icon: Image.asset("assets/images/circle_arrow.png"),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      }),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text("Acil Durum Numaraları",
                        textAlign: TextAlign.end,
                        style: TextStyleData.standartkirmizi36),
                  )),
                  SizedBox(width: 16),
                  SizedBox(
                      width: 10,
                      child: VerticalDivider(
                          color: ColorData.renkKirmizi, thickness: 5)),
                ],
              ),
            ),
          ),
          SizedBox(height: 35),
        ],
      ),
    ));

    numbers.asMap().forEach((key, value) {
      listWidget.add(GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: ColorData.renkKirmizi,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 0.0),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/ic_call.png",
                          height: 70.0,
                        ),
                        // Icon(
                        //   Icons.phone,
                        //   size: 70.0,
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(right: 13.0),
                            child: Text(
                              numbers[key] + "\n" + titles[key],
                              style: TextStyleData.boldSiyah30,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Aramak için tıklayınız',
                          style: TextStyleData.boldSiyah12,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
        onTap: () {
          if (acilNo == null || acilNo == '')
            _showSnackBar("Tel Numarası Bulunamadı");
          else
            Utils.launchURL("tel:$value");
        },
      ));
      listWidget.add(SizedBox(height: 35));
    });
    return listWidget;
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message, style: TextStyleData.boldBeyaz),
      duration: Duration(seconds: 2),
    ));
  }
}
