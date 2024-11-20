class Login {
  Login(this.id, this.firstname,this.coordinatorid,this.phone);

  int id;
  String coordinatorid;
  String firstname;
  String phone;





  Login.fromJson(Map json)
      : id=json['id'] ?? '',
        coordinatorid = json['coordinatorid'].toString()  ?? '',
        firstname=json['firstname']  ?? '',
        phone=json['phone']  ?? '';



  Map toJson() {
    return {

      'id': id,
      'coordinatorid':coordinatorid,
      'firstname': firstname,
      'phone':phone,
    };
  }

}
