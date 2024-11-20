import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/superadmin/region.dart';
import 'package:gulf_suprabhaatham/superadmin/zonemodel.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'countrymodel.dart';
import 'divisionmodel.dart';



class ClusterPage extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const ClusterPage({super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  State<ClusterPage> createState() => _ClusterPageState();
}

class _ClusterPageState extends State<ClusterPage> {

  var czone_val;
  List<ZoneList> czones = [];
  String?  selectedCzone_val;

  String? selectedCZonename;
  int itemsPerPage = 10;
  int currentPage = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var dzone_val;
  List<DivisionList> dzones = [];
  String?  selectedivision_val;
  bool showUpdateButton = false;
  var countryczone_val;
  List<CountryList> zoneccountries = [];
  String?  selectedccountryzone_val;
  String selectedUserID = '';
  String selectedUserID1='';
  String selectedUserID2='';
  String selectedUserZoneid='';
  var apiUrl;
  String dispalyedCountryId = '';
  String zoneid = '';
  String clusterID = '';
  String divisionid = '';
  String zoneid__zoneid = '';
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>>  dataList = [];
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallCluster();
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

  void initState()
  {
    super.initState();
    getApiurl();
    fetchcountry();
    fetchallCluster();
    fetchData();
  }

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  void filterData(String query) {
    setState(() {
      filteredList = dataList.where((item) =>
      item['clustername'].toLowerCase().contains(query.toLowerCase()) ||
          item['clusterid'].toString().contains(query)
      ).toList();
    });
  }

  TextEditingController clustercntr = TextEditingController();
  String? selectedcname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar:AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
          padding: EdgeInsets.only(top:10.0,left: 40),
          child: Text('Cluster Creation',style:appbarTextColor),
        ),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appbArrowColor),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Region(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),),
        body: Padding(
          padding: const EdgeInsets.all(2),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(child: Icon(Icons.refresh,color: HexColor('#3465D9'),size: 50,),onTap: ()
                      {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return  ClusterPage(firstname: widget.firstname, id: widget.id, isAdmin: widget.isAdmin);
                        }));
                      },),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.height*0.65,
                    color: Colors.white,
                    child:Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left:18.0,top:2),
                          child: Row(
                            children: [
                              Text("Select Country"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                           // Adjust border radius as needed
                            // Background color similar to TextFormField
                          ),
                          child: DropdownSearch<String>(
                              selectedItem: selectedccountryzone_val,
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                              ),
                              items: zoneccountries.map((CountryList data) {
                                return data.countryname; // Assuming 'Name' holds the strings you want to display
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedccountryzone_val = value!;
                                });
                                if (value != null) {
                                  CountryList? selectedUserData = zoneccountries.firstWhere(
                                        (data) => data.countryname == value,
                                  );
                                  selectedUserID = selectedUserData.id.toString();
                                  fetchzone(selectedUserID!);
                                }
                              }
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left:18.0,top:15),
                          child: Row(
                            children: [
                              Text("Select Zone"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.height*0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              // Background color similar to TextFormField
                            ),
                            child: DropdownSearch<String>(
                                selectedItem: selectedCzone_val,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                items: czones.map((ZoneList data) {
                                  return data.zonename; // Assuming 'Name' holds the strings you want to display
                                }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    selectedCzone_val = value!;
                                  });
                                  if (value != null) {
                                    ZoneList? selectedUserData1 = czones.firstWhere(
                                          (data) => data.zonename == value,
                                    );
                                    selectedUserID1 = selectedUserData1.id.toString();
                                    selectedUserZoneid = selectedUserData1.zoneid.toString();
                                    fetchdivision(selectedUserID1!);
                                  }
                                }
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left:18.0,top:2),
                          child: Row(
                            children: [
                              Text("Select Area"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.height*0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),// Adjust border radius as needed
                              // Background color similar to TextFormField
                            ),
                            child:DropdownSearch<String>(
                                selectedItem: selectedivision_val,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                items: dzones.map((DivisionList data) {
                                  return data.divisionname; // Assuming 'Name' holds the strings you want to display
                                }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    selectedivision_val = value!;
                                  });
                                  if (value != null) {
                                    DivisionList? selectedUserData2 = dzones.firstWhere(
                                          (data) => data.divisionname == value,
                                    );
                                    selectedUserID2 = selectedUserData2.id.toString();

                                    // fetchdivision(selectedUserID2!);
                                  }
                                }
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter cluster name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: clustercntr,
                            decoration: InputDecoration(
                              labelText: 'Enter Cluster',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                // borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) {
                    return  ClusterPage(firstname: widget.firstname, id: widget.id, isAdmin: widget.isAdmin);
                  }));
                }
              },
            ): ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor('#3465D9'),
                              ),
                              child: const Text('ADD', style: addButtonTextColor),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  insertCluster(zoneid__zoneid);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return ClusterPage(
                                            firstname: widget.firstname,
                                            id: widget.id,
                                            isAdmin: widget.isAdmin);
                                      }));
                                }

                              }
                            ),
                          ),
                        ),
                      ],
                    ) ,
                  ),
                  SizedBox(
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height:MediaQuery.of(context).size.height*0.8,
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
                                  'Cluster Name',
                                  style: TextStyle(fontSize: 16.0,color: Colors.white),
                                ),
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
                                      zoneData[index]['clusterid'].toString(),
                                      style: TextStyle(fontSize: 13.0,color: HexColor('#3465D9')),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 8.0), // Add left padding for the subtitle
                                    child: Text(
                                      zoneData[index]['clustername'].toString(),
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
                                            divisionid = data['divisionid'] ?? ''; // If data['divisionID'] is null, use an empty string
                                            dispalyedCountryId = data['dcountryzone_val'] ?? '';
                                            fetchzone(dispalyedCountryId!);
                                            zoneid = data['zoneid'] ?? '';
                                            clusterID = data['clusterID'] ?? '';
                                            fetchdivision(zoneid);
                                            zoneid__zoneid = data['zoneid__zoneid'] ?? '';

                                          });


                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await deleteZone(zoneData[index]);
                                          // Navigator.push(context,
                                          //     MaterialPageRoute(builder: (context) {
                                          //       return ClusterPage(
                                          //           firstname: widget.firstname,
                                          //           id: widget.id,
                                          //           isAdmin: widget.isAdmin);
                                          //     }));
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
  Future<void> insertCluster(String zoneid__zoneid) async {
    await getApiurl();
    var data;
    print("zoneid__zoneid ${this.zoneid__zoneid}");
    var response = await http.post(
      Uri.parse('$apiUrl/cluster_insert/'),
      body: {
       'selectedccountryzone_val':selectedUserID?.toString() ?? '',
        'selectedCzone_val':selectedUserID1?.toString() ?? '',
        'selectedivision_val':selectedUserID2?.toString() ?? '',
        'selectedUserZoneid':selectedUserZoneid?.toString() ?? '',
        'selectedCZonename':zoneid__zoneid,
        'clustercntr':clustercntr.text,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No need for jsonDecode
      });
      if (data.contains("success")) {// Check if data is "success"
        final SnackBar snackBar = const SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
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

    } else {
      // Handle API error
      print("Failed to fetch role");
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
        countryczone_val = jsonDecode(response.body);
      });
      // print("country",selectedcountryzone_val.status);
      print("countrydata $countryczone_val");
      zoneccountries = (countryczone_val).map<CountryList>((model) {
        return CountryList.fromJson(model);
      }).toList();
      print("countries $zoneccountries");
    }
  }
  Future fetchzone(String? selectedcountryzone_val) async {

    print("country_name................${this.selectedccountryzone_val}");
    print("fetchstatelist.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_zone/'),
        body: {
          'countryname': selectedcountryzone_val,
        });

    if (response.statusCode == 200) {
      setState(() {
        czone_val = jsonDecode(response.body);
      });

      print("State data: $czone_val");


      czones = (czone_val).map<ZoneList>((model) {
        return ZoneList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future fetchdivision(String? selectedCzone_val) async {

    print("zone_name................${this.selectedccountryzone_val}");
    print("fetchdivision.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_division/'),
        body: {
          'zoneid': selectedCzone_val,
        });

    if (response.statusCode == 200) {
      setState(() {
        dzone_val = jsonDecode(response.body);
      });

      print("State data: $dzone_val");


      dzones = (dzone_val).map<DivisionList>((model) {
        return DivisionList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future<List<Map<String, dynamic>>> fetchallCluster() async {
    print("selectsubcriber.............................");
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/viewAllCluster/'));

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

    clustercntr.text = zoneData['clustername'];
    selectedccountryzone_val = zoneData['countryid__countryname'].toString();
    selectedCzone_val = zoneData['zoneid__zonename'].toString();
    selectedivision_val = zoneData['divisionid__divisionname'].toString();
    var clusterdataid = zoneData['id'].toString();
    var dcountryzone_val = zoneData['countryid'].toString();
    var zoneid = zoneData['zoneid'].toString();
    var zoneid__zoneid = zoneData['zoneid__zoneid'].toString();
    var divisionid = zoneData['divisionid'].toString();



    return {
      'dcountryzone_val': dcountryzone_val,
      'zoneid': zoneid,
      'clusterID': clusterdataid,
      'divisionid':divisionid,
      'zoneid__zoneid':zoneid__zoneid,

    };

  }
  Future<void> EditUserData() async {
    setState(() {
      showUpdateButton = true;
    });
    var data;
    print(".....zoneid$selectedUserID");
    var response = await http.post(
      Uri.parse('$apiUrl/cluster_update/'),
      body: {
        'clustercntr': clustercntr.text,
        'selectedcountry_val': selectedUserID,
        'selectedCcZoneId':selectedUserID1,
        'selectedUserID2':selectedUserID2,
        'dispalyedCountryId':dispalyedCountryId,
        'dispalyedZoneId':zoneid,
        'zoneid__zoneid':zoneid__zoneid,
        'divisionid':divisionid,
        'zoneid':zoneid,
        'clusterID':clusterID,
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
          content: Text("Already changed"),
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
    int clusterid;
    clusterid= zoneData['id'];
    var response = await http.post(
      Uri.parse('$apiUrl/deleteCluster/'),
      body: {
        'clusterid':clusterid.toString(),
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
          text: "Sorry, the cluster is already assigned you can't delete it.",
        );
        setState(() {});
      }
      else if(data.contains("delete"))
      {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Cluster Successfully Deleted',
        ).then((_) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ClusterPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
            );
          });
        });
      }

    }else {
      // Handle API error
      print("Failed to fetch role");
    }
  }
}
