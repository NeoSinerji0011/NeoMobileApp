class Meslek {
    String meslekAdi;
    int meslekKodu;

    Meslek({this.meslekAdi, this.meslekKodu});

    factory Meslek.fromJson(Map<String, dynamic> json) {
        return Meslek(
            meslekAdi: json['meslekAdi'],
            meslekKodu: json['meslekKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['MeslekAdi'] = this.meslekAdi;
        data['MeslekKodu'] = this.meslekKodu;
        return data;
    }
}