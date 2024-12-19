class AracTip {
  int kisiSayisi;
  String kullanimSekli1;
  String kullanimSekli2;
  String kullanimSekli3;
  String kullanimSekli4;
  String markaKodu;
  String tipAdi;
  String tipKodu;

  AracTip({this.kisiSayisi, this.kullanimSekli1, this.kullanimSekli2, this.kullanimSekli3, this.kullanimSekli4, this.markaKodu, this.tipAdi, this.tipKodu});

  factory AracTip.fromJson(Map<String, dynamic> json) {
    return AracTip(
      kisiSayisi: json['kisiSayisi'],
      kullanimSekli1: json['kullanimSekli1'],
      kullanimSekli2: json['kullanimSekli2'],
      kullanimSekli3: json['kullanimSekli3'],
      kullanimSekli4: json['kullanimSekli4'],
      markaKodu: json['markaKodu'],
      tipAdi: json['tipAdi'],
      tipKodu: json['tipKodu'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MarkaKodu'] = this.markaKodu;
    data['TipAdi'] = this.tipAdi;
    data['TipKodu'] = this.tipKodu;
    data['KisiSayisi'] = this.kisiSayisi;
    data['KullanimSekli1'] = this.kullanimSekli1;
    data['KullanimSekli2'] = this.kullanimSekli2;
    data['KullanimSekli3'] = this.kullanimSekli3;
    data['KullanimSekli4'] = this.kullanimSekli4;
    return data;
  }
}
