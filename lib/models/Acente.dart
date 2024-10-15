class Acente {
  int acentSuvbeVar;
  String adres;
  int baglantiSiniri;
  int bagliOlduguTVMKodu;
  Object banner;
  int bolgeKodu;
  int bolgeYetkilisiMi;
  int durum;
  Object durumGuncallemeTarihi;
  String email;
  String fax;
  Object grupKodu;
  String ilKodu;
  int ilceKodu;
  Object ipmiMacmi;
  String kayitNo;
  int kodu;
  Object latitude;
  Object logo;
  Object longitude;
  String mobilDogrulama;
  String muhasebeEntegrasyon;
  Object notlar;
  int policeTransfer;
  int profili;
  String projeKodu;
  Object semt;
  int sifreDegistirmeGunu;
  int sifreIkazGunu;
  int sifreKontralSayisi;
  Object sonPoliceOnayTarihi;
  String sozlesmeBaslamaTarihi;
  String sozlesmeDondurmaTarihi;
  String tCKN;
  String telefon;
  int tipi;
  Object ucretlendirmeKodu;
  String ulkeKodu;
  String unvani;
  String vergiDairesi;
  String vergiNumarasi;
  Object webAdresi;

  Acente(
      {this.acentSuvbeVar,
      this.adres,
      this.baglantiSiniri,
      this.bagliOlduguTVMKodu,
      this.banner,
      this.bolgeKodu,
      this.bolgeYetkilisiMi,
      this.durum,
      this.durumGuncallemeTarihi,
      this.email,
      this.fax,
      this.grupKodu,
      this.ilKodu,
      this.ilceKodu,
      this.ipmiMacmi,
      this.kayitNo,
      this.kodu,
      this.latitude,
      this.logo,
      this.longitude,
      this.mobilDogrulama,
      this.muhasebeEntegrasyon,
      this.notlar,
      this.policeTransfer,
      this.profili,
      this.projeKodu,
      this.semt,
      this.sifreDegistirmeGunu,
      this.sifreIkazGunu,
      this.sifreKontralSayisi,
      this.sonPoliceOnayTarihi,
      this.sozlesmeBaslamaTarihi,
      this.sozlesmeDondurmaTarihi,
      this.tCKN,
      this.telefon,
      this.tipi,
      this.ucretlendirmeKodu,
      this.ulkeKodu,
      this.unvani,
      this.vergiDairesi,
      this.vergiNumarasi,
      this.webAdresi});

  factory Acente.fromJson(Map<String, dynamic> json) {
    return Acente(
      acentSuvbeVar: json['AcentSuvbeVar'],
      adres: json['Adres'],
      baglantiSiniri: json['BaglantiSiniri'],
      bagliOlduguTVMKodu: json['BagliOlduguTVMKodu'],
      banner: json['banner'],
      bolgeKodu: json['BolgeKodu'],
      bolgeYetkilisiMi: json['BolgeYetkilisiMi'],
      durum: json['durum'],
      durumGuncallemeTarihi: json['DurumGuncallemeTarihi'],
      email: json['email'],
      fax: json['fax'],
      grupKodu: json['GrupKodu'],
      ilKodu: json['IlKodu'],
      ilceKodu: json['IlceKodu'],
      ipmiMacmi: json['IpmiMacmi'],
      kayitNo: json['KayitNo'],
      kodu: json['kodu'],
      latitude: json['Latitude'],
      logo: json['logo'],
      longitude: json['Longitude'],
      mobilDogrulama: json['MobilDogrulama'],
      muhasebeEntegrasyon: json['MuhasebeEntegrasyon'],
      notlar: json['Notlar'],
      policeTransfer: json['PoliceTransfer'],
      profili: json['Profili'],
      projeKodu: json['ProjeKodu'],
      semt: json['Semt'],
      sifreDegistirmeGunu: json['SifreDegistirmeGunu'],
      sifreIkazGunu: json['SifreIkazGunu'],
      sifreKontralSayisi: json['SifreKontralSayisi'],
      sonPoliceOnayTarihi: json['SonPoliceOnayTarihi'],
      sozlesmeBaslamaTarihi: json['SozlesmeBaslamaTarihi'],
      sozlesmeDondurmaTarihi: json['SozlesmeDondurmaTarihi'],
      tCKN: json['TCKN'],
      telefon: json['telefon'],
      tipi: json['Tipi'],
      ucretlendirmeKodu: json['TcretlendirmeKodu'],
      ulkeKodu: json['UlkeKodu'],
      unvani: json['unvani'],
      vergiDairesi: json['VergiDairesi'],
      vergiNumarasi: json['VergiNumarasi'],
      webAdresi: json['webAdresi'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AcentSuvbeVar'] = this.acentSuvbeVar;
    data['BaglantiSiniri'] = this.baglantiSiniri;
    data['BagliOlduguTVMKodu'] = this.bagliOlduguTVMKodu;
    data['BolgeKodu'] = this.bolgeKodu;
    data['BolgeYetkilisiMi'] = this.bolgeYetkilisiMi;
    data['Durum'] = this.durum;
    data['Email'] = this.email;
    data['Fax'] = this.fax;
    data['IlKodu'] = this.ilKodu;
    data['IlceKodu'] = this.ilceKodu;
    data['KayitNo'] = this.kayitNo;
    data['Kodu'] = this.kodu;
    data['MuhasebeEntegrasyon'] = this.muhasebeEntegrasyon;
    data['PoliceTransfer'] = this.policeTransfer;
    data['Profili'] = this.profili;
    data['SifreDegistirmeGunu'] = this.sifreDegistirmeGunu;
    data['SifreIkazGunu'] = this.sifreIkazGunu;
    data['SifreKontralSayisi'] = this.sifreKontralSayisi;
    data['SozlesmeBaslamaTarihi'] = this.sozlesmeBaslamaTarihi;
    data['SozlesmeDondurmaTarihi'] = this.sozlesmeDondurmaTarihi;
    data['Telefon'] = this.telefon;
    data['Tipi'] = this.tipi;
    data['UlkeKodu'] = this.ulkeKodu;
    data['Unvani'] = this.unvani;
    data['VergiDairesi'] = this.vergiDairesi;
    data['VergiNumarasi'] = this.vergiNumarasi;
    data['Adres'] = this.adres;
    data['Banner'] = this.banner;
    data['DurumGuncallemeTarihi'] = this.durumGuncallemeTarihi;
    data['GrupKodu'] = this.grupKodu;
    data['IpmiMacmi'] = this.ipmiMacmi;
    data['Latitude'] = this.latitude;
    data['Logo'] = this.logo;
    data['Longitude'] = this.longitude;
    data['MobilDogrulama'] = this.mobilDogrulama;
    data['Notlar'] = this.notlar;
    data['ProjeKodu'] = this.projeKodu;
    data['Semt'] = this.semt;
    data['SonPoliceOnayTarihi'] = this.sonPoliceOnayTarihi;
    data['TCKN'] = this.tCKN;
    data['UcretlendirmeKodu'] = this.ucretlendirmeKodu;
    data['WebAdresi'] = this.webAdresi;
    return data;
  }
}
