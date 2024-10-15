class PolicyResponse {
  String acenteAdi;
  String acenteTelNo; 
  String pdfUrl; 
  String manuelMi;  
  int acenteUnvani;
  String aciklama;
  String adres;
  String aracKullanimTarzi;
  String asbisNo;
  String baslangicTarihi;
  double binaBedeli;
  int binaKatSayisi;
  int binaKullanimSekli;
  int binaYapiTarzi;
  int binaYapimYili;
  String bitisTarihi;
  int bransKodu;
  int daireBrut;
  String oncekiTVM_Kodu;
  double esyaBedeli;
  int id;
  String ilKodu;
  int ilceKodu;
  String kimlikNo;
  String markaKodu;
  String meslek;
  int modelYili;
  String plaka;
  String policeNumarasi;
  String ruhsatSeriKodu;
  String ruhsatSeriNo;
  String seyahatDonusTarihi;
  int seyahatEdenKisiSayisi;
  String seyahatGidisTarihi;
  String seyahatUlkeKodu;
  String sirketKodu;
  int teklifIslemNo;
  int teklifPolice;
  String tipKodu;
  int teklifTipi;
  int yenilemeNo;
  int kullaniciGonderiTuru;//hasar bildiriminde poliçenin acentesi yoksa şirkete telefon veya mail yoluyla mı iletişime geçileceğinin türünü tutan değişken --1:mail,2:telefon
  List<String> images;

  PolicyResponse(
      {this.acenteUnvani,
      this.acenteAdi,
      this.pdfUrl,
      this.manuelMi, 
      this.acenteTelNo,
      this.aciklama,
      this.adres,
      this.aracKullanimTarzi,
      this.asbisNo,
      this.baslangicTarihi = "Bulunamadı",
      this.binaBedeli,
      this.binaKatSayisi,
      this.binaKullanimSekli,
      this.binaYapiTarzi,
      this.binaYapimYili,
      this.bitisTarihi,
      this.bransKodu,
      this.daireBrut,
      this.oncekiTVM_Kodu,
      this.esyaBedeli,
      this.id,
      this.ilKodu,
      this.ilceKodu,
      this.kimlikNo,
      this.markaKodu,
      this.meslek,
      this.modelYili,
      this.plaka,
      this.policeNumarasi,
      this.ruhsatSeriKodu,
      this.ruhsatSeriNo,
      this.seyahatDonusTarihi,
      this.seyahatEdenKisiSayisi,
      this.seyahatGidisTarihi,
      this.seyahatUlkeKodu,
      this.sirketKodu,
      this.teklifIslemNo,
      this.teklifPolice,
      this.tipKodu,
      this.teklifTipi,
      this.yenilemeNo,
      this.images});

  factory PolicyResponse.fromJson(Map<dynamic, dynamic> json) {
    return PolicyResponse(
      acenteUnvani: json['acenteUnvani'],
      acenteAdi: json['acenteAdi'],
      pdfUrl: json['pdfUrl'],
      manuelMi: json['manuelMi'], 
      acenteTelNo: json['acenteTelNo'],
      aciklama: json['aciklama'],
      adres: json['adres'],
      aracKullanimTarzi: json['aracKullanimTarzi'],
      asbisNo: json['asbisNo'],
      baslangicTarihi: json['baslangicTarihi'],
      binaBedeli: json['binaBedeli']=="0"?json['binaBedeli']+0.0:0.0,
      binaKatSayisi: json['binaKatSayisi'],
      binaKullanimSekli: json['binaKullanimSekli'],
      binaYapiTarzi: json['binaYapiTarzi'],
      binaYapimYili: json['binaYapimYili'],
      bitisTarihi: json['bitisTarihi'],
      bransKodu: json['bransKodu'],
      daireBrut: json['daireBrut'],
      oncekiTVM_Kodu: json['OncekiTVM_Kodu'],
      esyaBedeli:json['esyaBedeli']=="0"?json['esyaBedeli']+0.0:0.0,
      id: json['id'],
      ilKodu: json['ilKodu'],
      ilceKodu: json['ilceKodu'],
      kimlikNo: json['kimlikNo'],
      markaKodu: json['markaKodu'],
      meslek: json['meslek'],
      modelYili: json['modelYili'],
      plaka: json['plaka'],
      policeNumarasi: json['policeNumarasi'],
      ruhsatSeriKodu: json['ruhsatSeriKodu'],
      ruhsatSeriNo: json['ruhsatSeriNo'],
      seyahatDonusTarihi: json['seyahatDonusTarihi'],
      seyahatEdenKisiSayisi: json['seyahatEdenKisiSayisi'],
      seyahatGidisTarihi: json['seyahatGidisTarihi'],
      seyahatUlkeKodu: json['seyahatUlkeKodu'],
      sirketKodu: json['sirketKodu'],
      teklifIslemNo: json['teklifIslemNo'],
      teklifPolice: json['teklifPolice'],
      tipKodu: json['tipKodu'],
      teklifTipi: json['TeklifTipi'],
      yenilemeNo: json['yenilemeNo'],
    
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acenteUnvani'] = this.acenteUnvani;
    data['acenteAdi'] = this.acenteAdi; 
    data['pdfUrl'] = this.pdfUrl;
    data['manuelMi'] = this.manuelMi; 
    data['acenteTelNo'] = this.acenteTelNo; 
    data['aciklama'] = this.aciklama;
    data['adres'] = this.adres;
    data['aracKullanimTarzi'] = this.aracKullanimTarzi;
    data['asbisNo'] = this.asbisNo;
    data['baslangicTarihi'] = this.baslangicTarihi;
    data['binaBedeli'] = this.binaBedeli;
    data['binaKatSayisi'] = this.binaKatSayisi;
    data['binaKullanimSekli'] = this.binaKullanimSekli;
    data['binaYapiTarzi'] = this.binaYapiTarzi;
    data['binaYapimYili'] = this.binaYapimYili;
    data['bitisTarihi'] = this.bitisTarihi;
    data['bransKodu'] = this.bransKodu;
    data['daireBrut'] = this.daireBrut;
    data['oncekiTVM_Kodu'] = this.oncekiTVM_Kodu;
    data['esyaBedeli'] = this.esyaBedeli;
    data['id'] = this.id;
    data['ilKodu'] = this.ilKodu;
    data['ilceKodu'] = this.ilceKodu;
    data['kimlikNo'] = this.kimlikNo;
    data['markaKodu'] = this.markaKodu;
    data['meslek'] = this.meslek;
    data['modelYili'] = this.modelYili;
    data['plaka'] = this.plaka;
    data['policeNumarasi'] = this.policeNumarasi;
    data['ruhsatSeriKodu'] = this.ruhsatSeriKodu;
    data['ruhsatSeriNo'] = this.ruhsatSeriNo;
    data['seyahatDonusTarihi'] = this.seyahatDonusTarihi;
    data['seyahatEdenKisiSayisi'] = this.seyahatEdenKisiSayisi;
    data['seyahatGidisTarihi'] = this.seyahatGidisTarihi;
    data['seyahatUlkeKodu'] = this.seyahatUlkeKodu;
    data['sirketKodu'] = this.sirketKodu;
    data['teklifIslemNo'] = this.teklifIslemNo;
    data['teklifPolice'] = this.teklifPolice;
    data['tipKodu'] = this.tipKodu;
    data['teklifTipi'] = this.teklifTipi;
    data['yenilemeNo'] = this.yenilemeNo;
    return data;
  }
}
