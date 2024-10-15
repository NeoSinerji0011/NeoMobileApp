import 'dart:async';

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/Acente.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/Policy/DamageFileResponse.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/screens/RenewPolicy.dart';
import 'package:sigortadefterim/screens/ReportDamage.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'package:image/image.dart' as ResizedImage;
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/models/BinaKullanimSekli.dart';
import 'package:sigortadefterim/models/YapiTarzi.dart';
import 'package:sigortadefterim/models/YapimYili.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data' show Uint8List;

class DamageDetailScreen extends StatefulWidget {
  final PolicyResponse policyResponse;
  final List<DamageFileResponse> policyResponseFileList;

  const DamageDetailScreen({this.policyResponse, this.policyResponseFileList});

  @override
  _DamageDetailScreenState createState() => _DamageDetailScreenState();
}

class _DamageDetailScreenState extends State<DamageDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DamageFileResponse> policyResponseFileResimList =
      List<DamageFileResponse>();
  List<DamageFileResponse> policyResponseFileSesList =
      List<DamageFileResponse>();
  List<String> _kullaniciInfo = List<String>();

  List<double> _location = List<double>();

  SigortaSirketi _sigortaSirketiforPDF =
      SigortaSirketi(sirketAdi: "Sigorta Şirketi");
  SigortaTuru _sigortaTuru = SigortaTuru(bransAdi: "Sigorta Türü");
  AracMarka _marka = AracMarka(markaAdi: "Marka");
  AracTip _aracTipi = AracTip(tipAdi: "Araç Tipi");
  AracKullanimTarzi _kullanimTarzi =
      AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");
  Ulke _gidilenUlke = Ulke(ulkeAdi: "Seyahat Edilicek Ülke");
  ILCE _ilce = ILCE(ilceAdi: "İlçe");
  IL _il = IL(ilAdi: "İl");
  Meslek _meslek = Meslek(meslekAdi: "Meslek");
  Acente _acenteObject = Acente(unvani: "Portal Üyesi Değil");

  String _kisiSayisi;

  //String _ulkeTuru = "Seyahat Edilicek Ülke Türü";
  UlkeTipi _ulkeTuru = UlkeTipi(ulkeTipiAdi: "Seyahat Edilicek Ülke Türü");

  BinaKullanimSekli _binaKullanimSekli =
      BinaKullanimSekli(binaKullanimTarziAdi: "Kullanım Tarzı");
  YapiTarzi _yapiTarzi = YapiTarzi(yapiTarziAdi: "Yapı Tarzı");
  YapimYili _yapimYili = YapimYili(yapimYiliAdi: "Yapım Yılı");

  List _sigortaSirketi = List();
  List _acente = List();
  List _aracTip = List();
  List _aracMarka = List();
  List _ilList = List();
  List _ilceList = List();
  List _meslekList = List();
  List _ulkeList = List();
  List _sigortaTurList = List();

  bool startmp3 = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _kullaniciInfo.addAll(["", "", "111111111111", "", ""]);
    if (widget.policyResponseFileList != null) {
      policyResponseFileResimList = widget.policyResponseFileList
          .where((element) => element.dosyaTipi == "image")
          .toList();

      policyResponseFileSesList = widget.policyResponseFileList
          .where((element) => element.dosyaTipi == "sound")
          .toList();
    }

    setState(() {
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
    });
    if (widget.policyResponse.acenteUnvani != null)
      UtilsPolicy.findAcente(
              _kullaniciInfo[3], widget.policyResponse.acenteUnvani)
          .then((value) => setState(() {
                _acenteObject = value;
              }));
    /* getPolicyInformation().whenComplete(() {
      if (widget.policyResponse.acenteUnvani != null) {
        UtilsPolicy.findAcente(
                _kullaniciInfo[3], widget.policyResponse.acenteUnvani)
            .then((value) => setState(() {
                  _acenteObject = value;
                }));
      }
    }); */
    setState(() {
      flutterSound = new FlutterSound();
      flutterSound.setSubscriptionDuration(0.01);
    });
  }

  @override
  void dispose() {
    //flutterSound=null;
    super.dispose();

    if (flutterSound.isPlaying) flutterSound.stopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorData.renkSolukBeyaz,
      //drawer: MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Image.asset("assets/images/circle_arrow.png",
                            color: ColorData.renkLacivert,
                            height: 30,
                            width: 30,
                            fit: BoxFit.contain),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Hasar Detay",
                        style: TextStyleData.standartLacivert24,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorData.renkBeyaz,
                  borderRadius: BorderRadius.circular(33),
                  boxShadow: [BoxDecorationData.shadow]),
              child: _getUrunDetail(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getUrunDetail() {
    switch (widget.policyResponse.bransKodu) {
      case 1:
        return _getAracDetail();
      case 2:
        return _getAracDetail();
      case 4:
        return _getSaglikDetail();
      case 11:
        return _getDASKDetail();
      case 21:
        return _getSeyahatDetail();
      case 22:
        return _getKonutDetail();
      default:
        return _getDigerDetail();
    }
  }

  bool checkisTelNumber(String val) {
    for (var i = 0; i < val.length; i++) {
      if (int.tryParse(val[i]) != null) {
        return true;
      }
    }
    return false;
  }

  Widget _getAracDetail() {
    var item = widget.policyResponse;
    //print(item.ruhsatSeriKodu+"-"+item.ruhsatSeriNo);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      colors: [ColorData.renkLacivert, ColorData.renkMavi])),
              child: Image.asset("assets/images/ic_car.png"),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Text(item.markaKodu == null ? "Bulunamadı" : UtilsPolicy.findMarkaa(item.markaKodu), style: TextStyleData.standartLacivert14),
                  Text(_getTitle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyleData.boldMavi18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/ic_hand.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4),
                  child: Text(
                    "Araç Bilgileri",
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Tip", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.tipKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findModel(
                                      item.tipKodu, item.markaKodu),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Plaka", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.plaka == null ? "Bulunmadı" : item.plaka,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Model", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.modelYili == null
                                  ? "Bulunamadı"
                                  : item.modelYili.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Ruhsat No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.ruhsatSeriNo == null &&
                                      item.ruhsatSeriKodu == null
                                  ? "Bulunamadı"
                                  : "${item.ruhsatSeriKodu}-${item.ruhsatSeriNo}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("ASBIS NO",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.asbisNo == null
                                  ? "Bulunamadı"
                                  : item.asbisNo,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4, top: 32),
                  child: Text(
                    "Poliçe Bilgileri",
                    textAlign: TextAlign.start,
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Sigorta Şirketi",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                  item.sirketKodu == null
                                      ? "Bulunamadı"
                                      : UtilsPolicy.findSirket(item.sirketKodu)
                                          .sirketAdi,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyleData.boldSiyah),
                            )),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_phone.png",
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                if (item.sirketKodu == null)
                                  UtilsPolicy.showSnackBar(_scaffoldKey,
                                      "şirketin telefon bilgisi bulunamadı");
                                else
                                  Utils.launchURL(
                                      "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Acente", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(item.acenteAdi,
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
                              onTap: () {
                                if (!checkisTelNumber(item.acenteTelNo))
                                  UtilsPolicy.showSnackBar(
                                      _scaffoldKey, item.acenteTelNo);
                                else
                                  Utils.launchURL("tel:${item.acenteTelNo}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Poliçe No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.policeNumarasi == null
                                  ? "Bulunamadı"
                                  : item.policeNumarasi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yenileme No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.yenilemeNo == null
                                  ? "Bulunamadı"
                                  : item.yenilemeNo.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                    item.bitisTarihi == null
                                        ? "Bulunamadı"
                                        : DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(item.bitisTarihi)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyleData.boldSiyah),
                              ),
                            ),
                            InkWell(
                              child: Image.asset("assets/images/ic_help2.png",
                                  height: 24,
                                  width: 24,
                                  color: _chooseDateColor(
                                      bitisTarihi: item.bitisTarihi)),
                              onTap: () {
                                if (item.bitisTarihi != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "PoliceDayInfo",
                                      color: _chooseDateColor(
                                          bitisTarihi: item.bitisTarihi),
                                      body: _chooseTextInfo(
                                          bitisTarihi: item.bitisTarihi,
                                          policeNo: item.policeNumarasi),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Açıklama",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.aciklama == null
                                  ? "Girilmemiş"
                                  : item.aciklama.toString(),
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                policyFileContainer(
                    policyResponseFileResimList, policyResponseFileSesList),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: OutlineButton(
                    borderSide:
                        BorderSide(color: ColorData.renkLacivert, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text("PDF", style: TextStyleData.boldLacivert),
                    ),
                    shape: StadiumBorder(),
                    onPressed: () {
                      pdfButtonClick();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void pdfButtonClick() {
    var temp = widget.policyResponseFileList.firstWhere(
        (x) =>
            x.mobilHasarId == widget.policyResponse.id && x.dosyaTipi == "pdf",
        orElse: () => null);
    String pdfUrl = temp != null ? temp.dosyaUrl : null;

    if (pdfUrl == null || pdfUrl == "")
      UtilsPolicy.showSnackBar(_scaffoldKey, "Dosya Bulunamadı");
    else {
      var tempContext = context;
      UtilsPolicy.onLoading(tempContext,
          body: "Pdf yükleniyor lütfen bekleyiniz...");
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          createPDF: (i) async{
            if (i == 1) {
              await UtilsPolicy.openPdfPrintingFromUrl(pdfUrl).then((value) {
                if (!value) {
                  UtilsPolicy.showSnackBar(_scaffoldKey, "Dosya Bulunamadı");
                }
              });
            }
            UtilsPolicy.closeLoader(tempContext);
          },
          dialogKind: "PdfSoru",
        ),
      );
    }
  }

  Widget policyFileContainer(
      policyResponseFileResimList, policyResponseFileSesList) {
    return Column(children: [
      SizedBox(height: 16),
      Container(
        alignment: Alignment.center,
        child: Text("Hasar Resimleri", style: TextStyleData.boldAcikSiyah),
      ),
      (policyResponseFileResimList.length > 0
          ? Container(
              margin: EdgeInsets.all(5),
              height: 100.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: policyResponseFileResimList.length,
                  itemBuilder: (BuildContext bContext, index) {
                    var item = policyResponseFileResimList[index];
                    var filepath = item.dosyaUrl;
                    //https://sigortadefterimv2api.azurewebsites.net/Damageimages/02a10dce-a4dc-4642-b4e3-a7cd4f61c351.png
                    return Container(
                        width: 120,
                        height: 75,
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          child: Image.network(
                            filepath,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          )
                          /* Image.network(
                            filepath,
                            height: 100,
                            width: 150,
                          ) */
                          ,
                          onTap: () {
                            showAlertDialog(context, filepath, true);
                          },
                        ));
                  }),
            )
          : Text("Bulunamadı", style: TextStyleData.boldAcikSiyah)),
      SizedBox(height: 16),
      Container(
        alignment: Alignment.center,
        child: Text("Ses Kaydı", style: TextStyleData.boldAcikSiyah),
      ),
      policyResponseFileSesList.length > 0
          ? Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: policyResponseFileSesList.length,
                  itemBuilder: (BuildContext bContext, index) {
                    var item = policyResponseFileSesList[index];
                    var filepath = item.dosyaUrl;

                    //https://sigortadefterimv2api.azurewebsites.net/Damageimages/02a10dce-a4dc-4642-b4e3-a7cd4f61c351.png
                    return Container(
                        width: MediaQuery.of(context).size.width - 45,
                        alignment: Alignment(0.0, 0.0),
                        padding: EdgeInsets.all(10),
                        height: 45,
                        child: InkWell(
                          child: Image.asset(
                            startmp3
                                ? "assets/images/stop.png"
                                : "assets/images/ic_play.png",
                            height: 50,
                          ),
                          onTap: () {
                            if (startmp3)
                              stopPlayer();
                            else
                              startplayer(filepath);
                          },
                        ));
                  }),
            )
          : Text("Bulunamadı", style: TextStyleData.boldAcikSiyah),
    ]);
  }

  FlutterSound flutterSound;
  StreamSubscription _playerSubscription;

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  /*  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      print('The file is ${contents.length} bytes long.');
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  } */

  void startplayer(_path) async {
    int result = await audioPlayer.play(_path);

    if (result == 1) {
      this.setState(() {
        startmp3 = true;
      });

      audioPlayer.onPlayerCompletion.listen(((e) {
        this.setState(() {
          startmp3 = false;
        });
      }));
    }

    /*  try {
      await flutterSound.startPlayer(_path);
      // await flutterSound.startPlayerFromBuffer(buffer);
      await flutterSound.setVolume(1.0);

      this.setState(() {
        startmp3 = true;
      });
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e == null) {
          this.setState(() {
            startmp3 = false;
          });
        }
      });
    } catch (err) {
      print('error: $err');
    } */
  }

  Future stopPlayer() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      this.setState(() {
        startmp3 = false;
      });
    }
    /* try {
      await flutterSound.stopPlayer();
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } catch (e) {}

    this.setState(() {
      startmp3 = false;
    }); */
  }

  Widget _getSaglikDetail() {
    var item = widget.policyResponse;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      colors: [ColorData.renkLacivert, ColorData.renkMavi])),
              child: Image.asset("assets/images/ic_healt.png"),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_getTitle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyleData.boldMavi18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/ic_hand.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4),
                  child: Text(
                    "Kişi Bilgileri",
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Meslek", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.meslek == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findMeslek(item.meslek),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4, top: 32),
                  child: Text(
                    "Poliçe Bilgileri",
                    textAlign: TextAlign.start,
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Sigorta Şirketi",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                  item.sirketKodu == null
                                      ? "Bulunamadı"
                                      : UtilsPolicy.findSirket(item.sirketKodu)
                                          .sirketAdi,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyleData.boldSiyah),
                            )),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_phone.png",
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                if (item.sirketKodu == null)
                                  UtilsPolicy.showSnackBar(_scaffoldKey,
                                      "şirketin telefon bilgisi bulunamadı");
                                else
                                  Utils.launchURL(
                                      "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Acente", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(item.acenteAdi,
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
                              onTap: () {
                                if (!checkisTelNumber(item.acenteTelNo))
                                  UtilsPolicy.showSnackBar(
                                      _scaffoldKey, item.acenteTelNo);
                                else
                                  Utils.launchURL("tel:${item.acenteTelNo}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Poliçe No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.policeNumarasi == null
                                  ? "Bulunamadı"
                                  : item.policeNumarasi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yenileme No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.yenilemeNo == null
                                  ? "Bulunamadı"
                                  : item.yenilemeNo.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                    item.bitisTarihi == null
                                        ? "Bulunamadı"
                                        : DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(item.bitisTarihi)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyleData.boldSiyah),
                              ),
                            ),
                            InkWell(
                              child: Image.asset("assets/images/ic_help2.png",
                                  height: 24,
                                  width: 24,
                                  color: _chooseDateColor(
                                      bitisTarihi: item.bitisTarihi)),
                              onTap: () {
                                if (item.bitisTarihi != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "PoliceDayInfo",
                                      color: _chooseDateColor(
                                          bitisTarihi: item.bitisTarihi),
                                      body: _chooseTextInfo(
                                          bitisTarihi: item.bitisTarihi,
                                          policeNo: item.policeNumarasi),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Açıklama",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.aciklama == null
                                  ? "Girilmemiş"
                                  : item.aciklama.toString(),
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                policyFileContainer(
                    policyResponseFileResimList, policyResponseFileSesList),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 2),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("PDF", style: TextStyleData.boldLacivert),
                  ),
                  shape: StadiumBorder(),
                  onPressed: () {
                    pdfButtonClick();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getDASKDetail() {
    var item = widget.policyResponse;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      colors: [ColorData.renkLacivert, ColorData.renkMavi])),
              child: Image.asset("assets/images/ic_dask.png"),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_getTitle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyleData.boldMavi18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/ic_hand.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4),
                  child: Text(
                    "Yapı Bilgileri",
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Adres", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.adres == null ? "Bulunamadı" : item.adres,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yapı Tarzı",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.binaYapiTarzi == null
                                  ? "Bulunamadı"
                                  : Utils.getYapiTarzi(
                                      index: item.binaYapiTarzi),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yapım Yılı",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.binaYapimYili == null
                                  ? "Bulunamadı"
                                  : Utils.getYapimYili(
                                      index: item.binaYapimYili),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Kullanım Şekli",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.binaKullanimSekli == null
                                  ? "Bulunamadı"
                                  : Utils.getBinaKullanimSekli(
                                      index: item.binaKullanimSekli),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Kat Sayısı",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.binaKatSayisi == null
                                  ? "Bulunamadı"
                                  : item.binaKatSayisi.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Daire m²",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.daireBrut == null
                                  ? "Bulunamadı"
                                  : item.daireBrut.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4, top: 32),
                  child: Text(
                    "Poliçe Bilgileri",
                    textAlign: TextAlign.start,
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Sigorta Şirketi",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                  item.sirketKodu == null
                                      ? "Bulunamadı"
                                      : UtilsPolicy.findSirket(item.sirketKodu)
                                          .sirketAdi,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyleData.boldSiyah),
                            )),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_phone.png",
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                if (item.sirketKodu == null)
                                  UtilsPolicy.showSnackBar(_scaffoldKey,
                                      "şirketin telefon bilgisi bulunamadı");
                                else
                                  Utils.launchURL(
                                      "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Acente", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(item.acenteAdi,
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
                              onTap: () {
                                if (!checkisTelNumber(item.acenteTelNo))
                                  UtilsPolicy.showSnackBar(
                                      _scaffoldKey, item.acenteTelNo);
                                else
                                  Utils.launchURL("tel:${item.acenteTelNo}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Poliçe No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.policeNumarasi == null
                                  ? "Bulunamadı"
                                  : item.policeNumarasi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yenileme No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.yenilemeNo == null
                                  ? "Bulunamadı"
                                  : item.yenilemeNo.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                    item.bitisTarihi == null
                                        ? "Bulunamadı"
                                        : DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(item.bitisTarihi)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyleData.boldSiyah),
                              ),
                            ),
                            InkWell(
                              child: Image.asset("assets/images/ic_help2.png",
                                  height: 24,
                                  width: 24,
                                  color: _chooseDateColor(
                                      bitisTarihi: item.bitisTarihi)),
                              onTap: () {
                                if (item.bitisTarihi != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "PoliceDayInfo",
                                      color: _chooseDateColor(
                                          bitisTarihi: item.bitisTarihi),
                                      body: _chooseTextInfo(
                                          bitisTarihi: item.bitisTarihi,
                                          policeNo: item.policeNumarasi),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Açıklama",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.aciklama == null
                                  ? "Girilmemiş"
                                  : item.aciklama.toString(),
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                policyFileContainer(
                    policyResponseFileResimList, policyResponseFileSesList),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 2),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("PDF", style: TextStyleData.boldLacivert),
                  ),
                  shape: StadiumBorder(),
                  onPressed: () {
                    pdfButtonClick();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getSeyahatDetail() {
    var item = widget.policyResponse;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      colors: [ColorData.renkLacivert, ColorData.renkMavi])),
              child: Image.asset("assets/images/ic_travel.png"),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_getTitle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyleData.boldMavi18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/ic_hand.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4),
                  child: Text(
                    "Seyahat Bilgileri",
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Ülke Türü",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatUlkeKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findUlke(
                                      item.seyahatUlkeKodu, true),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Kişi Sayısı",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatEdenKisiSayisi == null
                                  ? "Bulunmadı"
                                  : item.seyahatEdenKisiSayisi.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4, top: 32),
                  child: Text(
                    "Poliçe Bilgileri",
                    textAlign: TextAlign.start,
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Sigorta Şirketi",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                  item.sirketKodu == null
                                      ? "Bulunamadı"
                                      : UtilsPolicy.findSirket(item.sirketKodu)
                                          .sirketAdi,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyleData.boldSiyah),
                            )),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_phone.png",
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                if (item.sirketKodu == null)
                                  UtilsPolicy.showSnackBar(_scaffoldKey,
                                      "şirketin telefon bilgisi bulunamadı");
                                else
                                  Utils.launchURL(
                                      "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Acente", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(item.acenteAdi,
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
                              onTap: () {
                                if (!checkisTelNumber(item.acenteTelNo))
                                  UtilsPolicy.showSnackBar(
                                      _scaffoldKey, item.acenteTelNo);
                                else
                                  Utils.launchURL("tel:${item.acenteTelNo}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Poliçe No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.policeNumarasi == null
                                  ? "Bulunamadı"
                                  : item.policeNumarasi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yenileme No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.yenilemeNo == null
                                  ? "Bulunamadı"
                                  : item.yenilemeNo.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Gidiş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.seyahatGidisTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.seyahatGidisTarihi)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Dönüş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                    item.seyahatDonusTarihi == null
                                        ? "Bulunamadı"
                                        : DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                item.seyahatDonusTarihi)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyleData.boldSiyah),
                              ),
                            ),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_help2.png",
                                height: 24,
                                width: 24,
                                color: _chooseDateColor(
                                    bitisTarihi: item.seyahatDonusTarihi),
                              ),
                              onTap: () {
                                if (item.seyahatDonusTarihi != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "PoliceDayInfo",
                                      color: _chooseDateColor(
                                          bitisTarihi: item.seyahatDonusTarihi),
                                      body: _chooseTextInfo(
                                          bitisTarihi: item.seyahatDonusTarihi,
                                          policeNo: item.policeNumarasi),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Açıklama",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.aciklama == null
                                  ? "Girilmemiş"
                                  : item.aciklama.toString(),
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                policyFileContainer(
                    policyResponseFileResimList, policyResponseFileSesList),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 2),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("PDF", style: TextStyleData.boldLacivert),
                  ),
                  shape: StadiumBorder(),
                  onPressed: () {
                    pdfButtonClick();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getKonutDetail() {
    var item = widget.policyResponse;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      colors: [ColorData.renkLacivert, ColorData.renkMavi])),
              child: Image.asset("assets/images/ic_apartment.png"),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_getTitle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyleData.boldMavi18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/ic_hand.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4),
                  child: Text(
                    "Yapı Bilgileri",
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Adres", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.adres == null ? "Bulunamadı" : item.adres,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Bina Bedeli",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.binaBedeli == null
                                  ? "Bulunamadı"
                                  : NumberFormat("###,###,###,###")
                                      .format(item.binaBedeli),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Eşya Bedeli",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.esyaBedeli == null
                                  ? "Bulunamadı"
                                  : NumberFormat("###,###,###,###")
                                      .format(item.esyaBedeli),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4, top: 32),
                  child: Text(
                    "Poliçe Bilgileri",
                    textAlign: TextAlign.start,
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Sigorta Şirketi",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                  item.sirketKodu == null
                                      ? "Bulunamadı"
                                      : UtilsPolicy.findSirket(item.sirketKodu)
                                          .sirketAdi,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyleData.boldSiyah),
                            )),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_phone.png",
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                if (item.sirketKodu == null)
                                  UtilsPolicy.showSnackBar(_scaffoldKey,
                                      "şirketin telefon bilgisi bulunamadı");
                                else
                                  Utils.launchURL(
                                      "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Acente", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(item.acenteAdi,
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
                              onTap: () {
                                if (!checkisTelNumber(item.acenteTelNo))
                                  UtilsPolicy.showSnackBar(
                                      _scaffoldKey, item.acenteTelNo);
                                else
                                  Utils.launchURL("tel:${item.acenteTelNo}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Poliçe No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.policeNumarasi == null
                                  ? "Bulunamadı"
                                  : item.policeNumarasi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yenileme No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.yenilemeNo == null
                                  ? "Bulunamadı"
                                  : item.yenilemeNo.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                    item.bitisTarihi == null
                                        ? "Bulunamadı"
                                        : DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(item.bitisTarihi)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyleData.boldSiyah),
                              ),
                            ),
                            InkWell(
                              child: Image.asset("assets/images/ic_help2.png",
                                  height: 24,
                                  width: 24,
                                  color: _chooseDateColor(
                                      bitisTarihi: item.bitisTarihi)),
                              onTap: () {
                                if (item.bitisTarihi != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "PoliceDayInfo",
                                      color: _chooseDateColor(
                                          bitisTarihi: item.bitisTarihi),
                                      body: _chooseTextInfo(
                                          bitisTarihi: item.bitisTarihi,
                                          policeNo: item.policeNumarasi),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Açıklama",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.aciklama == null
                                  ? "Girilmemiş"
                                  : item.aciklama.toString(),
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                policyFileContainer(
                    policyResponseFileResimList, policyResponseFileSesList),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 2),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("PDF", style: TextStyleData.boldLacivert),
                  ),
                  shape: StadiumBorder(),
                  onPressed: () {
                    pdfButtonClick();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getDigerDetail() {
    var item = widget.policyResponse;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      colors: [ColorData.renkLacivert, ColorData.renkMavi])),
              child: Image.asset("assets/images/ic_other.png"),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_getTitle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyleData.boldMavi18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/ic_hand.png",
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4),
                  child: Text(
                    "Adres Bilgileri",
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("İl", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.ilKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findIL(item.ilKodu),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("İlçe", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.ilceKodu == null
                                  ? "Bulunamadı"
                                  : UtilsPolicy.findILCE(item.ilceKodu),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Adres", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.adres == null ? "Bulunamadı" : item.adres,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 62, bottom: 4, top: 32),
                  child: Text(
                    "Poliçe Bilgileri",
                    textAlign: TextAlign.start,
                    style: TextStyleData.boldSolukGri12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Sigorta Şirketi",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                  item.sirketKodu == null
                                      ? "Bulunamadı"
                                      : UtilsPolicy.findSirket(item.sirketKodu)
                                          .sirketAdi,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyleData.boldSiyah),
                            )),
                            InkWell(
                              child: Image.asset(
                                "assets/images/ic_phone.png",
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                if (item.sirketKodu == null)
                                  UtilsPolicy.showSnackBar(_scaffoldKey,
                                      "şirketin telefon bilgisi bulunamadı");
                                else
                                  Utils.launchURL(
                                      "tel:${UtilsPolicy.findSirket(item.sirketKodu).telefon}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Acente", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(item.acenteAdi,
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
                              onTap: () {
                                if (!checkisTelNumber(item.acenteTelNo))
                                  UtilsPolicy.showSnackBar(
                                      _scaffoldKey, item.acenteTelNo);
                                else
                                  Utils.launchURL("tel:${item.acenteTelNo}");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Poliçe No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.policeNumarasi == null
                                  ? "Bulunamadı"
                                  : item.policeNumarasi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Yenileme No",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.yenilemeNo == null
                                  ? "Bulunamadı"
                                  : item.yenilemeNo.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Başlangıç",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.baslangicTarihi == null
                                  ? "Bulunamadı"
                                  : DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(item.baslangicTarihi)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child:
                            Text("Bitiş", style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                    item.bitisTarihi == null
                                        ? "Bulunamadı"
                                        : DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(item.bitisTarihi)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyleData.boldSiyah),
                              ),
                            ),
                            InkWell(
                              child: Image.asset("assets/images/ic_help2.png",
                                  height: 24,
                                  width: 24,
                                  color: _chooseDateColor(
                                      bitisTarihi: item.bitisTarihi)),
                              onTap: () {
                                if (item.bitisTarihi != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => MyDialog(
                                      dialogKind: "PoliceDayInfo",
                                      color: _chooseDateColor(
                                          bitisTarihi: item.bitisTarihi),
                                      body: _chooseTextInfo(
                                          bitisTarihi: item.bitisTarihi,
                                          policeNo: item.policeNumarasi),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    SizedBox(width: 62),
                    SizedBox(
                        width: 75,
                        child: Text("Açıklama",
                            style: TextStyleData.boldAcikSiyah)),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorData.renkGri,
                            borderRadius: BorderRadius.circular(33)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                              item.aciklama == null
                                  ? "Girilmemiş"
                                  : item.aciklama.toString(),
                              style: TextStyleData.boldSiyah),
                        ),
                      ),
                    ),
                  ],
                ),
                policyFileContainer(
                    policyResponseFileResimList, policyResponseFileSesList),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: OutlineButton(
                  borderSide:
                      BorderSide(color: ColorData.renkLacivert, width: 2),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text("PDF", style: TextStyleData.boldLacivert),
                  ),
                  shape: StadiumBorder(),
                  onPressed: () {
                    pdfButtonClick();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    var item = widget.policyResponse;
    switch (widget.policyResponse.bransKodu) {
      case 1:
        return item.tipKodu == null
            ? "Bulunamadı"
            : UtilsPolicy.findMarka(item.markaKodu);
      case 2:
        return item.tipKodu == null
            ? "Bulunamadı"
            : UtilsPolicy.findMarka(item.markaKodu);
      case 4:
        return item.meslek == null
            ? "Bulunamadı"
            : "${UtilsPolicy.findMeslek(item.meslek)}";
      case 11:
        return item.ilKodu == null
            ? "Bulunamadı"
            : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}";
      case 21:
        return item.seyahatUlkeKodu == null
            ? "Bulunamadı"
            : UtilsPolicy.findUlke(item.seyahatUlkeKodu, false);
      case 22:
        return item.ilKodu == null
            ? "Bulunamadı"
            : "${UtilsPolicy.findIL(item.ilKodu)}/${UtilsPolicy.findILCE(item.ilceKodu)}";
      default:
        return item.bransKodu == null
            ? "Bulunamadı"
            : UtilsPolicy.findSigortaTuru(item.bransKodu, false);
    }
  }

  Future getPolicyInformation() async {
    Utils.getKullaniciInfo().then((value) => _kullaniciInfo = value);
  }

  Future getPolicyInformationWithCode(PolicyResponse police) async {
    await UtilsPolicy.getPolicyInformationWithCode(police).whenComplete(() {
      _marka = UtilsPolicy.marka;
      _aracTipi = UtilsPolicy.aracTipi;
      _kullanimTarzi = UtilsPolicy.kullanimTarzi;
      _sigortaSirketiforPDF = UtilsPolicy.sigortaSirketiforPDF;
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
      _sigortaTuru = UtilsPolicy.sigortaTuru;
      _ulkeTuru = UtilsPolicy.ulkeTuru;
      _gidilenUlke = UtilsPolicy.gidilenUlke;
      _yapiTarzi = UtilsPolicy.yapiTarzi;
      _yapimYili = UtilsPolicy.yapimYili;
      _binaKullanimSekli = UtilsPolicy.binaKullanimSekli;
      _il = UtilsPolicy.il;
      _ilce = UtilsPolicy.ilce;
      _meslek = UtilsPolicy.meslek;
    });
  }

  Future<void> pdfCreate(PolicyResponse policy) async {
    final pdf = PDF.Document();
    //final File pdfFile= File("${_sigortaSirketi.sirketKodu}-${widget.policyResponse.policeNumarasi}-${widget.policyResponse.yenilemeNo} Hasar Bildirimi.pdf");

    final ByteData fontData = await rootBundle.load("assets/fonts/micross.ttf");
    final PDF.Font ttf = PDF.Font.ttf(fontData);
    final ByteData logoData = await rootBundle.load("assets/images/logo-3.png");
    ResizedImage.Image logo =
        ResizedImage.decodeImage(logoData.buffer.asUint8List());

    String imageUrl;
    if (_sigortaSirketiforPDF.sirketLogo != null &&
        _sigortaSirketiforPDF.sirketLogo != "")
      imageUrl = _sigortaSirketiforPDF.sirketLogo;
    else {
      imageUrl = "https://neoonlinestrg.blob.core.windows.net";
    }

    var logoNetData = await get("$imageUrl");
    ResizedImage.Image logoNet;

    if (logoNetData.statusCode == 200)
      logoNet = ResizedImage.copyResize(
          ResizedImage.decodeImage(logoNetData.bodyBytes),
          height: -1,
          width: 100);

    pdf.addPage(PDF.MultiPage(
        theme: PDF.ThemeData(
            defaultTextStyle: PDF.TextStyle(font: ttf),
            paragraphStyle: PDF.TextStyle(font: ttf),
            tableCell: PDF.TextStyle(font: ttf),
            tableHeader: PDF.TextStyle(font: ttf)),
        footer: (PDF.Context context) {
          return PDF.Footer(
              leading: PDF.Text("2020 - © Neosinerji"),
              trailing: PDF.UrlLink(
                  child: PDF.Row(
                      mainAxisAlignment: PDF.MainAxisAlignment.end,
                      children: [
                        PDF.Text("sigorta",
                            style:
                                PDF.TextStyle(fontWeight: PDF.FontWeight.bold)),
                        PDF.Text("defterim.com")
                      ]),
                  destination: "www.sigortadefterim.com"));
        },
        build: (PDF.Context context) {
          return [
            PDF.Container(
                child: PDF.Column(
                    crossAxisAlignment: PDF.CrossAxisAlignment.center,
                    children: <PDF.Widget>[
                  PDF.Row(
                      mainAxisAlignment: PDF.MainAxisAlignment.spaceBetween,
                      children: [
                        PDF.Image(PdfImage(pdf.document,
                            image: logo.data.buffer.asUint8List(),
                            width: logo.width,
                            height: logo.height)),
                        PDF.Text(
                            "${DateFormat("dd/MM/yyyy").format(DateTime.now())}")
                      ]),
                  PDF.Padding(padding: const PDF.EdgeInsets.all(10)),
                  PDF.Paragraph(
                      text: "${_sigortaTuru.bransAdi} SİGORTASI HASAR TALEBİ",
                      style: PDF.TextStyle(fontSize: 18)),
                  PDF.Paragraph(
                      text:
                          "   Sayın ${_sigortaSirketiforPDF.sirketAdi}, sigortadefterim.com kullanıcısı tarafından aşağıda detayları bulunan Hasar Bildirimini acilen değerlendirerek, gerekli işlemlerin başlatılması hususunu önemle bilgilerinize sunarız.\n\nSaygılarımızla\n\n",
                      textAlign: PDF.TextAlign.left),
                  PDF.Row(
                      mainAxisAlignment: PDF.MainAxisAlignment.start,
                      children: [
                        PDF.Text("sigorta",
                            style:
                                PDF.TextStyle(fontWeight: PDF.FontWeight.bold)),
                        PDF.Text("defterim.com")
                      ]),
                  PDF.Container(
                      margin: PDF.EdgeInsets.symmetric(horizontal: 24),
                      child: PDF.Table(
                          tableWidth: PDF.TableWidth.max,
                          border: PDF.TableBorder(),
                          defaultVerticalAlignment:
                              PDF.TableCellVerticalAlignment.middle,
                          children: [
                            PDF.TableRow(children: [
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  alignment: PDF.Alignment.center,
                                  child: PDF.Text(
                                      "${_sigortaSirketiforPDF.sirketAdi}",
                                      textAlign: PDF.TextAlign.center)),
                            ]),
                            logoNetData.statusCode == 200
                                ? PDF.TableRow(children: [
                                    PDF.Container(
                                        padding: PDF.EdgeInsets.all(2),
                                        alignment: PDF.Alignment.center,
                                        child: PDF.Image(PdfImage(pdf.document,
                                            image: logoNet.data.buffer
                                                .asUint8List(),
                                            width: logoNet.width,
                                            height: logoNet.height)))
                                  ])
                                : PDF.TableRow(children: [PDF.Text("")])
                          ])),
                  PDF.Padding(padding: const PDF.EdgeInsets.all(10)),
                  PDF.Paragraph(
                      text: "POLİÇE BİLGİLERİ",
                      style: PDF.TextStyle(fontSize: 16)),
                  PDF.Container(
                      margin: PDF.EdgeInsets.symmetric(horizontal: 24),
                      child: PDF.Table(
                          tableWidth: PDF.TableWidth.max,
                          border: PDF.TableBorder(),
                          defaultVerticalAlignment:
                              PDF.TableCellVerticalAlignment.middle,
                          children: _getUrunPDF(policy))),
                ]))
          ];
        }));

    //pdfFile.writeAsBytesSync(pdf.save());
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  List<PDF.TableRow> _getUrunPDF(PolicyResponse police) {
    switch (_sigortaTuru.bransKodu) {
      case 1:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${police.kimlikNo.substring(0, 2)} ****** ${police.kimlikNo.substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Plakası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.plaka}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Tescil Belge No(Ruhsat No)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.ruhsatSeriKodu}-${police.ruhsatSeriNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.asbisNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Markası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_marka.markaAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Araç Tipi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_aracTipi.tipAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Model Yılı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.modelYili}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Kullanım Tarzı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullanimTarzi.kullanimTarzi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 2:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${police.kimlikNo.substring(0, 2)} ****** ${police.kimlikNo.substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Plakası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.plaka}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Tescil Belge No(Ruhsat No)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.ruhsatSeriKodu}-${police.ruhsatSeriNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.asbisNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Markası")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_marka.markaAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Araç Tipi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_aracTipi.tipAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Araç Model Yılı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.modelYili}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Kullanım Tarzı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullanimTarzi.kullanimTarzi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 4:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${_kullaniciInfo[2].substring(0, 2)} ****** ${_kullaniciInfo[2].substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Meslek")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_meslek.meslekAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 11:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${_kullaniciInfo[2].substring(0, 2)} ****** ${_kullaniciInfo[2].substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İl")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("${_il.ilAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İlçe")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ilce.ilceAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Kat Sayısı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.binaKatSayisi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Yapım Yılı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_yapimYili.yapimYiliAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Kullanım Şekli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_binaKullanimSekli.binaKullanimTarziAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Daire Brüt(m²)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.daireBrut}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Yapı Tarzı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_yapiTarzi.yapiTarziAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.adres}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 21:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Gidiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(police.seyahatGidisTarihi))))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Dönüş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(police.seyahatDonusTarihi))))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${_kullaniciInfo[2].substring(0, 2)} ****** ${_kullaniciInfo[2].substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Edilen Ülke Tipi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ulkeTuru.ulkeTipiAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Edilen Ülke")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_gidilenUlke.ulkeAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Eden Kişi Sayısı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.seyahatEdenKisiSayisi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      case 22:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${_kullaniciInfo[2].substring(0, 2)} ****** ${_kullaniciInfo[2].substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İl")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("${_il.ilAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İlçe")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ilce.ilceAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Eşya Bedeli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.esyaBedeli}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Bina Bedeli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.binaBedeli}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.adres}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            // PDF.Container(
            //     width: PdfPageFormat.a4.width/3,
            //     padding: PDF.EdgeInsets.all(2),
            //     child:PDF.UrlLink(child: PDF.Text(_location.isEmpty?"":"https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",maxLines: 2),destination: _location.isEmpty?"":"https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}")
            //     )
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
      default:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketiforPDF.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child:
                    PDF.Text("${police.policeNumarasi}/${police.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.bitisTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Branş Adı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaTuru.bransAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("TCKN/VKN")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${_kullaniciInfo[2].substring(0, 2)} ****** ${_kullaniciInfo[2].substring(8)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adı Soyadı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_kullaniciInfo[0]} ${_kullaniciInfo[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İl")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("${_il.ilAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("İlçe")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_ilce.ilceAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${police.adres}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Konum Bilgisi")),
            PDF.Container(
                width: PdfPageFormat.a4.width / 3,
                padding: PDF.EdgeInsets.all(2),
                child: PDF.UrlLink(
                    child: PDF.Text(
                        _location.isEmpty
                            ? ""
                            : "https://www.google.com/maps/search/?api=1&\nquery=${_location[0]},${_location[1]}",
                        maxLines: 2),
                    destination: _location.isEmpty
                        ? ""
                        : "https://www.google.com/maps/search/?api=1&query=${_location[0]},${_location[1]}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    police.aciklama == null ? "" : "${police.aciklama}"))
          ]),
        ];
    }
  }

  Color _chooseDateColor({String bitisTarihi}) {
    if (bitisTarihi == null) return Colors.white;
    DateTime _dateNow = DateTime.now();
    DateTime _bitisTarihi = DateTime.parse(bitisTarihi);

    final difference = _bitisTarihi.difference(_dateNow).inDays;

    if (difference > 32) {
      return ColorData.renkYesil;
    } else if (difference < 0)
      return ColorData.renkKirmizi;
    else if (difference < 32) return Colors.orange;
    return Colors.grey;
  }

  String _chooseTextInfo({String bitisTarihi, String policeNo}) {
    DateTime _dateNow = DateTime.now();
    DateTime _bitisTarihi = DateTime.parse(bitisTarihi);

    final difference = _bitisTarihi.difference(_dateNow).inDays;

    if (difference > 32) {
      return policeNo +
          " nolu poliçenizin süresi  " +
          difference.toString() +
          " gün sonra bitecektir";
    } else if (difference < 0)
      return policeNo +
          " Nolu Poliçenizin süresi " +
          difference.abs().toString() +
          " Gün önce bitmiştir";
    else if (difference < 32)
      return policeNo +
          " nolu poliçenizin süresi  " +
          difference.toString() +
          " gün sonra bitecektir,poliçenizi lütfen yenileyiniz";
    else
      return "bilgi bulunamadı";
  }

  showAlertDialog(BuildContext context, url, process) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    var content = null;
    if (process) {
      content = Image.network(url);
    } else
      content = Center(
        heightFactor: 10,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
      );
    AlertDialog alert = AlertDialog(
      title: process ? Text("Ön İzleme") : null,
      content: content,
      actions: process ? [continueButton] : null,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
