import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gulf_suprabhaatham/agent/usermode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'coordinatorlogin.dart';
import 'coordinatormodel.dart';

class viewIndiviualCoordinatorReceipt extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  final int data_val;

  const viewIndiviualCoordinatorReceipt({super.key, required this.firstname, required this.id, required this.isAdmin, required this.data_val});



  @override
  State<viewIndiviualCoordinatorReceipt> createState() => _viewIndiviualCoordinatorReceiptState();
}

class _viewIndiviualCoordinatorReceiptState extends State<viewIndiviualCoordinatorReceipt> {
  TextEditingController receiptidCntr = TextEditingController();
  TextEditingController amountCntr = TextEditingController();
  TextEditingController dateCntr = TextEditingController();
  TextEditingController transcationidCntr =  TextEditingController();
  TextEditingController coordinatorid_idCntr =  TextEditingController();
  TextEditingController accountnameCntr =  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String?  selecteduser;
  bool dropdownInitialized = false;
  var user_val;
  List<UserListData> users = [];
  var subscriber_val;
  bool isvisible = false;

  String? subscriberid;
  String? coordinatorid = '';
  String selectedUserID = '';
  var coordinator_val;
  List<CoorList> coordinator = [];
  String?  selectedcoordinator;

  var apiUrl;
  Map<String, String> userIdToNameMap = {};

  void initState()
  {
    super.initState();
    getApiurl();
    print("selectedUserID $selectedUserID");
    selectsubcriber();
    Coordinator();
    viewindiviuaCoordinatorlRecieptdata(widget.data_val);
  }

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Padding(
          padding: EdgeInsets.only(left:50.0),
          child: Text('Detailed View',style:appbarTextColor),
        ),backgroundColor: HexColor('#3465D9'),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CoordinatorPage(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: receiptidCntr,
                          decoration: InputDecoration(
                            labelText: 'Receipt Number',
                            hintText: 'age',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: const OutlineInputBorder(
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: transcationidCntr,
                          decoration: InputDecoration(
                            labelText: 'Transcation ID',
                            hintText: 'age',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: const OutlineInputBorder(

                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top:20.0),
                //   child: TextFormField(
                //     readOnly: true,
                //     enabled: false,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter your First Name';
                //       }
                //       return null; // Return null for no validation error
                //     },
                //     controller: accountnameCntr,
                //     decoration: InputDecoration(
                //       labelText: 'Name',
                //       hintText: 'fname',
                //       hintStyle: TextStyle(color: Colors.grey[400]),
                //       border: const OutlineInputBorder(
                //       ),
                //       contentPadding: const EdgeInsets.symmetric(
                //           horizontal: 16.0, vertical: 14.0),
                //     ),
                //     keyboardType: TextInputType.emailAddress,
                //     onSaved: (value) {
                //       setState(() {
                //       });
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [

                    Text('Subscriber'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: DropdownSearch<String>(
                    selectedItem: selecteduser,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    items: users.map((UserListData data) => data.name).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selecteduser = value ?? '';
                        isvisible = true;
                      });
                      // Update selectedUserID based on the selected user
                      UserListData? selectedUser = users.firstWhere(
                            (user) => user.name == value,
                      );
                      if (selectedUser != null) {
                        selectedUserID = selectedUser.accountid.toString(); // Use the account ID instead of the name
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text('Coordinator'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: DropdownSearch<String>(
                    selectedItem: selectedcoordinator,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    items: coordinator.map((CoorList data) {
                      return data.firstname; // Assuming 'Name' holds the strings you want to display
                    }).toList(),
                    onChanged: (String? value) { // Change the parameter to accept nullable string
                      setState(() {
                        selectedcoordinator = value ?? ''; // Ensure selecteduser is not null
                      });
                      if (value != null) {
                        // Find the UserListData instance corresponding to the selected name
                        CoorList? selectedUserData = coordinator.firstWhere(
                              (data) => data.firstname == value,
                        );

                        // Pass the ID to your function if available
                        print("selectedUserData ${selectedUserData.id}");
                        coordinatorid = selectedUserData.id.toString();


                      }
                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the amount';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: amountCntr,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'place',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#3465D9')
                    ),
                    child: const Text('UPDATE',style: addButtonTextColor),
                    onPressed: () async {
                      await updateCoordinatorRecipt(widget.data_val);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return  viewIndiviualCoordinatorReceipt(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin, data_val: widget.data_val);
                      }));
                    },
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  Future viewindiviuaCoordinatorlRecieptdata(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/viewCoorRecData/'),
      body: {
        'id': value.toString(),
      },
    );

    if (response.statusCode == 200) {
      var result_data;
      result_data = json.decode(response.body);
      print('result_data type: ${result_data.runtimeType}');
      print('result_data content: $result_data');

      if (result_data is List && result_data.isNotEmpty) {
        var detail = result_data[0];
        print("detail $detail");
        receiptidCntr.text = detail['receiptid'].toString();
        amountCntr.text = detail['amount'].toString();
        transcationidCntr.text = detail['transcationid'];
        accountnameCntr.text = detail['accountname'];
        dateCntr.text = detail['date'];
        selecteduser = detail['accountname'].toString();
        selectedcoordinator = detail['coordinatorid_id'].toString();
        selectedUserID = detail['account_id'].toString();
        coordinatorid = detail['coordinatorid'].toString();
      }
    }
  }

  Future selectsubcriber() async {
    print("selectsubcriber.............................");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/select_subscribers/'));

    if (response.statusCode == 200) {
      setState(() {
        user_val = jsonDecode(response.body);
      });

      print("user_val: $user_val");

      users = (user_val).map<UserListData>((model) {
        return UserListData.fromJson(model);
      }).toList();
      print("users................$users");
      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future updateCoordinatorRecipt(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/coordinatorReceiptUpdate/'),
      body: {
        'id': value.toString(),
        'amount':amountCntr.text,
        'transcationidCntr':transcationidCntr.text,
        'selectedUserID':selectedUserID,
        'coordinatorid': coordinatorid,
      },
    );
    print("response ${response.body}");
    if (response.statusCode == 200) {
      var data;
      setState(() {
        data = response.body.trim(); // No
      });
      print("data $data");
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
          content: Text("Not Updated"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

  }
  Future Coordinator() async
  {
    print("selectsubcriber.............................");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/select_coordinatorsre/'));

    if (response.statusCode == 200) {
      setState(() {
        coordinator_val = jsonDecode(response.body);
      });

      print("coordinator_val: $coordinator_val");

      coordinator = (coordinator_val).map<CoorList>((model) {
        return CoorList.fromJson(model);
      }).toList();
      print("users................$coordinator");
      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }
  // Future deleteCoordinatorsubscribers(value) async {
  //   await getApiurl();
  //   var response = await http.post(
  //     Uri.parse('$apiUrl/coordinatorsubscriberDelete/'),
  //     body: {
  //       'id': value.toString(),
  //     },
  //   );
  //   print("response ${response.body}");
  //   if (response.statusCode == 200) {
  //     var data;
  //     setState(() {
  //       data = response.body.trim(); // No
  //     });
  //     print("data $data");
  //     if (data.contains("success")) {// Check if data is "success"
  //       final SnackBar snackBar = const SnackBar(
  //         content: Text("Success"),
  //         backgroundColor: Colors.green,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       setState(() {});
  //     }
  //     else {
  //       final SnackBar snackBar = const SnackBar(
  //         content: Text("Not Updated"),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //   }
  //
  // }

}
