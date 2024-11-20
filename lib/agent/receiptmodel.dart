import 'dart:convert';

class ReceiptModelData {
  ReceiptModelData(this.id,this.account_id,this.coordinatorid, this.accountID,this.amount,this.recdate,this.receiptID,this.account_name,this.firstname);

  int id;
  int accountID;
  int amount;
  String recdate;
  int receiptID;
  String account_name;
  String firstname;
  String coordinatorid;
  String account_id;





  ReceiptModelData.fromJson(Map json)
      : id=json['id'],
        accountID=json['accountID'],
        amount = json['amount'],
        recdate=json['recdate'].toString(),
        account_name=json['account_name'].toString(),
        firstname=json['firstname'].toString(),
        receiptID=json['receiptID'],
        coordinatorid=json['coordinatorid'].toString(),
        account_id=json['account_id'].toString();




  Map toJson() {
    return {
      'id': id,
      'accountID': accountID,
      'clustername':amount,
      'recdate':recdate,
      'receiptID':receiptID,
      'name':account_name.toString(),
      'firstname':firstname.toString(),
      'coordinatorid':coordinatorid.toString(),
      'account_id':account_id.toString(),
    };
  }

}
