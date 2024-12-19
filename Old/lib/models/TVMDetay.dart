class TVMDetay {
  int kodu;
  String unvani;
  int durum;
  String telefon;
  String fax;
  String email;
  String webAdresi;
  String banner;
  String logo;
  TVMDetay(
      {this.kodu,
      this.unvani,
      this.durum,
      this.telefon,
      this.fax,
      this.email,
      this.webAdresi,
      this.banner,
      this.logo});

  factory TVMDetay.fromJson(Map<String, dynamic> json) {
    return TVMDetay(
      kodu: json['kodu'],
      unvani: json['unvani'],
      durum: json['durum'],
      telefon: json['telefon'],
      fax: json['fax'],
      email: json['email'],
      webAdresi: json['webAdresi'],
      banner: json['banner'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>(); 
    data['kodu'] = this.kodu;
    data['unvani'] = this.unvani;
    data['durum'] = this.durum;
    data['telefon'] = this.telefon;
    data['fax'] = this.fax;
    data['email'] = this.email;
    data['webAdresi'] = this.webAdresi;
    data['banner'] = this.banner;
    data['logo'] = this.logo;
    return data;
  }
}
