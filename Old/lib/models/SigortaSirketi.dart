class SigortaSirketi {
  String email;
  String sirketAdi;
  String sirketKodu;
  String sirketLogo;
  String telefon;
  int uygulamaKodu;
  String vergiDairesi;
  String vergiNumarasi;

  SigortaSirketi({this.email, this.sirketAdi, this.sirketKodu, this.sirketLogo, this.telefon, this.uygulamaKodu, this.vergiDairesi, this.vergiNumarasi});

  factory SigortaSirketi.fromJson(Map<String, dynamic> json) {
    return SigortaSirketi(
      email: json['email'],
      sirketAdi: json['sirketAdi'],
      sirketKodu: json['sirketKodu'],
      sirketLogo: json['sirketLogo'],
      telefon: json['telefon'],
      uygulamaKodu: json['uygulamaKodu'],
      vergiDairesi: json['vergiDairesi'],
      vergiNumarasi: json['vergiNumarasi'],
    );
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['SirketAdi'] = this.sirketAdi;
    data['SirketKodu'] = this.sirketKodu;
    data['Telefon'] = this.telefon;
    data['SirketLogo'] = this.sirketLogo;
    data['UygulamaKodu'] = this.uygulamaKodu;
    data['VergiDairesi'] = this.vergiDairesi;
    data['VergiNumarasi'] = this.vergiNumarasi;
    return data;
  }
}
