import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/AracKullanimTarzi.dart';
import 'package:sigortadefterim/models/AracMarka.dart';
import 'package:sigortadefterim/models/AracTip.dart';
import 'package:sigortadefterim/models/IL.dart';
import 'package:sigortadefterim/models/ILCE.dart';
import 'package:sigortadefterim/models/Meslek.dart';
import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/SigortaTuru.dart';
import 'package:sigortadefterim/models/Ulke.dart';
import 'package:sigortadefterim/models/UlkeTipi.dart';
import 'package:sigortadefterim/utils/Utils.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/widgets/ButtonContainer.dart';
import 'package:sigortadefterim/widgets/Drawers.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/widgets/TopInformationContainer.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';

import 'dart:math' as math;

class AddPolicy extends StatefulWidget {
  @override
  _AddPolicyState createState() => _AddPolicyState();
}

class _AddPolicyState extends State<AddPolicy> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _aracFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _seyahatFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _daskFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _saglikFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _konutFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _digerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _globalInputKey = GlobalKey<FormState>();

  final FocusNode _policeNoFocus = FocusNode();
  final FocusNode _yenilemeNoFocus = FocusNode();
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

  String _policeNo;
  String _yenilemeNo;
  String _ilKodu;
  String _plakaNo;
  String _ruhsatSeriNo;
  String _ruhsatSeriKodu;
  String _asbisNo;

  String _baslangicTarihi =
      DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());
  String _bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day));
  String _modelYili;
  String _aciklama;
  int _acenteSecimi = 0;
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

  String _yapiTarzi = "Yapı Tarzı";
  String _yapimYili = "Yapım Yılı";
  String _binaKullanimSekli = "Bina Kullanım Şekli";
  String _binaKatSayisi = "Bina Toplam Kat Sayısı";

  int _yapiTarziValue;
  int _yapimYiliValue;
  int _binaKullanimSekliValue;

  String _daireMetre;
  String _adres;
  IL _il = IL(ilAdi: "İl");
  ILCE _ilce = ILCE(ilceAdi: "İlçe");

  Meslek _meslek = Meslek(meslekAdi: "Meslek");

  String _binaBedeli;
  String _esyaBedeli;

  DateTime _startingDate = DateTime.now();
  DateTime _endingDate = DateTime.now();

  var _binabedelController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', rightSymbol: 'TL');
  var _esyabedelController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', rightSymbol: 'TL');
  final TextEditingController _startingDateController = TextEditingController();
  final TextEditingController _endingDateController = TextEditingController();

  List<String> _kullaniciInfo = List<String>();

  @override
  void initState() {
    super.initState();
    _kullaniciInfo.addAll(["", "", "111111111111", "", ""]); 
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
    Future.delayed(Duration.zero, () {
      _openListViewDialog(1);
    });
  }

  @override
  void dispose() {
    _startingDateController.dispose();
    _endingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startingDateController.text =
        DateFormat("dd/MM/yyyy").format(_startingDate);
    _endingDateController.text = DateFormat("dd/MM/yyyy").format(_endingDate);

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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Poliçe Ekle",
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
                //title: "Poliçe\nEkle",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                children: <Widget>[
                  Text(
                      _kullaniciInfo[2].substring(0, 2) +
                          "******" +
                          _kullaniciInfo[2].substring(8),
                      style: TextStyleData.boldSiyah),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: InkWell(
                child: ButtonContainer(
                    title: _sigortaSirketi.sirketAdi,
                    isFilled: _sigortaSirketi.sirketAdi != "Sigorta Şirketi"),
                onTap: () {
                  _openListViewDialog(0);
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
                  _openListViewDialog(1);
                },
              ),
            ),
            Form(
                key: _globalInputKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15)
                        ],
                        decoration: InputDecoration(
                            labelText: "Poliçe Numarası",
                            contentPadding: EdgeInsets.only(top: 8)),
                        textInputAction: TextInputAction.next,
                        style: TextStyleData.boldSiyah,
                        focusNode: _policeNoFocus,
                        onFieldSubmitted: (value) {
                          _focusNextField(_policeNoFocus, _yenilemeNoFocus);
                        },
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return null;
                          } else
                            return "Poliçe Numarası giriniz";
                        },
                        onSaved: (value) => _policeNo = value,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2)
                        ],
                        decoration: InputDecoration(
                            labelText: "Yenileme Numarası",
                            contentPadding: EdgeInsets.only(top: 8)),
                        textInputAction: TextInputAction.next,
                        style: TextStyleData.boldSiyah,
                        focusNode: _yenilemeNoFocus,
                        onFieldSubmitted: (value) {
                          _focusNextField(_yenilemeNoFocus, _ilKoduFocus);
                        },
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return null;
                          } else
                            return "Yenileme Numarası giriniz";
                        },
                        onSaved: (value) => _yenilemeNo = value,
                      ),
                    ]))),
            SizedBox(height: 8),
            _getUrunForm(),
            SizedBox(height: 8),
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
                      child: Text("EKLE",
                          style: TextStyleData.extraBoldLacivert16),
                    ),
                    color: ColorData.renkYesil,
                    shape: StadiumBorder(),
                    onPressed: () {
                      _addPolicy();
                    }),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<Null> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime value = await showDatePicker(
        context: context,
        locale: const Locale("tr", "TR"),
        initialDate: isStartDate ? _startingDate : _endingDate,
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
        });
        break;
      case 3:
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
      case 4:
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
        List<String> itemList = [
          "ÇELİK, BETORNARME, KARKAS",
          "YIĞMA KAGİR",
          "DİĞER"
        ];
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Yapı Tarzı", itemList: itemList));
        setState(() {
          _yapiTarzi = result != null ? itemList[result] : _yapiTarzi;
          _yapiTarziValue = result;
        });
        break;
      case 7:
        List<String> itemList = [
          "1975 - ÖNCESİ",
          "1976 - 1996",
          "1997 - 1999",
          "2000- 2006",
          "2007 - SONRASI"
        ];
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ListViewDrawer(title: "Yapım Yılı", itemList: itemList));
        setState(() {
          _yapimYili = result != null ? itemList[result] : _yapimYili;
          _yapimYiliValue = result;
        });
        break;
      case 8:
        List<String> itemList = ["MESKEN", "BÜRO", "TİCARETHANE", "DİĞER"];
        var result = await showDialog(
            context: context,
            builder: (BuildContext context) => ListViewDrawer(
                title: "Bina Kullanim Şekli", itemList: itemList));
        print(result);
        setState(() {
          _binaKullanimSekli =
              result != null ? itemList[result] : _binaKullanimSekli;
          _binaKullanimSekliValue = result;
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
        //List itemList = await Utils.getUlke(_ulkeTuru);
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

  void _addPolicy() {
    FormState _form, _globalkey = _globalInputKey.currentState;
    _globalkey.save();

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

    _form.save();

    var dropValidate = false;

    switch (_sigortaTuru.bransKodu) {
      case 1:
      case 2:
        if (_sigortaSirketi.sirketAdi != "Sigorta Şirketi" &&
            _sigortaTuru.bransAdi != "Sigorta Türü" &&
            _marka.markaAdi != "Marka" &&
            _aracTipi.tipAdi != "Araç Tipi" &&
            _kullanimTarzi.kullanimTarzi != "Kullanım Tarzı")
          dropValidate = true;
        break;
      case 4:
        if (_sigortaSirketi.sirketAdi != "Sigorta Şirketi" &&
            _sigortaTuru.bransAdi != "Sigorta Türü" &&
            _meslek.meslekAdi != "Meslek") dropValidate = true;
        break;
      case 11:
        if (_sigortaSirketi.sirketAdi != "Sigorta Şirketi" &&
            _sigortaTuru.bransAdi != "Sigorta Türü" &&
            _ilce.ilceAdi != "İlçe" &&
            _il.ilAdi != "İl" &&
            _yapiTarzi != "Yapı Tarzı" &&
            _yapimYili != "Yapım Yılı" &&
            _binaKullanimSekli != "Bina Kullanım Şekli") dropValidate = true;
        break;
      case 21:
        if (_sigortaSirketi.sirketAdi != "Sigorta Şirketi" &&
            _sigortaTuru.bransAdi != "Sigorta Türü" &&
            _gidilenUlke.ulkeAdi != "Seyahat Edilicek Ülke")
          dropValidate = true;

        break;
      case 22:
        if (_sigortaSirketi.sirketAdi != "Sigorta Şirketi" &&
            _sigortaTuru.bransAdi != "Sigorta Türü" &&
            _ilce.ilceAdi != "İlçe" &&
            _il.ilAdi != "İl") dropValidate = true;
        break;
      default:
        if (_sigortaSirketi.sirketAdi != "Sigorta Şirketi" &&
            _sigortaTuru.bransAdi != "Sigorta Türü" &&
            _ilce.ilceAdi != "İlçe" &&
            _il.ilAdi != "İl") dropValidate = true;
        break;
    }
    _globalkey.validate();
    if (_form.validate()) {
      if (dropValidate) {
        _onLoading();
        switch (_sigortaTuru.bransKodu) {
          case 1:
          case 2:
            WebAPI.addPolicy(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: _sigortaTuru.bransKodu,
              aciklama: _aciklama,
              sigortasirket: _sigortaSirketi.sirketKodu,
              policeNumarasi: _policeNo,
              basTarih: _baslangicTarihi,
              bitTarih: _bitisTarihi,
              plakano: _ilKodu + _plakaNo,
              ruhsatkodu: _ruhsatSeriKodu,
              ruhsatno: _ruhsatSeriNo,
              asbisno: _asbisNo,
              modelyili: int.parse(_modelYili),
              markaid: _marka.markaKodu,
              modelid: _aracTipi.tipKodu,
              kullanimtarzi:
                  _kullanimTarzi.kullanimTarziKodu + "+" + _kullanimTarzi.kod2,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;

          case 4: //saglik
            WebAPI.addPolicy(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: _sigortaTuru.bransKodu,
              aciklama: _aciklama,
              sigortasirket: _sigortaSirketi.sirketKodu,
              policeNumarasi: _policeNo,
              basTarih: _baslangicTarihi,
              bitTarih: _bitisTarihi,
              meslek: _meslek.meslekKodu.toString(),
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          case 11: //dask
            WebAPI.addPolicy(
                    token: _kullaniciInfo[3],
                    tckn: _kullaniciInfo[2],
                    branskodu: _sigortaTuru.bransKodu,
                    aciklama: _aciklama,
                    sigortasirket: _sigortaSirketi.sirketKodu,
                    policeNumarasi: _policeNo,
                    basTarih: _baslangicTarihi,
                    bitTarih: _bitisTarihi,
                    binakatsayisi: int.parse(_binaKatSayisi),
                    binakullanimsekli: _binaKullanimSekliValue,
                    binayapimtarzi: _yapiTarziValue,
                    binayapimyili: _yapimYiliValue,
                    il: _il.ilKodu,
                    ilce: _ilce.ilceKodu,
                    adres: _adres,
                    dairembrut: int.parse(_daireMetre))
                .then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          case 21: //seyahat
            WebAPI.addPolicy(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: _sigortaTuru.bransKodu,
              aciklama: _aciklama,
              sigortasirket: _sigortaSirketi.sirketKodu,
              policeNumarasi: _policeNo,
              seyahatGidisTarihi: _baslangicTarihi,
              seyahatDonusTarihi: _bitisTarihi,
              seyahatEdenKisiSayisi: int.parse(_kisiSayisi),
              seyahatUlkeKodu: _gidilenUlke.ulkeKodu,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          case 22: //konut
            _binaBedeli = _binaBedeli.replaceAll('TL', '');
            _binaBedeli = _binaBedeli.replaceAll(',', '');
            _esyaBedeli = _esyaBedeli.replaceAll('TL', '');
            _esyaBedeli = _esyaBedeli.replaceAll(',', '');

            WebAPI.addPolicy(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: _sigortaTuru.bransKodu,
              aciklama: _aciklama,
              sigortasirket: _sigortaSirketi.sirketKodu,
              policeNumarasi: _policeNo,
              basTarih: _baslangicTarihi,
              bitTarih: _bitisTarihi,
              binaBedeli: double.parse(_binaBedeli),
              esyaBedeli: double.parse(_esyaBedeli),
              adres: _adres,
              il: _il.ilKodu,
              ilce: _ilce.ilceKodu,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
          default: //diğer
            WebAPI.addPolicy(
              token: _kullaniciInfo[3],
              tckn: _kullaniciInfo[2],
              branskodu: _sigortaTuru.bransKodu,
              aciklama: _aciklama,
              sigortasirket: _sigortaSirketi.sirketKodu,
              policeNumarasi: _policeNo,
              basTarih: _baslangicTarihi,
              bitTarih: _bitisTarihi,
              adres: _adres,
              il: _il.ilKodu,
              ilce: _ilce.ilceKodu,
            ).then((result) {
              closeLoader();
              alertBox(result);
            });
            break;
        }
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
  }

  void closeLoader() {
    Navigator.pop(context);
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
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
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
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
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
                  onSaved: (value) => _modelYili = value,
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
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _marka.markaAdi, isFilled: _marka.markaAdi != "Marka"),
            onTap: () {
              _openListViewDialog(2);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _aracTipi.tipAdi,
                isFilled: _aracTipi.tipAdi != "Araç Tipi"),
            onTap: () {
              _openListViewDialog(3);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _kullanimTarzi.kullanimTarzi,
                isFilled: _kullanimTarzi.kullanimTarzi != "Kullanım Tarzı"),
            onTap: () {
              _openListViewDialog(4);
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
                  onSaved: (value) => _kisiSayisi = value,
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
                title: _ulkeTuru.ulkeTipiAdi,
                isFilled:
                    _ulkeTuru.ulkeTipiAdi != "Seyahat Edilicek Ülke Türü"),
            onTap: () {
              _openListViewDialog(11);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _gidilenUlke.ulkeAdi,
                isFilled: _gidilenUlke.ulkeAdi != "Seyahat Edilicek Ülke"),
            onTap: () {
              _openListViewDialog(12);
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
                title: _yapiTarzi, isFilled: _yapiTarzi != "Yapı Tarzı"),
            onTap: () {
              _openListViewDialog(6);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _yapimYili, isFilled: _yapimYili != "Yapım Yılı"),
            onTap: () {
              _openListViewDialog(7);
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
                    onSaved: (value) => _binaKatSayisi = value,
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
                    onSaved: (value) => _daireMetre = value,
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
                title: _binaKullanimSekli,
                isFilled: _binaKullanimSekli != "Bina Kullanım Şekli"),
            onTap: () {
              _openListViewDialog(8);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child:
                ButtonContainer(title: _il.ilAdi, isFilled: _il.ilAdi != "İl"),
            onTap: () {
              _openListViewDialog(9);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ilce.ilceAdi, isFilled: _ilce.ilceAdi != "İlçe"),
            onTap: () {
              _openListViewDialog(10);
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
                isFilled: _meslek.meslekAdi != "Meslek"),
            onTap: () {
              _openListViewDialog(5);
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
            child:
                ButtonContainer(title: _il.ilAdi, isFilled: _il.ilAdi != "İl"),
            onTap: () {
              _openListViewDialog(9);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ilce.ilceAdi, isFilled: _ilce.ilceAdi != "İlçe"),
            onTap: () {
              _openListViewDialog(10);
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    //DecimalTextInputFormatter(decimalRange: 2),
                    // WhitelistingTextInputFormatter.digitsOnly,
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
                    if (value.isNotEmpty) {
                      return null;
                    } else {
                      if (_esyaBedeli == "" || _esyaBedeli == null)
                        return "Bina Bedeli giriniz";
                      else
                        return null;
                    }
                  },
                  onSaved: (value) => _binaBedeli = value,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _esyabedelController,
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
                    if (value.isNotEmpty) {
                      return null;
                    } else if (_binaBedeli == null || _binaBedeli == "")
                      return "Eşya Bedeli giriniz";
                    else
                      return null;
                  },
                  onSaved: (value) => _esyaBedeli = value,
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
            child:
                ButtonContainer(title: _il.ilAdi, isFilled: _il.ilAdi != "İl"),
            onTap: () {
              _openListViewDialog(9);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
            child: ButtonContainer(
                title: _ilce.ilceAdi, isFilled: _ilce.ilceAdi != "İlçe"),
            onTap: () {
              _openListViewDialog(10);
            },
          ),
        ),
      ],
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
