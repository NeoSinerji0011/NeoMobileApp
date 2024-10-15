class Destek {
    String destekIsim;
    String altisim;
    String altisim2;
    

    

    Destek({this.destekIsim,this.altisim,this.altisim2});

    factory Destek.fromJson(Map<String, dynamic> json) {
        return Destek(
            destekIsim: json['DestekIsim'],
            altisim: json['Altisim'],
            altisim2: json['Altisim2'],
          
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['DestekIsim'] = this.destekIsim;
        data['Altisim'] = this.altisim;
        data['Altisim2'] = this.altisim2;

        
        return data;
    }
}

