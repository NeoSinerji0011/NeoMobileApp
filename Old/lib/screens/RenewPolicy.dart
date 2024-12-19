import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'package:image/image.dart' as ResizedImage;
import 'package:printing/printing.dart';
import 'package:sigortadefterim/AppStyle.dart';
import 'package:sigortadefterim/models/Acente.dart';
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
import 'package:sigortadefterim/widgets/MyRadioButton.dart';
import 'package:sigortadefterim/widgets/TopInformationContainer.dart';
import 'package:sigortadefterim/widgets/MyDialog.dart';
import 'package:sigortadefterim/web_services/WebAPI.dart';
import 'package:sigortadefterim/utils/UtilsPolicy.dart';
import 'package:sigortadefterim/models/BinaKullanimSekli.dart';
import 'package:sigortadefterim/models/YapiTarzi.dart';
import 'package:sigortadefterim/models/YapimYili.dart';
import 'package:sigortadefterim/models/TVMDetay.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class RenewPolicy extends StatefulWidget {
  final PolicyResponse policyResponse;

  RenewPolicy({this.policyResponse});

  @override
  _RenewPolicyState createState() => _RenewPolicyState();
}

class _RenewPolicyState extends State<RenewPolicy> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _aracFormKey = GlobalKey<FormState>();
  //final GlobalKey<FormState> _seyahatFormKey = GlobalKey<FormState>();
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

  //final FocusNode _kisiSayisiFocus = FocusNode();

  final FocusNode _binaKatFocus = FocusNode();
  final FocusNode _daireMetreFocus = FocusNode();
  final FocusNode _adresFocus = FocusNode();

  final FocusNode _binaBedeliFocus = FocusNode();
  final FocusNode _esyaBedeliFocus = FocusNode();

  int _acenteSecimi = 0;
  DateTime _startingDate = DateTime.now();
  DateTime _endingDate = DateTime.now();
  SigortaSirketi _sigortaSirketi = SigortaSirketi(sirketAdi: "Sigorta Şirketi");

  SigortaTuru _sigortaTuru = SigortaTuru(bransAdi: "Sigorta Türü");
  AracMarka _marka = AracMarka(markaAdi: "Marka");

  AracMarka _markaTemp = AracMarka(markaAdi: "Marka");
  List _aracTipListTemp;
  AracTip _aracTipi = AracTip(tipAdi: "Araç Tipi");
  AracKullanimTarzi _kullanimTarzi =
      AracKullanimTarzi(kullanimTarzi: "Kullanım Tarzı");

  BinaKullanimSekli _binaKullanimSekli =
      BinaKullanimSekli(binaKullanimTarziAdi: "Kullanım Tarzı");
  YapiTarzi _yapiTarzi = YapiTarzi(yapiTarziAdi: "Yapı Tarzı");
  YapimYili _yapimYili = YapimYili(yapimYiliAdi: "Yapım Yılı");
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

  IL _il = IL(ilAdi: "İl");
  ILCE _ilce = ILCE(ilceAdi: "İlçe"); 
  Meslek _meslek = Meslek(meslekAdi: "Meslek");

  final TextEditingController _startingDateController = TextEditingController();
  final TextEditingController _endingDateController = TextEditingController();

  List<String> _kullaniciInfo = List<String>();

  List _acente = List();
  PolicyResponse policyResponseRenew = PolicyResponse();

  var _binabedelController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', rightSymbol: 'TL');
  var _esyabedelController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', rightSymbol: 'TL');

  String _binaBedeli;
  String _esyaBedeli;

  @override
  void initState() {
    super.initState();
    _kullaniciInfo.addAll(["", "", "11111111111", "", ""]);
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

    getPolicyInformation().whenComplete(() {});

    policyResponseRenew.baslangicTarihi = widget.policyResponse.baslangicTarihi;
    policyResponseRenew.bitisTarihi = widget.policyResponse.bitisTarihi;
    policyResponseRenew.bransKodu = widget.policyResponse.bransKodu;
    _binabedelController.text = widget.policyResponse.binaBedeli.toString();
    _esyabedelController.text = widget.policyResponse.esyaBedeli.toString();

    _startingDate = DateTime.parse(widget.policyResponse.bitisTarihi);
    _endingDate = DateTime(
        _startingDate.year + 1, _startingDate.month, _startingDate.day);

    _startingDateController.addListener(() {
      setState(() {
        _kullaniciInfo = UtilsPolicy.kullaniciInfo;
        _endingDate = DateTime(
            _startingDate.year + 1, _startingDate.month, _startingDate.day);
      });
    });

    policyResponseRenew.baslangicTarihi =
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(_startingDate);
    policyResponseRenew.bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss").format(
        DateTime(
            _startingDate.year + 1, _startingDate.month, _startingDate.day));
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
        drawer:
            MenuDrawer(adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1]),
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
                          "Poliçe Yenile",
                          style: TextStyleData.standartLacivert24,
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TopInformationContainer(
                  imageUrl: _kullaniciInfo[4],
                  adSoyad: _kullaniciInfo[0] + " " + _kullaniciInfo[1],
                  riskOrani: "85",
                  //title: "Poliçe\nYenile",
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "${widget.policyResponse.kimlikNo.substring(0, 2)}******${widget.policyResponse.kimlikNo.substring(8, 11)}",
                            style: TextStyleData.boldSiyah),
                        Text(
                            "Teklif Talep No: ${widget.policyResponse.teklifIslemNo != null ? widget.policyResponse.teklifIslemNo : "Bulunamadı"}",
                            style: TextStyleData.boldSiyah),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "Poliçe No: ${widget.policyResponse.policeNumarasi}",
                            style: TextStyleData.boldSiyah),
                        Text(
                            "Yenileme No: ${widget.policyResponse.yenilemeNo != null ? widget.policyResponse.yenilemeNo : "Bulunamadı"}",
                            style: TextStyleData.boldSiyah),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: ButtonContainer(
                    title: _sigortaSirketi.sirketAdi,
                    isFilled: _sigortaSirketi.sirketAdi != "Sigorta Şirketi"),
              ),
               
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: ButtonContainer(
                    title: _sigortaTuru.bransAdi,
                    isFilled: _sigortaTuru.bransAdi != "Sigorta Türü"),
              ),
              SizedBox(height: 8),
              _getUrunForm(),
              SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: <Widget>[
                    MyRadioButton(
                      label: 'Talebi kendi acenteme gönder',
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      value: 0,
                      groupValue: _acenteSecimi,
                      onChanged: (value) {
                        setState(() {
                          _acenteSecimi = value;
                        });
                      },
                    ),
                    MyRadioButton(
                      label: 'Talebi diğer acentelere gönder',
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      value: 1,
                      groupValue: _acenteSecimi,
                      onChanged: (value) {
                        setState(() {
                          _acenteSecimi = value;
                        });
                      },
                    ),
                    /*  MyRadioButton(
                      label: 'Talebi her ikisine gönder',
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      value: 2,
                      groupValue: _acenteSecimi,
                      onChanged: (value) {
                        setState(() {
                          _acenteSecimi = value;
                        });
                      },
                    ) */
                  ],
                ),
              ),
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
                        child: Text("YENİLE",
                            style: TextStyleData.extraBoldLacivert16),
                      ),
                      color: ColorData.renkYesil,
                      shape: StadiumBorder(),
                      onPressed: () {
                        _renewPolicy();
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
    final DateTime value = await showDatePicker(
        context: context,
        initialDate: isStartDate ? _startingDate : _endingDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (isStartDate) {
      if (value != null && value != _startingDate)
        setState(() {
          _startingDateController.text = value.toString();
          _startingDate = value;

          policyResponseRenew.baslangicTarihi =
              DateFormat("yyyy-MM-ddTHH:mm:ss").format(value);
          policyResponseRenew.bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss")
              .format(DateTime(value.year + 1, value.month, value.day));
          /* widget.policyResponse.baslangicTarihi =
              DateFormat("yyyy-MM-ddTHH:mm:ss").format(value); */
          /*  widget.policyResponse.bitisTarihi = DateFormat("yyyy-MM-ddTHH:mm:ss")
              .format(DateTime(value.year + 1, value.month, value.day)); */
          //var endDatetemp=DateTime(value.year+1,value.month,value.day);
          //widget.policyResponse.bitisTarihi=DateTime(value.year+1,value.month,value.day).toIso8601String();
        });
    } else {
      if (value != null && value != _endingDate)
        setState(() {
          _endingDateController.text = value.toString();
          _endingDate = value;
          /*  widget.policyResponse.bitisTarihi =
              DateFormat("yyyy-MM-ddTHH:mm:ss").format(value); */
          policyResponseRenew.bitisTarihi =
              DateFormat("yyyy-MM-ddTHH:mm:ss").format(value);
        });
    }
  }

  void _renewPolicy() {
    FormState _form;

    if (_sigortaTuru.bransKodu == 1 || _sigortaTuru.bransKodu == 2)
      _form = _aracFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 11)
      _form = _daskFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 4)
      _form = _saglikFormKey.currentState;
    else if (_sigortaTuru.bransKodu == 22)
      _form = _konutFormKey.currentState;
    else {
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
        if (_binaBedeli != null) {
          _binaBedeli = _binaBedeli.replaceAll('TL', '');
          _binaBedeli = _binaBedeli.replaceAll(',', '');
        }
        if (_esyaBedeli != null) {
          _esyaBedeli = _esyaBedeli.replaceAll('TL', '');
          _esyaBedeli = _esyaBedeli.replaceAll(',', '');
        }

        _onLoading();
        WebAPI.reporRenew(
          token: _kullaniciInfo[3],
          tckn: _kullaniciInfo[2],
          kullaniciId: _kullaniciInfo[7],
          branskodu: policyResponseRenew.bransKodu,
          aciklama: policyResponseRenew.aciklama,
          sigortasirket: _sigortaSirketi.sirketKodu,
          policeNumarasi: widget.policyResponse.policeNumarasi,
          yenilemeno: widget.policyResponse.yenilemeNo,
          acentekodu: widget.policyResponse.acenteUnvani,
          basTarih: policyResponseRenew.baslangicTarihi,
          bitTarih: policyResponseRenew.bitisTarihi,
          emailType: _acenteSecimi,
          plakano: policyResponseRenew.plaka,
          ruhsatkodu: policyResponseRenew.ruhsatSeriKodu,
          ruhsatno: policyResponseRenew.ruhsatSeriNo,
          asbisno: policyResponseRenew.asbisNo,
          modelyili: policyResponseRenew.modelYili,
          markaid: _marka.markaKodu,
          modelid: _aracTipi.tipKodu,
          kullanimtarzi: _kullanimTarzi.kullanimTarziKodu != null ||
                  _kullanimTarzi.kod2 != null
              ? _kullanimTarzi.kullanimTarziKodu + "+" + _kullanimTarzi.kod2
              : null,
          meslek: _meslek.meslekKodu.toString(),
          binaBedeli:
              _binaBedeli != null ? double.parse(_binaBedeli) : _binaBedeli,
          esyaBedeli:
              _esyaBedeli != null ? double.parse(_esyaBedeli) : _esyaBedeli,
          binakatsayisi: policyResponseRenew.binaKatSayisi,
          binakullanimsekli: _binaKullanimSekli.binaKullanimTarziKodu,
          binayapimtarzi: _yapiTarzi.yapiTarziKodu,
          binayapimyili: _yapimYili.yapimYiliKodu,
          dairembrut: policyResponseRenew.daireBrut,
          il: _il.ilKodu,
          ilce: _ilce.ilceKodu,
          adres: policyResponseRenew.adres,
          seyahatEdenKisiSayisi: widget.policyResponse.seyahatEdenKisiSayisi,
          seyahatUlkeKodu: widget.policyResponse.seyahatUlkeKodu,
          seyahatGidisTarihi: widget.policyResponse.seyahatGidisTarihi,
          seyahatDonusTarihi: widget.policyResponse.seyahatDonusTarihi,
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

  Acente _findAcente(int kod) {
    Acente result = Acente(unvani: "Portal Üyesi Değil");
    _acente.forEach((item) {
      if (item.kodu == kod) result = item;
    });
    return result;
  }

  Future<void> pdfCreate() async {
    final pdf = PDF.Document();
    //final File pdfFile= File("${_sigortaSirketi.sirketKodu}-${widget.policyResponse.policeNumarasi}-${widget.policyResponse.yenilemeNo} Hasar PolicyResponsei.pdf");

    final ByteData fontData = await rootBundle.load("assets/fonts/micross.ttf");
    final PDF.Font ttf = PDF.Font.ttf(fontData);

    Acente _acente = _findAcente(widget.policyResponse.acenteUnvani);
    String imageUrl, acenteAdi;
    if (_acenteSecimi == 0) {
      acenteAdi = _findAcente(widget.policyResponse.acenteUnvani).unvani;

      Acente temp = _findAcente(widget.policyResponse.acenteUnvani);
      if (temp.logo != null && temp.logo.toString() != "")
        imageUrl = temp.logo;
      else {
        acenteAdi = "Acentemiz";
        imageUrl = "https://neoonlinestrg.blob.core.windows.net";
      }
    } else {
      acenteAdi = "Acentemiz";
      imageUrl = "https://neoonlinestrg.blob.core.windows.net";
    }

    var logoNetData = await get("$imageUrl");
    final ByteData logoData = await rootBundle.load("assets/images/logo-3.png");
    ResizedImage.Image logo =
        ResizedImage.decodeImage(logoData.buffer.asUint8List());

    ResizedImage.Image logoNet;

    if (logoNetData.statusCode == 200)
      logoNet = ResizedImage.copyResize(
          ResizedImage.decodeImage(logoNetData.bodyBytes),
          height: -1,
          width: 75);

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
                          "${_sigortaTuru.bransAdi} SİGORTASI YENİLEME TALEBİ",
                      style: PDF.TextStyle(fontSize: 18)),
                  PDF.Paragraph(
                      text:
                          "   Sayın $acenteAdi, sigortadefterim.com kullanıcısı tarafından aşağıda detayları bulunan Yenileme Talebini acilen değerlendirerek, kullanıcı e-posta adresine farklı sigorta şirketlerinden alınmış tekliflerinizi göndermenizi önemle bilgilerinize sunarız.\n\nSaygılarımızla\n\n",
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
                      child: acenteAdi != "Acentemiz"
                          ? PDF.Table(
                              tableWidth: PDF.TableWidth.max,
                              border: PDF.TableBorder(),
                              defaultVerticalAlignment:
                                  PDF.TableCellVerticalAlignment.middle,
                              children: [
                                  PDF.TableRow(children: [
                                    PDF.Container(
                                        padding: PDF.EdgeInsets.all(2),
                                        alignment: PDF.Alignment.center,
                                        child: PDF.Text("$acenteAdi",
                                            textAlign: PDF.TextAlign.center)),
                                  ]),
                                  logoNetData.statusCode == 200
                                      ? PDF.TableRow(children: [
                                          PDF.Container(
                                              padding: PDF.EdgeInsets.all(2),
                                              alignment: PDF.Alignment.center,
                                              child: PDF.Image(PdfImage(
                                                  pdf.document,
                                                  image: logoNet.data.buffer
                                                      .asUint8List(),
                                                  width: logoNet.width,
                                                  height: logoNet.height)))
                                        ])
                                      : PDF.TableRow(children: [PDF.Text("")])
                                ])
                          : PDF.Text("")),
                  PDF.Padding(padding: const PDF.EdgeInsets.all(10)),
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
                                  child: PDF.Text("Teklif Talep No")),
                              PDF.Container(
                                  padding: PDF.EdgeInsets.all(2),
                                  child: PDF.Text(
                                      "${widget.policyResponse.teklifIslemNo}")),
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
                padding: PDF.EdgeInsets.all(2), child: PDF.Text("$_yapimYili"))
          ]),
          PDF.TableRow(children: [
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("Bina Kullanım Şekli")),
            PDF.Container(
                padding: PDF.EdgeInsets.all(2),
                child: PDF.Text("$_binaKullanimSekli"))
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
    //FocusScope.of(_aracFormKey.currentContext).requestFocus(nextFocus);
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

  Widget _getUrunForm() {
    if (_sigortaTuru.bransAdi == "Sigorta Türü") {
      return Container();
    } else {
      switch (_sigortaTuru.bransKodu) {
        case 1:
        case 2:
          return _getAracForm();
        case 4:
          return _getSaglikForm();
        case 11:
          return _getDASKForm();
        //case 21:
        //  return _getSeyahatForm();
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
                if (_yapiTarziSelect) _openListViewDialog(6); //yapıtarzı
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: InkWell(
              child: ButtonContainer(
                  title: _yapimYili.yapimYiliAdi, isFilled: !_yapimYiliSelect),
              onTap: () {
                if (_yapimYiliSelect) _openListViewDialog(7);
              }),
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
                    initialValue: widget.policyResponse.binaKatSayisi != null
                        ? widget.policyResponse.binaKatSayisi.toString()
                        : "",
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
                    initialValue: widget.policyResponse.daireBrut != null
                        ? widget.policyResponse.daireBrut.toString()
                        : "",
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
                    readOnly: !_adresSelect,
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
                    /*  initialValue:
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
                        if (value == null || value == "")
                          return "Bina Bedeli giriniz";
                        else
                          return null;
                      }
                    },
                    onSaved: (value) {
                      _binaBedeli = value;
                      /*   var control = double.tryParse(value);
                      if (control != null)
                        policyResponseRenew.binaBedeli = double.parse(value); */
                    }),
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
                    /*  initialValue:
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
                    onSaved: (value) {
                      _esyaBedeli = value;
                      /*  var control = double.tryParse(value);
                      if (control != null)
                        policyResponseRenew.esyaBedeli = double.parse(value); */
                    }),
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
                      (widget.policyResponse.adres != "" &&
                          RegExp(r'(^[a-zA-Z]{3}$)')
                              .hasMatch(widget.policyResponse.adres)),
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
        /* List itemList = await Utils.getAracTip(_marka); */
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
        break;
       
      default:
        return null;
    }
  }
}
