class ZoneList {
  ZoneList(this.id, this.zonename,this.zoneid,this.countryid,this.countryid__countryname);

  int id;
  String zonename;
  String zoneid;
  int countryid;
  String countryid__countryname;



  ZoneList.fromJson(Map json)
      : id=json['id'],
        zoneid=json['zoneid'].toString(),
        countryid = json['countryid'],
        countryid__countryname = json['countryid__countryname'],
        zonename=json['zonename'].toString();


  Map toJson() {
    return {

      'id': id,
      'zonename': zonename,
       'zoneid':zoneid,
      'countryid':countryid,
      'countryid__countryname':countryid__countryname,



    };
  }

}
