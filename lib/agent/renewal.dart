import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/agent/subscribermodel.dart';
import 'package:gulf_suprabhaatham/agent/usermode.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

import '../constants.dart';
import '../superadmin/SubcriptionAgentPage.dart';
import 'coordinatormodel.dart';

class Renweal extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  Renweal(
      {super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  State<Renweal> createState() => _RenwealState();
}

class _RenwealState extends State<Renweal> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinput2 = TextEditingController();
  TextEditingController subamountCntr = TextEditingController();
  TextEditingController subrecivedamountCntr = TextEditingController();
  TextEditingController subgivenamountCntr = TextEditingController();
  TextEditingController refcheckNumber = TextEditingController();
  var coordinator_val;
  List<CoorList> coordinator = [];
  String? selectedcoordinator;
  var user_val;
  List<UserListData> users = [];
  String? selecteduser;
  var subscriber_val;
  List<SubscriberList> subscriber = [];
  String? selectedsubscriber;
  var apiUrl;
  String? selectedValue;
  bool isShow = false;
  String? subscriberid;
  String? coordinatorid;
  String? selectedUserID;
  String? selectedUserID1;
  String? balance = '0';
  String dateinputs = '';

  bool isvisible = false;
  String itemSelected = '';
  bool isAdmin = false;
  List<String> payementmode = [
    'Cheque',
    'Deposit',
    'Direct Transfer',
  ];
  bool checkVisible = false;
  String firstname = '';
  var id;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }

  int count = 1;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 1) {
        count--;
      }
    });
  }

  void initState() {
    super.initState();
    loadData();
    dateinputs = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }

  Future<void> loadData() async {
    await getuser();
    await selectsubcriber();
    await fetchsub();
    await Coordinator();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              SubscriberAgentPage(
                  firstname: firstname, id: id, isAdmin: false)),
              (
              Route<dynamic> route) => false, // Removes all routes in the stack
        );
        return false; // Returning false prevents the default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#3465D9'), title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text('Renewal Form', style: appbarTextColor,),
        ), automaticallyImplyLeading: true, leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: appbArrowColor,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>
                  SubscriberAgentPage(
                      firstname: firstname, id: id, isAdmin: isAdmin)),
                  (Route<
                  dynamic> route) => false, // Removes all routes in the stack
            );
          },
        ),),
        body:
        SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
              const SizedBox(
              height: 30,
              ),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                        children: [
                    Padding(
                    padding: const EdgeInsets.only(right:25.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                    Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(5)),

                    child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(
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


                // TextField(
                //   style: const TextStyle(fontSize: 20,color:Colors.black),
                //   controller: dateinput,
                //   textAlign: TextAlign.start,// Editing controller of this TextField
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     suffixIcon: Icon(Icons.calendar_today),
                //   ),
                //   readOnly: true,
                //   onTap: () async {
                //     DateTime? pickedDate1 = await showDatePicker(
                //       context: context,
                //       initialDate: DateTime.now(),
                //       firstDate: DateTime(1900),
                //       lastDate:  DateTime.now().add(const Duration(days: 365 * 10)),
                //     );
                //     dateinput.text= "gdfhshd";
                //
                //
                //     if (pickedDate1 != null) {
                //       print(pickedDate1); // Picked Date output format => 2021-03-10 00:00:00.000
                //       String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1);
                //       print("d.....$formattedDate1"); // Formatted date output using intl package => 2021-03-16
                //
                //       setState(() {
                //         dateinput.text = formattedDate1;
                //       });
                //       print("date....${dateinput.text}");
                //     } else {
                //       print("Date is not selected");
                //     }
                //   },
                // ),
              ),
            ),
            // const SizedBox(
            //   height:20,
            // )
            ]
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text('Subscriber'),
          ),
        ],
      ),
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.85,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.07,
        child: DropdownSearch<String>(
          selectedItem: selecteduser,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
          ),
          items: users.map((UserListData data) {
            return data
                .name; // Assuming 'Name' holds the strings you want to display
          }).toList(),
          onChanged: (
              String? value) { // Change the parameter to accept nullable string
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
              fetchbalance(selectedUserData.accountid);
            }
          },

        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Visibility(
        visible: isvisible,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text('Balance: $balance', style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text('Coordinator'),
          ),
        ],
      ),
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.85,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.07,
        child: DropdownSearch<String>(
          selectedItem: selectedcoordinator,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
          ),
          items: coordinator.map((CoorList data) {
            return data
                .firstname; // Assuming 'Name' holds the strings you want to display
          }).toList(),
          onChanged: (
              String? value) { // Change the parameter to accept nullable string
            setState(() {
              selectedcoordinator =
                  value ?? ''; // Ensure selecteduser is not null
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
      Row( // Adjust alignment as needed
        children: [
          const SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.4,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.grey
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),


              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: selectedsubscriber,
                    iconSize: 36,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Subscription"),
                    ),
                    // hint: Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Align(alignment: Alignment.centerLeft,
                    //     child: Text("Select HR",style: TextStyle(fontSize: 20),),
                    //   ),
                    // ),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black),
                    isExpanded: true,
                    items: subscriber
                        .map((SubscriberList data) {
                      return DropdownMenuItem<String>(
                        value: data.id.toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              data.subscribername,
                              style: const TextStyle(fontSize: 15)

                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedsubscriber = value!;
                        // selectedCZoneId = czones.firstWhere((element) => element.id.toString() == value).zoneid;
                      });
                      fetchamount(selectedsubscriber);
                    }
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    decrement();
                    fetchamount(selectedsubscriber);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: HexColor('#3465D9'),),
                    child: const Icon(
                      Icons.remove,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                    width: 20
                ),
                Text('$count',
                ),
                const SizedBox(
                    width: 20
                ),
                GestureDetector(
                  onTap: () {
                    increment();
                    fetchamount(selectedsubscriber);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: HexColor('#3465D9'),),
                    child: const Icon(
                      Icons.add,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                    width: 15
                ),
              ],
            ),
          ),


        ],
      ),
      Row(
        children: [
          const SizedBox(
              width: 31
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust border radius as needed
                // Background color similar to TextFormField
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter the Amount';
                  }
                  return null; // Return null for no validation error
                },
                controller: subamountCntr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
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
          const SizedBox(
              width: 20
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.4,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Given Amount';
                  }
                  return null; // Return null for no validation error
                },
                controller: subrecivedamountCntr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Given  Amount',
                  hintText: 'name',
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

        ],
      ),
      Row(
        children: [
          const SizedBox(
              width: 31
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    5.0), // Adjust border radius as needed
                // Background color similar to TextFormField
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter the Received Amount';
                  }
                  return null; // Return null for no validation error
                },
                controller: subgivenamountCntr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Received Amount',
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
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.4,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),

                  child: DropdownButton<String>(
                    value: selectedValue,
                    // Set the selected value to control the DropdownButton
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text('Payment Mode'),
                    ),
                    items: <String>['CASH', 'BANK', 'CARD'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    underline: Container(),
                    onChanged: (
                        String? newValue) { // Retrieve the selected value here
                      setState(() {
                        if (newValue == null) {
                          selectedValue =
                          ''; // Set selectedValue to empty if newValue is null
                          isShow = false;
                        }

                        else {
                          selectedValue = newValue;
                          if (newValue == 'BANK') {
                            isShow = true; // Update the selected value
                          }
                          else {
                            isShow = false;
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),


        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Visibility(
              visible: isShow,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text('PayementMode'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.9,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.06,

                          child: DropdownSearch<String>(
                            items: payementmode,
                            onChanged: (value) {
                              setState(() {
                                itemSelected = value.toString();
                                if (itemSelected == 'Cheque') {
                                  checkVisible =
                                  true; // Assign only if the value is a String
                                }
                                else {
                                  checkVisible = false;
                                }
                              });
                            },
                            selectedItem: itemSelected,
                          ),

                        ),
                      ),
                      const Row(
                        children: [
                          Text('Check Date'),
                        ],
                      ),
                      Visibility(
                        visible: checkVisible,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.9,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.07,
                            child: TextFormField(
                              controller: dateinput2,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate1 = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now().add(
                                      const Duration(days: 365 * 10)),
                                );

                                if (pickedDate1 != null) {
                                  String formattedDate1 = DateFormat(
                                      'yyyy-MM-dd').format(pickedDate1);
                                  setState(() {
                                    dateinput2.text = formattedDate1;
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextField(
                                controller: refcheckNumber,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Ref/Cheque Number',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      SizedBox(height: 20,),
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.4,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#3465D9'),
          ),
          child: const Text('RENEW', style: TextStyle(color: Colors.white),),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              renewal_insert();
              // await  insert_sub(selectedCcZoneId);
              // // _formKey.currentState?.reset();
              // clear_data();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Renweal(firstname: widget.firstname,
                  id: widget.id,
                  isAdmin: widget.isAdmin,);
              }));
            }
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
    )
    ,
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

  Future fetchsub() async {
    await getApiurl();
    var response = await http.post(
      (Uri.parse(
          '$apiUrl/select_sub/')),
    );


    if (response.statusCode == 200) {
      setState(() {
        subscriber_val = jsonDecode(response.body);
      });
      // print("country",selectedcountryzone_val.status);
      print("subscriber_val $subscriber_val");
      subscriber = (subscriber_val).map<SubscriberList>((model) {
        return SubscriberList.fromJson(model);
      }).toList();
      print("subscriber $subscriber");
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

  Future fetchamount(String? selectedsubscriber) async {
    print("subscriber_name................${this.selectedsubscriber}");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(
        Uri.parse('$apiUrl/select_subscriberamount/'),
        body: {
          'subscribername': selectedsubscriber,
        });

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      var subAmountList = decodedResponse as List<dynamic>;
      if (subAmountList.isNotEmpty) {
        var subAmount = subAmountList[0]['subscriberamount'];
        print("subAmount $subAmount");
        int val_count = subAmount * count;
        print("val_count $val_count");
        setState(() {
          subamountCntr.text = val_count.toString();
        });
      }
      print(response.body);
    }
  }

  Future<void> renewal_insert() async {
    print("subscriber_name................${this.selectedsubscriber}");
    await getApiurl(); // Assuming this function sets the API URL

    var selectedValue1 = selectedValue ?? '';
    var subrecivedamountCntr2 = subrecivedamountCntr.text;
    var finalCoordinatorId = coordinatorid ?? widget.id;

    var response = await http.post(
      Uri.parse('$apiUrl/renewal_subscriber/'),
      body: {
        'subscriberid': subscriberid,
        'coordinatorid': finalCoordinatorId,
        'dateinput': dateinput.text,
        'selectedsubscriber': selectedsubscriber,
        'subamountCntr': subamountCntr.text,
        'subrecivedamountCntr': subrecivedamountCntr2,
        'subgivenamountCntr': subgivenamountCntr.text,
        'selectedValue': selectedValue1,
        'selectedUserID': selectedUserID,
        'selectedUserID1': selectedUserID1,
        'selecteduser': selecteduser,
        'dateinput2': dateinput2.text,
        'refcheckNumber': refcheckNumber.text,
        'itemSelected': itemSelected,
      },
    );

    var data;
    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No
        if (data.contains("success")) {
          final SnackBar snackBar = const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {});
        } else {
          final SnackBar snackBar = const SnackBar(
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


  Future fetchbalance(accountID) async {
    print("accountID................${accountID}");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_customerbalance/'),
        body: {
          'accountID': accountID.toString(),
        });
    print("dfdsf $response.body");
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      var balanceList = decodedResponse as List<dynamic>;
      print("decodedResponse $decodedResponse");
      if (balanceList.isNotEmpty) {
        var balanceAmount = balanceList[0]['SUM(`Debit`)-SUM(`Credit`)'];
        print("balanceAmount $balanceAmount");
        if (balanceAmount == null) {
          setState(() {
            balance = '0';
          });
        }
        else {
          setState(() {
            balance = balanceAmount;
          });
        }
      }
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
