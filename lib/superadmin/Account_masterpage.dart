import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'account.dart';
import 'accountmodel.dart';

class AccountMaster extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const AccountMaster({super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  State<AccountMaster> createState() => _AccountMasterState();
}

class _AccountMasterState extends State<AccountMaster> {
  var apiUrl;

  @override
  void initState()
  {
    super.initState();
    getApiurl();
    fetchaccount();
    fetchcode();
    getuser();
    fetchallArea();
    fetchData();
  }
  @override
  void dispose() {
    // Cancel timers, dispose of controllers, etc.
    super.dispose();
  }
  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> zoneData = await fetchallArea();
      setState(() {
        dataList = zoneData;
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
  TextEditingController codeCntr = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController openingCntr = TextEditingController();

  bool isSelected1 = false;
  bool isSelected2 = false;
  int itemsPerPage = 10;
  int currentPage = 1;
  String? selectedaccountval;
  var account_val;
  List<AccountList> accounts = [];
  List<Map<String, dynamic>>  dataList = [];
  int selectedValue = 0;
  int selectedValue1 = 0;
  String firstname='';
  String namval='';
  String parentidval='';
  String accidval='';
  String openbalvanceval='';
  String selectedUserID1='';
  bool showUpdateButton = false;
  List<Map<String, dynamic>> getVisibleItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return dataList.sublist(startIndex, endIndex < dataList.length ? endIndex : dataList.length);
  }

  var id;
  final ScrollController _scrollController = ScrollController();

  int userReg=0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
          padding: EdgeInsets.only(left:40.0),
          child:Text('Account Master',style: appbarTextColor),
        ),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color:appbArrowColor),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Accounts(firstname: firstname, id: id,isAdmin:true)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Refresh"),
                            GestureDetector(child: Icon(Icons.refresh,color: HexColor('#3465D9'),size: 50,),onTap: ()
                            {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return AccountMaster(
                                      firstname: widget.firstname,
                                      id: widget.id,
                                      isAdmin: widget.isAdmin,);
                                  }));
                            },),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:15,right: 15,top:30),
                          child: TextField(
                            enabled: false,
                            controller: codeCntr,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Code',
                              hintText: 'Code',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller:name,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              hintText: 'Name',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left:18.0,top:5),
                          child: Row(
                            children: [
                              Text("Select Accounts"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:15,right:15),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.height*0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0), // Adjust border radius as needed
                              // Background color similar to TextFormField
                            ),
                            child: DropdownSearch<String>(
                                selectedItem: selectedaccountval,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                                items: accounts.map((AccountList data) {
                                  return data.name; // Assuming 'Name' holds the strings you want to display
                                }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    selectedaccountval = value!;
                                  });
                                  if (value != null) {
                                    AccountList? selectedUserData = accounts.firstWhere(
                                          (data) => data.name == value,
                                    );
                                    selectedUserID1 = selectedUserData.id.toString();
                                  }
                                }
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the opening balance';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: openingCntr,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Opening Balance',
                              hintText: 'OB',
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected1 = !isSelected1; // Toggle the selection state for the first toggle button
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected1 ? Colors.blue : Colors.transparent, // Set color based on selection state
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: isSelected1
                                        ? Icon(Icons.check, size: 16, color: Colors.white) // Show check icon when selected
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Isactive'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelected2 = !isSelected2; // Toggle the selection state for the second toggle button
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected2 ? Colors.blue : Colors.transparent, // Set color based on selection state
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: isSelected2
                                        ? Icon(Icons.check, size: 16, color: Colors.white) // Show check icon when selected
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Isdebit'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return AccountMaster(
                                        firstname: widget.firstname,
                                        id: widget.id,
                                        isAdmin: widget.isAdmin,);
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
                                insertaccount();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return AccountMaster(
                                        firstname: widget.firstname,
                                        id: widget.id,
                                        isAdmin: widget.isAdmin,);
                                    }));
                              }
                            },
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(top:30.0),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * 0.4,
                        //     height: MediaQuery.of(context).size.height * 0.05,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: HexColor('#3465D9'),
                        //       ),
                        //       child: const Text('ADD',style: addButtonTextColor),
                        //       onPressed: () {
                        //         if (_formKey.currentState?.validate() ??
                        //             false) {
                        //           insertaccount();
                        //           Navigator.push(context,
                        //               MaterialPageRoute(builder: (context) {
                        //                 return AccountMaster(
                        //                   firstname: widget.firstname,
                        //                   id: widget.id,
                        //                   isAdmin: widget.isAdmin,);
                        //               }));
                        //         }
                        //
                        //       }
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        // Container(
                        //   height:MediaQuery.of(context).size.height,
                        //   color: Colors.grey.shade100,
                        //   child: Column(
                        //     children: [
                        //       DropdownButton<int>(
                        //         value: itemsPerPage,
                        //         onChanged: (newValue) {
                        //           setState(() {
                        //             itemsPerPage = newValue!;
                        //             currentPage = 1; // Reset to first page when changing items per page
                        //           });
                        //         },
                        //         items: [10, 20, 50].map<DropdownMenuItem<int>>((int value) {
                        //           return DropdownMenuItem<int>(
                        //             value: value,
                        //             child: Text('$value per page'),
                        //           );
                        //         }).toList(),
                        //       ),
                        //       SizedBox(
                        //         height:8,
                        //       ),
                        //       Container(
                        //         color: HexColor('#3465D9'),
                        //         height:40,
                        //         width:MediaQuery.of(context).size.width*0.98,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             // Display zonename on the left
                        //             Padding(
                        //               padding: const EdgeInsets.only(left:20.0),
                        //               child: Text(
                        //                 'ACCOUNT NAME',
                        //                 style: TextStyle(fontSize: 16.0,color: Colors.white),
                        //               ),
                        //             ),
                        //             // Display edit icon on the right
                        //             Padding(
                        //               padding: const EdgeInsets.only(left:5.0,right: 9),
                        //               child: Text('Edit',
                        //                 style: TextStyle(fontSize: 16.0,color: Colors.white),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height:8,
                        //       ),
                        //       Expanded(
                        //         child: ListView.builder(
                        //           itemCount: getVisibleItems().length,
                        //           itemBuilder: (BuildContext context, int index) {
                        //             var zoneData = getVisibleItems();
                        //             return Card(
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   // Display zonename on the left
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left:8.0),
                        //                     child: Text(
                        //                       zoneData[index]['name'],
                        //                       style: TextStyle(fontSize: 16.0),
                        //                     ),
                        //                   ),
                        //                   // Display edit icon on the right
                        //                   Row(
                        //                     children: [
                        //                       IconButton(
                        //                         icon: Icon(Icons.edit),
                        //                           onPressed: () async {
                        //                             Map<String, dynamic> data = await showEditZoneForm(zoneData[index]);
                        //                             setState(() {
                        //                               namval = data['name'] ?? ''; // If data['name'] is null, use an empty string
                        //                               parentidval = data['parentid']?.toString() ?? ''; // Convert to string and handle null
                        //                               accidval = data['accid']?.toString() ?? ''; // Convert to string and handle null
                        //                             });
                        //                           }
                        //
                        //                       ),
                        //                       // IconButton(
                        //                       //   icon: Icon(Icons.delete),
                        //                       //   onPressed: () async {
                        //                       //
                        //                       //     await deleteZone(zoneData[index]);
                        //                       //     // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //                       //     //   return const DivisonPage();
                        //                       //     // }));
                        //                       //
                        //                       //
                        //                       //   },
                        //                       // ),
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ),
                        //             );
                        //
                        //           },
                        //         ),
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           ElevatedButton(
                        //             onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                        //             child: Text('Previous'),
                        //           ),
                        //           SizedBox(width: 10),
                        //           Text('Page $currentPage'),
                        //           SizedBox(width: 10),
                        //           ElevatedButton(
                        //             onPressed: currentPage < (dataList.length / itemsPerPage).ceil() ? () => setState(() => currentPage++) : null,
                        //             child: Text('Next'),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // FloatingActionButton(
                        //   onPressed: () {
                        //     // Scroll to top when FloatingActionButton is pressed
                        //     _scrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        //   },
                        //   child: Icon(Icons.arrow_upward),
                        // ),
                      ],
                    ),
                  )



                ],
              ),
            ),
          ),

        )
    );
  }
  Future fetchaccount() async {
    print("fetchaccount.................");
    await getApiurl();
    var response = await http.post(
      (Uri.parse(
          '$apiUrl/select_account/')),
    );


    if (response.statusCode == 200) {
      setState(() {
        // account_val = jsonDecode(jsonEncode(response.body));
        var decodedResponse = jsonDecode(response.body);
        var reEncodedResponse = jsonEncode(decodedResponse);
        account_val = jsonDecode(reEncodedResponse);
      });
      // print("country",selectedcountryzone_val.status);
      print("account_val $account_val");
      accounts = (account_val).map<AccountList>((model) {
        return AccountList.fromJson(model);
      }).toList();
      print("accounts $accounts");
    }
  }



  Future<void> EditUserData() async {
    setState(() {
      showUpdateButton = true;
    });
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/AccountMaster_edit/'),
      body: {
        'name': name.text,
        'accid': accidval,
        'parentid':parentidval,
        'openbalvanceval':openingCntr.text,

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

  // Future deleteZone(Map<String, dynamic> zoneData) async {
  //   var data;
  //   int accid;
  //   accid= zoneData['id'];
  //   var response = await http.post(
  //     Uri.parse('$apiUrl/deleteAccountMaster/'),
  //     body: {
  //       'accid':accid.toString(),
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       data = response.body.trim(); // No need for jsonDecode
  //     });
  //     print("data success $data");
  //
  //     if (data.contains("assigned")) {
  //       QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.error,
  //         title: 'Oops...',
  //         text: "Sorry, the area is already assigned you can't delete it",
  //       );
  //       setState(() {});
  //     }
  //     else if(data.contains("delete"))
  //     {
  //       QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.success,
  //         text: 'Successfully Deleted',
  //       ).then((_) {
  //         setState(() {
  //           Navigator.push(context,
  //                             MaterialPageRoute(builder: (context) {
  //                               return AccountMaster(
  //                                 firstname: widget.firstname,
  //                                 id: widget.id,
  //                                 isAdmin: widget.isAdmin,);
  //                             }));
  //         });
  //       });
  //     }
  //
  //   }else {
  //     // Handle API error
  //     print("Failed to fetch role");
  //   }
  // }


  Future showEditZoneForm(Map<String, dynamic> zoneData) async {
    setState(() {
      showUpdateButton = true;
    });
    print("clikcked fun");
    name.text = zoneData['name'];
    selectedaccountval = zoneData['parentid__name'].toString();
    openingCntr.text = zoneData['openbalance'];
    var parentid = zoneData['parentid'];
    var accid = zoneData['id'];
    print("parentid111111 $parentid");
    print("accid $accid");
    // var zoneid = zoneData['zoneid'].toString();
    // var zoneid__zoneid = zoneData['zoneid__zoneid'].toString();
    return {
      'parentid': parentid,
      'accid': accid,
    };

  }
  Future<void> insertaccount() async {
    await getApiurl();
    var data;
    print("insertaccount");
    var response = await http.post(
      Uri.parse('$apiUrl/insert_accountmaster/'),
      body: {
        'codeCntr':codeCntr.text,
        'name':name.text,
        'openingCntr':openingCntr.text,
        'selectedaccountval':selectedUserID1,
        'selectedValue':isSelected1.toString(),
        'selectedValue1':isSelected2.toString(),


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
  Future fetchcode() async {


    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_code/'),
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      print("decodedResponse $decodedResponse");
      if (decodedResponse is List<dynamic> && decodedResponse.isNotEmpty) {
        var subreg1 = decodedResponse[0]['max_value'];
        print("subreg1 $subreg1");
        if (subreg1 != null) {
          // int incrementedValue = (subreg1 as int) + 1; // Increment subreg by 1
           if(subreg1 as int<100)
             {
               int incrementedValue = 101;
               setState(() {
                 codeCntr.text = incrementedValue.toString(); // Set the incremented value to regval.text
               });
               print("Incremented subreg: $incrementedValue");
             }
           else
             {
               int incrementedValue = (subreg1 as int) + 1;
               setState(() {
                 codeCntr.text = incrementedValue.toString(); // Set the incremented value to regval.text
               });
               print("Incremented subreg1: $incrementedValue");
             }


        } else {
          print('Value not found or null');
        }
      } else {
        print('Empty or invalid response');
      }
    }

  }
  Future<List<Map<String, dynamic>>> fetchallArea() async {
    print("selectsubcriber.............................");
    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/viewAllAccountmaster/'));

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
  Future<void> getuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    firstname = prefs.getString('firstname')!;
    print('...........firstname.....$firstname');
    id = prefs.getString('id');
    print('...........id.....$id');
    return;
  }
}
