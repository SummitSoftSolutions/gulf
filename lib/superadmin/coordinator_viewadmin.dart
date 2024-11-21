import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/superadmin/viewIndivialcoordinator.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empty_widget_fork/empty_widget_fork.dart';

import '../agent/coordinatorlogin.dart';
import '../constants.dart';



class CoordinatorViewAdmin extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  const CoordinatorViewAdmin({Key? key, required this.firstname, required this.id, required this.isAdmin}) : super(key: key);

  @override
  _CoordinatorViewAdminState createState() => _CoordinatorViewAdminState();
}

class _CoordinatorViewAdminState extends State<CoordinatorViewAdmin> {
  late String _sortColumnName;
  late bool _sortAscending;

  List<Map<String, dynamic>> _coordinatorData = [];
  bool _dataLoaded = true;
  bool _isLoading = false;
  int itemsPerPage = 10;
  int currentPage = 1;
  bool _isEmpty = false;
  List<Map<String, dynamic>> filteredList = [];
  int _displayedRows = 10;
  TextEditingController searchController = TextEditingController();
  // List<Map<String, dynamic>> _subData = [];
  List<Map<String, dynamic>>  dataList = [];
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallCoordinator();
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
  void filterData(String query) {
    setState(() {
      filteredList = dataList.where((item) =>
      item['firstname'].toLowerCase().contains(query.toLowerCase()) ||
          item['coordinatorid'].toString().contains(query)
      ).toList();
    });
  }
  List<Map<String, dynamic>> getVisibleItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredList.sublist(startIndex, endIndex < filteredList.length ? endIndex : filteredList.length);
  }
  @override
  void initState() {
    super.initState();
    fetchallCoordinator();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Text('Coordinator List'),
          ),
          backgroundColor: HexColor('#3465D9'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: appbArrowColor),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CoordinatorPage(
                    firstname: widget.firstname,
                    id: widget.id,
                    isAdmin: widget.isAdmin,
                  ),
                ),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        body:_isLoading
            ? Center(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Container(child: const CircularProgressIndicator()),
            ],
          ),
        )
            : _isEmpty
            ?Padding(
          padding: const EdgeInsets.only(top:150.0),
          child: EmptyWidget(
            image: null,
            packageImage: PackageImage.Image_1,
            title: 'No Data',
            subTitle: 'No data available yet',
            titleTextStyle: const TextStyle(
              fontSize: 22,
              color: Color(0xff9da9c7),
              fontWeight: FontWeight.w500,
            ),
            subtitleTextStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xffabb8d6),
            ),
          ),
        )
            : Container(
          height:MediaQuery.of(context).size.height*0.9,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 40,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Enter Coordinator name  or ID',
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
                  SizedBox(width: 15),
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

                ],
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
                        'ID',
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
                            zoneData[index]['coordinatorid'].toString(),
                            style: TextStyle(fontSize: 13.0,color: HexColor('#3465D9')),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Add left padding for the subtitle
                          child: Text(
                            zoneData[index]['firstname'].toString(),
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewIndiviualCoordinator(
                                  firstname: widget.firstname,
                                  id: widget.id,
                                  isAdmin: widget.isAdmin,
                                  val: zoneData[index]['id'],
                                ),
                              ),
                                  (Route<dynamic> route) => false, // Removes all routes in the stack
                            );
                          },
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
        )

      ),
    );
  }


  Future<List<Map<String, dynamic>>> fetchallCoordinator() async {
    print('Widget ID: ${widget.id}');
    print("selectsubcriber.............................");
    _isLoading = true;
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/viewAllCoordinators/'));

    if (response.statusCode == 200) {
      try {
        List<Map<String, dynamic>> coordinator = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );

        print("users................$coordinator");
        if (coordinator.isEmpty){
          setState(() {
            _isLoading = false;
            _dataLoaded=true;
          });
        }
        else{
          setState(() {
            _isLoading = false;
            _isEmpty=false;
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

  var apiUrl;
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
  }
}





