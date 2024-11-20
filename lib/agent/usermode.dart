class UserListData {
  UserListData(this.id, this.name, this.accountid,this.regid);

  int id;
  String name;
  int  accountid;
  String regid;// Make accountID nullable

  UserListData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'].toString(),
        regid = json['regid'].toString(),
        accountid = json['accountid']; // Parse accountID as int?

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountid': accountid,
      'regid':regid,
    };
  }
}
