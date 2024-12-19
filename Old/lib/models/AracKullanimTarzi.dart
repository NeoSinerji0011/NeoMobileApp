class AracKullanimTarzi {
    int durum;
    String kod2;
    int kullanimSekliKodu;
    String kullanimTarzi;
    String kullanimTarziKodu;

    AracKullanimTarzi({this.durum, this.kod2, this.kullanimSekliKodu, this.kullanimTarzi, this.kullanimTarziKodu});

    factory AracKullanimTarzi.fromJson(Map<String, dynamic> json) {
        return AracKullanimTarzi(
            durum: json['durum'],
            kod2: json['kod2'],
            kullanimSekliKodu: json['kullanimSekliKodu'],
            kullanimTarzi: json['kullanimTarzi'],
            kullanimTarziKodu: json['kullanimTarziKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Durum'] = this.durum;
        data['Kod2'] = this.kod2;
        data['KullanimSekliKodu'] = this.kullanimSekliKodu;
        data['KullanimTarzi'] = this.kullanimTarzi;
        data['KullanimTarziKodu'] = this.kullanimTarziKodu;
        return data;
    }
}