class CoorListData {
  CoorListData(this.Id, this.firstname,this.lastname,this.date,this.age,this.gender,this.phone,this.place,this.country_id,this.zone_id,this.division_id,this.coordinatorid,this.cluster_id);

  int Id;
  String firstname;
  String lastname;
  String date;
  String age;
  String gender;
  String phone;
  String place;
  String country_id;
  String zone_id;
  String division_id;
  String cluster_id;
  String coordinatorid;




  CoorListData.fromJson(Map json)
      : Id=json['id'],
        firstname=json['firstname'],
        lastname = json['lastname'],
        date = json['date'],
        age =  json['age'],
        gender = json['gender'],
        phone = json['phone'],
        place =  json['place'],
        country_id = json['country_id'],
        zone_id = json['zone_id'],
        division_id = json['division_id'],
        cluster_id = json['cluster_id'],
        coordinatorid = json['coordinatorid'].toString();



  Map toJson() {
    return {

      'Id': Id,
      'firstname': firstname,
      'lastname':lastname,
      'date' : date,
      'age':age,
      'gender':gender,
      'phone':phone,
      'place':place,
      'country_id':country_id,
      'zone_id':zone_id,
      'division_id':division_id,
      'cluster_id':cluster_id,
      'coordinatorid':coordinatorid,
    };
  }

}
