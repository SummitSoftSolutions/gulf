class CoorList {
  CoorList(this.id, this.firstname);

  int id;
  String firstname;




  CoorList.fromJson(Map json)
      : id=json['id'],
        firstname=json['firstname'];




  Map toJson() {
    return {

      'id': id,
      'firstname': firstname,
    };
  }

}
