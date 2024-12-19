class DamageFileResponse { 
  int mobilHasarId;
  int mobilTeklifId;
  String dosyaUrl; 
  String dosyaTipi; 
  DamageFileResponse(
      {this.mobilHasarId,
      this.mobilTeklifId,
      this.dosyaTipi,
      this.dosyaUrl, });

  factory DamageFileResponse.fromJson(Map<dynamic, dynamic> json) {
    return DamageFileResponse( 
      mobilHasarId: json['mobilHasarId'],
      mobilTeklifId: json['mobilTeklifId'], 
      dosyaUrl: json['dosyaUrl'], 
      dosyaTipi: json['dosyaTipi'],  
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobilHasarId'] = this.mobilHasarId;
    data['dosyaUrl'] = this.dosyaUrl;
    data['mobilTeklifId'] = this.mobilTeklifId; 
    data['dosyaTipi'] = this.dosyaTipi; 
    return data;
  }
}
