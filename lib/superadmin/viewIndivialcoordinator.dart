import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gulf_suprabhaatham/superadmin/coordinator_viewadmin.dart';
import 'package:gulf_suprabhaatham/superadmin/zonemodel.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'clustermodel.dart';
import 'countrymodel.dart';
import 'divisionmodel.dart';

class viewIndiviualCoordinator extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  final int val;

  const viewIndiviualCoordinator({super.key, required this.firstname, required this.id, required this.isAdmin, required this.val});



  @override
  State<viewIndiviualCoordinator> createState() => _viewIndiviualCoordinatorState();
}

class _viewIndiviualCoordinatorState extends State<viewIndiviualCoordinator> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController coageCntr = TextEditingController();
  TextEditingController fnameCntr = TextEditingController();
  TextEditingController lnameCntr =  TextEditingController();
  TextEditingController phoneCntr =  TextEditingController();
  TextEditingController placeCntr =  TextEditingController();
  TextEditingController usernameCntr =  TextEditingController();
  TextEditingController passwordCntr =  TextEditingController();
  TextEditingController gender =  TextEditingController();
  TextEditingController country_id =  TextEditingController();
  TextEditingController zone_id =  TextEditingController();
  TextEditingController division_id =  TextEditingController();
  TextEditingController cluster_id =  TextEditingController();
  TextEditingController coordinatorid =  TextEditingController();
  TextEditingController dateinput2 = TextEditingController();
  String?  selectedsubzones;
  List<DivisionList> subdivision = [];
  String?  selectedcountry_val;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CountryList> countries = [];
  String selectedUserID='';
  var country_val;
  String?  selectedzone_val;
  List<ZoneList> zones = [];
  String selectedCcZoneId = '';
  String selectedCcZoneId1 = '';
  var zone_val;
  var apiUrl;
  var subcluster_val;
  String?  selectedcountryzone_val;
  String?  selectedivision_val;
  List<DivisionList> dzones = [];
  String selectedUserID2='';
  String selectedUserID3='';
  var subdivision_val;
  String?  selectedsubcluster;
  List<ClusterList> subcluster = [];
  String country_nid='';
  String division_id_val='';
  String cluster_id_val='';

  void initState()
  {
    super.initState();
    getApiurl();
    fetchcountry();
    viewindiviualCoordinatordata(widget.val);



  }


  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Padding(
          padding: const EdgeInsets.only(left:50.0),
          child: const Text('Detailed View',style:appbarTextColor),
        ),backgroundColor: HexColor('#3465D9'),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CoordinatorViewAdmin(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null; // Return null for no validation error
                    },
                    readOnly: true,
                    enabled: false,
                    controller: coordinatorid,
                    decoration: InputDecoration(
                      labelText: 'Coordinator ID',
                      hintText: 'fname',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      setState(() {
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: fnameCntr,
                    decoration: InputDecoration(
                      labelText: 'Firstname',
                      hintText: 'fname',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      setState(() {
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    controller: lnameCntr,
                    decoration: InputDecoration(
                      labelText: 'Lastname',
                      hintText: 'lname',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      setState(() {
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: dateinput2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                            labelText: "Date",
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate1 = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate:  DateTime.now().add(const Duration(days: 365 * 10)),
                            );

                            if (pickedDate1 != null) {
                              String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1);
                              setState(() {
                                dateinput2.text = formattedDate1;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: coageCntr,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            hintText: 'age',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: const OutlineInputBorder(

                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            hintText: 'age',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: const OutlineInputBorder(
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: phoneCntr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            hintText: 'Phone',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: const OutlineInputBorder(
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Phone Number';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: placeCntr,
                    decoration: InputDecoration(
                      labelText: 'Place',
                      hintText: 'place',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top:20.0),
                //   child: TextFormField(
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter your place';
                //       }
                //       return null; // Return null for no validation error
                //     },
                //     controller: placeCntr,
                //     decoration: InputDecoration(
                //       labelText: 'Enter place',
                //       hintText: 'place',
                //       hintStyle: TextStyle(color: Colors.grey[400]),
                //       border: OutlineInputBorder(
                //       ),
                //       contentPadding: const EdgeInsets.symmetric(
                //           horizontal: 16.0, vertical: 14.0),
                //     ),
                //   ),
                // ),


                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.94,
                    height: MediaQuery.of(context).size.height*0.06,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: country_id,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        hintText: 'place',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: const OutlineInputBorder(
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.94,
                    height: MediaQuery.of(context).size.height*0.06,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: zone_id,
                      decoration: InputDecoration(
                        labelText: 'Zone',
                        hintText: 'Zone',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: const OutlineInputBorder(
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.94,
                    height: MediaQuery.of(context).size.height*0.06,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: division_id,
                      decoration: InputDecoration(
                        labelText: 'Area',
                        hintText: 'Area',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: const OutlineInputBorder(
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.94,
                    height: MediaQuery.of(context).size.height*0.06,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: cluster_id,
                      decoration: InputDecoration(
                        labelText: 'Cluster',
                        hintText: 'Cluster',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: const OutlineInputBorder(
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#3465D9')
                        ),
                        child: const Text('UPDATE',style: addButtonTextColor),
                        onPressed: () async {
                          await updateCoordinatoor(widget.val);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return  viewIndiviualCoordinator(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin, val:widget.val);
                          }));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                        ),
                        child: const Text('DELETE',style: addButtonTextColor),
                        onPressed: () async {
                         await deleteCoordinatoor(widget.val);
                         Navigator.push(context, MaterialPageRoute(builder: (context) {
                           return  CoordinatorViewAdmin(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin);
                         }));
                        },
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Future fetchcluster(String? selectedsubcluster) async {

    print("cluster_name................${this.selectedsubcluster}");
    print("fetchcluster.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_cluster/'),
        body: {
          'clusterid': selectedsubcluster,
        });

    if (response.statusCode == 200) {
      setState(() {
        subcluster_val = jsonDecode(response.body);
      });

      print("Cluster data: $subcluster_val");


      subcluster = (subcluster_val).map<ClusterList>((model) {
        return ClusterList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }
  Future fetchzone(String? selectedcountryzone_val) async {

    print("country_name................${this.selectedcountryzone_val}");
    print("fetchstatelist.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_zone/'),
        body: {
          'countryname': selectedcountryzone_val,
        });

    if (response.statusCode == 200) {
      setState(() {
        zone_val = jsonDecode(response.body);
      });

      print("State data: $zone_val");


      zones = (zone_val).map<ZoneList>((model) {
        return ZoneList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }
  Future viewindiviualCoordinatordata(value) async {
    await getApiurl();
    print("iddata $value");
    var response = await http.post(
      Uri.parse('$apiUrl/viewCoordinatorData/'),
      body: {
        'id': value.toString(),
      },
    );

    if (response.statusCode == 200) {
      var result_data;
      result_data = json.decode(response.body);
      print('result_data type: ${result_data.runtimeType}');
      print('result_data content: $result_data');

      if (result_data is List && result_data.isNotEmpty) {
        var detail = result_data[0];
        print("detail $detail");
        fnameCntr.text = detail['firstname'];
        lnameCntr.text = detail['lastname'];
        dateinput2.text = detail['date'].toString();
        coageCntr.text = detail['age'].toString();
        gender.text = detail['gender'].split(".").last;
        phoneCntr.text = detail['phone'].toString();
        placeCntr.text = detail['place'];
        country_id.text = detail['country'];
        zone_id.text = detail['zone'];
        division_id.text = detail['division'];
        cluster_id.text = detail['cluster'];
        coordinatorid.text = detail['coordinator_id'].toString();
        country_nid = detail['country_nid'].toString();
        division_id_val = detail['division_id'];
        cluster_id_val = detail['cluster_id'];

      }
      setState(() {
        fetchzone(country_nid);
        fetchdivision(division_id_val);
        fetchcluster(cluster_id_val);
      });

    }
  }
  Future updateCoordinatoor(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/coordinatorUpdate/'),
      body: {
        'id': value.toString(),
        'fnameCntr':fnameCntr.text,
        'lnameCntr':lnameCntr.text,
        'coageCntr':coageCntr.text,
        'phoneCntr':phoneCntr.text,
        'placeCntr':placeCntr.text,
        'selectedUserID':selectedUserID,
        'selectedCcZoneId':selectedCcZoneId,
        'selectedCcZoneId1':selectedCcZoneId1,
        'selectedUserID2':selectedUserID2,
        'selectedUserID3':selectedUserID3,
      },
    );
   print("response ${response.body}");
    if (response.statusCode == 200) {
      var data;
      setState(() {
        data = response.body.trim(); // No
      });
      print("data $data");
      if (data.contains("success")) {// Check if data is "success"
        const SnackBar snackBar = SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      }
      else {
        const SnackBar snackBar = SnackBar(
          content: Text("Not Updated"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

  }
  Future fetchcountry() async {
    await getApiurl();
    var response = await http.post(
      (Uri.parse(
          '$apiUrl/select_country/')),
    );
    if (response.statusCode == 200) {
      setState(() {
        country_val = jsonDecode(response.body);
      });
      // print("country",selectedcountryzone_val.status);
      print("countrydata $country_val");
      countries = (country_val).map<CountryList>((model) {
        return CountryList.fromJson(model);
      }).toList();
      print("countries $countries");
    }
  }

  Future fetchdivision(String? selectedsubzones) async {

    print("zone_name................${this.selectedsubzones}");
    print("fetchdivision.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_division/'),
        body: {
          'zoneid': selectedsubzones,
        });

    if (response.statusCode == 200) {
      setState(() {
        subdivision_val = jsonDecode(response.body);
      });

      print("subdivision_val data: $subdivision_val");


      subdivision = (subdivision_val).map<DivisionList>((model) {
        return DivisionList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }



  Future deleteCoordinatoor(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/coordinatorDelete/'),
      body: {
        'id': value.toString(),
      },
    );
    print("response ${response.body}");
    if (response.statusCode == 200) {
      var data;
      setState(() {
        data = response.body.trim(); // No
      });
      print("data $data");
      if (data.contains("success")) {// Check if data is "success"
        const SnackBar snackBar = SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      }
      else {
        const SnackBar snackBar = SnackBar(
          content: Text("Not Updated"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

  }

}
