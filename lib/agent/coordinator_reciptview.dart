import 'dart:async';
import 'dart:convert';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empty_widget_fork/empty_widget_fork.dart';

import '../constants.dart';
import 'coordinatorlogin.dart';
import 'indiviual_coordinator_receipt.dart';




class ViewReceiptPage extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  const ViewReceiptPage({super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  _ViewReceiptPageState createState() => _ViewReceiptPageState();
}

class _ViewReceiptPageState extends State<ViewReceiptPage> {
  late String _sortColumnName;
  late bool _sortAscending;

  List<Map<String, dynamic>> _coordinatorData = [];
  bool _dataLoaded = true;
  bool _isLoading = false;
  int itemsPerPage = 10;
  int currentPage = 1;
  bool _isEmpty = false;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredList = [];
  int _displayedRows = 10;

  // List<Map<String, dynamic>> _subData = [];
  List<Map<String, dynamic>>  dataList = [];

  @override
  void initState() {
    super.initState();
    fetchallCoordinatorreceipt(widget.id);
    fetchData();
  }
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallCoordinatorreceipt(widget.id);
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
      item['transcationid'].toLowerCase().contains(query.toLowerCase()) ||
          item['id'].toString().contains(query)
      ).toList();
    });
  }
  List<Map<String, dynamic>> getVisibleItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredList.sublist(startIndex, endIndex < filteredList.length ? endIndex : filteredList.length);
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Coordinator Receipt List'),
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
              :Container(
            height:MediaQuery.of(context).size.height*0.9,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
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
                    SizedBox(width: 20),
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
                        padding: const EdgeInsets.only(left:9.0),
                        child: Text(
                          'RECEIPT ID',
                          style: TextStyle(fontSize: 16.0,color: Colors.white),
                        ),
                      ),

                      // Display edit icon on the right
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,right: 9),
                        child: Text('Edit',
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display zonename on the left
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Text(
                                zoneData[index]['transcationid'].toString(),
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                            // Display edit icon on the right
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                      builder: (context) =>  viewIndiviualCoordinatorReceipt(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin,data_val:zoneData[index]['id'],)),
                                      (Route<dynamic> route) =>
                                  false, // Removes all routes in the stack
                                );


                              },
                            ),
                          ],
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


  Future<List<Map<String, dynamic>>> fetchallCoordinatorreceipt(String id) async {
    print("selectsubcriber.............................");
    _isLoading = true;
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(
      Uri.parse('$apiUrl/viewAllCoordinatorreceipt/'),
      body: {
        'id': id.toString(),
      },
    );

    if (response.statusCode == 200) {
      try {
        List<Map<String, dynamic>> coordinator = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );

        print("users................$coordinator");
        if (coordinator.isEmpty){
          setState(() {
            _isLoading = false;
            _isEmpty=true;
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





