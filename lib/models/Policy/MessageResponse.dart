import 'package:sigortadefterim/models/SigortaSirketi.dart';
import 'package:sigortadefterim/models/Acente.dart';

class MessageResponse {
  String ekSureDisplay;
  String firmaAdiDisplay;
  int id;
  bool isActive;
  bool isNewMessage=false;
  int policeId;
  int policeTip;
  int kullaniciId;
  String kullanici_Mesaj;
  String tarih_Saat;
  int acenteKodu;
  String sirketKodu;
  String token;
  String firma_Mesaji;
  String cevap_Suresi;
  String cevap_Tarihi;
  int kullanici_Gordumu;
  String policeNumarasi;
  int bransKodu;
  int talepNo;
  MessageResponse({
    this.ekSureDisplay,
    this.id,
    this.policeId,
    this.policeTip,
    this.kullaniciId,
    this.kullanici_Mesaj,
    this.tarih_Saat,
    this.acenteKodu,
    this.sirketKodu,
    this.token,
    this.firma_Mesaji,
    this.cevap_Suresi,
    this.cevap_Tarihi,
    this.kullanici_Gordumu,
    this.policeNumarasi,
    this.bransKodu,
    this.talepNo,
    this.isActive
  });

  factory MessageResponse.fromJson(Map<dynamic, dynamic> json) {
    return MessageResponse(
      ekSureDisplay: json["ekSureDisplay"],
      id: json["id"],
      isActive: json["isActive"],
      policeId: json["policeId"],
      policeTip: json["policeTip"],
      kullaniciId: json["kullaniciId"],
      kullanici_Mesaj: json["kullanici_Mesaj"],
      tarih_Saat: json["tarih_Saat"],
      acenteKodu: json["acenteKodu"],
      sirketKodu: json["sirketKodu"],
      token: json["token"],
      firma_Mesaji: json["firma_Mesaji"],
      cevap_Suresi: json["cevap_Suresi"],
      cevap_Tarihi: json["cevap_Tarihi"],
      kullanici_Gordumu: json["kullanici_Gordumu"],
      policeNumarasi: json["policeNumarasi"],
      bransKodu: json["bransKodu"],
      talepNo: json["talepNo"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ekSureDisplay'] = ekSureDisplay;
    data['id'] = id;
    data['isActive'] = isActive;
    data['policeId'] = policeId;
    data['policeTip'] = policeTip;
    data['kullaniciId'] = kullaniciId;
    data['kullanici_Mesaj'] = kullanici_Mesaj;
    data['tarih_Saat'] = tarih_Saat;
    data['acenteKodu'] = acenteKodu;
    data['sirketKodu'] = sirketKodu;
    data['token'] = token;
    data['firma_Mesaji'] = firma_Mesaji;
    data['cevap_Suresi'] = cevap_Suresi;
    data['cevap_Tarihi'] = cevap_Tarihi;
    data['kullanici_Gordumu'] = kullanici_Gordumu;
    data['policeNumarasi'] = policeNumarasi;
    data['bransKodu'] = bransKodu;
    data['talepNo'] = talepNo;
    return data;
  }
}
class MobilMessageResponse { 
  int id; 
  int oturumId; 
  String gonderici_Tip; 
  String mesaj;
  String tarih_Saat;   
  String goruldumu; 
  MobilMessageResponse({
    this.oturumId,
    this.id,
    this.gonderici_Tip,
    this.tarih_Saat, 
    this.mesaj, 
    this.goruldumu, 
  });

  factory MobilMessageResponse.fromJson(Map<dynamic, dynamic> json) {
    return MobilMessageResponse(
      oturumId: json["oturumId"],
      id: json["id"],
      gonderici_Tip: json["gonderici_Tip"],
      mesaj: json["mesaj"], 
      goruldumu: json["goruldumu"],
      tarih_Saat: json["tarih_Saat"], 
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data["oturumId"]= oturumId;
      data["id"]= id;
      data["gonderici_Tip"]= gonderici_Tip;
      data["mesaj"]= mesaj; 
      data["goruldumu"]= goruldumu;
      data["tarih_Saat"]= tarih_Saat; 
    return data;
  }
}
class MobilMessageDosyaResponse { 
  int id; 
  int mobilMessageId; 
  String dosyaUrl; 
  String dosyaTip;  
  MobilMessageDosyaResponse({
    this.id,
    this.mobilMessageId, 
    this.dosyaUrl, 
    this.dosyaTip, 
  });

  factory MobilMessageDosyaResponse.fromJson(Map<dynamic, dynamic> json) {
    return MobilMessageDosyaResponse(
      mobilMessageId: json["mobilMessageId"],
      id: json["id"],
      dosyaUrl: json["dosyaUrl"],
      dosyaTip: json["dosyaTip"],  
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data["dosyaTip"]= dosyaTip;
      data["id"]= id;
      data["dosyaUrl"]= dosyaUrl;
      data["mobilMessageId"]= mobilMessageId;  
    return data;
  }
}
class MessageInput {
  String policeNumarasi;
  int policeId;
  int talepNo;
  int policeTip;
  int kullaniciId;
  String kullanici_Mesaj;
  SigortaSirketi sigortaSirketi = SigortaSirketi(sirketAdi: "Sigorta Şirketi");
  Acente acenteObject = Acente(unvani: "Portal Üyesi Değil");
}
class MessageGlobal
{
  List<MessageResponse> messageSessionResponseList=List<MessageResponse>();
  List<MobilMessageResponse> mobilMessageResponseList=List<MobilMessageResponse>();
  List<MobilMessageDosyaResponse> mobilMessageDosyaList=List<MobilMessageDosyaResponse>();

}