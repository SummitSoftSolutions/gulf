import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/agent/coordinatorlogin.dart';
import 'package:gulf_suprabhaatham/constants.dart';
import 'package:gulf_suprabhaatham/superadmin/clustermodel.dart';
import 'package:gulf_suprabhaatham/superadmin/countrymodel.dart';
import 'package:gulf_suprabhaatham/superadmin/divisionmodel.dart';
import 'package:gulf_suprabhaatham/superadmin/zonemodel.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
void main() {
  runApp(const FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: const FormPage(title: 'Coordinator Registeration'),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  String firstname='';
  var id;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
        padding: EdgeInsets.only(left:30.0),
        child: Text('Coordinator Creation',style: appbarTextColor,),
      ),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () async{
          await getuser();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CoordinatorPage(firstname: firstname, id: id,isAdmin:true)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SignUpForm()),
    );
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

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {


TextEditingController dateinput = TextEditingController();
TextEditingController coageCntr = TextEditingController();
TextEditingController fnameCntr = TextEditingController();
TextEditingController lnameCntr =  TextEditingController();
TextEditingController phoneCntr =  TextEditingController();
TextEditingController placeCntr =  TextEditingController();
TextEditingController usernameCntr =  TextEditingController();
TextEditingController passwordCntr =  TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




var cczone_val;
List<ZoneList> cczones = [];
String?  selectedCczone_val;

String? selectedccZoneId;
String? selectedcgender;


var dczone_val;
List<DivisionList> dczones = [];
String?  selectedcivision_val;


bool isContainerVisible=false;
var countrycczone_val;
List<CountryList> zonecccountries = [];
String?  selectedccountryzone_val;

var ccluster_val;
List<ClusterList> ccluster = [];
String?  selectedCCluster;
Gender? selectedGender = Gender.Male;

var apiUrl;
String selectedUserID = '';
String selectedCcZoneId = '';
String selectedUserID2 = '';
String selectedUserID3 = '';

void initState()
{
  super.initState();
  getApiurl();
  fetchcountry();


}


Future<void> getApiurl() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  apiUrl = prefs.getString('api_url');
  print('............getApiurl..getApiurl.....$apiUrl');
  return;
}
@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: fnameCntr,
                    decoration: InputDecoration(
                      labelText: 'Enter Firstname',
                      hintText: 'fname',
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
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    controller: lnameCntr,
                    decoration: InputDecoration(
                      labelText: 'Enter Lastname',
                      hintText: 'lname',
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
                SizedBox(
                    height:10
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: dateinput, // Editing controller of this TextField
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                            labelText: "Select DOB",
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate:  DateTime.now().add(const Duration(days: 365 * 10)),
                            );

                            if (pickedDate != null) {
                              print(pickedDate); // Picked Date output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate); // Formatted date output using intl package => 2021-03-16

                              int age = calculateAge(pickedDate); // Calculate age using the selected date

                              setState(() {
                                dateinput.text = formattedDate;
                                coageCntr.text = age.toString();// Set output date and age to TextField value
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        width:2
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: coageCntr,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            hintText: 'age',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // getWidget(false, true),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Phone Number';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: phoneCntr,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'phone',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                        return 'Please enter your place';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: placeCntr,
                    decoration: InputDecoration(
                      labelText: 'Enter place',
                      hintText: 'place',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Select Country',style: TextStyle(color:Colors.grey.shade700),),
                    SizedBox(
                      width: 85,
                    ),
                    Text(
                      'Select Zone',style: TextStyle(color:Colors.grey.shade700),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:7.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border:Border.all(color: Colors.grey.shade500,),// Adjust border radius as needed
                          // Background color similar to TextFormField
                        ),
                        child: DropdownSearch<String>(
                            selectedItem: selectedccountryzone_val,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: zonecccountries.map((CountryList data) {
                              return data.countryname; // Assuming 'Name' holds the strings you want to display
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedccountryzone_val = value!;
                              });
                              if (value != null) {
                                CountryList? selectedUserData = zonecccountries.firstWhere(
                                      (data) => data.countryname == value,
                                );
                                selectedUserID = selectedUserData.id.toString();
                                fetchzone(selectedUserID!);
                              }
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border:Border.all(color: Colors.grey.shade500,),// Adjust border radius as needed
                          // Background color similar to TextFormField
                        ),
                        child: DropdownSearch<String>(
                            selectedItem: selectedCczone_val,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: cczones.map((ZoneList data) {
                              return data.zonename; // Assuming 'Name' holds the strings you want to display
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedCczone_val = value!;
                                // selectedCcZoneId = subzones
                                //     .firstWhere((element) => element.id.toString() == value)
                                //     .zoneid;
                              });
                              if (value != null) {
                                ZoneList? selectedUserData1 = cczones.firstWhere(
                                      (data) => data.zonename == value,
                                );
                                selectedCcZoneId = selectedUserData1.id.toString();
                                fetchdivision(selectedCcZoneId!);
                              }
                            }
                        ),
                      ),
                    ),



                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Select Area',style: TextStyle(color:Colors.grey.shade700),),
                    SizedBox(
                      width: 105,
                    ),
                    Text(
                      'Select Cluster',style: TextStyle(color:Colors.grey.shade700),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:7.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border:Border.all(color: Colors.grey.shade500,),// Adjust border radius as needed
                          // Background color similar to TextFormField
                        ),
                        child: DropdownSearch<String>(
                            selectedItem: selectedcivision_val,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: dczones.map((DivisionList data) {
                              return data.divisionname; // Assuming 'Name' holds the strings you want to display
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedcivision_val = value!;
                              });
                              if (value != null) {
                                DivisionList? selectedUserData2 = dczones.firstWhere(
                                      (data) => data.divisionname == value,
                                );
                                selectedUserID2 = selectedUserData2.id.toString();
                                fetchcluster(selectedUserID2!);
                              }
                            }
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:7.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border:Border.all(color: Colors.grey.shade500,),// Adjust border radius as needed
                          // Background color similar to TextFormField
                        ),
                        child: DropdownSearch<String>(
                            selectedItem: selectedCCluster,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: ccluster.map((ClusterList data) {
                              return data.clustername; // Assuming 'Name' holds the strings you want to display
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedCCluster  = value!;
                              });
                              if (value != null) {
                                ClusterList? selectedUserData3 = ccluster.firstWhere(
                                      (data) => data.clustername == value,
                                );
                                selectedUserID3 = selectedUserData3.id.toString();

                              }
                            }
                        ),
                      ),
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.444,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Username';
                            }
                            return null; // Return null for no validation error
                          },
                          controller: usernameCntr,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'uname',
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
                    Visibility(
                      visible: isContainerVisible,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.444,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 5.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: passwordCntr,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon:  GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: passwordCntr.text))
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Password copied to clipboard!'))
                                    );
                                  });
                                },
                                child: Icon(Icons.copy, color: HexColor('#3465D9')),
                              ),
                              hintText: 'pwd',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                            ),
                          ),

                        ),
                      ),
                    ),

                    Visibility(
                      visible: !isContainerVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#3465D9'),
                          ),
                          child: const Text('Generate Password',style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            setState(() {
                              isContainerVisible = true;
                              fetchword();
                            });

                          },
                        ),
                      ),
                    ),


                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#3465D9'),
                    ),
                    child: const Text('ADD',style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false)  {
                        var val= await CoordinatorCheck(usernameCntr);
                        print("valdata $val");
                        if(val =="false") {
                          insertCoordinator(selectedGender, selectedUserID3);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return const FormPage(title: 'Coordinator Registeration');
                          }));
                        }
                        else if(val== "true")
                        {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Username is already taken'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

Widget getWidget(bool showOtherGender, bool alignVertical) {
  return Padding(
    padding: const EdgeInsets.only(left: 25.0),
    child: GenderPickerWithImage(
      showOtherGender: false, // Disable other gender options
      verticalAlignedText: alignVertical,

      // Male is pre-selected and it's the only option available
      selectedGender: Gender.Male,
      selectedGenderTextStyle: const TextStyle(
          color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
      unSelectedGenderTextStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal),
      onChanged: (Gender? gender) {
        if (gender == Gender.Male) {
          print("Selected gender: Male");
        } else {
          // Do nothing or show a message
          print("Only Male is selectable");
        }
      },
      equallyAligned: true,
      animationDuration: const Duration(milliseconds: 300),
      isCircular: true,
      opacityOfGradient: 0.4,
      padding: const EdgeInsets.all(3),
      size: 50, // default: 40
    ),
  );
}


Future fetchcountry() async {
  await getApiurl();
  var response = await http.post(
    (Uri.parse(
        '$apiUrl/select_country/')),
  );


  if (response.statusCode == 200) {
    setState(() {
      countrycczone_val = jsonDecode(response.body);
    });
    // print("country",selectedcountryzone_val.status);
    print("countrydata $countrycczone_val");
    zonecccountries = (countrycczone_val).map<CountryList>((model) {
      return CountryList.fromJson(model);
    }).toList();
    print("countries $zonecccountries");
  }
}

Future fetchzone(String? selectedccountryzone_val) async {

  print("country_name................${this.selectedccountryzone_val}");
  print("fetchstatelist.............................");
  await getApiurl(); // Assuming this function sets the API URL

  var response = await http.post(Uri.parse('$apiUrl/select_zone/'),
      body: {
        'countryname': selectedccountryzone_val,
      });

  if (response.statusCode == 200) {
    setState(() {
      cczone_val = jsonDecode(response.body);
    });

    print("State data: $cczone_val");


    cczones = (cczone_val).map<ZoneList>((model) {
      return ZoneList.fromJson(model);
    }).toList();

    // You can parse and update state data here if needed
  } else {
    // Handle API error
    print("Failed to ZoneList");
  }
}

Future fetchdivision(String? selectedCczone_val) async {

  print("zone_name................${this.selectedCczone_val}");
  print("fetchdivision.............................");
  await getApiurl(); // Assuming this function sets the API URL

  var response = await http.post(Uri.parse('$apiUrl/select_division/'),
      body: {
        'zoneid': selectedCczone_val,
      });

  if (response.statusCode == 200) {
    setState(() {
      dczone_val = jsonDecode(response.body);
    });

    print("State data: $dczone_val");


    dczones = (dczone_val).map<DivisionList>((model) {
      return DivisionList.fromJson(model);
    }).toList();

    // You can parse and update state data here if needed
  } else {
    // Handle API error
    print("Failed to dczones");
  }
}



Future fetchcluster(String? selectedCCluster) async {

  print("cluster_name................${this.selectedCCluster}");
  print("fetchcluster.............................");
  await getApiurl(); // Assuming this function sets the API URL

  var response = await http.post(Uri.parse('$apiUrl/select_cluster/'),
      body: {
        'clusterid': selectedCCluster,
      });

  if (response.statusCode == 200) {
    setState(() {
      ccluster_val = jsonDecode(response.body);
    });

    print("Cluster data: $ccluster_val");


    ccluster = (ccluster_val).map<ClusterList>((model) {
      return ClusterList.fromJson(model);
    }).toList();

    // You can parse and update state data here if needed
  } else {
    // Handle API error
    print("Failed to ccluster");
  }
}

int calculateAge(DateTime birthDate) {
  final now = DateTime.now();
  final age1 = now.year - birthDate.year;

  // Check if the birthday has occurred this year
  if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
    return age1 - 1;
  } else {
    return age1;
  }
}

