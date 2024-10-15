class Bildirim {
  String policeid;
  String riziko;
  String riziko1;
  String bransAdi;
  String bransicon;
  String bitisTarihi;
  String policeTur;
  String alarm;
  String adet;
  String isRead;
  String talepNo;
  String dosya;

  Bildirim(
      {this.policeid,
      this.riziko,
      this.riziko1,
      this.bransAdi,
      this.bransicon,
      this.bitisTarihi,
      this.policeTur,
      this.alarm,
      this.adet,
      this.isRead,
      this.talepNo,
      this.dosya});

  factory Bildirim.fromJson(Map<String, dynamic> json) {
    return Bildirim(
      policeid: json['Policeid'],
      riziko: json['Riziko'],
      riziko1: json['Riziko1'],
      bransAdi: json['BransAdi'],
      bransicon: json['BransIcon'],
      bitisTarihi: json['BitisTarihi'],
      policeTur: json['PoliceTur'],
      alarm: json['Alarm'],
      adet: json['Adet'],
      isRead: json['Okundumu'],
      talepNo: json['TalepNo'],
      dosya: json['Dosya'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Policeid'] = this.policeid;
    data['Riziko'] = this.riziko;
    data['Riziko1'] = this.riziko1;
    data['BransAdi'] = this.bransAdi;
    data['BransIcon'] = this.bransicon;
    data['BitisTarihi'] = this.bitisTarihi;
    data['PoliceTur'] = this.policeTur;
    data['Alarm'] = this.alarm;
    data['Adet'] = this.adet;
    data['Okundumu'] = this.isRead;
    data['TalepNo'] = this.talepNo;
    data['Dosya'] = this.dosya;
    return data;
  }
}
