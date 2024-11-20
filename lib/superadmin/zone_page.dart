import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/superadmin/region.dart';
import 'package:gulf_suprabhaatham/superadmin/zonemodel.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'countrymodel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:quickalert/quickalert.dart';


class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  int itemsPerPage = 10; // Default number of items per page
  late List<Map<String, dynamic>> _zoneData = []; // List to store zone data

  var country_val;
  List<CountryList> countries = [];
  String?  selectedcountry_val;
  List<Map<String, dynamic>> _coordinatorData = [];
  var apiUrl;
  String selectedUserID='';
  String selectedUserID1='';
  String selectedUserZoneid='';
  String selectedcountry_id='';
  bool checkVisible = false;
  String firstname='';
  var id;
  bool isAdmin = false;
  bool showUpdateButton = false;
  late String zoneID;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentPage = 1;
  List<Map<String, dynamic>>  dataList = [];

  final ScrollController _scrollController = ScrollController();

  bool _showBackToTopButton = false;

  List<ZoneList> dataSearchList = <ZoneList>[];

  List<ZoneList> dsList =[];
  List<Map<String, dynamic>> filteredList = [];


  @override
  void initState()
  {
    super.initState();
    getApiurl();
    fetchallZone();
    getuser();
    fetchcountry();
    fetchData();
    _scrollController.addListener(() {
      setState(() {
        _showBackToTopButton = _scrollController.position.pixels >= 2 ? true : false;

      });
    });

  }
  // Method to fetch zone data
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallZone();
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


  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  TextEditingController zonecntr = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> getVisibleItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredList.sublist(startIndex, endIndex < filteredList.length ? endIndex : filteredList.length);
  }
  void filterData(String query) {
    setState(() {
      filteredList = dataList.where((item) =>
      item['zonename'].toLowerCase().contains(query.toLowerCase()) ||
          item['zoneid'].toString().contains(query)
      ).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title:const Padding(
        padding: EdgeInsets.only(left:50.0),
        child: Text('Zone Creation',style:appbarTextColor),
      ),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Region(firstname: firstname, id: id,isAdmin:true)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),backgroundColor: HexColor('#3465D9'),),
      body: Padding(
        padding: const EdgeInsets.only(top:15.0),
        child: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*1.2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(child: Icon(Icons.refresh,color: HexColor('#3465D9'),size: 40,),onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ZonePage();
                        }));
                      },),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.33,
                      color: Colors.white,
                      child:Column(
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
                            padding: const EdgeInsets.only(top:5.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                height: MediaQuery.of(context).size.height*0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),// Adjust border radius as needed
                                  // Background color similar to TextFormField
                                ),
                                child:DropdownSearch<String>(
                                    selectedItem: selectedcountry_val,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    items: countries.map((CountryList data) {
                                      return data.countryname; // Assuming 'Name' holds the strings you want to display
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          // Find the selected item by its name and retrieve its ID
                                          var selectedCountry = countries.firstWhere((country) => country.countryname == value);
                                          selectedUserID = selectedCountry.id.toString();
                                        }
                                      });
                                    }

                                )






                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the zone name';
                                  }
                                  return null; // Return null for no validation error
                                },
                                controller: zonecntr,
                                decoration: InputDecoration(
                                  labelText: 'Enter Zone',
                                  hintText: 'place',
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
                            child:showUpdateButton
                                ?ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('#3465D9')
                              ),
                              child: const Text('UPDATE',style: addButtonTextColor),
                              onPressed: (){
                                if (_formKey.currentState?.validate() ?? false) {
                                  EditUserData();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const ZonePage();
                                  }));
                                }
                              },
                            ):ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('#3465D9')
                              ),
                              child: const Text('ADD',style: addButtonTextColor),
                              onPressed: (){
                                if (_formKey.currentState?.validate() ?? false) {
                                  zoneinsertion();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const ZonePage();
                                  }));
                                }
                              },
                            ),
                          ),
                        ],
                      ) ,
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
                          hintText: 'Zone name',
                          prefixIcon: const Icon(Icons.search),
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
                        const SizedBox(
                          height:8,
                        ),
                        Container(
                          color: HexColor('#3465D9'),
                          height:40,
                          width:MediaQuery.of(context).size.width*0.98,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Display zonename on the left
                              Padding(
                                padding: EdgeInsets.only(left:10.0),
                                child: Text(
                                  'Zone',
                                  style: TextStyle(fontSize: 16.0,color: Colors.white),
                                ),
                              ),

                              // Display edit icon on the right
                              Padding(
                                padding: EdgeInsets.only(left:10.0,right: 20),
                                child: Text('Action',
                                  style: TextStyle(fontSize: 16.0,color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
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
                                      zoneData[index]['zoneid'].toString(),
                                      style: TextStyle(fontSize: 13.0,color: HexColor('#3465D9')),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 8.0), // Add left padding for the subtitle
                                    child: Text(
                                      zoneData[index]['zonename'].toString(),
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          zoneID = await showEditZoneForm(zoneData[index]);
                                          setState(()  {
                                            zoneID=zoneID;
                                          });


                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await deleteZone(zoneData[index]);

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
                              child: const Text('Previous'),
                            ),
                            const SizedBox(width: 10),
                            Text('Page $currentPage'),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: currentPage < (dataList.length / itemsPerPage).ceil() ? () => setState(() => currentPage++) : null,
                              child: const Text('Next'),
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
        ),
      ),
      floatingActionButton:
      _showBackToTopButton
          ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.purple,
            highlightElevation: 150,
            onPressed: () {
              _scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            backgroundColor: Colors.purple,
            highlightElevation: 150,
            onPressed: () {
              _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
          )
        ],
      ) : null,

    );
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
  Future showEditZoneForm(Map<String, dynamic> zoneData) async {
    setState(() {
      showUpdateButton = true;
    });

    zonecntr.text = zoneData['zonename'];
    selectedcountry_val = zoneData['countryid__countryname'].toString();
    var zonedataid = zoneData['id'].toString();
    selectedcountry_id = zoneData['countryid'].toString();
    return zonedataid;

  }



  Future zoneinsertion() async {
    await getApiurl();
    var data;
    print("zonecntr.text ${zonecntr.text}");
    var response = await http.post(
      Uri.parse('$apiUrl/zone_insert/'),
      body: {
        'zonecntr': zonecntr.text,
        'selectedcountry_val': selectedUserID,
      },
    );
    print("zone data ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No need for jsonDecode
      });
      print(data);

      if (data.contains("success")) {// Check if data is "success"
        final SnackBar snackBar = const SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      }
      else if(data.contains("ae"))
      {
        final SnackBar snackBar = const SnackBar(
          content: Text("Already Exists"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else if(selectedUserID=='')
        {
          final SnackBar snackBar = const SnackBar(
            content: Text("Please select country"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      else {
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
  Future<void> getuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    firstname = prefs.getString('firstname')!;
    print('...........firstname.....$firstname');
    id = prefs.getString('id');
    print('...........id.....$id');
    return;
  }
  Future<List<Map<String, dynamic>>> fetchallZone() async {
    print("selectsubcriber.............................");
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/viewAllZone/'));

    if (response.statusCode == 200) {
      try {
        List<Map<String, dynamic>> coordinator = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        // dataSearchList = (jsonDecode(response.body)).map<ZoneList>((model) {
        //   return ZoneList.fromJson(model);
        // }).toList();
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

  Future<void> EditUserData() async {
    setState(() {
      showUpdateButton = true;
    });
    var data;
    print(".....zoneid$selectedUserID");
    var response = await http.post(
      Uri.parse('$apiUrl/zone_update/'),
      body: {
        'zonecntr': zonecntr.text,
        'selectedcountry_val': selectedUserID,
        'zonedataid':zoneID,
        'selectedcountry_id':selectedcountry_id
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
          content: Text("Already changed to same data"),
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

  void updateLIst(String value) {
    setState(() {
      dsList =
          dataSearchList.where((element) => element.zonename.toLowerCase().contains(value.toLowerCase())).toList();
    });
    print("dataSearchList $dataSearchList");
  }

  Future deleteZone(Map<String, dynamic> zoneData) async {
    var data;
    int zoneid;
    zoneid= zoneData['id'];
    var response = await http.post(
      Uri.parse('$apiUrl/deleteZone/'),
      body: {
        'zoneid':zoneid.toString(),
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
          text: "Sorry, the zone is already assigned you can't delete it.",
        );
        setState(() {});
      }
      else if(data.contains("delete"))
      {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Zone successfully Deleted',
        ).then((_) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ZonePage()),
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