Future<void> insertCoordinator(Gender? gender,String? selectedUserID3) async {
  await getApiurl();
  var data;
  var response = await http.post(
    Uri.parse('$apiUrl/insert_coordinators/'),
    body: {
      'fnameCntr': fnameCntr.text,
      'lnameCntr':lnameCntr.text,
      'dateinput': dateinput.text,
      'coageCntr':coageCntr.text,
      'phoneCntr':phoneCntr.text,
      'placeCntr':placeCntr.text,
      'selectedccountryzone_val':selectedUserID?.toString() ?? '',
      'selectedCczone_val':selectedCcZoneId?.toString() ?? '',
      'selectedcivision_val':selectedUserID2?.toString() ?? '',
      'usernameCntr':usernameCntr.text,
      'passwordCntr': passwordCntr.text,
      // 'selectedGender': 'Male' ?? '',
      'selectedCCluster':selectedUserID3?.toString() ?? '',
      'selectedccZoneId':selectedUserID3?.toString() ?? '',


    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    setState(() {
      data = response.body.trim(); // No need for jsonDecode
    });
    print("response.body ${response.body}");
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

Future fetchword() async {


  await getApiurl(); // Assuming this function sets the API URL

  var response = await http.post(Uri.parse('$apiUrl/passwordGenerator/'),
  );

  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);
    print("decodedResponse $decodedResponse");
    if (decodedResponse is Map<String, dynamic> && decodedResponse.isNotEmpty) {
      var subreg = decodedResponse['password'];
      print('subreg $subreg');
      if (subreg != null) {
        setState(() {
          passwordCntr.text = subreg;
        });

      }
    } else {
      print('Empty or invalid response');
    }
  }

}

Future CoordinatorCheck(TextEditingController usernameCntr) async {
  await getApiurl(); // Assuming this function sets the API URL

  var response = await http.post(Uri.parse('$apiUrl/checkUserExists/'),
      body: {
        'usernameCntr': usernameCntr.text,
      });
  print("data ${response.body}");
  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);
    print("decodedResponse $decodedResponse");
    if (decodedResponse is Map<String, dynamic> && decodedResponse.isNotEmpty) {
      var userCheck = decodedResponse['data'];
      return userCheck;
    } else {
      print('Empty or invalid response');
    }
  }
  else {
    // Handle API error
    print("Failed to fetch CoordinatorCheck");
  }
}

}


