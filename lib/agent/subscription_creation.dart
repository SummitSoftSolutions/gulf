import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'coordinatorlogin.dart';

class SubscriptionCreation extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const SubscriptionCreation({super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  State<SubscriptionCreation> createState() => _SubscriptionCreationState();
}

class _SubscriptionCreationState extends State<SubscriptionCreation> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController subscriberptionname = TextEditingController();
  TextEditingController subscriberptionamount = TextEditingController();
  TextEditingController searchController = TextEditingController(); // Add this line
  int itemsPerPage = 10;
  int currentPage = 1;
  bool showUpdateButton = false;
  var apiUrl;
  String subid = '';
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = []; // Add this line

  @override
  void initState() {
    super.initState();
    getApiurl();
    fetchallArea();
    fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallArea();
      setState(() {
        dataList = zoneData;
        filteredList = dataList; // Initialize filteredList with all data
      });
      return zoneData;
    } catch (e) {
      print('Error fetching data: $e');
      throw e; // Rethrow the error to handle it in the FutureBuilder
    }
  }

  List<Map<String, dynamic>> getVisibleItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredList.sublist(startIndex, endIndex < filteredList.length ? endIndex : filteredList.length);
  }

  void filterData(String query) {
    setState(() {
      filteredList = dataList.where((item) =>
      item['subscribername'].toLowerCase().contains(query.toLowerCase()) ||
          item['subscriberamount'].toString().contains(query)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(backgroundColor: HexColor('#3465D9'),title: const Padding(
        padding: EdgeInsets.only(left:10.0),
        child: Text('Subscription Creation',style: appbarTextColor,),
      ),leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CoordinatorPage(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),),
      body: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Refresh"),
                    GestureDetector(child: Icon(Icons.refresh,color: HexColor('#3465D9'),size:30,),onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return  SubscriptionCreation(firstname: widget.firstname,id:widget.id,isAdmin:widget.isAdmin,);
                      }));
                    },),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Subscription name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: subscriberptionname,
                            decoration: InputDecoration(
                              labelText: 'Enter Subscription name',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:5,left:20,right:20,bottom: 15),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Subscription amount';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: subscriberptionamount,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter Subscription amount',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child:showUpdateButton? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#3465D9'),
                          ),
                          child: const Text('UPDATE', style: addButtonTextColor),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              EditUserData();
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  SubscriptionCreation(firstname: widget.firstname,id:widget.id,isAdmin:widget.isAdmin,);
                              }));
                            }
                          },
                        )
                            :ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#3465D9'),
                          ),
                          child: const Text('ADD', style: addButtonTextColor),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              subscription_insert();
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  SubscriptionCreation(firstname: widget.firstname,id:widget.id,isAdmin:widget.isAdmin,);
                              }));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Enter Subscription name or amount',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                      ),
                      onChanged: (value) {
                        filterData(value);
                      },
                    ),
                  ),
                ),
                Container(
                  height:MediaQuery.of(context).size.height*0.56,
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      DropdownButton<int>(
                        value: itemsPerPage,
                        onChanged: (newValue) {
                          setState(() {
                            itemsPerPage = newValue!;
                            currentPage = 1; // Reset to first page when changing items per page
                          });
                        },
                        items: [10, 20, 50].map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value per page'),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height:8,
                      ),
                      Container(
                        color: HexColor('#3465D9'),
                        height:40,
                        width:MediaQuery.of(context).size.width*0.98,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display zonename on the left
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: Text(
                                'SNAME',
                                style: TextStyle(fontSize: 16.0,color: Colors.white),
                              ),
                            ),
                            Text(
                              'SAmount',
                              style: TextStyle(fontSize: 16.0,color: Colors.white),
                            ),
                            // Display edit icon on the right
                            Padding(
                              padding: const EdgeInsets.only(left:10.0,right: 20),
                              child: Text('Action',
                                style: TextStyle(fontSize: 16.0,color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height:8,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: getVisibleItems().length,
                          itemBuilder: (BuildContext context, int index) {
                            var zoneData = getVisibleItems();
                            return Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero, // Set contentPadding to zero
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 8.0), // Add left padding for the title
                                  child: Text(
                                    zoneData[index]['subscribername'].toString(),
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 8.0), // Add left padding for the subtitle
                                  child: Text(
                                    zoneData[index]['subscriberamount'].toString(),
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        Map<String, String?> data = await showEditZoneForm(zoneData[index]);
                                        setState(() {
                                          subid = data['subid'] ?? ''; // If data['divisionID'] is null, use an empty string
                                        });


                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {

                                        await deleteZone(zoneData[index]);
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        //   return const DivisonPage();
                                        // }));


                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                            child: Text('Previous'),
                          ),
                          SizedBox(width: 10),
                          Text('Page $currentPage'),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: currentPage < (dataList.length / itemsPerPage).ceil() ? () => setState(() => currentPage++) : null,
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      )
    );
  }
  Future<List<Map<String, dynamic>>> fetchallArea() async {
    print("selectsubcriber.............................");
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/viewAllSubscription/'));

    if (response.statusCode == 200) {
      try {
        List<Map<String, dynamic>> coordinator = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );

        print("users................$coordinator");
        if (coordinator.isEmpty){
          setState(() {

          });
        }
        return coordinator;
      } catch (e) {
        print("Error decoding JSON: $e");
        return []; // Return an empty list if there is an error decoding JSON
      }
    } else {
      // Handle API error
      print("Failed to fetch coordinator");
      throw Exception('Failed to load data');
    }
  }

  Future showEditZoneForm(Map<String, dynamic> zoneData) async {
    setState(() {
      showUpdateButton = true;
    });

    subscriberptionname.text = zoneData['subscribername'];
    subscriberptionamount.text = zoneData['subscriberamount'].toString();
    var subid = zoneData['id'].toString();
    return {
      'subid': subid,
    };

  }

  Future<void> EditUserData() async {
    setState(() {
      showUpdateButton = true;
    });
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/subcr_edit/'),
      body: {
        'subscriberptionname': subscriberptionname.text,
        'subscriberptionamount': subscriberptionamount.text,
        'subid':subid,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No need for jsonDecode
      });
      print("data success $data");

      if (data.contains("success")) {
        final SnackBar snackBar = const SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      }

      else if(data.contains("change"))
      {
        final SnackBar snackBar = const SnackBar(
          content: Text("Already data changed"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      else if(data.contains("error"))
      {
        final SnackBar snackBar = const SnackBar(
          content: Text("Error"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }else {
      // Handle API error
      print("Failed to fetch role");
    }
  }

  Future deleteZone(Map<String, dynamic> zoneData) async {
    var data;
    int subid;
    subid= zoneData['id'];
    var response = await http.post(
      Uri.parse('$apiUrl/deleteSub/'),
      body: {
        'subid':subid.toString(),
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No need for jsonDecode
      });
      print("data success $data");

      if (data.contains("assigned")) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: "Sorry, the area is already assigned you can't delete it",
        );
        setState(() {});
      }
      else if(data.contains("delete"))
      {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Subscription is successfully Deleted',
        ).then((_) {
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return  SubscriptionCreation(firstname: widget.firstname,id:widget.id,isAdmin:widget.isAdmin,);
            }));
          });
        });
      }

    }else {
      // Handle API error
      print("Failed to fetch role");
    }
  }
  Future<void> subscription_insert() async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/Subscription_data_insert/'),
      body: {
        'subscriberptionname': subscriberptionname.text,
        'subscriberptionamount': subscriberptionamount.text,
      },
    );

    var data;
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim();
        print('data $data');// No
        if (data.contains("success")) {
          final SnackBar snackBar = const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {});
        }
        else if (data.contains("exists")) {
          final SnackBar snackBar = const SnackBar(
            content: Text("Already Exists"),
            backgroundColor: Colors.black,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {});
        }
        else {
          final SnackBar snackBar = const SnackBar(
            content: Text("Error"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
}
