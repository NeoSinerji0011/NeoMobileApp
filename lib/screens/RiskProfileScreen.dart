import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/Policy/AllPolicyResponse.dart';
import 'package:sigortadefterim/widgets/PdfViewPage.dart';

class RiskProfileScreen extends StatefulWidget {
  @override
  _RiskProfileScreenState createState() => _RiskProfileScreenState();
}

class _RiskProfileScreenState extends State<RiskProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _kullaniciInfo = List<String>();

  @override
  void initState() {
    super.initState();
 
    _kullaniciInfo.addAll(["", "", "", "", ""]);
    _getKullaniciInfo();
  }

  void _getKullaniciInfo() {
    Utils.getKullaniciInfo().then((value) {
      setState(() {
        _kullaniciInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(CalculateRisk.riskAciklama.split(',').length);
    return Scaffold(
        key: _scaffoldKey,
        drawer:
            MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
        backgroundColor: ColorData.renkSolukBeyaz,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Image.asset("assets/images/ic_menu.png",
                                height: 24, width: 24, fit: BoxFit.contain),
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            }),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Risk Profili",
                            style: TextStyleData.standartLacivert24,
                          ),
                        )),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                            icon: Image.asset(
                              "assets/images/ic_soru.png",
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfViewPage(
                                          path: UtilsPolicy.kullanimKilavuzu)));
                              /* showDialog(
                                  context: context,
                                  builder: (BuildContext context) => MyDialog(
                                      imageUrl: "assets/images/ic_info.png",
                                      dialogKind: "AlertDialogInfo",
                                      body:
                                          "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.\nNeque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.\nThe End.",
                                      buttonText: "Kapat")); */
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: ColorData.renkLacivert,
                  //image: DecorationImage(image: AssetImage("assets/images/ikonlar.png")),
                  borderRadius: BorderRadius.circular(33),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xff0048FE),
                        Color(0xff00247F),
                      ]),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                      child: Image.asset(
                        "assets/images/ic_info-2.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 24, 16, 24),
                        child: Text(
                          CalculateRisk.riskAciklama,
                          style: TextStyleData.standartBeyaz,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(33),
                    boxShadow: [BoxDecorationData.shadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 2.2,
                        child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Risk Skoru\n",
                                        style: TextStyleData.standartSiyah),
                                    TextSpan(
                                        text: "%" +
                                            CalculateRisk.riskSkoru.toString(),
                                        style: TextStyleData.standartSiyah36),
                                    TextSpan(
                                        text: "\n" + CalculateRisk.riskDurum,
                                        style: TextStyleData.standartSiyah24),
                                  ])),
                              !CalculateRisk.isLoading
                                  ? DonutAutoLabelChart.withRandomData()
                                  : Container()
                            ])),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "RİSK SKORUNUZUN DAĞILIMI",
                        style: TextStyleData.boldSolukGri12,
                      ),
                    ),
                    SizedBox(
                        height: CalculateRisk.riskAciklama.split(',').length>2?MediaQuery.of(context).size.height / 9:MediaQuery.of(context).size.height /4.5,
                        child: !CalculateRisk.isLoading
                            ? HorizontalBarChart.withSampleData()
                            : Container()),
                    SizedBox(height: 16),
                    //SizedBox(height: 200,child: StackedHorizontalBarChart.withSampleData()),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  //factory DonutAutoLabelChart.withSampleData() {
  //  return new DonutAutoLabelChart(
  //    _createSampleData(),
  //    // Disable animations for image tests.
  //    animate: false,
  //    );
  //}

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory DonutAutoLabelChart.withRandomData() {
    return new DonutAutoLabelChart(_createRandomData());
  }
  static var listAciklama = "";
  static var riskSkoru = 0;
  static var risksonucAciklama = "";

  /// Create random data.
  static List<charts.Series<LinearSales, String>> _createRandomData() {
    var listLinear = List<LinearSales>();

    listAciklama = "";
    riskSkoru = 0;
    if (CalculateRisk.trafik != null) {
      if (CalculateRisk.trafik > 0 || CalculateRisk.kasko > 0) {
        listLinear.add(new LinearSales(
            "Araç",
            CalculateRisk.trafik + CalculateRisk.kasko,
            charts.Color.fromHex(code: "#FF0000")));
      }
     /*  if (CalculateRisk.trafik == 0) listAciklama = "Trafik Yok, ";
      if (CalculateRisk.kasko == 0) listAciklama += "Kasko Yok, "; */

      if (CalculateRisk.konut > 0 || CalculateRisk.dask > 0)
        listLinear.add(new LinearSales(
            "Konut",
            CalculateRisk.konut + CalculateRisk.dask,
            charts.Color.fromHex(code: "#00FFB4")));
    /*   if (CalculateRisk.konut == 0) listAciklama += "Konut Yok, ";
      if (CalculateRisk.dask == 0) listAciklama += "Dask Yok, "; */

      if (CalculateRisk.saglik > 0 || CalculateRisk.tamamlayicisaglik > 0)
        listLinear.add(new LinearSales(
            "Sağlık",
            CalculateRisk.saglik + CalculateRisk.tamamlayicisaglik,
            charts.Color.fromHex(code: "#388e3c")));
    /*   if (CalculateRisk.saglik == 0) listAciklama += "Sağlık Yok, ";
      if (CalculateRisk.tamamlayicisaglik == 0)
        listAciklama += "T.Sağlık Yok, "; */
      /* if (CalculateRisk.saglik > 0 || CalculateRisk.tamamlayicisaglik > 0) {
        listAciklama = listAciklama.replaceAll("T.Sağlık Yok, ", "");
        listAciklama = listAciklama.replaceAll("Sağlık Yok, ", "");
      } */
      if (CalculateRisk.diger > 0)
        listLinear.add(new LinearSales("Diğer", CalculateRisk.diger,
            charts.Color.fromHex(code: "#B2C7FE")));
     /*  if (CalculateRisk.diger == 0) listAciklama += "Diğer Yok, ";
      listAciklama = listAciklama.substring(0, listAciklama.length - 1); */
    }
   
    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        colorFn: (LinearSales sales, _) => sales.color,
        data: listLinear,
        labelAccessorFn: (LinearSales row, _) => '${row.sales}%',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        //behaviors: [charts.DatumLegend(
        //  position: charts.BehaviorPosition.bottom,
        //    entryTextStyle: charts.TextStyleSpec(
        //    fontFamily: "Panton",
        //    fontSize: 12,
        //    color: charts.Color.black
        //  )
        //)],
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer:
            new charts.ArcRendererConfig(arcWidth: 45, arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            insideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.Color.black,
              fontSize: 16,
              fontFamily: "Panton",
            ),
            outsideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.Color.black,
              fontSize: 16,
              fontFamily: "Panton",
            ),
          )
        ]));
  }

  /// Create one series with sample hard coded data.
  //static List<charts.Series<LinearSales, int>> _createSampleData() {
  //  final data = [
  //    new LinearSales(0, 100),
  //    new LinearSales(1, 75),
  //    new LinearSales(2, 25),
  //    new LinearSales(3, 5),
  //  ];
