class AcilArama {
    String acilIsim;
    String telefonNo;

    AcilArama({this.acilIsim, this.telefonNo});

    factory AcilArama.fromJson(Map<String, dynamic> json) {
        return AcilArama(
            acilIsim: json['AcilIsim'],
            telefonNo: json['TelefonNo'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['AcilIsim'] = this.acilIsim;
        data['TelefonNo'] = this.telefonNo;
        return data;
    }
}


 