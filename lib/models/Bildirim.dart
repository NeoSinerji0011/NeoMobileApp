class Bildirim {
  int id;
  String kimlikNo;
  String policeNumarasi;
  String bitisTarihi; 

  Bildirim(
      {this.id,
      this.kimlikNo,
      this.policeNumarasi,
      this.bitisTarihi });

  factory Bildirim.fromJson(Map<String, dynamic> json) {
    return Bildirim(
      id: json['id'],
      kimlikNo: json['kimlikNo'],
      policeNumarasi: json['policeNumarasi'],
      bitisTarihi: json['bitisTarihi'], 
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kimlikNo'] = this.kimlikNo;
    data['policeNumarasi'] = this.policeNumarasi;
    data['bitisTarihi'] = this.bitisTarihi; 
    return data;
  }
}
