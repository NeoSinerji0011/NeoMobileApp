class ILCE {
    String ilKodu;
    String ilceAdi;
    int ilceKodu;
    String ulkeKodu;

    ILCE({this.ilKodu, this.ilceAdi, this.ilceKodu, this.ulkeKodu});

    factory ILCE.fromJson(Map<String, dynamic> json) {
        return ILCE(
            ilKodu: json['ilKodu'],
            ilceAdi: json['ilceAdi'],
            ilceKodu: json['ilceKodu'],
            ulkeKodu: json['ulkeKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['IlKodu'] = this.ilKodu;
        data['IlceAdi'] = this.ilceAdi;
        data['IlceKodu'] = this.ilceKodu;
        data['UlkeKodu'] = this.ulkeKodu;
        return data;
    }
}