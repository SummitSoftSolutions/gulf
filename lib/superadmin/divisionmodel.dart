class DivisionList {
  DivisionList(this.id, this.divisionid,this.divisionname,this.zoneid__zonename,this.countryid__countryname,this.zoneid,this.countryid,this.zoneid__zoneid);

  int id;
  String divisionid;
  String divisionname;
  String zoneid__zonename;
  String countryid__countryname;
  String zoneid;
  String countryid;
  String zoneid__zoneid;





  DivisionList.fromJson(Map json)
      : id=json['id'],
        divisionname=json['divisionname'],
        divisionid = json['divisionid'].toString(),
        zoneid__zonename=json['zoneid__zonename'].toString(),
        countryid__countryname=json['countryid__countryname'].toString(),
        zoneid=json['zoneid'].toString(),
        zoneid__zoneid = json['zoneid__zoneid'].toString(),
        countryid=json['countryid'].toString();


  Map toJson() {
    return {

      'id': id,
      'divisionname': divisionname,
      'divisionid':divisionid,
      'zoneid__zonename':zoneid__zonename,
      'countryid__countryname':countryid__countryname,
      'zoneid':zoneid,
      'countryid':countryid,
      'zoneid__zoneid':zoneid__zoneid,

    };
  }

}
