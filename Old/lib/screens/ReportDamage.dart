import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as ResizedImage;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'package:printing/printing.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/widgets/ButtonContainer.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyStepper.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/models/BinaKullanimSekli.dart';
import 'package:sigortadefterim/models/YapiTarzi.dart';
import 'package:sigortadefterim/models/YapimYili.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ReportDamage extends StatefulWidget {
  final PolicyResponse policyResponse;

  const ReportDamage({this.policyResponse});

  @override
  _ReportDamageState createState() => _ReportDamageState();
}

class _ReportDamageState extends State<ReportDamage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _aracFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _seyahatFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _daskFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _saglikFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _konutFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _digerFormKey = GlobalKey<FormState>();

  final FocusNode _ilKoduFocus = FocusNode();
  final FocusNode _plakaNoFocus = FocusNode();
  final FocusNode _ruhsatFocus = FocusNode();
  final FocusNode _asbisFocus = FocusNode();
  final FocusNode _modelFocus = FocusNode();
  final FocusNode _aciklamaFocus = FocusNode();

  final FocusNode _kisiSayisiFocus = FocusNode();

  final FocusNode _binaKatFocus = FocusNode();
  final FocusNode _daireMetreFocus = FocusNode();
  final FocusNode _adresFocus = FocusNode();

  final FocusNode _binaBedeliFocus = FocusNode();
  final FocusNode _esyaBedeliFocus = FocusNode();

  SigortaSirketi _sigortaSirketi = SigortaSirketi(sirketAdi: "Sigorta Şirketi");
  SigortaTuru _sigortaTuru = SigortaTuru(bransAdi: "Sigorta Türü");
  AracMarka _marka = AracMarka(markaAdi: "Marka");
  AracMarka _markaTemp = AracMarka(markaAdi: "Marka");
  List _aracTipListTemp;
  AracTip _aracTipi = AracTip(tipAdi: "Araç Tipi");
  AracKullanimTarzi _kullanimTarzi =
      AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");

  String _kisiSayisi;
  //String _ulkeTuru = "Seyahat Edilicek Ülke Türü";
  UlkeTipi _ulkeTuru = UlkeTipi(ulkeTipiAdi: "Seyahat Edilicek Ülke Türü");

  Ulke _gidilenUlke = Ulke(ulkeAdi: "Seyahat Edilicek Ülke");
  Meslek _meslek = Meslek(meslekAdi: "Meslek");
  IL _il = IL(ilAdi: "İl");
  ILCE _ilce = ILCE(ilceAdi: "İlçe");

  BinaKullanimSekli _binaKullanimSekli =
      BinaKullanimSekli(binaKullanimTarziAdi: "Kullanım Tarzı");
  YapiTarzi _yapiTarzi = YapiTarzi(yapiTarziAdi: "Yapı Tarzı");
  YapimYili _yapimYili = YapimYili(yapimYiliAdi: "Yapım Yılı");

  int _yapiTarziValue;
  int _yapimYiliValue;
  int _binaKullanimSekliValue;

  bool _kullanimTarziSelect = false;
  bool _aracTipiSelect = false;
  bool _markaSelect = false;
  bool _sigortaSirketiSelect = false;
  bool _yapiTarziSelect = false;
  bool _yapimYiliSelect = false;
  bool _binaKullanimSekliSelect = false;
  bool _ilSelect = false;
  bool _ilceSelect = false;
  bool _meslekSelect = false;
  bool _ruhsatnoSelect = false;
  bool _asbisnoSelect = false;
  bool _modelyiliSelect = false;
  bool _ilkoduSelect = false;
  bool _plakanoSelect = false;
  bool _dairebrutSelect = false;
  bool _binakatsayisiSelect = false;
  bool _adresSelect = false;
  bool _gidilenUlkeSelect = false;

  final TextEditingController _startingDateController = TextEditingController();
  final TextEditingController _endingDateController = TextEditingController();

  List<String> _selectedImages = List();
  List<String> _checkimagesList = List();
  String _recordFile = "";

  List<double> _location = List<double>();

  List<String> _kullaniciInfo = List<String>();

  var _binabedelController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', rightSymbol: 'TL');
  var _esyabedelController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', rightSymbol: 'TL');
  PolicyResponse policyResponseRenew = PolicyResponse();

  String _binaBedeli;
  String _esyaBedeli;
  @override
  void initState() {
    super.initState();
    _kullaniciInfo.addAll(["", "", "11111111111", "", ""]);
    getPolicyInformation().whenComplete(() {});

    if (widget.policyResponse.binaYapiTarzi == null) _yapiTarziSelect = true;
    if (widget.policyResponse.binaYapimYili == null) _yapimYiliSelect = true;
    if (widget.policyResponse.binaKullanimSekli == null)
      _binaKullanimSekliSelect = true;
    if (widget.policyResponse.ilKodu == null) _ilSelect = true;
    if (widget.policyResponse.ilceKodu == null) _ilceSelect = true;

    if (widget.policyResponse.aracKullanimTarzi == null)
      _kullanimTarziSelect = true;
    if (widget.policyResponse.markaKodu == null ||
        widget.policyResponse.markaKodu == "") _markaSelect = true;
    if (widget.policyResponse.tipKodu == null ||
        widget.policyResponse.tipKodu == "") _aracTipiSelect = true;
    if (widget.policyResponse.sirketKodu == null) _sigortaSirketiSelect = true;
    if (widget.policyResponse.meslek == null ||
        widget.policyResponse.meslek == "") _meslekSelect = true;

    if (widget.policyResponse.plaka == null ||
        widget.policyResponse.plaka == "") {
      _ilkoduSelect = true;
      _plakanoSelect = true;
    }

    if ((widget.policyResponse.ruhsatSeriKodu == null ||
            widget.policyResponse.ruhsatSeriKodu == "") &&
        (widget.policyResponse.ruhsatSeriNo == null ||
            widget.policyResponse.ruhsatSeriNo == "")) _ruhsatnoSelect = true;

    if (widget.policyResponse.asbisNo == null ||
        widget.policyResponse.asbisNo == "") _asbisnoSelect = true;

    if (widget.policyResponse.modelYili == null) _modelyiliSelect = true;
    if (widget.policyResponse.daireBrut == null) _dairebrutSelect = true;
    if (widget.policyResponse.binaKatSayisi == null)
      _binakatsayisiSelect = true;
    if (widget.policyResponse.adres == null ||
        widget.policyResponse.adres == "") _adresSelect = true;

    if (widget.policyResponse.seyahatUlkeKodu == null ||
        widget.policyResponse.seyahatUlkeKodu == "") _gidilenUlkeSelect = true;
    policyResponseRenew.baslangicTarihi = widget.policyResponse.baslangicTarihi;
    policyResponseRenew.bitisTarihi = widget.policyResponse.bitisTarihi;

    policyResponseRenew.seyahatGidisTarihi =
        widget.policyResponse.seyahatGidisTarihi;
    policyResponseRenew.seyahatDonusTarihi =
        widget.policyResponse.seyahatDonusTarihi;

    policyResponseRenew.bransKodu = widget.policyResponse.bransKodu;
    _binabedelController.text = widget.policyResponse.binaBedeli.toString();
    _esyabedelController.text = widget.policyResponse.esyaBedeli.toString();
  }

  @override
  void dispose() {
    _startingDateController.dispose();
    _endingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sigortaTuru.bransKodu == 21) {
      _startingDateController.text = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(widget.policyResponse.seyahatGidisTarihi));
      _endingDateController.text = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(widget.policyResponse.seyahatDonusTarihi));
    } else {
      _startingDateController.text = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(widget.policyResponse.baslangicTarihi));
      _endingDateController.text = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(widget.policyResponse.bitisTarihi));
    }

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorData.renkSolukBeyaz,
      drawer: MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Stack(
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
                        "Hasar Bildir",
                        style: TextStyleData.standartLacivert24,
                      ),
                    )),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorData.renkBeyaz,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                "${widget.policyResponse.kimlikNo.substring(0, 2)}******${widget.policyResponse.kimlikNo.substring(8, 11)}",
                                style: TextStyleData.standartSiyah12),
                            Text(
                                "Talep No: ${widget.policyResponse.teklifIslemNo != null ? widget.policyResponse.teklifIslemNo : "Bulunamadı"}",
                                style: TextStyleData.standartSiyah12),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                "Poliçe No: ${widget.policyResponse.policeNumarasi != null ? widget.policyResponse.policeNumarasi : "Bulunamadı"}",
                                style: TextStyleData.standartSiyah12),
                            Text(
                                "Yenileme No: ${widget.policyResponse.yenilemeNo != null ? widget.policyResponse.yenilemeNo : "Bulunamadı"}",
                                style: TextStyleData.standartSiyah12),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            //Padding(
            //  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            //  child: Column(
            //    children: <Widget>[
            //      Row(
            //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //        children: <Widget>[
            //          Text("${widget.policyResponse.kimlikNo.substring(0, 2)}******${widget.policyResponse.kimlikNo.substring(8, 11)}", style: TextStyleData.boldSiyah),
            //          Text("Teklif Talep No: ${widget.policyResponse.teklifIslemNo}", style: TextStyleData.boldSiyah),
            //        ],
            //      ),
            //      Row(
            //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //        children: <Widget>[
            //          Text("Poliçe No: ${widget.policyResponse.policeNumarasi}", style: TextStyleData.boldSiyah),
            //          Text("Yenileme No: ${widget.policyResponse.yenilemeNo}", style: TextStyleData.boldSiyah),
            //        ],
            //      ),
            //    ],
            //  ),
            //),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: InkWell(
                child: ButtonContainer(
                    title: _sigortaSirketi.sirketAdi,
                    isFilled: !_sigortaSirketiSelect),
                onTap: () {
                  if (_sigortaSirketiSelect) _openListViewDialog(0);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: InkWell(
                child: ButtonContainer(
                    title: _sigortaTuru.bransAdi,
                    isFilled: _sigortaTuru.bransAdi != "Sigorta Türü"),
                onTap: () {
                  if (_sigortaTuru.bransAdi == "Sigorta Türü")
                    _openListViewDialog(1);
                },
              ),
            ),

            SizedBox(height: 8),
            //_getUrunForm(),
            //SizedBox(height: 8),

            Stack(
              children: <Widget>[
                _getUrunForm(),
                Positioned(
                  bottom: 0,
                  left: 32,
                  right: 32,
                  child: Container(
                    decoration:
                        BoxDecoration(boxShadow: [BoxDecorationData.shadow]),
                    //width: MediaQuery.of(context).size.width / 1.4,
                    child: RaisedButton(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("HASAR BİLDİR",
                              style: TextStyleData.extraBoldLacivert16),
                        ),
                        color: ColorData.renkYesil,
                        shape: StadiumBorder(),
                        onPressed: () {
                          _reportDamage();
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    ));
  }

  Widget _getUrunForm() {
    if (_sigortaTuru.bransAdi == "Sigorta Türü") {
      return Container();
    } else {
      switch (_sigortaTuru.bransKodu) {
        case 1:
          return _getAracForm();
        case 2:
          return _getAracForm();
        case 4:
          return _getSaglikForm();
        case 11:
          return _getDASKForm();
        case 21:
          return _getSeyahatForm();
        case 22:
          return _getKonutForm();
        default:
          return _getDigerForm();
      }
    }
  }

  Widget _getAracForm() {
    return Column(
      children: <Widget>[
        Form(
          key: _aracFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: widget.policyResponse.plaka == null ||
                                widget.policyResponse.plaka.trim() == ""
                            ? ""
                            : widget.policyResponse.plaka.substring(0, 2),
                        readOnly: !_plakanoSelect,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2)
                        ],
                        decoration: InputDecoration(
                            labelText: "İl Kodu",
                            contentPadding: EdgeInsets.only(top: 8)),
                        textInputAction: TextInputAction.next,
                        style: TextStyleData.boldSiyah,
                        focusNode: _ilKoduFocus,
                        onFieldSubmitted: (value) {
                          _focusNextField(_ilKoduFocus, _plakaNoFocus);
                        },
                        validator: (value) {
                          if (value.isNotEmpty) {
                            bool valid =
                                RegExp(r'(^[0-9]{2}$)').hasMatch(value);
                            if (valid)
                              return null;
                            else
                              return "İl kodu 2 hanelidir";
                          } else
                            return "İl kodu giriniz";
                        },
                        onSaved: (value) => policyResponseRenew.plaka = value,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: widget.policyResponse.plaka == null ||
                                widget.policyResponse.plaka.trim() == ""
                            ? ""
                            : widget.policyResponse.plaka.substring(2),
                        readOnly: !_plakanoSelect,
                        decoration: InputDecoration(
                            labelText: "Plaka No",
                            contentPadding: EdgeInsets.only(top: 8)),
                        textInputAction: TextInputAction.next,
                        style: TextStyleData.boldSiyah,
                        focusNode: _plakaNoFocus,
                        onFieldSubmitted: (value) {
                          _focusNextField(_plakaNoFocus, _ruhsatFocus);
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Plaka No giriniz' : null,
                        onSaved: (value) => policyResponseRenew.plaka += value,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.policyResponse.ruhsatSeriKodu +
                        widget.policyResponse.ruhsatSeriNo,
                    readOnly: !_ruhsatnoSelect,
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
                    decoration: InputDecoration(
                        labelText: "Ruhsat Seri No",
                        contentPadding: EdgeInsets.only(top: 8)),
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _ruhsatFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_ruhsatFocus, _asbisFocus);
                    },
                    validator: (value) {
                      if (value.isNotEmpty) {
                        bool valid = RegExp(r'^([a-zA-Z]){2}([0-9]){6}$')
                            .hasMatch(value.toUpperCase());
                        if (valid)
                          return null;
                        else
                          return "Ruhsat Seri No: AA123456 formatta olmalı";
                      } else
                        return "Ruhsat Seri No giriniz";
                    },
                    onSaved: (value) {
                      if (value.length > 3) {
                        policyResponseRenew.ruhsatSeriKodu =
                            value.substring(0, 2);
                        policyResponseRenew.ruhsatSeriNo = value.substring(2);
                      }
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: widget.policyResponse.asbisNo,
                  readOnly: !_asbisnoSelect,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19)
                  ],
                  decoration: InputDecoration(
                      labelText: "ASBİS No",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _asbisFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_asbisFocus, _modelFocus);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      bool valid = RegExp(r'^([0-9]){19}$')
                          .hasMatch(value.toUpperCase());
                      if (valid)
                        return null;
                      else
                        return "ASBİS No 19 hanelidir";
                    } else
                      return null;
                  },
                  onSaved: (value) => policyResponseRenew.asbisNo = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _startingDateController,
                  decoration: InputDecoration(
                      labelText: "Başlangıç Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _endingDateController,
                  decoration: InputDecoration(
                      labelText: "Bitiş Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: widget.policyResponse.modelYili != null &&
                          widget.policyResponse.modelYili.toString() != ""
                      ? widget.policyResponse.modelYili.toString()
                      : "",
                  readOnly: !_modelyiliSelect,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4)
                  ],
                  decoration: InputDecoration(
                      labelText: "Model Yılı",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _modelFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_modelFocus, _aciklamaFocus);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      bool valid = RegExp(r'^([0-9]){4}$').hasMatch(value);
                      if (valid)
                        return null;
                      else
                        return "Model Yılı 4 hanelidir";
                    } else
                      return "Model Yılı giriniz";
                  },
                  onSaved: (value) {
                    var control = int.tryParse(value);
                    if (control != null)
                      policyResponseRenew.modelYili = int.parse(value);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: widget.policyResponse.aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => policyResponseRenew.aciklama = value,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _marka.markaAdi, isFilled: !_markaSelect),
            onTap: () {
              if (_markaSelect) _openListViewDialog(2);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _aracTipi.tipAdi, isFilled: !_aracTipiSelect),
            onTap: () {
              if (_aracTipiSelect) _openListViewDialog(3);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _kullanimTarzi.kullanimTarzi,
                isFilled: !_kullanimTarziSelect),
            onTap: () {
              if (_kullanimTarziSelect) _openListViewDialog(4);
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyStepper(
              onSelectionComplete: (images, chechimages, recordFile, location) {
                images != null ? _selectedImages = images : null;
                chechimages != null ? _checkimagesList = chechimages : null;
                _recordFile = recordFile;
                _location = location;
              },
              isArac: true,
            )),
      ],
    );
  }

  Widget _getSeyahatForm() {
    return Column(
      children: <Widget>[
        Form(
          key: _seyahatFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _startingDateController,
                  decoration: InputDecoration(
                      labelText: "Gidiş Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _endingDateController,
                  decoration: InputDecoration(
                      labelText: "Dönüş Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      labelText: "Sizinle Seyahat Edecek Kişi Sayısı",
                      contentPadding: EdgeInsets.only(top: 8)),
                  initialValue: widget.policyResponse.seyahatEdenKisiSayisi !=
                          null
                      ? widget.policyResponse.seyahatEdenKisiSayisi.toString()
                      : "",
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _kisiSayisiFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_kisiSayisiFocus, _aciklamaFocus);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      return null;
                    } else
                      return "Seyahat Edecek Kişi Sayısı giriniz";
                  },
                  onSaved: (value) {
                    var control = int.tryParse(value);
                    if (control != null)
                      policyResponseRenew.seyahatEdenKisiSayisi =
                          int.parse(value);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: widget.policyResponse.aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => policyResponseRenew.aciklama = value,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ulkeTuru.ulkeTipiAdi, isFilled: !_gidilenUlkeSelect),
            onTap: () {
              if (_gidilenUlkeSelect) _openListViewDialog(11);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _gidilenUlke.ulkeAdi, isFilled: !_gidilenUlkeSelect),
            onTap: () {
              if (_gidilenUlkeSelect) _openListViewDialog(12);
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyStepper(
              onSelectionComplete: (images, chechimages, recordFile, location) {
                _selectedImages = images;
                _checkimagesList = chechimages;
                _recordFile = recordFile;
                _location = location;
              },
              isArac: false,
            )),
      ],
    );
  }

  Widget _getDASKForm() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _yapiTarzi.yapiTarziAdi, isFilled: !_yapiTarziSelect),
            onTap: () {
              if (_yapiTarziSelect) _openListViewDialog(6);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _yapimYili.yapimYiliAdi, isFilled: !_yapimYiliSelect),
            onTap: () {
              if (_yapimYiliSelect) _openListViewDialog(7);
            },
          ),
        ),
        Form(
            key: _daskFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    controller: _startingDateController,
                    decoration: InputDecoration(
                        labelText: "Başlangıç Tarihi",
                        contentPadding: EdgeInsets.only(top: 8),
                        suffixIcon: Image.asset(
                          "assets/images/ic_takvim.png",
                          height: 16,
                          width: 16,
                        )),
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    controller: _endingDateController,
                    decoration: InputDecoration(
                        labelText: "Bitiş Tarihi",
                        contentPadding: EdgeInsets.only(top: 8),
                        suffixIcon: Image.asset(
                          "assets/images/ic_takvim.png",
                          height: 16,
                          width: 16,
                        )),
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    initialValue: widget.policyResponse.binaKatSayisi == null
                        ? ""
                        : widget.policyResponse.binaKatSayisi.toString(),
                    decoration: InputDecoration(
                        labelText: "Bina Toplam Kat Sayısı",
                        contentPadding: EdgeInsets.only(top: 8)),
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _binaKatFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_binaKatFocus, _daireMetreFocus);
                    },
                    validator: (value) {
                      if (value.isNotEmpty) {
                        bool valid = RegExp(r'^([0-9]){1,3}$').hasMatch(value);
                        if (valid)
                          return null;
                        else
                          return "Geçersiz Bina Toplam Kat Sayısı";
                      } else
                        return "Bina Toplam Kat Sayısı giriniz";
                    },
                    onSaved: (value) {
                      var control = int.tryParse(value);
                      if (control != null)
                        policyResponseRenew.binaKatSayisi = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    initialValue: widget.policyResponse.daireBrut == null
                        ? ""
                        : widget.policyResponse.daireBrut.toString(),
                    decoration: InputDecoration(
                        labelText: "Daire m²",
                        contentPadding: EdgeInsets.only(top: 8)),
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _daireMetreFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_daireMetreFocus, _adresFocus);
                    },
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else
                        return "Daire m² giriniz";
                    },
                    onSaved: (value) {
                      var control = int.tryParse(value);
                      if (control != null)
                        policyResponseRenew.daireBrut = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Adres",
                        contentPadding: EdgeInsets.only(top: 8)),
                    initialValue: widget.policyResponse.adres,
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _adresFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_adresFocus, _aciklamaFocus);
                    },
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else
                        return "Adres giriniz";
                    },
                    onSaved: (value) => policyResponseRenew.adres = value,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Açıklama",
                        contentPadding: EdgeInsets.only(top: 8)),
                    initialValue: widget.policyResponse.aciklama,
                    textInputAction: TextInputAction.done,
                    style: TextStyleData.boldSiyah,
                    focusNode: _aciklamaFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_aciklamaFocus, null);
                    },
                    onSaved: (value) => policyResponseRenew.aciklama = value,
                  ),
                ],
              ),
            )),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _binaKullanimSekli.binaKullanimTarziAdi,
                isFilled: !_binaKullanimSekliSelect),
            onTap: () {
              if (_binaKullanimSekliSelect) _openListViewDialog(8);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(title: _il.ilAdi, isFilled: !_ilSelect),
            onTap: () {
              if (_ilSelect) _openListViewDialog(9);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child:
                ButtonContainer(title: _ilce.ilceAdi, isFilled: !_ilceSelect),
            onTap: () {
              if (_ilceSelect) _openListViewDialog(10);
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyStepper(
              onSelectionComplete: (images, chechimages, recordFile, location) {
                _selectedImages = images;
                _checkimagesList = chechimages;
                _recordFile = recordFile;
                _location = location;
              },
              isArac: false,
            )),
      ],
    );
  }

  Widget _getSaglikForm() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _meslek.meslekAdi, isFilled: !_meslekSelect),
            onTap: () {
              if (_meslekSelect) _openListViewDialog(5);
            },
          ),
        ),
        Form(
          key: _saglikFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _startingDateController,
                  decoration: InputDecoration(
                      labelText: "Başlangıç Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _endingDateController,
                  decoration: InputDecoration(
                      labelText: "Bitiş Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: widget.policyResponse.aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => policyResponseRenew.aciklama = value,
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyStepper(
              onSelectionComplete: (images, chechimages, recordFile, location) {
                _selectedImages = images;
                _checkimagesList = chechimages;
                _recordFile = recordFile;
                _location = location;
              },
              isArac: false,
            )),
      ],
    );
  }

  Widget _getKonutForm() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(title: _il.ilAdi, isFilled: !_ilSelect),
            onTap: () {
              if (_ilSelect) _openListViewDialog(9);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child:
                ButtonContainer(title: _ilce.ilceAdi, isFilled: !_ilceSelect),
            onTap: () {
              if (_ilceSelect) _openListViewDialog(10);
            },
          ),
        ),
        Form(
          key: _konutFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _startingDateController,
                  decoration: InputDecoration(
                      labelText: "Başlangıç Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _endingDateController,
                  decoration: InputDecoration(
                      labelText: "Bitiş Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _binabedelController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        labelText: "Bina Bedeli",
                        contentPadding: EdgeInsets.only(top: 8)),
                    /* initialValue:
                        widget.policyResponse.binaBedeli.toStringAsFixed(0), */
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _binaBedeliFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_binaBedeliFocus, _esyaBedeliFocus);
                    },
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else {
                        if (double.tryParse(value) == null)
                          return "Bina Bedeli giriniz";
                        else
                          return null;
                      }
                    },
                    onSaved: (value) => _binaBedeli = value),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _esyabedelController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        labelText: "Eşya Bedeli",
                        contentPadding: EdgeInsets.only(top: 8)),
                    /* initialValue:
                        widget.policyResponse.esyaBedeli.toStringAsFixed(0), */
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _esyaBedeliFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_esyaBedeliFocus, _adresFocus);
                    },
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else if (value == null || value == "")
                        return "Eşya Bedeli giriniz";
                      else
                        return null;
                    },
                    onSaved: (value) => _esyaBedeli = value),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Adres",
                      contentPadding: EdgeInsets.only(top: 8)),
                  initialValue: widget.policyResponse.adres,
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _adresFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_adresFocus, _aciklamaFocus);
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      return null;
                    } else
                      return "Adres giriniz";
                  },
                  onSaved: (value) => policyResponseRenew.adres = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: widget.policyResponse.aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => policyResponseRenew.aciklama = value,
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyStepper(
                onSelectionComplete:
                    (images, chechimages, recordFile, location) {
                  _selectedImages = images;
                  _checkimagesList = chechimages;
                  _recordFile = recordFile;
                  _location = location;
                },
                isArac: false,
                testfile: "")),
      ],
    );
  }

  Widget _getDigerForm() {
    return Column(
      children: <Widget>[
        Form(
          key: _digerFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _startingDateController,
                  decoration: InputDecoration(
                      labelText: "Başlangıç Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: _endingDateController,
                  decoration: InputDecoration(
                      labelText: "Bitiş Tarihi",
                      contentPadding: EdgeInsets.only(top: 8),
                      suffixIcon: Image.asset(
                        "assets/images/ic_takvim.png",
                        height: 16,
                        width: 16,
                      )),
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Adres",
                      contentPadding: EdgeInsets.only(top: 8)),
                  initialValue: widget.policyResponse.adres,
                  readOnly: widget.policyResponse.adres != null &&
                      widget.policyResponse.adres != "",
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _adresFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_adresFocus, _aciklamaFocus);
                  },
                  onSaved: (value) => policyResponseRenew.adres = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: widget.policyResponse.aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => policyResponseRenew.aciklama = value,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(title: _il.ilAdi, isFilled: !_ilSelect),
            onTap: () {
              if (_ilSelect) _openListViewDialog(9);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child:
                ButtonContainer(title: _ilce.ilceAdi, isFilled: !_ilceSelect),
            onTap: () {
              if (_ilceSelect) _openListViewDialog(10);
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyStepper(
              onSelectionComplete: (images, chechimages, recordFile, location) {
                _selectedImages = images;
                _checkimagesList = chechimages;
                _recordFile = recordFile;
                _location = location;
              },
              isArac: false,
            )),
      ],
    );
  }

  void _openListViewDialog(int index) async {
    switch (index) {
      case 0:
        List<String> list = List<String>();
        List itemList = WebAPI.sigortaSirketiList;
        //List itemList = await Utils.getSigortaSirketi();
        itemList.forEach((temp) {
          list.add(temp.sirketAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Sigorta Şirketi", itemList: list));
        setState(() {
          _sigortaSirketi = result != null ? itemList[result] : _sigortaSirketi;
        });
        break;
      case 1:
        List<String> list = List<String>();
        List itemList = WebAPI.sigortaTuruList;
        //List itemList = await Utils.getSigortaTuru();
        itemList.forEach((temp) {
          list.add(temp.bransAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Sigorta Türü", itemList: list));
        setState(() {
          _sigortaTuru = result != null ? itemList[result] : _sigortaTuru;
          policyResponseRenew.bransKodu = result != null
              ? itemList[result].bransKodu
              : policyResponseRenew.bransKodu;
        });
        break;
      case 2:
        List<String> list = List<String>();
        List itemList = WebAPI.aracMarkaList;
        //List itemList = await Utils.getAracMarka();
        itemList.forEach((temp) {
          list.add(temp.markaAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Marka", itemList: list));
        setState(() {
          _marka = result != null ? itemList[result] : _marka;
          _aracTipi = AracTip(tipAdi: "Bulunamadı");
        });
        break;
      case 3:
        List<String> list = List<String>();
        List itemList;
        if (_markaTemp == _marka) {
          itemList = _aracTipListTemp;
        } else if (_marka.markaKodu == null)
          break;
        else {
          _onLoading();
          itemList = await WebAPI.getAracTipRequest(
                  token: _kullaniciInfo[3], markakodu: _marka.markaKodu)
              .whenComplete(() => closeLoader());
          _aracTipListTemp = itemList;
          _markaTemp = _marka;
        }
        itemList.forEach((temp) {
          list.add(temp.tipAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Araç Tipi", itemList: list));
        setState(() {
          _aracTipi = result != null ? itemList[result] : _aracTipi;
        });
        break;
      case 4:
        List<String> list = List<String>();
        List itemList = WebAPI.aracKullanimTarziList;
        itemList.forEach((temp) {
          list.add(temp.kullanimTarzi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Kullanım Tarzı", itemList: list));
        setState(() {
          _kullanimTarzi = result != null ? itemList[result] : _kullanimTarzi;
        });
        break;
      case 5:
        List<String> list = List<String>();
        List itemList = WebAPI.meslekList;
        //List itemList = await Utils.getMeslek();
        itemList.forEach((temp) {
          list.add(temp.meslekAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Meslek", itemList: list));
        setState(() {
          _meslek = result != null ? itemList[result] : _meslek;
        });
        break;
      case 6:
        List<String> itemList = Utils.getYapiTarzi();
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Yapı Tarzı", itemList: itemList));
        setState(() {
          _yapiTarzi.yapiTarziAdi =
              result != null ? itemList[result] : _yapiTarzi.yapiTarziAdi;
          _yapiTarzi.yapiTarziKodu =
              result != null ? result : _yapiTarzi.yapiTarziKodu;
        });
        break;
      case 7:
        List<String> itemList = Utils.getYapimYili();
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Yapım Yılı", itemList: itemList));
        setState(() {
          _yapimYili.yapimYiliAdi =
              result != null ? itemList[result] : _yapimYili.yapimYiliAdi;
          _yapimYili.yapimYiliKodu =
              result != null ? result : _yapimYili.yapimYiliKodu;
        });
        break;
      case 8:
        List<String> itemList = Utils.getBinaKullanimSekli();
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) => ListViewDrawer(
                title: "Bina Kullanim Şekli", itemList: itemList));
        setState(() {
          _binaKullanimSekli.binaKullanimTarziAdi = result != null
              ? itemList[result]
              : _binaKullanimSekli.binaKullanimTarziAdi;
          _binaKullanimSekli.binaKullanimTarziKodu = result != null
              ? result
              : _binaKullanimSekli.binaKullanimTarziKodu;
        });
        break;
      case 9:
        List<String> list = List<String>();
        List itemList = WebAPI.ilList;
        //List itemList = await Utils.getIL();
        itemList.forEach((temp) {
          list.add(temp.ilAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "İl", itemList: list));
        setState(() {
          _il = result != null ? itemList[result] : _il;
        });
        break;
      case 10:
        List<String> list = List<String>();
        List itemList =
            WebAPI.ilceList.where((x) => x.ilKodu == _il.ilKodu).toList();
        //List itemList = await Utils.getILCE(_il);
        itemList.forEach((temp) {
          list.add(temp.ilceAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "İlçe", itemList: list));
        setState(() {
          _ilce = result != null ? itemList[result] : _ilce;
        });
        break;
      case 11:
        /* List<String> itemList = [
          "SCHENGEN",
          "DİĞER AVRUPA",
          "DÜNYA",
          "TÜRKİYE"
        ]; */
        List<String> list = List<String>();
        List itemList = WebAPI.ulkeTipiList;
        itemList.forEach((temp) {
          list.add(temp.ulkeTipiAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) => ListViewDrawer(
                title: "Seyahat Edilicek Ülke Türü", itemList: list));
        setState(() {
          _ulkeTuru = result != null ? itemList[result] : _ulkeTuru;
        });
        break;
      case 12:
        List<String> list = List<String>();
        List itemList = WebAPI.ulkeList
            .where((x) => x.ulkeTipiKodu == _ulkeTuru.ulkeTipiKodu)
            .toList();
//        List itemList = await Utils.getUlke(_ulkeTuru);
        itemList.forEach((temp) {
          list.add(temp.ulkeAdi);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Seyahat Edilicek Ülke", itemList: list));
        setState(() {
          _gidilenUlke = result != null ? itemList[result] : _gidilenUlke;
        });
        break;
      default:
        return null;
    }
  }

  void _reportDamage() async {
    FormState _form; 

    var metin =  
        (_checkimagesList.firstWhere((x) => x == "6", orElse: () => null) ==
                null
            ? "Hasar Fotoğrafını Ekleyiniz\n"
            : "");

    if (_sigortaTuru.bransKodu == 1 || _sigortaTuru.bransKodu == 2) {
      _form = _aracFormKey.currentState;
      metin =
          (_checkimagesList.firstWhere((x) => x == "0", orElse: () => null) ==
                  null
              ? "Kendi Araç Ruhsat Fotoğrafını Ekleyiniz\n"
              : "");
      metin +=
          (_checkimagesList.firstWhere((x) => x == "1", orElse: () => null) ==
                  null
              ? "Kendi Ehliyet Fotoğrafını Ekleyiniz\n"
              : "");
      metin +=
          (_checkimagesList.firstWhere((x) => x == "2", orElse: () => null) ==
                  null
              ? "Karşı Araç Ruhsat Fotoğrafını Ekleyiniz\n"
              : "");
      metin +=
          (_checkimagesList.firstWhere((x) => x == "3", orElse: () => null) ==
                  null
              ? "Karşı Sürücü Ehliyet Fotoğrafını Ekleyiniz\n"
              : "");
      metin +=
          (_checkimagesList.firstWhere((x) => x == "4", orElse: () => null) ==
                  null
              ? "Kaza Tespit Fotoğrafını Ekleyiniz\n"
              : "");
    } else if (_sigortaTuru.bransKodu == 21) {
      _form = _seyahatFormKey.currentState;
      
    } else if (_sigortaTuru.bransKodu == 11) {
      _form = _daskFormKey.currentState;
     
    } else if (_sigortaTuru.bransKodu == 4) {
      _form = _saglikFormKey.currentState;
     
    } else if (_sigortaTuru.bransKodu == 22) {
      _form = _konutFormKey.currentState;
    
    } else {
      _form = _digerFormKey.currentState;
    }
    _form.save();

    var dropValidate = false;

    switch (_sigortaTuru.bransKodu) {
      case 1:
      case 2:
        if (_sigortaSirketi.sirketAdi != "Bulunamadı" &&
            _sigortaTuru.bransAdi != "Bulunamadı" &&
            _marka.markaAdi != "Bulunamadı" &&
            _aracTipi.tipAdi != "Bulunamadı" &&
            _kullanimTarzi.kullanimTarzi != "Bulunamadı") dropValidate = true;
        break;
      case 4:
        if (_sigortaSirketi.sirketAdi != "Bulunamadı" &&
            _sigortaTuru.bransAdi != "Bulunamadı" &&
            _meslek.meslekAdi != "Bulunamadı") dropValidate = true;
        break;
      case 11:
        if (_sigortaSirketi.sirketAdi != "Bulunamadı" &&
            _sigortaTuru.bransAdi != "Bulunamadı" &&
            _ilce.ilceAdi != "Bulunamadı" &&
            _il.ilAdi != "Bulunamadı" &&
            _yapiTarzi.yapiTarziAdi != "Bulunamadı" &&
            _yapimYili.yapimYiliAdi != "Bulunamadı" &&
            _binaKullanimSekli.binaKullanimTarziAdi != "Bulunamadı")
          dropValidate = true;
        break;
      case 21:
        if (widget.policyResponse.sirketKodu != "Bulunamadı" &&
            _sigortaTuru.bransAdi != "Bulunamadı" &&
            _gidilenUlke.ulkeAdi != "Bulunamadı") dropValidate = true;
        break;
      case 22:
        if (_sigortaSirketi.sirketAdi != "Bulunamadı" &&
            _sigortaTuru.bransAdi != "Bulunamadı" &&
            _ilce.ilceAdi != "Bulunamadı" &&
            _il.ilAdi != "Bulunamadı") dropValidate = true;
        break;
      default:
        if (_sigortaSirketi.sirketAdi != "Bulunamadı" &&
            _sigortaTuru.bransAdi != "Bulunamadı" &&
            _ilce.ilceAdi != "Bulunamadı" &&
            _il.ilAdi != "Bulunamadı") dropValidate = true;
        break;
    }

    if (_form.validate()) {
      if (dropValidate) {
        print(1);
        if (metin.trim().length > 0) {
          UtilsPolicy.showSnackBar(_scaffoldKey, metin);
          return;
        }
        /* 
        if (!checkfile) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Lütfen Resimleri Seçiniz"),
            duration: Duration(seconds: 3),
          ));
          return;
        } */

        widget.policyResponse.kullaniciGonderiTuru = 0;
        if (widget.policyResponse.acenteUnvani == null) {
          //burası ==null olacak
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              imageUrl: "assets/images/ic_tick.png",
              body: _sigortaSirketi.sirketAdi,
              buttonText: _sigortaSirketi.email,
              button2Text: _sigortaSirketi.telefon,
              dialogKind: "DamageReport",
            ),
          );

          if (result == null) {
            return;
          } else if (result == 2) {
            Utils.launchURL("tel:${_sigortaSirketi.telefon}");
            return;
          } else
            widget.policyResponse.kullaniciGonderiTuru = result;
        }

        var sesDosyaList = [];
        if (_recordFile.isNotEmpty) {
          _recordFile = _recordFile.replaceAll("data:audio/mp3;base64,", "");
          sesDosyaList = [_recordFile];
        }

        _onLoading();
        if (_binaBedeli != null) {
          _binaBedeli = _binaBedeli.replaceAll('TL', '');
          _binaBedeli = _binaBedeli.replaceAll(',', '');
        }
        if (_esyaBedeli != null) {
          _esyaBedeli = _esyaBedeli.replaceAll('TL', '');
          _esyaBedeli = _esyaBedeli.replaceAll(',', '');
        }

        WebAPI.reportDamage(
                token: _kullaniciInfo[3],
                tckn: _kullaniciInfo[2],
                branskodu: policyResponseRenew.bransKodu,
                aciklama: policyResponseRenew.aciklama,
                sigortasirket: _sigortaSirketi.sirketKodu,
                policeNumarasi: widget.policyResponse.policeNumarasi,
                acentekodu: widget.policyResponse.acenteUnvani,
                kullaniciGonderiTuru:
                    widget.policyResponse.kullaniciGonderiTuru,
                latitude: _location != null
                    ? _location.length > 0
                        ? _location[0]
                        : ""
                    : "",
                longitude: _location != null
                    ? _location.length > 1
                        ? _location[1]
                        : ""
                    : "",
                basTarih: policyResponseRenew.baslangicTarihi,
                bitTarih: policyResponseRenew.bitisTarihi,
                resimDosyaList: _selectedImages,
                sesDosyaList: sesDosyaList,
                plakano: policyResponseRenew.plaka,
                ruhsatkodu: policyResponseRenew.ruhsatSeriKodu,
                ruhsatno: policyResponseRenew.ruhsatSeriNo,
                asbisno: policyResponseRenew.asbisNo,
                modelyili: policyResponseRenew.modelYili,
                markaid: _marka.markaKodu,
                modelid: _aracTipi.tipKodu,
                kullanimtarzi: _kullanimTarzi.kullanimTarziKodu != null ||
                        _kullanimTarzi.kod2 != null
                    ? _kullanimTarzi.kullanimTarziKodu +
                        "+" +
                        _kullanimTarzi.kod2
                    : null,
                meslek: _meslek.meslekKodu,
                binakatsayisi: policyResponseRenew.binaKatSayisi,
                binakullanimsekli: _binaKullanimSekli.binaKullanimTarziKodu,
                binayapimtarzi: _yapiTarzi.yapiTarziKodu,
                binayapimyili: _yapimYili.yapimYiliKodu,
                dairembrut: policyResponseRenew.daireBrut,
                binaBedeli: _binaBedeli != null
                    ? double.parse(_binaBedeli)
                    : _binaBedeli,
                esyaBedeli: _esyaBedeli != null
                    ? double.parse(_esyaBedeli)
                    : _esyaBedeli,
                il: _il.ilKodu,
                ilce: _ilce.ilceKodu,
                adres: policyResponseRenew.adres,
                seyahatGidisTarihi: policyResponseRenew.seyahatGidisTarihi,
                seyahatDonusTarihi: policyResponseRenew.seyahatDonusTarihi,
                seyahatEdenKisiSayisi:
                    policyResponseRenew.seyahatEdenKisiSayisi,
                seyahatUlkeKodu: _gidilenUlke.ulkeKodu)
            .then((result) {
          closeLoader();
          alertBox(result);
        });
        /* switch (_sigortaTuru.bransKodu) {
          case 1:
          case 2:
            WebAPI.reportDamage(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: widget.policyResponse.bransKodu,
              aciklama: widget.policyResponse.aciklama,
              sigortasirket: widget.policyResponse.sirketKodu,
              policeNumarasi: widget.policyResponse.policeNumarasi,
              latitude: _location != null
                  ? _location.length > 0
                      ? _location[0]
                      : ""
                  : "",
              longitude: _location != null
                  ? _location.length > 1
                      ? _location[1]
                      : ""
                  : "",
              basTarih: widget.policyResponse.baslangicTarihi,
              bitTarih: widget.policyResponse.bitisTarihi,
              plakano: widget.policyResponse.plaka,
              ruhsatkodu: widget.policyResponse.ruhsatSeriKodu,
              ruhsatno: widget.policyResponse.ruhsatSeriNo,
              asbisno: widget.policyResponse.asbisNo,
              modelyili: widget.policyResponse.modelYili,
              markaid: _marka.markaKodu,
              modelid: _aracTipi.tipKodu,
              kullanimtarzi:
                  _kullanimTarzi.kullanimTarziKodu + "+" + _kullanimTarzi.kod2,
              resimDosyaList: _selectedImages,
              sesDosyaList: sesDosyaList,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;

          case 4: //saglik
            WebAPI.reportDamage(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: widget.policyResponse.bransKodu,
              aciklama: widget.policyResponse.aciklama,
              sigortasirket: widget.policyResponse.sirketKodu,
              policeNumarasi: widget.policyResponse.policeNumarasi,
              latitude: _location != null
                  ? _location.length > 0
                      ? _location[0]
                      : ""
                  : "",
              longitude: _location != null
                  ? _location.length > 1
                      ? _location[1]
                      : ""
                  : "",
              basTarih: widget.policyResponse.baslangicTarihi,
              bitTarih: widget.policyResponse.bitisTarihi,
              meslek: _meslek.meslekKodu,
              resimDosyaList: _selectedImages,
              sesDosyaList: sesDosyaList,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          case 11: //dask
            WebAPI.reportDamage(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: widget.policyResponse.bransKodu,
              aciklama: widget.policyResponse.aciklama,
              sigortasirket: widget.policyResponse.sirketKodu,
              policeNumarasi: widget.policyResponse.policeNumarasi,
              latitude: _location != null
                  ? _location.length > 0
                      ? _location[0]
                      : ""
                  : "",
              longitude: _location != null
                  ? _location.length > 1
                      ? _location[1]
                      : ""
                  : "",
              basTarih: widget.policyResponse.baslangicTarihi,
              bitTarih: widget.policyResponse.bitisTarihi,
              binakatsayisi: widget.policyResponse.binaKatSayisi,
              binakullanimsekli: widget.policyResponse.binaKullanimSekli,
              binayapimtarzi: widget.policyResponse.binaYapiTarzi,
              binayapimyili: widget.policyResponse.binaYapimYili,
              dairembrut: widget.policyResponse.daireBrut,
              il: _il.ilKodu,
              ilce: _ilce.ilceKodu,
              adres: widget.policyResponse.adres,
              resimDosyaList: _selectedImages,
              sesDosyaList: sesDosyaList,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          case 21: //seyehat
            WebAPI.reportDamage(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: widget.policyResponse.bransKodu,
              aciklama: widget.policyResponse.aciklama,
              sigortasirket: widget.policyResponse.sirketKodu,
              policeNumarasi: widget.policyResponse.policeNumarasi,
              latitude: _location != null
                  ? _location.length > 0
                      ? _location[0]
                      : ""
                  : "",
              longitude: _location != null
                  ? _location.length > 1
                      ? _location[1]
                      : ""
                  : "",
              seyahatGidisTarihi: widget.policyResponse.seyahatGidisTarihi,
              seyahatDonusTarihi: widget.policyResponse.seyahatDonusTarihi,
              seyahatEdenKisiSayisi:
                  widget.policyResponse.seyahatEdenKisiSayisi,
              seyahatUlkeKodu: widget.policyResponse.seyahatUlkeKodu,
              resimDosyaList: _selectedImages,
              sesDosyaList: sesDosyaList,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          case 22: //konut
            WebAPI.reportDamage(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: widget.policyResponse.bransKodu,
              aciklama: widget.policyResponse.aciklama,
              sigortasirket: widget.policyResponse.sirketKodu,
              policeNumarasi: widget.policyResponse.policeNumarasi,
              latitude: _location != null
                  ? _location.length > 0
                      ? _location[0]
                      : ""
                  : "",
              longitude: _location != null
                  ? _location.length > 1
                      ? _location[1]
                      : ""
                  : "",
              basTarih: widget.policyResponse.baslangicTarihi,
              bitTarih: widget.policyResponse.bitisTarihi,
              binaBedeli: widget.policyResponse.binaBedeli,
              esyaBedeli: widget.policyResponse.esyaBedeli,
              adres: widget.policyResponse.adres,
              il: widget.policyResponse.ilKodu,
              ilce: widget.policyResponse.ilceKodu,
              resimDosyaList: _selectedImages,
              sesDosyaList: sesDosyaList,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          default: //diğer
            WebAPI.reportDamage(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: widget.policyResponse.bransKodu,
              aciklama: widget.policyResponse.aciklama,
              sigortasirket: widget.policyResponse.sirketKodu,
              policeNumarasi: widget.policyResponse.policeNumarasi,
              latitude: _location != null
                  ? _location.length > 0
                      ? _location[0]
                      : ""
                  : "",
              longitude: _location != null
                  ? _location.length > 1
                      ? _location[1]
                      : ""
                  : "",
              basTarih: widget.policyResponse.baslangicTarihi,
              bitTarih: widget.policyResponse.bitisTarihi,
              adres: widget.policyResponse.adres,
              il: widget.policyResponse.ilKodu,
              ilce: widget.policyResponse.ilceKodu,
              resimDosyaList: _selectedImages,
              sesDosyaList: sesDosyaList,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
        } */
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Seçilmemiş alanları seçiniz"),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  void alertBox(String mesaj) {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        imageUrl: "assets/images/ic_tick.png",
        body: mesaj,
        buttonText: "TAMAM",
        dialogKind: "AlertDialogInfo",
      ),
    );
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
    /*  new Future.delayed(new Duration(seconds: 3), () {
    Navigator.pop(context); //pop dialog 
  }); */
  }

  void closeLoader() {
    Navigator.pop(context);
  }

  Future<Null> sendreportDamge() async {}

  Future<void> pdfCreate() async {
    final pdf = PDF.Document();
    //final File pdfFile= File("${_sigortaSirketi.sirketKodu}-${widget.policyResponse.policeNumarasi}-${widget.policyResponse.yenilemeNo} Hasar PolicyResponsei.pdf");

    final ByteData fontData = await rootBundle.load("assets/fonts/micross.ttf");
    final PDF.Font ttf = PDF.Font.ttf(fontData);
    final ByteData logoData = await rootBundle.load("assets/images/logo-3.png");
    ResizedImage.Image logo =
        ResizedImage.decodeImage(logoData.buffer.asUint8List());

    String imageUrl;
    if (_sigortaSirketi.sirketLogo != null && _sigortaSirketi.sirketLogo != "")
      imageUrl = _sigortaSirketi.sirketLogo;
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
                      text:
                          "${_sigortaTuru.bransAdi} SİGORTASI HASAR BİLDİRİMİ",
                      style: PDF.TextStyle(fontSize: 18)),
                  PDF.Paragraph(
                      text:
                          "   Sayın ${_kullaniciInfo[0]} ${_kullaniciInfo[1]}, sigortadefterim.com kullanıcısı tarafından aşağıda detayları bulunan Hasar Bildirimini acilen değerlendirerek, gerekli işlemlerin başlatılması hususunu önemle bilgilerinize sunarız.\n\nSaygılarımızla\n\n",
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
                                      "${_sigortaSirketi.sirketAdi}",
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
                          children: _getUrunPDF())),
                ]))
          ];
        }));

    //pdfFile.writeAsBytesSync(pdf.save());
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  List<PDF.TableRow> _getUrunPDF() {
    switch (_sigortaTuru.bransKodu) {
      case 1:
        return [
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Sigorta Şirketi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${widget.policyResponse.kimlikNo}"))
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
                child: PDF.Text("${_marka.markaAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Tescil Belge No(Ruhsat No)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.ruhsatSeriKodu}-${widget.policyResponse.ruhsatSeriNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.asbisNo}"))
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
                child: PDF.Text("${widget.policyResponse.modelYili}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
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
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${widget.policyResponse.kimlikNo}"))
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
                child: PDF.Text("${_marka.markaAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Tescil Belge No(Ruhsat No)")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.ruhsatSeriKodu}-${widget.policyResponse.ruhsatSeriNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.asbisNo}"))
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
                child: PDF.Text("${widget.policyResponse.modelYili}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
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
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${_kullaniciInfo[2]}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
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
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${_kullaniciInfo[2]}"))
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
                child: PDF.Text("${widget.policyResponse.binaKatSayisi}"))
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
                child: PDF.Text("${widget.policyResponse.daireBrut}"))
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
                child: PDF.Text("${widget.policyResponse.adres}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
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
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${_kullaniciInfo[2]}"))
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
                child: PDF.Text("${_gidilenUlke.ulkeAdi}}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Eden Kişi Sayısı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.seyahatEdenKisiSayisi != null ? widget.policyResponse.seyahatEdenKisiSayisi : ""}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
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
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${_kullaniciInfo[2]}"))
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
                child: PDF.Text("${widget.policyResponse.esyaBedeli}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Bina Bedeli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.binaBedeli}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.adres}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
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
                child: PDF.Text("${_sigortaSirketi.sirketAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Poliçe No/Yenileme No")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(
                    "${widget.policyResponse.policeNumarasi}/${widget.policyResponse.yenilemeNo}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Başlangıç Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.baslangicTarihi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bitiş Tarihi")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("${widget.policyResponse.bitisTarihi}"))
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
                child: PDF.Text("${_kullaniciInfo[2]}"))
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
                child: PDF.Text("${widget.policyResponse.adres}"))
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
                child: PDF.Text(widget.policyResponse.aciklama == null
                    ? ""
                    : "${widget.policyResponse.aciklama}"))
          ]),
        ];
    }
  }

  void _focusNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future getPolicyInformation() async {
    await UtilsPolicy.getPolicyInformationWithCode(widget.policyResponse)
        .whenComplete(() {
      setState(() {
        _marka = UtilsPolicy.marka;
        _aracTipi = UtilsPolicy.aracTipi;
        _aracTipiSelect = _aracTipi.tipAdi == "Bulunamadı" ? true : false;
        _kullanimTarzi = UtilsPolicy.kullanimTarzi;
        _sigortaSirketi = UtilsPolicy.sigortaSirketiforPDF;
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
    });
  }

  String base64String(Uint32List data) {
    return base64Encode(data);
  }
}
