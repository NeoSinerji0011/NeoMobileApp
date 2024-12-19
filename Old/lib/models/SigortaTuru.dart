
class SigortaTuru {
    String bransAdi;
    int bransKodu;
    int durum;

    SigortaTuru({this.bransAdi, this.bransKodu, this.durum});

    factory SigortaTuru.fromJson(Map<String, dynamic> json) {
        return SigortaTuru(
            bransAdi: json['bransAdi'].toString(),
            bransKodu: json['bransKodu'],
            durum: json['durum'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['BransAdi'] = this.bransAdi;
        data['BransKodu'] = this.bransKodu;
        data['Durum'] = this.durum;
        return data;
    }
}