class UserListData {
  UserListData(this.id, this.Name,this.accountID,this.mobileno,this.whatsno,this.startdate,this.regid,this.email,this.postbox,this.flatno,this.floor,this.addressl,this.countryid,this.zoneid,this.divisionid,this.clusterid,this.subid,this.givenamount,this.coordinatorid,this.enddate,this.officetel,this.residencetel,this.subscriberid);

  int id;
  String Name;
  String mobileno;
  String whatsno;
  String startdate;
  String enddate;
  String officetel;
  String residencetel;
  String email;
  String postbox;
  String flatno;
  String floor;
  String addressl;
  String countryid;
  String zoneid;
  String divisionid;
  String clusterid;
  String subscriberid;
  String subid;
  String givenamount;
  String coordinatorid;
  String regid;
  int accountID;





  UserListData.fromJson(Map json)
      : id=json['id'],
        Name=json['Name'].toString(),
        accountID=json['accountID'],
        mobileno = json['mobileno'],
        whatsno=json['whatsno'],
        startdate=json['startdate'],
        enddate=json['enddate'],
        officetel=json['officetel'],
        residencetel=json['residencetel'],
        email=json['email'],
        postbox=json['postbox'],
        flatno=json['flatno'],
        floor=json['floor'],
        addressl=json['addressl'],
        countryid=json['countryid'],
        zoneid=json['zoneid'],
        divisionid=json['divisionid'],
        clusterid=json['clusterid'],
        subscriberid=json['subscriberid'],
        subid=json['subid'],
        givenamount=json['givenamount'],
        regid=json['regid'],
        coordinatorid = json['coordinatorid'];




  Map toJson() {
    return {

      'id': id,
      'Name': Name,
      'accountID':accountID,
    };
  }

}
