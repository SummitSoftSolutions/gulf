class User {
  User(this.role,this.coordinatorid	,this.firstname,this.id);

  final int role;
  String coordinatorid;
  String firstname;
  String id;

  User.fromJson(Map json)
      : role=json['role'] as int,
        coordinatorid = json['coordinatorid'].toString(),
        firstname=json['firstname'],
        id=json['Id'].toString();



  Map toJson() {
    return {
      'role': role,
      'coordinatorid':coordinatorid,
      'firstname': firstname,
      'Id': id,

    };

  }

}