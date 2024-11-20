class Item {
  Item(this.id, this.commitycreation);

  String id;
  String commitycreation;


  Item.fromJson(Map json)
      : id=json['id'].toString(),
        commitycreation=json['commitycreation'];

  Map toJson() {
    return {

      'id': id,
      'commitycreation': commitycreation,


    };
  }

}
