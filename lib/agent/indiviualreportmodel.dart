class IndiviualReportListData {
  IndiviualReportListData(this.Id,this.date, this.name,this.Debit,this.Credit);

  int Id;
  String date;
  String name;
  String Debit;
  String Credit;





  IndiviualReportListData.fromJson(Map json)
      : date=json['date'],
        Id=json['Id'],
        name=json['name'].toString(),
        Debit=json['Debit'],
        Credit=json['Credit'];



  Map toJson() {
    return {

      'date': date,
      'Id': Id,
      'name': name,
      'Debit':Debit,
      'Credit':Credit,
    };
  }

}
