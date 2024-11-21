import 'dart:async';
import 'dart:convert';
import 'package:empty_widget_fork/empty_widget_fork.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../agent/coordinatormodel.dart';
import '../constants.dart';
import 'SubscriberDetailPage.dart';
import 'indiviual_sub_detail.dart';

class SubDetails extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  const SubDetails({super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  _SubDetailsState createState() => _SubDetailsState();
}

class _SubDetailsState extends State<SubDetails> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;
  List<Map<String, dynamic>> _subData = [];
  bool _isEmpty = false;
  bool _isLoding = false;
  int _displayedRows = 10;

  int itemsPerPage = 10;
  int currentPage = 1;
  List<Map<String, dynamic>>  dataList = [];


  @override
  void initState() {
    super.initState();
    fetchallSubscribers();
    fetchData();
  }
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredList = [];
  String?  selecteduser;
  var coordinator_val;
  List<CoorList> coordinator = [];
  var apiUrl;
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallSubscribers();
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
      item['name'].toLowerCase().contains(query.toLowerCase()) ||
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
          title: const Padding(
            padding: EdgeInsets.only(left:40.0),
            child: Text('Subscriber List'),
          ),backgroundColor: HexColor('#3465D9'),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SubscriberDetailPage(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),
        ),
        body: SingleChildScrollView(
          child:_isLoding?
        Center(
        child: Column(
        children: [
          const SizedBox(height: 250,),
        Container(child: const CircularProgressIndicator())
        ],
      ),
    ):

    _isEmpty
    ?Padding(
      padding: const EdgeInsets.only(top:150.0),
      child: EmptyWidget(
        image: null,
        packageImage: PackageImage.Image_1,
        title: 'No Data',
        subTitle: 'No  data available yet',
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
    ):
    Container(
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
                      hintText: 'Enter Subcriber name or id',
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
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text(
                    'ID/NAME',
                    style: TextStyle(fontSize: 16.0,color: Colors.white),
                  ),
                ),


                // Display edit icon on the right
                Padding(
                  padding: const EdgeInsets.only(left:10.0,right: 20),
                  child: Text('ACTION',
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
                        zoneData[index]['regid'].toString(),
                        style: TextStyle(fontSize: 13.0,color: HexColor('#3465D9')),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Add left padding for the subtitle
                      child: Text(
                        zoneData[index]['name'].toString(),
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(
                              builder: (context) =>  viewIndiviualsubscribers(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin,val:zoneData[index]['id'])),
                              (Route<dynamic> route) =>
                          false, // Removes all routes in the stack
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
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchallSubscribers() async {
    print("selectsubcriber.............................");
    _isLoding = true;
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.get(Uri.parse('$apiUrl/ViewAllSubscribers/'));

    if (response.statusCode == 200) {
      try {
        List<Map<String, dynamic>> coordinator = List<Map<String, dynamic>>.from(
          jsonDecode(response.body),
        );
        if (coordinator.isEmpty){
          setState(() {
            _isLoding = false;
            _isEmpty=true;
          });

        }
        else{
          setState(() {
            _isLoding = false;
            _isEmpty=false;
          });
        }
        print("users................$coordinator");
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




}
