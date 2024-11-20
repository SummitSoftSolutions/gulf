import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/superadmin/Itemsmodel.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class CommityCreation extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const CommityCreation({super.key,required this.firstname, required this.id, required this.isAdmin,});

  @override
  State<CommityCreation> createState() => _CommityCreationState();
}

class _CommityCreationState extends State<CommityCreation> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController commityNamecntr = TextEditingController();

  List<Item> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    getApiurl();
    _fetchItems();
  }

  var apiUrl;
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('COMMITY CREATION',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: HexColor('#3465D9'),),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.87,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child:  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:30.0),
                              child: SizedBox(
                                width:300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: commityNamecntr,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Commity Name',
                                    hintText: 'Commity Name',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
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
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('#3465D9'),
                                ),
                                child: const Text('ADD',style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ?? false)  {
                                    await commityCreation();
                                      // Navigator.push(
                                      //     context, MaterialPageRoute(builder: (context) {
                                      //   return  SubscriberDetailPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin);
                                      // }));
                                  }
                                },
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.87,
              //   height: MediaQuery.of(context).size.height * 0.58,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.3),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //         offset: const Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: NotificationListener<ScrollNotification>(
              //     onNotification: (scrollInfo) {
              //       if (!_isLoading && _hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              //         _fetchItems();
              //       }
              //       return false;
              //     },
              //     child: ListView.builder(
              //       itemCount: _items.length + (_hasMore ? 1 : 0),
              //       itemBuilder: (context, index) {
              //         if (index == _items.length) {
              //           return Center(child: CircularProgressIndicator());
              //         }
              //         final item = _items[index];
              //         return ListTile(
              //           title: Text(item.commitycreation),
              //           trailing: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: <Widget>[
              //               IconButton(
              //                 icon: Icon(Icons.edit),
              //                 onPressed: () {
              //
              //                 },
              //               ),
              //               IconButton(
              //                 icon: Icon(Icons.delete),
              //                 onPressed: () {
              //
              //                 },
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> commityCreation() async {
    await getApiurl(); // Make sure this function is setting apiUrl correctly

    var response = await http.post(
      Uri.parse('$apiUrl/CommityCreation/'),
      headers: {
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: jsonEncode({
        'commitycreation': commityNamecntr.text,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> _fetchItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('$apiUrl/CommityCreation/?page=$_page&page_size=$_pageSize'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      final List<dynamic> results = data['results'];  // Adjust based on your API response

      List<Item> fetchedItems = results.map((json) => Item.fromJson(json)).toList();

      setState(() {
        _isLoading = false;
        _page++;
        if (fetchedItems.length < _pageSize) {
          _hasMore = false;
        }
        _items.addAll(fetchedItems);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