//
  //  return [
  //    new charts.Series<LinearSales, int>(
  //      id: 'Sales',
  //      domainFn: (LinearSales sales, _) => sales.year,
  //      measureFn: (LinearSales sales, _) => sales.sales,
  //      data: data,
  //      // Set a label accessor to control the text of the arc label.
  //      labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
  //      )
  //  ];
  //}
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.color);
}

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData() {
    return new HorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    /* return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: charts.ConstCornerStrategy(10),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelJustification: charts.TickLabelJustification.outside,
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14,
              fontFamily: "Panton",
              color: charts.MaterialPalette.black),
        ),
        showAxisLine: false,
      ),
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelJustification: charts.TickLabelJustification.outside,
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14,
              fontFamily: "Panton",
              color: charts.MaterialPalette.black),
        ),
        showAxisLine: true,
      ),
    ); */
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.outside,
        labelPadding: -30,
        
      ),
      // Hide domain axis.
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelJustification: charts.TickLabelJustification.inside,
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14,
              fontFamily: "Panton",
              color: charts.MaterialPalette.black),
        ),
        showAxisLine: true,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelJustification: charts.TickLabelJustification.outside,
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14,
              fontFamily: "Panton",
              color: charts.MaterialPalette.black),
        ),
        showAxisLine: false,
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    var listLinear = List<OrdinalSales>();

    //CalculateRisk.calcPolicy();
    if (CalculateRisk.trafik != null) {
      if (CalculateRisk.trafik > 0 || CalculateRisk.kasko > 0) {
        listLinear.add(new OrdinalSales(
            "Araç",
            CalculateRisk.trafik + CalculateRisk.kasko,
            charts.Color.fromHex(code: "#FF0000")));
      }

      if (CalculateRisk.konut > 0 || CalculateRisk.dask > 0)
        listLinear.add(new OrdinalSales(
            "Konut",
            CalculateRisk.konut + CalculateRisk.dask,
            charts.Color.fromHex(code: "#00FFB4")));

      if (CalculateRisk.saglik > 0 || CalculateRisk.tamamlayicisaglik > 0)
        listLinear.add(new OrdinalSales(
            "Sağlık",
            CalculateRisk.saglik + CalculateRisk.tamamlayicisaglik,
            charts.Color.fromHex(code: "#388e3c")));

      if (CalculateRisk.diger > 0)
        listLinear.add(new OrdinalSales("Diğer", CalculateRisk.diger,
            charts.Color.fromHex(code: "#B2C7FE")));
    }
 

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.color,
        data: listLinear,
        labelAccessorFn: (OrdinalSales sales, _) =>
            '%${sales.sales.toString()}',
        insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;

          return new charts.TextStyleSpec(
            color: color,
          );
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color);
        },

        //seriesColor: charts.Color.fromHex(code: "#0048fe")
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;

  OrdinalSales(this.year, this.sales, this.color);
}

