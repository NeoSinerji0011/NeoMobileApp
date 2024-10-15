class IL {
    String ilAdi;
    String ilKodu;
    String ulkeKodu;

    IL({this.ilKodu,this.ilAdi,  this.ulkeKodu});

    factory IL.fromJson(Map<String, dynamic> json) {
        return IL(
            ilAdi: json['ilAdi'],
            ilKodu: json['ilKodu'],
            ulkeKodu: json['ulkeKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['IlAdi'] = this.ilAdi;
        data['IlKodu'] = this.ilKodu;
        data['UlkeKodu'] = this.ulkeKodu;
        return data;
    }
}