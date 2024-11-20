import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'NotRenew.dart';
import 'coordinatorlogin.dart';

class NotificationAgent extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  const NotificationAgent({
    super.key,
    required this.firstname,
    required this.isAdmin,
    required this.id,
  });

  @override
  State<NotificationAgent> createState() => _NotificationAgentState();
}

class _NotificationAgentState extends State<NotificationAgent> {
  List<Map<String, String>> subscribers = [];
  List<Map<String, String>> filteredSubscribers = [];
  var apiUrl;
  bool _isEmpty = false;
  bool _isLoading = false;

  int currentPage = 1;
  final int itemsPerPage = 5;
  final TextEditingController _searchController = TextEditingController();

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }

  @override
  void initState() {
    super.initState();
    fetchRenewSubscribers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // Filter subscribers based on the search query
      filteredSubscribers = subscribers.where((subscriber) {
        return subscriber['name']!.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
      // Reset pagination to the first page when searching
      currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredSubscribers.length / itemsPerPage).ceil();
    List<Map<String, String>> paginatedSubscribers = filteredSubscribers
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 50),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: HexColor('#3465D9'),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => CoordinatorPage(
                      firstname: widget.firstname,
                      id: widget.id,
                      isAdmin: widget.isAdmin,
                    )),
                    (Route<dynamic> route) => false, // Removes all routes in the stack
              );
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
                      : _isEmpty
                      ? Center(child: Text("No subscribers found.")) // Show message if the list is empty
                      : ListView.builder(
                    itemCount: paginatedSubscribers.length, // Number of items per page
                    itemBuilder: (context, index) {
                      final subscriber = paginatedSubscribers[index];
                      bool isDeletable = subscriber['isdelete'] == '0'; // Check if isdelete is '0'
                      bool isActive = subscriber['isactive'] == '1'; // Check if isactive is '1'

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                subscriber['name']!,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  isDeletable && isActive ? 'Temporary' : 'Normal',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Add some spacing before the button
                            isDeletable && isActive ?
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await tempoaryUpdate(subscriber['id']);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationAgent(firstname: widget.firstname, isAdmin: widget.isAdmin, id: widget.id),
                                    ),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text('Update'),
                              ),
                            ):
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotRenew(id: subscriber['id']),
                                    ),
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text('Renew'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                  Text('Page $currentPage of $totalPages'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future tempoaryUpdate(id) async {

    print("accountID................${id}");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/TempoarySubscriberUpdate/'),
        body: {
          'id': id.toString(),
        });
    print("dfdsf $response.body");
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);


    }
  }

  Future<void> fetchRenewSubscribers() async {
    print("Fetching subscribers...");
    setState(() {
      _isLoading = true;
    });

    await getApiurl(); // Assuming this function sets the API URL

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/AgentNotification/'),
        body: {
          'id': widget.id,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> subData = jsonResponse['sub_data'];
        List<Map<String, String>> fetchedSubscribers = subData.map<Map<String, String>>((item) {
          return {
            'name': item['name'] as String,
            'id': item['id'].toString(), // Make sure to replace with actual key for ID
            'isdelete': item['isdelete'].toString(), // Make sure to replace with actual key for ID
            'isactive': item['isactive'].toString(),
          };
        }).toList();

        setState(() {
          _isLoading = false;
          _isEmpty = fetchedSubscribers.isEmpty;
          subscribers = fetchedSubscribers;
          filteredSubscribers = fetchedSubscribers; // Initialize filteredSubscribers
        });

        print("Subscribers: $subscribers");
      } else {
        print("Failed to fetch subscribers");
        setState(() {
          _isLoading = false;
          _isEmpty = true;
        });
      }
    } catch (e) {
      print("Error decoding JSON: $e");
      setState(() {
        _isLoading = false;
        _isEmpty = true;
      });
    }
  }
}
