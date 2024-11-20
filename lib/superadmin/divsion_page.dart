import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/superadmin/region.dart';
import 'package:gulf_suprabhaatham/superadmin/zonemodel.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../constants.dart';
import 'countrymodel.dart';



class DivisonPage extends StatefulWidget {
  const DivisonPage({super.key});

  @override
  State<DivisonPage> createState() => _DivisonPageState();
}

class _DivisonPageState extends State<DivisonPage> {

  var zone_val;
  List<ZoneList> zones = [];
  String?  selectedzone_val;
  String? selectedZoneId;
  String? selectedZoneval;
  String selectedCcZoneId = '';
  String selectedCcZoneId1 = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> filteredList = [];
  var countryzone_val;
  List<CountryList> zonecountries = [];
  String?  selectedcountryzone_val;
  String firstname='';
  String selectedUserID = '';
  var id;
  int itemsPerPage = 10;
  // bool isAdmin = false;
  var apiUrl;
  int currentPage = 1;
  List<Map<String, dynamic>>  dataList = [];
  String divisionID='';
  bool showUpdateButton = false;
  String dispalyedCountryId = '';
  String dispalyedZoneId = '';
  String zoneid__zoneid = '';
  TextEditingController searchController = TextEditingController();
  void initState()
  {
    super.initState();
    getApiurl();
    fetchcountry();
    getuser();
    fetchallArea();
    fetchData();
  }

  @override
  void dispose() {
    // Cancel timers, listeners, etc. in dispose method
    super.dispose();
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

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }

