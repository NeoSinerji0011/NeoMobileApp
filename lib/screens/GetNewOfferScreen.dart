import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'package:image/image.dart' as ResizedImage;
import 'package:printing/printing.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/widgets/ButtonContainer.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/widgets/MyRadioButton.dart';
import 'package:sigortadefterim/widgets/TopInformationContainer.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/models/BinaKullanimSekli.dart';
import 'package:sigortadefterim/models/YapiTarzi.dart';
import 'package:sigortadefterim/models/YapimYili.dart';
import 'package:sigortadefterim/models/TVMDetay.dart';
import 'package:sigortadefterim/models/Policy/PolicyResponse.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';

class GetNewOfferScreen extends StatefulWidget {
  PolicyResponse policyResponse = null;

  GetNewOfferScreen();
  GetNewOfferScreen.havePolicy(PolicyResponse pol) {
    this.policyResponse = pol;
  }

  @override
  _GetNewOfferScreenState createState() => _GetNewOfferScreenState();
}

class _GetNewOfferScreenState extends State<GetNewOfferScreen> {
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

  String _ilKodu;
  String _plakaNo;
  String _ruhsatSeriNo;
  String _ruhsatSeriKodu;
  String _asbisNo;
  String _baslangicTarihi;
  String _bitisTarihi;
  int _modelYili;
  String _aciklama;
  int _acenteSecimi = 0;

