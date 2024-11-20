import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gulf_suprabhaatham/agent/subscribermodel.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../superadmin/SubcriptionAgentPage.dart';
import '../superadmin/clustermodel.dart';
import '../superadmin/countrymodel.dart';
import '../superadmin/divisionmodel.dart';
import '../superadmin/zonemodel.dart';
import 'logincoormodel.dart';


class SubscriberPage extends StatefulWidget {
  const SubscriberPage({super.key});

  @override
  State<SubscriberPage> createState() => _SubscriberPageState();
}

class _SubscriberPageState extends State<SubscriberPage> {
  bool rebuildWidget = false;
  var apiUrl;
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
    subFunctions();

  }

  List<String> payementmode = [
    'Cheque',
    'Deposit',
    'Direct Transfer',
  ];
  Future<void> subFunctions()
  async {
    await getApiurl();
    await fetchcountry();
    await fetchsub();
    await fetchmax();
    await getuser();
    await fetchcoordinators();
  }
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }

  bool isCheck = false;
  String?  selectedcountryzone_val;
  List<CountryList> zonecountries = [];
  String?  selectedzone_val;
  List<ZoneList> zones = [];
  TextEditingController divisioncntr = TextEditingController();
  TextEditingController clustercntr = TextEditingController();
  Color myColor = const Color(0xFF7EC8E3);
  TextEditingController refcheckNumber = TextEditingController();
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
  TextEditingController dateinput2 = TextEditingController();
  TextEditingController galsno = TextEditingController();
  TextEditingController batch = TextEditingController();
  String itemSelected = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> __formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> __formKey1 = GlobalKey<FormState>();

  String? selectedValue;
  var subcountry_val;
  List<CountryList> subcountry = [];
  String?  selectedsubcountry;

  var coordinator_val;
  List<Login> coordinator = [];
  String?  selectedcoordinator;
  String?  selectedcoordinator1;
  bool isVisible =false;
  var subzone_val;
  List<ZoneList> subzones = [];
  String?  selectedsubzones;
  bool isdisplay =false;
  var subdivision_val;
  List<DivisionList> subdivision = [];
  String?  selectedsubdivision;

  String selectedUserID = '';
  String selectedUserID1 = '';
  String selectedUserID2 = '';
  String selectedUserID3 = '';
  String selectedUserID4 = '';
  String selectedUserIDVal = '';


  var subcluster_val;
  List<ClusterList> subcluster = [];
  String?  selectedsubcluster;

  String firstname='';
  var id;
  bool isAdmin = false;
  var subscriber_val;
  List<SubscriberList> subscriber = [];
  String?  selectedsubscriber;

  String? selectedCcZoneId;
  String? selectedcgender;
  String? selecteddate;
  String? selecteddate1;
  String? selectedCcZoneIdname;



  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SubscriberAgentPage(firstname: firstname, id: id, isAdmin: isAdmin,)),
              (Route<dynamic> route) => false, // Removes all routes in the stack
        );
        return false; // Returning false prevents the default back navigation
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
          padding: EdgeInsets.only(left:30.0),
          child: Text('Subscriber Creation',style: appbarTextColor,),
        ),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SubscriberAgentPage(firstname: firstname, id: id,isAdmin:isAdmin)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key:_formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.445,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: TextFormField(
                              controller: regval,
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 15),
                              ),
                              readOnly: true,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'Reg No',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),

                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 14.0),
                              ),

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.445,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: TextFormField(
                              controller: galsno,
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 15),
                              ),
                              decoration: InputDecoration(
                                labelText: 'GAL SNO',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),

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
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.445,
                          height: MediaQuery.of(context).size.height*0.06,
                          child: TextFormField(
                            controller: batch,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 15),
                            ),
                            decoration: InputDecoration(
                              labelText: 'BATCH NO',
                              hintStyle: const TextStyle(color: Colors.grey),
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
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 13),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter Name',
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
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Mobile Number';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: mobileno,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 15),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
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
                          return 'Please enter your WhatsApp Number';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: whatsupno,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 15),
                      ),
                      decoration: InputDecoration(
                        labelText: 'WhatsApp Number',
                        hintText: 'WhatsApp Number',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),

                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [

                  SizedBox(
                  width: MediaQuery.of(context).size.width * 0.445,
                  // height: MediaQuery.of(context).size.height * 0.06,
            child:
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please pick the Start date';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: dateinput,
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 11),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelText: "Start Date",
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.445,
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please pick the End date';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: dateinput1,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 11),
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                              labelText: "End Date",
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate1 = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate:  DateTime.now().add(const Duration(days: 365 * 10)),
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
                      controller: telephoneoffice,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 15),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Office Telephone',
                        hintText: 'phone',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: TextFormField(
                      controller: telephoneres,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 15),
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Residence Office Number',
                        hintText: 'phone',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),

                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: TextFormField(
                      controller: emailCntr,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 15),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[400],),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),

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
                          // height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed

                          ),
                          child:  TextFormField(
                            controller: pbox,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 15),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Post Box',
                              hintText: 'pbox',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.445,
                          // height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                             // Background color similar to TextFormField
                          ),
                          child:  TextFormField(
                            controller: flatno,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 15),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Flat Number',
                              hintText: 'flat',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.91,
                          // height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // Adjust border radius as needed
                             // Background color similar to TextFormField
                          ),
                          child:  TextFormField(
                            controller: floor,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 15),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Floor/Villa',
                              hintText: 'floor',
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

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width * 0.445,
                      //     height: MediaQuery.of(context).size.height * 0.06,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                      //       color: Colors.grey[200], // Background color similar to TextFormField
                      //     ),
                      //     child:  TextFormField(
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Please enter your First Name';
                      //         }
                      //         return null; // Return null for no validation error
                      //       },
                      //       controller: buildv,
                      //       decoration: InputDecoration(
                      //         labelText: 'Building/Villa',
                      //         hintText: 'Email',
                      //         hintStyle: TextStyle(color: Colors.grey[400]),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10.0),
                      //
                      //         ),
                      //         contentPadding: EdgeInsets.symmetric(
                      //             horizontal: 16.0, vertical: 14.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Address';
                        }
                        return null; // Return null for no validation error
                      },
                      controller: address,
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 15),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter Address',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),

                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                      ),

                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Select Country',style: TextStyle(color:Colors.grey.shade700),),
                      const SizedBox(
                        width: 85,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:3.0),
                        child: Text(
                          'Select Zone',style: TextStyle(color:Colors.grey.shade700),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.445,
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                              // Adjust border radius as needed

                          ),
                          child: DropdownSearch<String>(
                              selectedItem: selectedsubcountry,
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                              ),
                              items: subcountry.map((CountryList data) {
                                return data.countryname; // Assuming 'Name' holds the strings you want to display
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedsubcountry = value!;
                                });
                                if (value != null) {
                                  CountryList? selectedUserData = subcountry.firstWhere(
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.445,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child:DropdownSearch<String>(
                              selectedItem: selectedsubzones,
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                              ),
                              items: subzones.map((ZoneList data) {
                                return data.zonename; // Assuming 'Name' holds the strings you want to display
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedsubzones = value!;
                                  // selectedCcZoneId = subzones
                                  //     .firstWhere((element) => element.id.toString() == value)
                                  //     .zoneid;
                                });
                                if (value != null) {
                                  ZoneList? selectedUserData1 = subzones.firstWhere(
                                        (data) => data.zonename == value,
                                  );
                                  selectedCcZoneId = selectedUserData1.id.toString();
                                  selectedCcZoneIdname = selectedUserData1.zoneid.toString();
                                  fetchdivision(selectedCcZoneId!);
                                }
                              }
                          ),
                        ),
                        ),




                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Select Area',style: TextStyle(color:Colors.grey.shade700),),
                      const SizedBox(
                        width: 85,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:26.0),
                        child: Text(
                          'Select Cluster',style: TextStyle(color:Colors.grey.shade700),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.445,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownSearch<String>(
                                        selectedItem: selectedsubdivision,
                                        popupProps: const PopupProps.menu(
                                          showSearchBox: true,
                                        ),
                                        items: subdivision.map((DivisionList data) {
                                          return data.divisionname; // Assuming 'Name' holds the strings you want to display
                                        }).toList(),

                                        onChanged: (value) {
                                          setState(() {
                                            selectedsubdivision = value!;
                                          });
                                          if (value != null) {
                                            DivisionList? selectedUserData2 = subdivision.firstWhere(
                                                  (data) => data.divisionname == value,
                                            );
                                            selectedUserID2 = selectedUserData2.id.toString();
                                            fetchcluster(selectedUserID2!);
                                          }
                                        }
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: const Text('Area Creation'),
                                              content:Form(
                                                key: __formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width*0.9,
                                                        child: Column(
                                                          children: [
                                                            const Text('Please Select Country and Zone'),
                                                            Padding(
                                                              padding: const EdgeInsets.all(15),
                                                              child: TextFormField(
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter the Area';
                                                                  }
                                                                  return null; // Return null for no validation error
                                                                },
                                                                controller: divisioncntr,
                                                                style: GoogleFonts.roboto(
                                                                  textStyle: const TextStyle(
                                                                      fontSize: 12),
                                                                ),
                                                                decoration: InputDecoration(
                                                                  labelText: 'Enter Area',
                                                                  hintText: 'place',
                                                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                                                  border: const OutlineInputBorder(
                                                                    // borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                  contentPadding: const EdgeInsets.symmetric(
                                                                      horizontal: 16.0, vertical: 14.0),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ),



  ],
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: HexColor('#3465D9'),
                                                  ),
                                                  child: const Text('ADD', style: addButtonTextColor),
                                                  onPressed: () {
                                                    if (__formKey.currentState?.validate() ?? false) {
                                                      insertDivision(selectedCcZoneId);
                                                      Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) {
                                                        return const SubscriberPage();
                                                      }));
                                                    }
                                                  },
                                                ),
                                              ],

                                            );
                                          });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      color:  HexColor('#3465D9'),
                                      child: const Icon(Icons.add, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.445,
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<String>(
                                    selectedItem: selectedsubcluster,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    items: subcluster.map((ClusterList data) {
                                      return data.clustername; // Assuming 'Name' holds the strings you want to display
                                    }).toList(),

                                    onChanged: (value) {
                                      setState(() {
                                        selectedsubcluster  = value!;
                                      });
                                      if (value != null) {
                                        ClusterList? selectedUserData3 = subcluster.firstWhere(
                                              (data) => data.clustername == value,
                                        );
                                        selectedUserID3 = selectedUserData3.id.toString();

                                      }
                                    }
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text('Cluster Creation'),
                                          content:Form(
                                            key: __formKey1,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                const Text('Please Select Country,Zone and Area'),
                                                Center(
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width*0.9,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(15),
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'Please enter the division';
                                                              }
                                                              return null; // Return null for no validation error
                                                            },
                                                            controller: clustercntr,
                                                            decoration: InputDecoration(
                                                              labelText: 'Enter Cluster',
                                                              hintText: 'place',
                                                              hintStyle: TextStyle(color: Colors.grey[400]),
                                                              border: const OutlineInputBorder(
                                                                // borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              contentPadding: const EdgeInsets.symmetric(
                                                                  horizontal: 16.0, vertical: 14.0),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),



                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: HexColor('#3465D9'),
                                              ),
                                              child: const Text('ADD', style: addButtonTextColor),
                                              onPressed: () {
                                                if (__formKey1.currentState?.validate() ?? false) {
                                                  insertCluster();
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) {
                                                    return const SubscriberPage();
                                                  }));
                                                }
                                              },
                                            ),
                                          ],

                                        );
                                      });
                                },
                                child: Container(
                                  width: 40,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  color:  HexColor('#3465D9'),
                                  child: const Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Select Coordinator',style: TextStyle(color:Colors.grey.shade700),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.91,
                              height: MediaQuery.of(context).size.height*0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                
                              ),
                              child: DropdownSearch<String>(
                                  selectedItem: selectedcoordinator,
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                  ),
                                  items: coordinator.map((Login data) {
                                    return data.firstname; // Assuming 'Name' holds the strings you want to display
                                  }).toList(),

                                  onChanged: (value) {
                                    setState(() {
                                      selectedcoordinator  = value!;
                                    });
                                    if (value != null) {
                                      Login? selectedUserVal = coordinator.firstWhere(
                                            (data) => data.firstname == value,
                                      );
                                      selectedUserIDVal = selectedUserVal.id.toString();
                                     print("selectedUserIDVal $selectedUserIDVal");
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:18.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.445,
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey.shade500,)// Adjust border radius as needed
                             // Background color similar to TextFormField
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                value: selectedsubscriber,
                                iconSize: 36,
                                hint: const Padding(
                                  padding: EdgeInsets.only(left:8.0),
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
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Text(
                                          data.subscribername,style: const TextStyle(fontSize:15)

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

                      Padding(
                        padding: const EdgeInsets.only(top:19.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.445,
                          // height: MediaQuery.of(context).size.height*0.02,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                             // Background color similar to TextFormField
                          ),
                          child:  TextFormField(
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
                              // hintText: 'lname',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap:()
                              {
                                decrement();
                                fetchamount(selectedsubscriber);
                              },
                              child: Container(
                                width:50,
                                height: 50,
                                decoration: BoxDecoration(shape: BoxShape.circle,color: HexColor('#3465D9'),),
                                child: const Icon(
                                  Icons.remove,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:20
                            ),
                            Text('$count',
                            ),
                            const SizedBox(
                                width:20
                            ),
                            GestureDetector(
                              onTap:()
                              {
                                increment();
                                fetchamount(selectedsubscriber);
                              },
                              child: Container(
                                width:50,
                                height: 50,
                                decoration: BoxDecoration(shape: BoxShape.circle,color: HexColor('#3465D9'),),
                                child: const Icon(
                                  Icons.add,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:15
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.445,
                          // height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            // Adjust border radius as needed
                            // Background color similar to TextFormField
                          ),
                          child:  TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'The total amount';
                              }
                              return null; // Return null for no validation error
                            },
                            controller: subgivenamountCntr,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Total Amount',
                              hintText: 'Total Amount',
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
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.445,
                          // height: MediaQuery.of(context).size.height*0.06,
                          child: TextFormField(
                            controller: subrecivedamountCntr,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Received  Amount',
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0,top:16),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4295,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:Border.all(color: Colors.grey.shade500,),
                            // Adjust border radius as needed

                          ),
                          child: DropdownButton<String>(
                            value: selectedValue, // Set the selected value to control the DropdownButton
                            hint: const Padding(
                              padding: EdgeInsets.only(left:10.0),
                              child: Text(' Select Mode'),
                            ),
                            isExpanded:true,
                            underline: Container(),
                            items: <String>['CASH', 'BANK','CARD'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(value),
                                ),

                              );
                            }).toList(),
                            onChanged: (String? newValue) { // Retrieve the selected value here
                              setState(() {
                                selectedValue = newValue;
                                if (selectedValue == 'BANK')
                                {
                                  isVisible =true;
                                }
                                else
                                  {
                                    isVisible =false;
                                  }
                              });
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.300,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Text('Payment Mode'),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.06,

                                child:  DropdownSearch<String>(
                                  items: payementmode,
                                  onChanged: (value) {
                                    setState(() {

                                      itemSelected = value.toString();
                                      if(itemSelected=='Cheque')
                                        {
                                          isCheck=true;// Assign only if the value is a String
                                      }
                                        else
                                          {
                                            isCheck=false;
                                          }
                                    });
                                  },
                                  selectedItem: itemSelected,
                                ),

                              ),
                            ),
                            Visibility(
                              visible: isCheck,
                              child: Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: TextFormField(
                                    controller: dateinput2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_today),
                                      labelText: "Date",
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate1 = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate:  DateTime.now().add(const Duration(days: 365 * 10)),
                                      );

                                      if (pickedDate1 != null) {
                                        String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1);
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
                                    padding: const EdgeInsets.only(top:8.0),
                                    child:   TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Ref/Cheque Number';
                                        }
                                        return null; // Return null for no validation error
                                      },
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

                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  const EdgeInsets.only(top:10.0),
                    child: SizedBox(
                      width:500,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#3465D9'),
                        ),
                        child: const Text('ADD',style: TextStyle(color: Colors.white),),
                        onPressed:() {
                          if (_formKey.currentState?.validate() ?? false) {
                            insert_sub(selectedCcZoneId,selectedCcZoneIdname);
                            // _formKey.currentState?.reset();
                            clear_data();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return const SubscriberPage();
                            }));
                            if (_formKey.currentState?.validate() ?? false) {
                              // insertCoordinator(selectedGender);
                            }
                          }
                        }
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
  Future fetchsub() async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/select_sub/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        subscriber_val = jsonDecode(response.body);
      });

      print("subscriber_val $subscriber_val");

      // Check if 'subscriber_val' is a List of Maps
      if (subscriber_val is List) {
        subscriber = (subscriber_val as List).map<SubscriberList>((item) {
          return SubscriberList.fromJson(item);
        }).toList();
        print("subscriber $subscriber");
      } else {
        // Handle unexpected structure
        print("Unexpected structure in response: $subscriber_val");
      }
    } else {
      // Handle API error
      print("Failed to fetch subscribers");
    }
  }


  Future fetchcommity() async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/select_sub/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        subscriber_val = jsonDecode(response.body);
      });

      print("subscriber_val $subscriber_val");

      // Check if 'subscriber_val' contains the 'data' key with a list
      if (subscriber_val.containsKey('data') && subscriber_val['data'] is List) {
        subscriber = (subscriber_val['data'] as List).map<SubscriberList>((model) {
          return SubscriberList.fromJson(model);
        }).toList();
        print("subscriber $subscriber");
      } else {
        // Handle the case where 'data' is not found or is not a list
        print("Unexpected structure in response: $subscriber_val");
      }
    } else {
      // Handle API error
      print("Failed to fetch subscribers");
    }
  }
  Future fetchcountry() async {
    await getApiurl();
    var response = await http.post(
      (Uri.parse(
          '$apiUrl/select_country/')),
    );


    if (response.statusCode == 200) {
      setState(() {
        subcountry_val = jsonDecode(response.body);
      });
      // print("country",selectedcountryzone_val.status);
      print("subcountry_val $subcountry_val");
      subcountry = (subcountry_val).map<CountryList>((model) {
        return CountryList.fromJson(model);
      }).toList();
      print("subcountry $subcountry");
    }
  }

  Future fetchzone(String? selectedsubcountry) async {

    print("country_name................${this.selectedsubcountry}");
    print("fetchstatelist.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_zone/'),
        body: {
          'countryname': selectedsubcountry,
        });

    if (response.statusCode == 200) {
      setState(() {
        subzone_val = jsonDecode(response.body);
      });

      print("subzone_val: $subzone_val");


      subzones = (subzone_val).map<ZoneList>((model) {
        return ZoneList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future fetchcoordinators() async {
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.get(Uri.parse('$apiUrl/select_coordinators/'));
       print("afsdfsdgsdg");
      print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        coordinator_val = jsonDecode(response.body);
      });

      print("coordinator_val data: $coordinator_val");
      coordinator = (coordinator_val).map<Login>((model) {
        return Login.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }
  Future fetchamount(String? selectedsubscriber) async {

    print("subscriber_name................${this.selectedsubscriber}");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_subscriberamount/'),
        body: {
          'subscribername': selectedsubscriber,
        });

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      var subAmountList = decodedResponse as List<dynamic>;
      if(subAmountList.isNotEmpty) {
        var subAmount = subAmountList[0]['subscriberamount'];
        print("subAmount $subAmount");
        int val_count = subAmount * count;
        print("val_count $val_count");
        setState(() {
          subamountCntr.text = val_count.toString();
          subgivenamountCntr.text = val_count.toString();
        });
      }
      print(response.body);
    }
  }
void clear_data()
{
  selectedcoordinator =null;
}
  Future fetchmax() async {


    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_reg/'),
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
       print("decodedResponse $decodedResponse");
      if (decodedResponse is Map<String, dynamic> && decodedResponse.isNotEmpty) {
        var subreg = decodedResponse['MAX(`id`)'];

        if (subreg != null) {
          var new_val = 'GS';
          int incrementedValue = (subreg as int) + 1;

          setState(() {
            regval.text = new_val + incrementedValue.toString();
          });

          print("Incremented subreg: $incrementedValue");
        } else {
          var first_val = 1;
          setState(() {
            regval.text = 'GS' + first_val.toString();
          });
        }
      } else {
        print('Empty or invalid response');
      }
    }

  }



  Future fetchdivision(String? selectedsubzones) async {

    print("zone_name................${this.selectedsubzones}");
    print("fetchdivision.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_division/'),
        body: {
          'zoneid': selectedsubzones,
        });

    if (response.statusCode == 200) {
      setState(() {
        subdivision_val = jsonDecode(response.body);
      });

      print("subdivision_val data: $subdivision_val");


      subdivision = (subdivision_val).map<DivisionList>((model) {
        return DivisionList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future fetchcluster(String? selectedsubcluster) async {

    print("cluster_name................${this.selectedsubcluster}");
    print("fetchcluster.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_cluster/'),
        body: {
          'clusterid': selectedsubcluster,
        });

    if (response.statusCode == 200) {
      setState(() {
        subcluster_val = jsonDecode(response.body);
      });

      print("Cluster data: $subcluster_val");


      subcluster = (subcluster_val).map<ClusterList>((model) {
        return ClusterList.fromJson(model);
      }).toList();

      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future insert_sub(String? selectedCcZoneId,selectedCcZoneIdname) async {
    var data;
    print("cluster_name................${this.selectedsubcluster}");
    print("insert_sub.............................$id");
    String coordinatorValue = selectedUserIDVal ?? 'None';
    print("zcc $coordinatorValue");
    String selectedValue1 = selectedValue ?? 'None';

    await getApiurl(); // Assuming this function sets the API URL
    var subgivenamountCntr2 = subgivenamountCntr.text ?? '';
    var response = await http.post(Uri.parse('$apiUrl/insert_subscriber/'),
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
          'buildv':buildv.text,
          'address':address.text,
          'officetele':telephoneoffice.text,
          'officeres':telephoneres.text,
          'selectedsubcountry':selectedUserID,
          'selectedsubzones':selectedCcZoneId,
          'selectedsubdivision':selectedUserID2,
          'selectedcoordinator':coordinatorValue,
          'selectedsubcluster':selectedUserID3,
          'selectedsubscriber':selectedsubscriber,
          'subamountCntr':subamountCntr.text,
          'subgivenamountCntr':subgivenamountCntr2,
          'subrecivedamountCntr':subrecivedamountCntr.text,
          'selectedCcZoneId':selectedCcZoneIdname,
          'regval':regval.text,
          'id':id,
          'selectedValue':selectedValue1,
          'itemSelected':itemSelected,
          'refcheckNumber':refcheckNumber.text,
          'dateinput2':dateinput2.text,
          'galsno':galsno.text,
          'batchNo':batch.text


        });

    if (response.statusCode == 200) {
      print("response.body ${response.body}");
      setState(() {
        data = response.body.trim(); // No
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
    return;
  }
  Future<void> insertDivision(String? selectedZoneId) async {
    await getApiurl();
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/division_insert/'),
      body: {
        'divisioncntr': divisioncntr.text,
        'selectedzone_val':selectedCcZoneId,
        'selectedzone_id': selectedCcZoneId,
        'selectedcountryzone_val':selectedUserID,
        'selectedzonezoneid':selectedCcZoneIdname,
      },
    );
    print("respons data ${response.body}");
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
  Future<void> insertCluster() async {
    await getApiurl();
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/cluster_insert/'),
      body: {
        'selectedccountryzone_val':selectedUserID,
        'selectedCzone_val':selectedCcZoneId,
        'selectedivision_val':selectedUserID2,
        'selectedCZonename':selectedCcZoneIdname,
        'clustercntr':clustercntr.text,
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

}