  void filterData(String query) {
    setState(() {
      filteredList = dataList.where((item) =>
      item['divisionname'].toLowerCase().contains(query.toLowerCase()) ||
          item['divisionid'].toString().contains(query)
      ).toList();
    });
  }
  TextEditingController divisioncntr = TextEditingController();
  String? selectedname;
  bool checkVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor:HexColor('#3465D9'),title:const Padding(
          padding: EdgeInsets.only(left:40.0),
          child: Text('Area Creation',style: appbarTextColor,),
        ),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appbArrowColor),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Region(firstname: firstname, id: id,isAdmin:true)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(child: Icon(Icons.refresh,color: HexColor('#3465D9'),size: 50,),onTap: ()
                      {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return const DivisonPage();
                        }));
                      },),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.56,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left:18.0,top:15),
                            child: Row(
                              children: [
                                Text("Select Country"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: DropdownSearch<String>(
                                selectedItem: selectedcountryzone_val,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                items: zonecountries.map((CountryList data) {
                                  return data.countryname; // Assuming 'Name' holds the strings you want to display
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedcountryzone_val = value!;
                                  });
                                  if (value != null) {
                                    CountryList? selectedUserData = zonecountries.firstWhere(
                                          (data) => data.countryname == value,
                                    );
                                    selectedUserID = selectedUserData.id.toString();
                                    fetchzone(selectedUserID!);
                                  }
                                }
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left:18.0,top:2),
                            child: Row(
                              children: [
                                Text("Select Zone"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: DropdownSearch<String>(
                                selectedItem: selectedzone_val,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                items: zones.map((ZoneList data) {
                                  return data.zonename; // Assuming 'Name' holds the strings you want to display
                                }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    selectedzone_val = value!;
                                    // selectedCcZoneId = subzones
                                    //     .firstWhere((element) => element.id.toString() == value)
                                    //     .zoneid;
                                  });
                                  if (value != null) {
                                    ZoneList? selectedUserData1 = zones.firstWhere(
                                          (data) => data.zonename == value,
                                    );
                                    selectedCcZoneId = selectedUserData1.id.toString();
                                    selectedCcZoneId1 = selectedUserData1.zoneid.toString();
                                  }
                                }
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
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the division';
                                }
                                return null; // Return null for no validation error
                              },
                              controller: divisioncntr,
                              decoration: InputDecoration(
                                labelText: 'Enter Area',
                                hintText: 'place',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 14.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) {
                                    return const DivisonPage();
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
                                  insertDivision(selectedCcZoneId1);
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) {
                                    return const DivisonPage();
                                  }));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Enter Division name or ID',
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
                    height: 10,
                  ),
                  Container(
                    height:MediaQuery.of(context).size.height*0.56,
                    width:MediaQuery.of(context).size.width*0.99,
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
                          width:MediaQuery.of(context).size.width*0.99,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Display zonename on the left
                              Padding(
                                padding: const EdgeInsets.only(left:10.0),
                                child: Text(
                                  'Area Name',
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
                                      zoneData[index]['divisionid'].toString(),
                                      style: TextStyle(fontSize: 13.0,color: HexColor('#3465D9')),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 8.0), // Add left padding for the subtitle
                                    child: Text(
                                      zoneData[index]['divisionname'].toString(),
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
                                            divisionID = data['divisionID'] ?? ''; // If data['divisionID'] is null, use an empty string
                                            dispalyedCountryId = data['dcountryzone_val'] ?? '';
                                            fetchzone(dispalyedCountryId!);
                                            dispalyedZoneId = data['zoneid'] ?? '';
                                            zoneid__zoneid = data['zoneid__zoneid'] ?? '';
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


  Future<void> insertDivision(String? selectedCcZoneId1) async {
    await getApiurl();
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/division_insert/'),
      body: {
        'divisioncntr': divisioncntr.text,
        'selectedzone_val':selectedCcZoneId?.toString() ?? '',
        'selectedzone_id': selectedCcZoneId?.toString() ?? '',
        'selectedzonezoneid':selectedCcZoneId1?.toString() ?? '',
        'selectedcountryzone_val':selectedUserID?.toString() ?? '',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No need for jsonDecode
      });
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
        countryzone_val = jsonDecode(response.body);
      });
      // print("country",selectedcountryzone_val.status);
      print("countrydata $countryzone_val");
      zonecountries = (countryzone_val).map<CountryList>((model) {
        return CountryList.fromJson(model);
      }).toList();
      print("countries $zonecountries");
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

  Future<void> getuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    firstname = prefs.getString('firstname')!;
    print('...........firstname.....$firstname');
    id = prefs.getString('id');
    print('...........id.....$id');
    return;
  }
  Future<List<Map<String, dynamic>>> fetchallArea() async {
    print("selectsubcriber.............................");
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/viewAllDivision/'));

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

    divisioncntr.text = zoneData['divisionname'];
    selectedcountryzone_val = zoneData['countryid__countryname'].toString();
    selectedzone_val = zoneData['zoneid__zonename'].toString();
    var zonedataid = zoneData['id'].toString();
    var dcountryzone_val = zoneData['countryid'].toString();
    var zoneid = zoneData['zoneid'].toString();
    var zoneid__zoneid = zoneData['zoneid__zoneid'].toString();
    return {
      'dcountryzone_val': dcountryzone_val,
      'zoneid': zoneid,
      'divisionID': zonedataid,
      'zoneid__zoneid':zoneid__zoneid,
    };

  }

  Future<void> EditUserData() async {
    setState(() {
      showUpdateButton = true;
    });
    print(".....zoneid$selectedUserID");
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/division_update/'),
      body: {
        'divisioncntr': divisioncntr.text,
        'selectedcountry_val': selectedUserID,
        'selectedCcZoneId':selectedCcZoneId,
        'divisionID':divisionID,
        'dispalyedCountryId':dispalyedCountryId,
        'dispalyedZoneId':dispalyedZoneId,
        'zoneid__zoneid':zoneid__zoneid,
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
    int divisionid;
    divisionid= zoneData['id'];
    var response = await http.post(
      Uri.parse('$apiUrl/deleteDivision/'),
      body: {
        'divisionid':divisionid.toString(),
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
          text: "Sorry, the area is already assigned you can't delete it.",
        );
        setState(() {});
      }
      else if(data.contains("delete"))
      {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Area Successfully Deleted',
        ).then((_) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DivisonPage()),
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