  TextEditingController _binabedelController = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: ',', rightSymbol: 'TL');
  TextEditingController _esyabedelController = MoneyMaskedTextController(
      thousandSeparator: '.', decimalSeparator: ',', rightSymbol: 'TL');
  SigortaTuru _sigortaTuru = SigortaTuru(bransAdi: "Sigorta Türü");
  TVMDetay _tvmDetay = TVMDetay(unvani: "Acente");
  AracMarka _marka = AracMarka(markaAdi: "Marka");
  AracMarka _markaTemp = AracMarka(markaAdi: "Marka");
  List _aracTipListTemp;
  AracTip _aracTipi = AracTip(tipAdi: "Araç Tipi");
  AracKullanimTarzi _kullanimTarzi =
      AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");
  SigortaSirketi _sigortaSirketi = SigortaSirketi(sirketAdi: "Sigorta Şirketi");

  int _kisiSayisi;
  //String _ulkeTuru = "Seyahat Edilicek Ülke Türü";
  UlkeTipi _ulkeTuru = UlkeTipi(ulkeTipiAdi: "Seyahat Edilicek Ülke Türü");

  Ulke _gidilenUlke = Ulke(ulkeAdi: "Seyahat Edilicek Ülke");

  BinaKullanimSekli _binaKullanimSekli =
      BinaKullanimSekli(binaKullanimTarziAdi: "Bina Kullanım Şekli");
  YapiTarzi _yapiTarzi = YapiTarzi(yapiTarziAdi: "Yapı Tarzı");
  YapimYili _yapimYili = YapimYili(yapimYiliAdi: "Yapım Yılı");
  int _yapiTarziIndis = -1;
  int _yapimYiliIndis = -1;
  int _binaKullanimSekliIndis = -1;
  int _binaKatSayisi;
  int _daireMetre;
  String _adres;
  IL _il = IL(ilAdi: "İl");
  ILCE _ilce = ILCE(ilceAdi: "İlçe");

  Meslek _meslek = Meslek(meslekAdi: "Meslek");

  String _binaBedeli;
  String _esyaBedeli;

  DateTime _startingDate = DateTime.now();
  DateTime _endingDate = DateTime.now();

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

  List<String> _kullaniciInfo = List<String>();
  PolicyResponse policyResponseRenew = PolicyResponse();

  @override
  void initState() {
    super.initState();
    _kullaniciInfo.addAll(["", "", "11111111111", "", ""]);

    setState(() {
      _kullaniciInfo = UtilsPolicy.kullaniciInfo;
      _sigortaTuru = SigortaTuru(bransAdi: "Trafik", bransKodu: 1);
    });

    _startingDateController.addListener(() {
      if (_sigortaTuru.bransKodu != 21) {
        setState(() {
          _endingDate = DateTime(
              _startingDate.year + 1, _startingDate.month, _startingDate.day);
        });
      }
    });

    if (widget.policyResponse != null) {
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
      if (widget.policyResponse.sirketKodu == null)
        _sigortaSirketiSelect = true;
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
      getPolicyInformation().whenComplete(() {});

      policyResponseRenew.baslangicTarihi =
          widget.policyResponse.baslangicTarihi;
      policyResponseRenew.bitisTarihi = widget.policyResponse.bitisTarihi;
      policyResponseRenew.bransKodu = widget.policyResponse.bransKodu;
      _binabedelController.text = widget.policyResponse.binaBedeli.toString();
      _esyabedelController.text = widget.policyResponse.esyaBedeli.toString();
    } else
      Future.delayed(Duration.zero, () {
        _openListViewDialog(0);
      });
  }

  @override
  void dispose() {
    _startingDateController.dispose();
    _endingDateController.dispose();
    super.dispose();
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
        _sigortaSirketiSelect =
            _sigortaSirketi.sirketAdi == "Bulunamadı" ? true : false;
        //_kullaniciInfo = UtilsPolicy.kullaniciInfo;
        _sigortaTuru = UtilsPolicy.sigortaTuru;
        _yapiTarzi = UtilsPolicy.yapiTarzi;
        _yapimYili = UtilsPolicy.yapimYili;
        _binaKullanimSekli = UtilsPolicy.binaKullanimSekli;
        _il = UtilsPolicy.il;
        _ilce = UtilsPolicy.ilce;
        _meslek = UtilsPolicy.meslek;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (false) {
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
    } else {
      _startingDateController.text =
          DateFormat("dd/MM/yyyy").format(_startingDate);
      _endingDateController.text = DateFormat("dd/MM/yyyy").format(_endingDate);
      _baslangicTarihi =
          DateFormat("yyyy-MM-ddTHH:mm:ss").format(_startingDate);
      _bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss").format(_endingDate);
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorData.renkSolukBeyaz,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Yeni Teklif Al",
                          style: TextStyleData.standartLacivert24,
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TopInformationContainer(
                  adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1],
                  imageUrl: _kullaniciInfo[4],
                  riskOrani: "85",
                  //title: "Yeni\nTeklif Al",
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        _kullaniciInfo[2].substring(0, 2) +
                            "******" +
                            _kullaniciInfo[2].substring(8),
                        style: TextStyleData.boldSiyah),
                    Text(
                        "Teklif Talep No: ${widget.policyResponse != null ? widget.policyResponse.teklifIslemNo != null ? widget.policyResponse.teklifIslemNo : "Bulunamadı" : "Bulunamadı"}",
                        style: TextStyleData.boldSiyah),
                  ],
                ),
              ),
              /*  
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: InkWell(
                  child: ButtonContainer(
                      title: _tvmDetay.unvani,
                      isFilled: _tvmDetay.unvani != "Acente"),
                  onTap: () {
                    _openListViewDialog(12);
                  },
                ),
              ), */
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: InkWell(
                  child: ButtonContainer(
                      title: _sigortaTuru.bransAdi,
                      isFilled: _sigortaTuru.bransAdi != "Sigorta Türü"),
                  onTap: () {
                    _openListViewDialog(0);
                  },
                ),
              ),
              _getUrunForm(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32, top: 16),
                child: Container(
                  decoration:
                      BoxDecoration(boxShadow: [BoxDecorationData.shadow]),
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: RaisedButton(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("TEKLİF TALEBİ GÖNDER",
                            style: TextStyleData.extraBoldLacivert16),
                      ),
                      color: ColorData.renkYesil,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _getNewOffer();
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context, bool isStartDate) async {
    var start, end;

    start = _startingDate;
    end = _endingDate;

    final DateTime value = await showDatePicker(
        context: context,
        locale: const Locale("tr", "TR"),
        initialDate: isStartDate ? start : end,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (isStartDate) {
      if (value != null && value != _startingDate)
        setState(() {
          _startingDateController.text = value.toString();
          _startingDate = value;
          _baslangicTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss").format(value);
          _bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss")
              .format(DateTime(value.year + 1, value.month, value.day));
        });
    } else {
      if (value != null && value != _endingDate)
        setState(() {
          _endingDateController.text = value.toString();
          _endingDate = value;
          _bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss").format(value);
        });
    }
  }

  void formReset() {
    //_sigortaTuru = SigortaTuru(bransAdi: "Sigorta Türü");
    _marka = AracMarka(markaAdi: "Marka");
    _aracTipi = AracTip(tipAdi: "Araç Tipi");
    _kullanimTarzi = AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");
    _ulkeTuru.ulkeTipiAdi = "Seyahat Edilicek Ülke Türü";
    _gidilenUlke = Ulke(ulkeAdi: "Seyahat Edilicek Ülke");

    _binaKullanimSekli =
        BinaKullanimSekli(binaKullanimTarziAdi: "Bina Kullanım Şekli");
    _yapiTarzi = YapiTarzi(yapiTarziAdi: "Yapı Tarzı");
    _yapimYili = YapimYili(yapimYiliAdi: "Yapım Yılı");

    _binaKatSayisi = null;
    _il = IL(ilAdi: "İl");
    _ilce = ILCE(ilceAdi: "İlçe");
    _meslek = Meslek(meslekAdi: "Meslek");

    _daireMetre = null;
    _adres = null;
    _binaBedeli = null;
    _esyaBedeli = null;
    _kisiSayisi = null;
    _ilKodu = null;
    _plakaNo = null;
    _ruhsatSeriNo = null;
    _ruhsatSeriKodu = null;
    _asbisNo = null;
    _baslangicTarihi = null;
    _bitisTarihi = null;
    _modelYili = null;
    _aciklama = null;
  }

  void _openListViewDialog(int index) async {
    switch (index) {
      case 0:
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
        formReset();
        setState(() {
          _sigortaTuru = result != null ? itemList[result] : _sigortaTuru;
          _baslangicTarihi =
              DateFormat("yyyy-MM-ddTHH:mm:ss").format(_startingDate);
          if (_sigortaTuru.bransKodu == 21) {
            //seyahat sağlık default 1 aylık geliyor
            _endingDate = DateTime(
                _startingDate.year, _startingDate.month + 1, _startingDate.day);
            _bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
                _endingDate.year, _endingDate.month + 1, _endingDate.day));
          } else {
            _endingDate = DateTime(
                _startingDate.year + 1, _startingDate.month, _startingDate.day);
            _bitisTarihi =
                DateFormat("yyyy-MM-ddTHH:mm:ss").format(_endingDate);
          }
        });

        break;
      case 1:
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
        });
        break;
      case 2:
        List<String> list = List<String>();
        List itemList;
        if (_markaTemp == _marka) {
          itemList = _aracTipListTemp;
        } else {
          itemList = await WebAPI.getAracTipRequest(
              token: _kullaniciInfo[3], markakodu: _marka.markaKodu);
          _aracTipListTemp = itemList;
          _markaTemp = _marka;
        }
        //List itemList = await Utils.getAracTip(_marka);
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
      case 3:
        List<String> list = List<String>();
        List itemList = WebAPI.aracKullanimTarziList;
        //List itemList = await Utils.getAracKullanimTarzi();
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
      case 4:
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
      case 5:
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
          //_yapiTarziIndis = result != null ? result : _yapiTarziIndis;
        });
        break;
      case 6:
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
          //_yapimYiliIndis = result != null ? result : _yapimYiliIndis;
        });
        break;
      case 7:
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
          /* _binaKullanimSekliIndis =
              result != null ? result : _binaKullanimSekliIndis; */
        });
        break;
      case 8:
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
      case 9:
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
      case 10:
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
      case 11:
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
      case 12:
        List<String> list = List<String>();
        List itemList = WebAPI.acenteList;

        itemList.forEach((temp) {
          list.add(temp.unvani);
        });
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Acente", itemList: list));
        setState(() {
          _tvmDetay = result != null ? itemList[result] : _tvmDetay;
        });
        break;
      default:
        return null;
    }
  }

  void _getNewOffer() {
    FormState _form;

    if (_sigortaTuru.bransKodu == 1 || _sigortaTuru.bransKodu == 2)
      _form = _aracFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 21)
      _form = _seyahatFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 11)
      _form = _daskFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 4)
      _form = _saglikFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 22)
      _form = _konutFormKey.currentState;
    else
      _form = _digerFormKey.currentState;

    var dropValidate = false;

    switch (_sigortaTuru.bransKodu) {
      case 1:
      case 2:
        if (_sigortaTuru.bransAdi != "Sigorta Türü" &&
            
            _marka.markaAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "Marka") &&
            _aracTipi.tipAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "Araç Tipi") &&
            _kullanimTarzi.kullanimTarzi !=
                (widget.policyResponse != null
                    ? "Bulunamadı"
                    : "Kullanım Tarzı")) dropValidate = true;
        break;
      case 4:
        if (_sigortaTuru.bransAdi != "Sigorta Türü" &&
            
            _meslek.meslekAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "Meslek"))
          dropValidate = true;
        break;
      case 11:
        if (_sigortaTuru.bransAdi != "Sigorta Türü" &&
            
            _ilce.ilceAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "İlçe") &&
            _il.ilAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "İl") &&
            _yapiTarzi.yapiTarziAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "Yapı Tarzı") &&
            _yapimYili.yapimYiliAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "Yapım Yılı") &&
            _binaKullanimSekli.binaKullanimTarziAdi !=
                (widget.policyResponse != null
                    ? "Bulunamadı"
                    : "Bina Kullanım Şekli")) dropValidate = true;
        break;
      case 21:
        if (_sigortaTuru.bransAdi != "Sigorta Türü" &&
            
            _gidilenUlke.ulkeAdi !=
                (widget.policyResponse != null
                    ? "Bulunamadı"
                    : "Seyahat Edilicek Ülke")) dropValidate = true;

        break;
      case 22:
        if (_sigortaTuru.bransAdi != "Sigorta Türü" &&
            
            _ilce.ilceAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "İlçe") &&
            _il.ilAdi != (widget.policyResponse != null ? "Bulunamadı" : "İl"))
          dropValidate = true;
        break;
      default:
        if (_sigortaTuru.bransAdi != "Sigorta Türü" &&
            
            _ilce.ilceAdi !=
                (widget.policyResponse != null ? "Bulunamadı" : "İlçe") &&
            _il.ilAdi != (widget.policyResponse != null ? "Bulunamadı" : "İl"))
          dropValidate = true;
        break;
    }
    
    _form.save();

    if (_form.validate()) {
      if (dropValidate) {
        _onLoading();
        if (_binaBedeli != null) {
          _binaBedeli = _binaBedeli.replaceAll('TL', '');
          _binaBedeli = _binaBedeli.replaceAll(',', '');
        }
        if (_esyaBedeli != null) {
          _esyaBedeli = _esyaBedeli.replaceAll('TL', '');
          _esyaBedeli = _esyaBedeli.replaceAll(',', '');
        }
        WebAPI.addGetNewOffer(
          token: _kullaniciInfo[3],
          tckn: _kullaniciInfo[2],
          kullaniciId: _kullaniciInfo[7],
          branskodu: _sigortaTuru.bransKodu,
          acentekodu: _acenteSecimi == 0 ? _tvmDetay.kodu : null,
          aciklama: _aciklama,
          basTarih: _baslangicTarihi,
          bitTarih: _bitisTarihi,
          emailType: _acenteSecimi,
          plakano: _ilKodu != null ? _ilKodu + _plakaNo : "",
          ruhsatkodu: _ruhsatSeriKodu,
          ruhsatno: _ruhsatSeriNo,
          asbisno: _asbisNo,
          modelyili: _modelYili,
          markaid: _marka.markaKodu,
          modelid: _aracTipi.tipKodu,
          kullanimtarzi: _kullanimTarzi.kullanimTarziKodu != null ||
                  _kullanimTarzi.kod2 != null
              ? _kullanimTarzi.kullanimTarziKodu + "+" + _kullanimTarzi.kod2
              : null,
          meslek: _meslek.meslekKodu.toString(),
          binakatsayisi: _binaKatSayisi,
          binakullanimsekli: _binaKullanimSekli.binaKullanimTarziKodu,
          binayapimtarzi: _yapiTarzi.yapiTarziKodu,
          binayapimyili: _yapimYili.yapimYiliKodu,
          binaBedeli:
              _binaBedeli != null ? double.parse(_binaBedeli) : _binaBedeli,
          esyaBedeli:
              _esyaBedeli != null ? double.parse(_esyaBedeli) : _esyaBedeli,
          il: _il.ilKodu,
          ilce: _ilce.ilceKodu,
          adres: _adres,
          dairembrut: _daireMetre,
          seyahatGidisTarihi: _baslangicTarihi,
          seyahatDonusTarihi: _bitisTarihi,
          seyahatEdenKisiSayisi: _kisiSayisi,
          seyahatUlkeKodu: _gidilenUlke.ulkeKodu,
        ).then((result) {
          closeLoader();
          alertBox(result);
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Seçilmemiş alanları seçiniz"),
          duration: Duration(seconds: 3),
        ));
      }
    }
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

  void alertBox(result) {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        imageUrl: result["status"]
            ? "assets/images/ic_tick.png"
            : "assets/images/error.png",
        body: result["message"],
        buttonText: "TAMAM",
        dialogKind: "AlertDialogInfo",
      ),
    );
  }

  Future<void> pdfCreate() async {
    final pdf = PDF.Document();
    //final File pdfFile= File("${_sigortaSirketi.sirketKodu}-${widget.policyResponse.policeNumarasi}-${widget.policyResponse.yenilemeNo} Hasar Bildirimi.pdf");

    final ByteData fontData = await rootBundle.load("assets/fonts/micross.ttf");
    final PDF.Font ttf = PDF.Font.ttf(fontData);

    final ByteData logoData = await rootBundle.load("assets/images/logo-3.png");
    ResizedImage.Image logo =
        ResizedImage.decodeImage(logoData.buffer.asUint8List());

    pdf.addPage(PDF.MultiPage(
        pageFormat: PdfPageFormat.a4,
        /*   theme: PDF.Theme(
            defaultTextStyle: PDF.TextStyle(font: ttf),
            paragraphStyle: PDF.TextStyle(font: ttf),
            tableCell: PDF.TextStyle(font: ttf),
            tableHeader: PDF.TextStyle(font: ttf)), */
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
                      text: "${_sigortaTuru.bransAdi} SİGORTASI TEKLİF TALEBİ",
                      style: PDF.TextStyle(fontSize: 18)),
                  PDF.Paragraph(
                      text:
                          "   Sayın ${_kullaniciInfo[0]} ${_kullaniciInfo[1]}, sigortadefterim.com kullanıcısı tarafından aşağıda detayları bulunan Teklif Talebini acilen değerlendirerek, kullanıcı e-posta adresine farklı sigorta şirketlerinden alınmış tekliflerinizi göndermenizi önemle bilgilerinize sunarız.\n\nSaygılarımızla\n\n",
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
                          children: [
                            PDF.TableRow(children: [
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  child: PDF.Text("Teklif Talep No")),
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  child: PDF.Text("119")),
                            ]),
                            PDF.TableRow(children: [
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  child: PDF.Text("Teklif Talep Tarihi")),
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  child: PDF.Text(
                                      "${DateFormat("dd/MM/yyyy").format(DateTime.now())}")),
                            ]),
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
                        children: _getUrunPDF(),
                      )),
                ]))
          ];
        }));
    await _savePDF(pdf);
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
                    "${_ruhsatSeriNo.substring(0, 2)}-${_ruhsatSeriNo.substring(2)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_asbisNo"))
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_modelYili"))
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
      case 2:
        return [
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
                    "${_ruhsatSeriNo.substring(0, 2)}-${_ruhsatSeriNo.substring(2)}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("ASBIS NO")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_asbisNo"))
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_modelYili"))
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
      case 4:
        return [
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
      case 11:
        return [
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
                child: PDF.Text("$_binaKatSayisi"))
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_daireMetre"))
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_adres"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
      case 21:
        return [
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
                child: PDF.Text("${_gidilenUlke.ulkeAdi}"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Seyahat Eden Kişi Sayısı")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_kisiSayisi"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
      case 22:
        return [
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_esyaBedeli"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Bina Bedeli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_binaBedeli"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Adres")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_adres"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
      default:
        return [
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_adres"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("Açıklama")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text(_aciklama == null ? "" : "$_aciklama"))
          ]),
        ];
    }
  }

  void _focusNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _getKullaniciInfo() {
    Utils.getKullaniciInfo().then((value) {
      setState(() {
        _kullaniciInfo = value;
      });
    });
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
                          initialValue: widget.policyResponse != null
                              ? widget.policyResponse.plaka == null ||
                                      widget.policyResponse.plaka.trim() == ""
                                  ? ""
                                  : widget.policyResponse.plaka.substring(0, 2)
                              : "",
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
                          onSaved: (value) => _ilKodu = value,
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: widget.policyResponse != null
                              ? widget.policyResponse.plaka == null ||
                                      widget.policyResponse.plaka.trim() == ""
                                  ? ""
                                  : widget.policyResponse.plaka.substring(2)
                              : "",
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
                          onSaved: (value) => _plakaNo = value,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.policyResponse != null
                        ? (widget.policyResponse.ruhsatSeriKodu != null
                                ? widget.policyResponse.ruhsatSeriKodu
                                    .toString()
                                : "") +
                            (widget.policyResponse.ruhsatSeriNo != null
                                ? widget.policyResponse.ruhsatSeriNo.toString()
                                : "")
                        : "",
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Image.asset(
                              "assets/images/ic_soru.png",
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => MyDialog(
                                  dialogKind: "RuhsatImage",
                                ),
                              );
                            }),
                        labelText: "Ruhsat Seri No",
                        contentPadding: EdgeInsets.only(top: 8)),
                    textInputAction: TextInputAction.next,
                    style: TextStyleData.boldSiyah,
                    focusNode: _ruhsatFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_ruhsatFocus, _asbisFocus);
                    },
                    validator: (value) {
                      var message = null;
                      if (_asbisNo.isEmpty && value.isEmpty) {
                        message = 'Ruhsat seri no yada ASBİS kodunu giriniz.';
                      }
                      if (value.isNotEmpty) {
                        bool valid = RegExp(r'^([a-zA-Z]){2}([0-9]){6}$')
                            .hasMatch(value.toUpperCase());
                        if (!valid)
                          message = "Ruhsat Seri No: AA123456 formatta olmalı";
                      }
                      return message;
                    },
                    onSaved: (value) {
                      if (value.length < 3)
                        _ruhsatSeriKodu = value;
                      else if (value.length >= 3) {
                        _ruhsatSeriKodu = value.substring(0, 2);
                        _ruhsatSeriNo = value.substring(2);
                      } else {
                        _ruhsatSeriKodu = "";
                        _ruhsatSeriNo = "";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.policyResponse != null
                        ? widget.policyResponse.asbisNo
                        : "",
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
                      if (_ruhsatSeriKodu.isEmpty && value.isEmpty) {
                        return 'Ruhsat seri no yada ASBİS kodunu giriniz.';
                      }

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
                    onSaved: (value) => _asbisNo = value,
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
                    validator: (value) =>
                        value.isEmpty ? 'Başlangıç Tarihi giriniz' : null,
                    onTap: () {
                      _selectDate(context, true);
                    },
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
                    validator: (value) {
                      if (value.isNotEmpty) {
                        if (_endingDate.isAfter(_startingDate))
                          return null;
                        else
                          return "Bitiş tarihi Başlangıç tarihinden sonra olmalıdır";
                      } else
                        return 'Bitiş Tarihi giriniz';
                    },
                    onTap: () {
                      _selectDate(context, false);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.policyResponse != null
                        ? widget.policyResponse.modelYili != null &&
                                widget.policyResponse.modelYili.toString() != ""
                            ? widget.policyResponse.modelYili.toString()
                            : ""
                        : "",
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
                      if (control != null) _modelYili = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    initialValue: _aciklama,
                    decoration: InputDecoration(
                        labelText: "Açıklama",
                        contentPadding: EdgeInsets.only(top: 8)),
                    textInputAction: TextInputAction.done,
                    style: TextStyleData.boldSiyah,
                    focusNode: _aciklamaFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_aciklamaFocus, null);
                    },
                    onSaved: (value) => _aciklama = value,
                  ),
                ],
              ),
            )),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _marka.markaAdi,
                isFilled: widget.policyResponse != null
                    ? !_markaSelect
                    : _marka.markaAdi != "Marka"),
            onTap: () {
              _openListViewDialog(1);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _aracTipi.tipAdi,
                isFilled: widget.policyResponse != null
                    ? !_aracTipiSelect
                    : _aracTipi.tipAdi != "Araç Tipi"),
            onTap: () {
              _openListViewDialog(2);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _kullanimTarzi.kullanimTarzi,
                isFilled: widget.policyResponse != null
                    ? !_kullanimTarziSelect
                    : _kullanimTarzi.kullanimTarzi != "Kullanım Tarzı"),
            onTap: () {
              _openListViewDialog(3);
            },
          ),
        ),
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
                  validator: (value) =>
                      value.isEmpty ? 'Gidiş Tarihi giriniz' : null,
                  onTap: () {
                    _selectDate(context, true);
                  },
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
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (_endingDate.isAfter(_startingDate))
                        return null;
                      else
                        return "Dönüş tarihi Gidiş tarihinden sonra olmalıdır";
                    } else
                      return 'Dönüş Tarihi giriniz';
                  },
                  onTap: () {
                    _selectDate(context, false);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.policyResponse != null
                        ? widget.policyResponse.seyahatEdenKisiSayisi != null
                            ? widget.policyResponse.seyahatEdenKisiSayisi
                                .toString()
                            : ""
                        : "",
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        labelText: "Sizinle Seyahat Edecek Kişi Sayısı",
                        contentPadding: EdgeInsets.only(top: 8)),
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
                      if (control != null) _kisiSayisi = int.parse(value);
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: _aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => _aciklama = value,
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
                title: _ulkeTuru.ulkeTipiAdi,
                isFilled: widget.policyResponse != null
                    ? !_gidilenUlkeSelect
                    : _ulkeTuru.ulkeTipiAdi != "Seyahat Edilicek Ülke Türü"),
            onTap: () {
              _openListViewDialog(10);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _gidilenUlke.ulkeAdi,
                isFilled: widget.policyResponse != null
                    ? !_gidilenUlkeSelect
                    : _gidilenUlke.ulkeAdi != "Seyahat Edilicek Ülke"),
            onTap: () {
              _openListViewDialog(11);
            },
          ),
        ),
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
                title: _yapiTarzi.yapiTarziAdi,
                isFilled: widget.policyResponse != null
                    ? !_yapiTarziSelect
                    : _yapiTarzi.yapiTarziAdi != "Yapı Tarzı"),
            onTap: () {
              _openListViewDialog(5);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _yapimYili.yapimYiliAdi,
                isFilled: widget.policyResponse != null
                    ? !_yapimYiliSelect
                    : _yapimYili.yapimYiliAdi != "Yapım Yılı"),
            onTap: () {
              _openListViewDialog(6);
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
                    validator: (value) =>
                        value.isEmpty ? 'Başlangıç Tarihi giriniz' : null,
                    onTap: () {
                      _selectDate(context, true);
                    },
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
                    validator: (value) {
                      if (value.isNotEmpty) {
                        if (_endingDate.isAfter(_startingDate))
                          return null;
                        else
                          return "Bitiş tarihi Başlangıç tarihinden sonra olmalıdır";
                      } else
                        return 'Bitiş Tarihi giriniz';
                    },
                    onTap: () {
                      _selectDate(context, false);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.policyResponse != null
                        ? widget.policyResponse.binaKatSayisi != null
                            ? widget.policyResponse.binaKatSayisi.toString()
                            : ""
                        : "",
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
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
                      if (control != null) _binaKatSayisi = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.policyResponse != null
                        ? widget.policyResponse.daireBrut != null
                            ? widget.policyResponse.daireBrut.toString()
                            : ""
                        : "",
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
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
                      if (control != null) _daireMetre = int.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.policyResponse.adres,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Adres",
                        contentPadding: EdgeInsets.only(top: 8)),
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
                    onSaved: (value) => _adres = value,
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
                    textInputAction: TextInputAction.done,
                    style: TextStyleData.boldSiyah,
                    focusNode: _aciklamaFocus,
                    onFieldSubmitted: (value) {
                      _focusNextField(_aciklamaFocus, null);
                    },
                    onSaved: (value) => _aciklama = value,
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
                isFilled: widget.policyResponse != null
                    ? !_binaKullanimSekliSelect
                    : _binaKullanimSekli.binaKullanimTarziAdi !=
                        "Bina Kullanım Şekli"),
            onTap: () {
              _openListViewDialog(7);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _il.ilAdi,
                isFilled: widget.policyResponse != null
                    ? !_ilSelect
                    : _il.ilAdi != "İl"),
            onTap: () {
              _openListViewDialog(8);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ilce.ilceAdi,
                isFilled: widget.policyResponse != null
                    ? !_ilceSelect
                    : _ilce.ilceAdi != "İlçe"),
            onTap: () {
              _openListViewDialog(9);
            },
          ),
        ),
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
                title: _meslek.meslekAdi,
                isFilled: widget.policyResponse != null
                    ? !_meslekSelect
                    : _meslek.meslekAdi != "Meslek"),
            onTap: () {
              _openListViewDialog(4);
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
                  validator: (value) =>
                      value.isEmpty ? 'Başlangıç Tarihi giriniz' : null,
                  onTap: () {
                    _selectDate(context, true);
                  },
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
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (_endingDate.isAfter(_startingDate))
                        return null;
                      else
                        return "Bitiş tarihi Başlangıç tarihinden sonra olmalıdır";
                    } else
                      return 'Bitiş Tarihi giriniz';
                  },
                  onTap: () {
                    _selectDate(context, false);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: _aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => _aciklama = value,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getKonutForm() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _il.ilAdi,
                isFilled: widget.policyResponse != null
                    ? !_ilSelect
                    : _il.ilAdi != "İl"),
            onTap: () {
              _openListViewDialog(8);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ilce.ilceAdi,
                isFilled: widget.policyResponse != null
                    ? !_ilceSelect
                    : _ilce.ilceAdi != "İlçe"),
            onTap: () {
              _openListViewDialog(9);
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
                  validator: (value) =>
                      value.isEmpty ? 'Başlangıç Tarihi giriniz' : null,
                  onTap: () {
                    _selectDate(context, true);
                  },
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
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (_endingDate.isAfter(_startingDate))
                        return null;
                      else
                        return "Bitiş tarihi Başlangıç tarihinden sonra olmalıdır";
                    } else
                      return 'Bitiş Tarihi giriniz';
                  },
                  onTap: () {
                    _selectDate(context, false);
                  },
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
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _binaBedeliFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_binaBedeliFocus, _esyaBedeliFocus);
                  },
                  validator: (value) {
                    value = value.replaceAll('TL', '');

                    if (value == "0,00") {
                      return "Bina veya Eşya Bedeli giriniz";
                    } else
                      return null;
                  },
                  onSaved: (value) => _binaBedeli = value,
                ),
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
                  textInputAction: TextInputAction.next,
                  style: TextStyleData.boldSiyah,
                  focusNode: _esyaBedeliFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_esyaBedeliFocus, _adresFocus);
                  },
                  validator: (value) {
                    value = value.replaceAll('TL', '');
                    if (value == "0,00") {
                      return "Eşya veya Bina Bedeli giriniz";
                    } else
                      return null;
                  },
                  onSaved: (value) => _esyaBedeli = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: widget.policyResponse != null
                      ? widget.policyResponse.adres
                      : "",
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Adres",
                      contentPadding: EdgeInsets.only(top: 8)),
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
                  onSaved: (value) => _adres = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: _aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => _aciklama = value,
                ),
              ],
            ),
          ),
        ),
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
                  validator: (value) =>
                      value.isEmpty ? 'Başlangıç Tarihi giriniz' : null,
                  onTap: () {
                    _selectDate(context, true);
                  },
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
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (_endingDate.isAfter(_startingDate))
                        return null;
                      else
                        return "Bitiş tarihi Başlangıç tarihinden sonra olmalıdır";
                    } else
                      return 'Bitiş Tarihi giriniz';
                  },
                  onTap: () {
                    _selectDate(context, false);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: widget.policyResponse != null
                      ? widget.policyResponse.adres
                      : "",
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Adres",
                      contentPadding: EdgeInsets.only(top: 8)),
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
                  onSaved: (value) => _adres = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  initialValue: _aciklama,
                  decoration: InputDecoration(
                      labelText: "Açıklama",
                      contentPadding: EdgeInsets.only(top: 8)),
                  textInputAction: TextInputAction.done,
                  style: TextStyleData.boldSiyah,
                  focusNode: _aciklamaFocus,
                  onFieldSubmitted: (value) {
                    _focusNextField(_aciklamaFocus, null);
                  },
                  onSaved: (value) => _aciklama = value,
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
                title: _il.ilAdi,
                isFilled: widget.policyResponse != null
                    ? !_ilSelect
                    : _il.ilAdi != "İl"),
            onTap: () {
              _openListViewDialog(8);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ilce.ilceAdi,
                isFilled: widget.policyResponse != null
                    ? !_ilceSelect
                    : _ilce.ilceAdi != "İlçe"),
            onTap: () {
              _openListViewDialog(9);
            },
          ),
        ),
      ],
    );
  }
}

// Future<void> send() async {
//     final Email email = Email(
//       body: 'deneme',
//       subject: 'deneme1',
//       recipients: ['onuracikgoz28@gmail.com'],
//       attachmentPaths: attachments,
//       isHTML: isHTML,
//     );

Future _savePDF(PDF.Document pdf) async {
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String documentpath = documentDirectory.path;

  final File file = File("$documentpath/example.pdf");

  file.writeAsBytesSync(pdf.save());
}
