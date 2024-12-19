class AracMarka {
    String markaAdi;
    String markaKodu;

    AracMarka({this.markaAdi, this.markaKodu});

    factory AracMarka.fromJson(Map<String, dynamic> json) {
        return AracMarka(
            markaAdi: json['markaAdi'],
            markaKodu: json['markaKodu'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['MarkaAdi'] = this.markaAdi;
        data['MarkaKodu'] = this.markaKodu;
        return data;
    }
}