import 'dart:convert';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

import '../constants.dart';
import '../superadmin/SubcriptionAgentPage.dart';
import 'usermode.dart';
class CoordinatorUserView extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  CoordinatorUserView({super.key, required this.firstname, required this.id, required this.isAdmin});


  @override
  State<CoordinatorUserView> createState() => _CoordinatorUserViewState();
}

class _CoordinatorUserViewState extends State<CoordinatorUserView> {
  var apiUrl;
  String?  selecteduser;
  var user_val1;
  String selectedUserID = '';
  String selectedUserID1 = '';
  TextEditingController name = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  TextEditingController whatsupno = TextEditingController();
  TextEditingController telephoneres =  TextEditingController();
  TextEditingController telephoneoffice =  TextEditingController();
  TextEditingController pbox =  TextEditingController();
  TextEditingController flatno =  TextEditingController();
  TextEditingController floor =  TextEditingController();
  TextEditingController buildv =  TextEditingController();
  TextEditingController landmark =  TextEditingController();
  TextEditingController address =  TextEditingController();
  TextEditingController cluster =  TextEditingController();
  TextEditingController emailCntr =  TextEditingController();
  TextEditingController subamountCntr = TextEditingController();
  TextEditingController subgivenamountCntr = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinput1 = TextEditingController();
  TextEditingController subrecivedamountCntr = TextEditingController();
  TextEditingController regval = TextEditingController();
  TextEditingController subscribtionID = TextEditingController();
  TextEditingController regid = TextEditingController();
  TextEditingController coordinator = TextEditingController();
  TextEditingController id = TextEditingController();
  bool isVisible= false;
  bool isidVisible=false;
  String firstname='';
  bool isAdmin = false;
  bool isShow = true;
  var id1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void initState()
  {
    super.initState();
    selectsubcriber();
    getuser();
  }
  List<UserListData> users1 = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
        padding: EdgeInsets.only(left:50.0),
        child: Text('Subscriber View',style: appbarTextColor,),
      ),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SubscriberAgentPage(firstname: firstname, id: id1,isAdmin:isAdmin)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top:60.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.93,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: DropdownSearch<String>(
                    selectedItem: users1.isNotEmpty ? users1.first.name : null,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    items: users1.map((UserListData data) {
                      return data.name; // Assuming 'Name' holds the strings you want to display
                    }).toList(),
                    onChanged: (String? value) { // Change the parameter to accept nullable string
                      setState(() {
                        selecteduser = value ?? ''; // Ensure selecteduser is not null
                      });
                      if (value != null) {
                        // Find the UserListData instance corresponding to the selected name
                        UserListData? selectedUserData = users1.firstWhere(
                              (data) => data.name == value,
                        );

                        // Pass the ID to your function if available
                        print("selectedUserData ${selectedUserData.accountid}");
                        selectedUserID = selectedUserData.accountid.toString();
                        selectedUserID1 = selectedUserData.id.toString();
                        viewsubscribers();
                        isShow =false;
                        isVisible=true;
                                            }
                    },

                  ),
                ),
              ),
            ),
            Visibility(visible:isShow,child: Image.asset('images/subview.png',height:MediaQuery.of(context).size.height * 0.5,width:MediaQuery.of(context).size.width * 0.5,)),
            Visibility(
              visible: isVisible,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Form(
                    key:_formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.434,
                                height: MediaQuery.of(context).size.height*0.06,
                                child: TextFormField(
                                  readOnly: true,
                                  enabled: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: regval,
                                  decoration: InputDecoration(
                                    labelText: 'Reg ID',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: const OutlineInputBorder(
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 14.0),
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(
                              width:12
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.445,
                                height: MediaQuery.of(context).size.height*0.06,
                                child: TextFormField(
                                  readOnly: true,
                                  enabled: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: subscribtionID,
                                  decoration: InputDecoration(
                                    labelText: 'Reg No',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: const OutlineInputBorder(
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 14.0),
                                  ),

                                ),
                              ),
                            ),
                            Visibility(
                              visible: isidVisible,
                              child: Padding(
                                padding: const EdgeInsets.only(top:20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.445,
                                  height: MediaQuery.of(context).size.height*0.06,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your First Name';
                                      }
                                      return null; // Return null for no validation error
                                    },
                                    controller: id,
                                    decoration: InputDecoration(
                                      labelText: 'Reg No',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      border: const OutlineInputBorder(
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 14.0),
                                    ),

                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width * 0.445,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child:
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: dateinput, // Editing controller of this TextField
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                    ),
                                    suffixIcon: Icon(Icons.calendar_today),
                                    labelText: "Start Date",
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                                    );

                                    if (pickedDate != null) {
                                      print(pickedDate); // Picked Date output format => 2021-03-10 00:00:00.000
                                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                      print(formattedDate); // Formatted date output using intl package => 2021-03-16

                                      setState(() {
                                        dateinput.text = formattedDate;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),

                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.445,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child:
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: dateinput1, // Editing controller of this TextField
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                    ),
                                    suffixIcon: Icon(Icons.calendar_today),
                                    labelText: "End Date",
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate1 = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                                    );

                                    if (pickedDate1 != null) {
                                      print(pickedDate1); // Picked Date output format => 2021-03-10 00:00:00.000
                                      String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1);
                                      print(formattedDate1); // Formatted date output using intl package => 2021-03-16

                                      setState(() {
                                        dateinput1.text = formattedDate1;
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),

                            ),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: name,
                            decoration: InputDecoration(
                              labelText: 'Enter Name',
                              hintText: 'name',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: mobileno,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              hintText: 'lname',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: whatsupno,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'WhatAp Number',
                              hintText: 'lname',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),

                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: telephoneoffice,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Office Telephone',
                              hintText: 'phone',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: telephoneres,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Residence Office',
                              hintText: 'phone',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: emailCntr,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.445,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed// Background color similar to TextFormField
                                ),
                                child:  TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: pbox,
                                  decoration: InputDecoration(
                                    labelText: 'Post Box',
                                    hintText: 'pbox',
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
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.445,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                                ),
                                child:  TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: flatno,
                                  decoration: InputDecoration(
                                    labelText: 'Flat Number',
                                    hintText: 'flat',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.445,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                                ),
                                child:  TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: floor,
                                  decoration: InputDecoration(
                                    labelText: 'Floor',
                                    hintText: 'floor',
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
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.445,
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                                  // Background color similar to TextFormField
                                ),
                                child:  TextFormField(
                                  readOnly: true,
                                    enabled: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First Name';
                                    }
                                    return null; // Return null for no validation error
                                  },
                                  controller: coordinator,
                                  decoration: InputDecoration(
                                    labelText: 'Coordinator',
                                    hintText: 'Email',
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
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: address,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: 'name',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: const OutlineInputBorder(
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),

                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(top:20.0),
                        //   child: TextFormField(
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please enter your First Name';
                        //       }
                        //       return null; // Return null for no validation error
                        //     },
                        //     controller: subgivenamountCntr,
                        //     decoration: InputDecoration(
                        //       labelText: 'Subscriber Amount',
                        //       hintText: 'name',
                        //       hintStyle: TextStyle(color: Colors.grey[400]),
                        //       border: const OutlineInputBorder(
                        //       ),
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           horizontal: 16.0, vertical: 14.0),
                        //     ),
                        //
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: SizedBox(
                                width:250,
                                child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#3465D9'),),
                                  onPressed: (){
                                    update_users();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return  CoordinatorUserView(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin);
                                    }));
                                  }, child: const Text('Update',style: TextStyle(color: Colors.white),),
                                ),
                              )
                            ),

                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  Future selectsubcriber() async {
    print("selectsubcriber.............................");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/select_subscribers/'));

    if (response.statusCode == 200) {
      setState(() {
        user_val1 = jsonDecode(response.body);
      });

      print("user_val: $user_val1");

      users1 = (user_val1).map<UserListData>((model) {
        return UserListData.fromJson(model);
      }).toList();
      print("users................$users1");
      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future viewsubscribers() async {
    var data;
    print("viewusers.............................$selecteduser");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/searched_user/'),
        body: {
          'selecteduser':selectedUserID1,

        });
      var result = json.decode(response.body);
      print("result $result");
      print('result_data type: ${result.runtimeType}');
      if(result.isNotEmpty)
        {
          var detail = result[0];
          print("detail $detail");
          name.text=detail['name'];
          emailCntr.text=detail['email'].toString();
          mobileno.text=detail['mobileno'];
          telephoneoffice.text=detail['officetel'].toString();
          telephoneres.text=detail['residencetel'].toString();
          dateinput.text =detail['startdate'].toString();
          dateinput1.text =detail['enddate'].toString();
          flatno.text=detail['flatno'].toString();
          floor.text=detail['floor'].toString();
          address.text =detail['address'];
          subscribtionID.text=detail['subscribtionID'];
          regval.text=detail['reg'];
          whatsupno.text=detail['whatsno'];
          subgivenamountCntr.text =detail['recievedamount'].toString();
          pbox.text=detail['postbox'].toString();
          coordinator.text =detail['coordinator'].toString();
          id.text=detail['Id'].toString();
          if (response.statusCode == 200) {
            setState(() {
              data = response.body.trim(); // No
            });

            print("data: $data");



            // You can parse and update state data here if needed
          } else {
            // Handle API error
            print("Failed to fetch states");
          }

        }

  }
  Future update_users() async {
    var data;
    print("Update................Update");


    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/update_user/'),
        body: {
          'name': name.text,
          'mobileno':mobileno.text,
          'whatsupno':whatsupno.text,
          'dateinput':dateinput.text,
          'dateinput1':dateinput1.text,
          'emailCntr':emailCntr.text,
          'pbox':pbox.text,
          'flatno':flatno.text,
          'floor':floor.text,
          'address':address.text,
          'officetele':telephoneoffice.text,
          'officeres':telephoneres.text,
          'subamountCntr':subamountCntr.text,
          'subgivenamountCntr':subgivenamountCntr.text,
          'subrecivedamountCntr':subrecivedamountCntr.text,
          'regval':regval.text,
          'id':id.text,


        });

    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No
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
    id1 = prefs.getString('id');
    print('...........id.....$id');
    return;
  }
}
