class SubscriberList {
  SubscriberList(this.id, this.subscribername,this.subscriberamount,this.subscription);

  int id;
  String subscribername;
  int subscription;
  int subscriberamount;




  SubscriberList.fromJson(Map json)
      : id=json['id'],
        subscribername=json['subscribername'].toString(),
        subscriberamount = json['subscriberamount'],
        subscription = json['subscription'] is int
            ? json['subscription']
            : int.tryParse(json['subscription'].toString()) ?? 0;



  Map toJson() {
    return {

      'id': id,
      'subscribername': subscribername,
      'subscriberamount':subscriberamount,
      'subscription':subscription,
    };
  }

}
