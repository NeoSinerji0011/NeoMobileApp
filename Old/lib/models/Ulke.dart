class Ulke {
    int id;
    String ulkeAdi;
    String ulkeKodu; 
    int ulkeTipiKodu;

    Ulke({this.id, this.ulkeTipiKodu, this.ulkeKodu, this.ulkeAdi});

    factory Ulke.fromJson(Map<String, dynamic> json) {
        return Ulke(
            id: json['id'],
            ulkeAdi: json['ulkeAdi'],
            ulkeKodu: json['ulkeKodu'], 
            ulkeTipiKodu: json['ulkeTipiKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Id'] = this.id;
        data['UlkeAdi'] = this.ulkeAdi;
        data['UlkeKodu'] = this.ulkeKodu; 
        data['UlkeTipiKodu'] = this.ulkeTipiKodu;
        return data;
    }
}