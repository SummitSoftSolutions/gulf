class CountryList {
  CountryList(this.id, this.countryname);

  String id;
  String countryname;


  CountryList.fromJson(Map json)
      : id=json['id'].toString(),
        countryname=json['countryname'];

  Map toJson() {
    return {

      'id': id,
      'countryname': countryname,


    };
  }

}
