

class HasarPostMessage {
  int status;
  String message;
  int hasarTalepNo;
  var data;
  int sayac;
  List sirketlist;
  List modelList;
  List kullanimSekilList;
  List markaList;
  List aracTipList;
  List ilList;
  List ilceList;
  List meslekList;
  List ulkeList;
  List bransList;

  HasarPostMessage(
      {this.status,
      this.message,
      this.hasarTalepNo,
      this.data,
      this.sayac,
      this.sirketlist,
      this.modelList,
      this.kullanimSekilList,
      this.markaList,
      this.aracTipList,
      this.ilList,
      this.ilceList,
      this.meslekList,
      this.ulkeList,
      this.bransList});

  factory HasarPostMessage.fromJson(Map<String, dynamic> json) {
    return HasarPostMessage(
        status: json['status'],
        hasarTalepNo: json['hasarTalepNo'],
        data: json['data'],
        sayac: json['sayac'],
        sirketlist: json['sirketlist'],
        modelList: json['modellist'],
        kullanimSekilList: json['kullanimsekillist'],
        markaList: json['markalist'],
        aracTipList: json['aracTipList'],
        ilList: json['ilList'],
        ilceList: json['ilceList'],
        meslekList: json['meslekList'],
        ulkeList: json['ulkeList'],
        bransList: json['bransList']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['hasarTalepNo'] = this.hasarTalepNo;
    data['data'] = this.data;
    data['sayac'] = this.sayac;
    data['sirketlist'] = this.sirketlist;
    data['modelList'] = this.modelList;
    data['kullanimSekilList'] = this.kullanimSekilList;
    data['markaList'] = this.markaList;
    data['aracTipList'] = this.aracTipList;
    data['ilList'] = this.ilList;
    data['ilceList'] = this.ilceList;
    data['meslekList'] = this.meslekList;
    data['ulkeList'] = this.ulkeList;
    data['bransList'] = this.bransList;
    return data;
  }
}
