class GlobalResponse {
  int statusCode;
  String message;
  GlobalResponse({this.statusCode, this.message});

  factory GlobalResponse.fromJson(Map<String, dynamic> json) {
    return GlobalResponse(
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class LoginResponse {
  Kullanici kullanici;
  String token;

  LoginResponse({this.kullanici, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      kullanici: json['kullanici'] != null
          ? Kullanici.fromJson(json['kullanici'])
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.kullanici != null) {
      data['kullanici'] = this.kullanici.toJson();
    }
    return data;
  }
}

class Kullanici {
  String adres;
  String adsoyad;
  String durum;
  String eposta;
  String guvenlik;
  int id;
  String onaykodu;
  String resim;
  String sifre;
  String tc;
  String tc_es;
  String tc_cocuk;
  String tc_diger;
  String telefon;
  String gsm1;
  String gsm2;

  Kullanici({
    this.adres,
    this.adsoyad,
    this.durum,
    this.eposta,
    this.guvenlik,
    this.id,
    this.onaykodu,
    this.resim,
    this.sifre,
    this.tc,
    this.tc_es,
    this.tc_cocuk,
    this.tc_diger,
    this.telefon,
    this.gsm1,
    this.gsm2,
  });

  factory Kullanici.fromJson(Map<String, dynamic> json) {
    return Kullanici(
      adres: json['adres'],
      adsoyad: json['adsoyad'],
      durum: json['durum'],
      eposta: json['eposta'],
      guvenlik: json['guvenlik'],
      id: json['id'],
      onaykodu: json['onaykodu'],
      resim: json['resim'],
      //sifre: json['sifre'],
      sifre: "",
      tc: json['tc'],
      tc_es: json['tc_es'],
      tc_cocuk: json['tc_cocuk'],
      tc_diger: json['tc_diger'],
      telefon: json['telefon'],
      gsm1: json['gsm_1'],
      gsm2: json['gsm_2'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adres'] = this.adres;
    data['adsoyad'] = this.adsoyad;
    data['durum'] = this.durum;
    data['eposta'] = this.eposta;
    data['guvenlik'] = this.guvenlik;
    data['id'] = this.id;
    data['onaykodu'] = this.onaykodu;
    data['resim'] = this.resim;
    data['sifre'] = this.sifre;
    data['tc'] = this.tc;
    data['tc_es'] = this.tc_es;
    data['tc_cocuk'] = this.tc_cocuk;
    data['tc_diger'] = this.tc_diger;
    data['telefon'] = this.telefon;
    data['gsm_1'] = this.gsm1;
    data['gsm_2'] = this.gsm2;
    return data;
  }
}
