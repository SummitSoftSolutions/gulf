class AccountList{
  AccountList(this.id,this.name,this.code,this.parentid,this.openbalance,this.isdebut,this.parentid__name);

  int id;
  String name;
  String code;
  String parentid;
  String openbalance;
  String isdebut;
  String parentid__name;

  AccountList.fromJson(Map json)
      : id=json['id'],
        code=json['code'].toString(),
        name=json['name'].toString(),
        parentid=json['name'].toString(),
        isdebut=json['name'].toString(),
        parentid__name=json['name'].toString(),
        openbalance=json['name'].toString();



  Map toJson() {
    return {

      'id': id,
      'name': name,
      'code':code,
      'parentid':parentid,
      'openbalance':openbalance,
      'isdebut':isdebut,
      'parentid__name':parentid__name,
    };
  }

}
