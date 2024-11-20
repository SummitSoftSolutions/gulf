import 'dart:convert';
import 'package:gulf_suprabhaatham/agent/cancelation/CancelPageList.dart';
import 'package:gulf_suprabhaatham/agent/coordinatormodel.dart';
import 'package:gulf_suprabhaatham/agent/subscribermodel.dart';
import 'package:gulf_suprabhaatham/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

import '../usermode.dart';

class SubscriptionCancel extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const SubscriptionCancel({super.key,required this.firstname, required this.id, required this.isAdmin,});

  @override
  State<SubscriptionCancel> createState() => _SubscriptionCancelState();
}

class _SubscriptionCancelState extends State<SubscriptionCancel> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinput2 = TextEditingController();
  TextEditingController subamountCntr = TextEditingController();
  TextEditingController subrecivedamountCntr = TextEditingController();
  TextEditingController subgivenamountCntr = TextEditingController();
  TextEditingController cancelReason = TextEditingController();
  var coordinator_val;
  List<CoorList> coordinator = [];
  String?  selectedcoordinator;
  String?  selectedCancelType;
  var user_val;
  List<UserListData> users = [];
  String?  selecteduser;
  var subscriber_val;
  List<SubscriberList> subscriber = [];
  String?  selectedsubscriber;
  var apiUrl;
  String? selectedValue;
  bool isShow=false;
  String? subscriberid;
  String? coordinatorid;
  String? selectedUserID;
  String? selectedUserID1;
  String? balance = '0' ;
  bool isvisible = false;
  String itemSelected = '';
  bool isAdmin = false;
  List<String> cancelTypeIds = ['1', '2'];
  List<String> cancelType = ['Temporary', 'Permanent'];

  String? selectedCancelTypeId;
  bool checkVisible = false;
  String firstname='';
  String selectedUser='';
  String dateinputs = '';
  var id;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }

  int count=1;

  void increment()
  {
    setState(() {
      count++;
    });

  }
  void decrement()
  {
    setState(() {
      if (count >1)
      {
        count--;
      }

    });

  }
  void initState()
  {
    super.initState();
    loadData();
    dateinputs = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }
  Future<void> loadData()
  async {
    await getuser();
    await selectsubcriber(selectedUser);
    await Coordinator();
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageViewCancel(firstname: firstname,id: id, isAdmin:false)),
              (Route<dynamic> route) => false, // Removes all routes in the stack
        );
        return false; // Returning false prevents the default back navigation
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
          padding: EdgeInsets.only(left:20),
          child: Text('Subscription Cancel',style: appbarTextColor,),
        ),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageViewCancel(firstname: firstname, id: id,isAdmin:isAdmin)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),),
        body:
        SingleChildScrollView(
          child: Form(
            key:_formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.6,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.40,
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black, // Border color
                                      ),
                                      borderRadius: BorderRadius.circular(5), // Optional: Rounded corners
                                    ),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                            dateinputs
                                        ),
                                        IconButton(onPressed: () async {
                                          DateTime? pickedDate1 = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now().add(
                                                const Duration(days: 365 * 10)),
                                          );
                                          // dateinput.text = "gdfhshd";


                                          if (pickedDate1 != null) {
                                            print(
                                                pickedDate1); // Picked Date output format => 2021-03-10 00:00:00.000
                                            String formattedDate1 = DateFormat('yyyy-MM-dd')
                                                .format(pickedDate1);
                                            print(
                                                "d.....$formattedDate1"); // Formatted date output using intl package => 2021-03-16

                                            setState(() {
                                              dateinputs = formattedDate1;
                                            });
                                            print("date....${dateinput.text}");
                                          } else {
                                            print("Date is not selected");
                                          }
                                        },  icon:Icon(Icons.calendar_today))


                                      ],
                                    )
                                ),
                                const SizedBox(
                                  height:20,
                                )
                              ]
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:28.0),
                              child: Text('Coordinator'),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
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
                                selectedUser = selectedUserData.id.toString();
                                selectsubcriber(selectedUser);


                              }
                            },

                          ),
                        ),

                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:28.0),
                              child: Text('Subscriber'),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: DropdownSearch<String>(
                            selectedItem: selecteduser,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: users.map((UserListData data) {
                              return data.name; // Assuming 'Name' holds the strings you want to display
                            }).toList(),
                            onChanged: (String? value) { // Change the parameter to accept nullable string
                              setState(() {
                                selecteduser = value ?? '';
                                isvisible = true;
                              });
                              if (value != null) {
                                // Find the UserListData instance corresponding to the selected name
                                UserListData? selectedUserData = users.firstWhere(
                                      (data) => data.name == value,
                                );
                                print("selecteduser $selecteduser");
                                // Pass the ID to your function if available
                                print("selectedUserData ${selectedUserData.id}");
                                subscriberid = selectedUserData.id.toString();
                                selectedUserID = selectedUserData.accountid.toString();
                                selectedUserID1 = selectedUserData.regid.toString();
                                print("selectedUserID ${selectedUserData.accountid}");

                              }
                            },

                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),

                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:28.0),
                              child: Text('Cancel Type'),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.07,

                          child: DropdownButton<String>(
                            value: selectedCancelTypeId,
                            items: List.generate(cancelTypeIds.length, (index) {
                              return DropdownMenuItem<String>(
                                value: cancelTypeIds[index], // The ID
                                child: Text(cancelType[index]), // The Name
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedCancelTypeId = value;
                              });

                            },
                          ),
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:28.0),
                              child: Text('Cancel Reason'),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.09,
                          child:  TextField(
                            controller: cancelReason,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('CANCEL',style: TextStyle(color: Colors.white),),
                            onPressed:() {

                                cancel_insert();
                                // await  insert_sub(selectedCcZoneId);
                                // // _formKey.currentState?.reset();
                                // clear_data();
                                // Navigator.push(context, MaterialPageRoute(builder: (context) {return  Renweal();}));

                              // if (_formKey.currentState?.validate() ?? false) {
                              //   // insertCoordinator(selectedGender);
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )





              ],
            ),
          ),
        ),
      ),
    );
  }
  // Future fetchamount(String? selectedsubscriber) async {
  //
  //   print("subscriber_name................${this.selectedsubscriber}");
  //   await getApiurl(); // Assuming this function sets the API URL
  //
  //   var response = await http.post(Uri.parse('$apiUrl/select_subscriberamount/'),
  //       body: {
  //         'subscribername': selectedsubscriber,
  //       });
  //
  //   if (response.statusCode == 200) {
  //     var decodedResponse = jsonDecode(response.body);
  //     var subAmountList = decodedResponse as List<dynamic>;
  //     if(subAmountList.isNotEmpty) {
  //       var subAmount = subAmountList[0]['subscriberamount'];
  //       print("subAmount $subAmount");
  //
  //       setState(() {
  //         subamountCntr.text = subAmount.toString();
  //       });
  //     }
  //     print(response.body);
  //   }
  // }
  Future selectsubcriber(String selectedUser) async {
    print("selectsubcriber.............................$selectedUser");
    String idToPass = selectedUser?.isNotEmpty == true ? selectedUser! : widget.id;

    print("selectsubcriber with ID: $idToPass");

    await getApiurl();
      var response = await http.post(Uri.parse('$apiUrl/select_subscribers/'),
          body: {
            'id': idToPass,
          });
    if (response.statusCode == 200) {
      setState(() {
        user_val = jsonDecode(response.body);
      });
      print("user_val:...................... $widget.id");

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


  Future<void> cancel_insert() async {
    await getApiurl(); // Assuming this function sets the API URL
    String idToPass = selectedUser?.isNotEmpty == true ? selectedUser! : widget.id;
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var response = await http.post(
      Uri.parse('$apiUrl/CancelationSubscription/'),
      body: {
        'subscriberid': subscriberid,
        'coordinatorid': idToPass,
        'dateinput': dateinput.text,
        'cancelReason': cancelReason.text,
        'selectedCancelTypeId': selectedCancelTypeId,
        'created_by': widget.id,
        'created_at': formattedDate,
      },
    );
    var data;
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No
        if (data.contains("success")) {
          const SnackBar snackBar = SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {});
        } else {
          const SnackBar snackBar = SnackBar(
            content: Text("Error"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });

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
    // await fetchcountofusers(id);
    return;
  }
}
