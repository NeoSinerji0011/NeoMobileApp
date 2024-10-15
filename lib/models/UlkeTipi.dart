class UlkeTipi { 
    String ulkeTipiAdi;
    int ulkeTipiKodu;

    UlkeTipi({ this.ulkeTipiKodu,this.ulkeTipiAdi});

    factory UlkeTipi.fromJson(Map<dynamic, dynamic> json) {
        return UlkeTipi( 
            ulkeTipiAdi: json['ulkeTipiAdi'],
            ulkeTipiKodu: json['ulkeTipiKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<dynamic, dynamic>(); 
        data['UlkeTipiAdi'] = this.ulkeTipiAdi;
        data['UlkeTipiKodu'] = this.ulkeTipiKodu;
        return data;
    }
}