class CalculateRisk2 {
  static int trafik;
  static int kasko;
  static int dask;
  static int konut;
  static int saglik;
  static int tamamlayicisaglik;
  static int diger;
  var currentDate;
  var diffinDays;

  Future calcPolicy() async {
    trafik = 0;
    kasko = 0;
    dask = 0;
    konut = 0;
    saglik = 0;
    tamamlayicisaglik = 0;
    diger = 0;
    currentDate = DateTime.now();
    diffinDays = 0;
    for (var item in AllPolicyResponse.staticTrafikPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        trafik = 3;
        break;
      }
    }
    for (var item in AllPolicyResponse.staticKaskoPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        kasko = 7;
        break;
      }
    }
    for (var item in AllPolicyResponse.staticDaskPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        dask = 9;
        break;
      }
    }

    for (var item in AllPolicyResponse.staticKonutPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        konut = 21;
        break;
      }
    }

    for (var item in AllPolicyResponse.staticSaglikPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        saglik = 28;
        break;
      }
    }
    for (var item in AllPolicyResponse.staticTamamlayiciSaglikPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) {
        tamamlayicisaglik = 12;
        break;
      }
    }

    List<int> bransList = List<int>();
    List<int> bransList2 = [1, 2, 4, 8, 11, 21, 22];
    for (var item in AllPolicyResponse.staticDigerPolicyList) {
      diffinDays =
          currentDate.difference(DateTime.parse(item.bitisTarihi)).inDays;
      if (diffinDays <= 0) if (!bransList.contains(item.bransKodu)) {
        bransList.add(item.bransKodu);
      }
    }

    List<int> digerbransList = List<int>();
    for (var item in WebAPI.sigortaTuruList) {
      if (!bransList2.contains(item.bransKodu)) {
        digerbransList.add(item.bransKodu);
      }
    }

    double digerbransdegeri = 20 /
        digerbransList
            .length; //diğer ürün başı verilecek puan 1,25 -- 20 diğer ürünlerinin toplam puanı

    diger = bransList.length > 0
        ? (bransList.length * digerbransdegeri).round()
        : 0;
  }
}
