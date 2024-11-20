class ClusterList {
  ClusterList(this.id, this.clusterid,this.clustername,this.zoneid__zonename,this.divisionid__divisionname,this.countryid__countryname,this.zoneid,this.countryid,this.divisionid,this.zoneid__zoneid);

  int id;
  String clusterid;
  String clustername;
  String zoneid__zonename;
  String divisionid__divisionname;
  String countryid__countryname;
  String zoneid;
  String countryid;
  String divisionid;
  String zoneid__zoneid;




  ClusterList.fromJson(Map json)
      : id=json['id'],
        clusterid=json['clusterid'],
        clustername = json['clustername'].toString(),
        zoneid__zonename = json['zoneid__zonename'].toString(),
        divisionid__divisionname = json['divisionid__divisionname'].toString(),
        countryid__countryname=json['countryid__countryname'].toString(),
        zoneid=json['zoneid'].toString(),
        countryid=json['countryid'].toString(),
        divisionid=json['divisionid'].toString(),
        zoneid__zoneid=json['zoneid__zoneid'].toString();



  Map toJson() {
    return {

      'id': id,
      'clusterid': clusterid,
      'clustername':clustername,
      'zoneid__zonename':zoneid__zonename,
      'divisionid__divisionname':divisionid__divisionname,
      'countryid__countryname':countryid__countryname,
      'zoneid':zoneid,
      'countryid':countryid,
      'divisionid':divisionid,
      "zoneid__zoneid":zoneid__zoneid,



    };
  }

}
