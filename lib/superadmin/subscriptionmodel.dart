class ZoneData {
  ZoneData(this.id, this.subscribername,this.subscriberamount);

  int id;
  String subscribername;
  String subscriberamount;




  ZoneData.fromJson(Map json)
      : id=json['id'],
        subscribername=json['subscribername'].toString(),
        subscriberamount = json['subscriberamount'];



  Map toJson() {
    return {

      'id': id,
      'subscribername': subscribername,
      'subscriberamount':subscriberamount,
    };
  }

}
