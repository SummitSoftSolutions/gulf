class CashList{
  CashList(this.id,this.name);

  int id;
  String name;


  CashList.fromJson(Map json)
      : id=json['id'],
        name=json['name'].toString();



  Map toJson() {
    return {

      'id': id,
      'name': name,
    };
  }

}
