import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gulf_suprabhaatham/agent/coordinatorsubscriberview.dart';
import 'package:gulf_suprabhaatham/superadmin/clustermodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../superadmin/countrymodel.dart';
import '../superadmin/divisionmodel.dart';
import '../superadmin/zonemodel.dart';

class viewIndiviualCoordinatorsubscribers extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  final int val_data;

  const viewIndiviualCoordinatorsubscribers({super.key, required this.firstname, required this.id, required this.isAdmin, required this.val_data});



  @override
  State<viewIndiviualCoordinatorsubscribers> createState() => _viewIndiviualCoordinatorsubscribersState();
}

class _viewIndiviualCoordinatorsubscribersState extends State<viewIndiviualCoordinatorsubscribers> {
  TextEditingController mobileCntr = TextEditingController();
  TextEditingController whatsnoCntr = TextEditingController();
  TextEditingController startdateCntr = TextEditingController();
  TextEditingController enddateCntr =  TextEditingController();
  TextEditingController officetelCntr =  TextEditingController();
  TextEditingController residencetelCntr =  TextEditingController();
  TextEditingController emailCntr =  TextEditingController();
  TextEditingController postboxCntr =  TextEditingController();
  TextEditingController flatno =  TextEditingController();
  TextEditingController floor =  TextEditingController();
  TextEditingController address =  TextEditingController();
  TextEditingController countryid  =  TextEditingController();
  TextEditingController zoneid  =  TextEditingController();
  TextEditingController divisionid  =  TextEditingController();
  TextEditingController clusterid   =  TextEditingController();
  TextEditingController subid    =  TextEditingController();
  TextEditingController givenamount    =  TextEditingController();
  TextEditingController subscribtionID   =  TextEditingController();
  TextEditingController regid    =  TextEditingController();
  TextEditingController coordinatorid     =  TextEditingController();
  TextEditingController nameCntr     =  TextEditingController();
  TextEditingController galCntr     =  TextEditingController();
  TextEditingController batchCntr     =  TextEditingController();
  TextEditingController sncntr     =  TextEditingController();
  TextEditingController bookCntr     =  TextEditingController();
  TextEditingController coordinatorphone = TextEditingController();
  TextEditingController streetnoCntr =  TextEditingController();
  TextEditingController buildingname =  TextEditingController();
  TextEditingController statusCntr =  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String?  selectedcountry_val;
  List<CountryList> countries = [];
  String selectedUserID='';
  String?  selectedcountryzone_val;
  var zone_val;
  List<ZoneList> zones = [];
  var country_val;
  String?  selectedzone_val;
  String selectedCcZoneId = '';
  String selectedCcZoneId1 = '';
  var apiUrl;
  var subdivision_val;
  String?  selectedsubzones;
  List<DivisionList> subdivision = [];
  String country_nid='';
  String?  selectedsubdivision;
  String?  selectedsubcluster;
  String division_id_val='';
  String cluster_id_val='';
  String?  zone_id_val= '';
  var subcluster_val;
  String selectedUserID2='';
  String selectedUserID3='';
  List<ClusterList> subcluster = [];
  int remainingDate = 0; // Initialized with a default value
  int totalDate = 0; // Initialized with a default value
  void initState()
  {
    super.initState();
    getApiurl();
    fetchcountry();
    viewindiviualCoordinatorsubscriberdata(widget.val_data);

    // Check if there is a pre-selected country and load zones accordingly
    if (selectedcountry_val != null && selectedcountry_val!.isNotEmpty) {
      var selectedCountry = countries.firstWhere(
            (country) => country.countryname == selectedcountry_val,
      );
      selectedUserID = selectedCountry.id.toString();
      // Fetch zones based on the pre-selected country
      fetchzone(selectedUserID!);
    }


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
            MaterialPageRoute(
              builder: (context) => SubCoord(
                firstname: widget.firstname,
                id: widget.id,
                isAdmin: widget.isAdmin,
              ),
            ),
                (Route<dynamic> route) => false,
          );

        },
      ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01, // Dynamic top padding
                    bottom: MediaQuery.of(context).size.height * 0.015, // Dynamic bottom padding
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: statusCntr.text == 'Normal'
                          ? Colors.black  // Black for Normal
                          : statusCntr.text == 'Temp'
                          ? Colors.orange  // Orange for Temp
                          : Colors.red,
                      // Red for Permanent
                      borderRadius: BorderRadius.circular(8), // Optional: adds rounded corners
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the content
                      children: [
                        Text(
                          'Subscription Status : ${statusCntr.text}', // Display the status text
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8), // Add space between text and icon
                        Icon(
                          statusCntr.text == 'Normal'
                              ? Icons.check // Tick icon for Normal
                              : statusCntr.text == 'Temp'
                              ? Icons.warning // Cancel icon for Temp
                              : Icons.close, // X icon for Permanent
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    totalDate == 0  // Check if remainingDate is greater than 0
                        ? SizedBox.shrink()  // Display this text if true
                        : Text('Total Days : $totalDate',style: TextStyle(fontWeight: FontWeight.bold),), // This will take up no space if false
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    remainingDate == 0  // Check if remainingDate is greater than 0
                        ? SizedBox.shrink()  // Display this text if true
                        : Text('Remaining Days : $remainingDate',style: TextStyle(fontWeight: FontWeight.bold),), // This will take up no space if false
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.43,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: regid,
                          decoration: InputDecoration(
                            labelText: 'Registeration Number',
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
                          controller: subscribtionID,
                          decoration: InputDecoration(
                            labelText: 'Subscription ID',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.43,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: sncntr,
                          decoration: InputDecoration(
                            labelText: 'S No',
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
                          controller: bookCntr,
                          decoration: InputDecoration(
                            labelText: 'Book Received',
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
                          controller: galCntr,
                          decoration: InputDecoration(
                            labelText: 'GAL SNo',
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
                          controller: batchCntr,
                          decoration: InputDecoration(
                            labelText: 'BATCH',
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
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: nameCntr,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'fname',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: mobileCntr,
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
                          onSaved: (value) {
                            setState(() {
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: whatsnoCntr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Whatapp number',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: startdateCntr,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            enabled: false,
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
                          controller: enddateCntr,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            enabled: false,
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
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.43,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: coordinatorid,
                          decoration: InputDecoration(
                            labelText: 'Coordinator Name',
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
                          enabled: true,
                          controller: coordinatorphone,
                          decoration: InputDecoration(
                            labelText: 'Coordinator Number',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: officetelCntr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Office Telephone',
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
                          controller: residencetelCntr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'residential Number',
                            hintText: 'Phone',
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
                        return 'Please enter your Phone Number';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: emailCntr,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'place',
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
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: postboxCntr,
                          decoration: InputDecoration(
                            labelText: 'Post Box',
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
                          controller: flatno,
                          decoration: InputDecoration(
                            labelText: 'Flat No',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: floor,
                          decoration: InputDecoration(
                            labelText: 'Floor',
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
                          controller: address,
                          decoration: InputDecoration(
                            labelText: 'Address',
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
            const Padding(
              padding: EdgeInsets.only(top:20),
              child: Row(
                children: [
                  Text("Country"),
                ],
              ),
            ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: DropdownSearch<String>(
                      selectedItem: selectedcountry_val,
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      items: countries.map((CountryList data) {
                        return data.countryname;
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            selectedcountry_val = value;

                            // Reset zones, area, and cluster on country change
                            selectedzone_val = null;
                            zones.clear();
                            selectedsubdivision = null;
                            subdivision.clear();
                            selectedsubcluster = null;
                            subcluster.clear();

                            // Fetch the zones based on the new selected country
                            var selectedCountry = countries.firstWhere(
                                  (country) => country.countryname == value,
                            );
                            selectedUserID = selectedCountry.id.toString();
                            fetchzone(selectedUserID);
                          }
                        });
                      },

                    ),
                  ),
                ),
            const Padding(
              padding: EdgeInsets.only(left:5.0,top:9),
              child: Row(
                children: [
                  Text("Zone"),
                ],
              ),
            ),
                // Zone Dropdown
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: DropdownSearch<String>(
                    selectedItem: selectedzone_val,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    items: zones.map((ZoneList data) {
                      return data.zonename;
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        // Reset any related dropdowns
                        selectedzone_val = value!;
                        selectedsubdivision = null;
                        selectedsubcluster = null;
                        subdivision.clear();
                        subcluster.clear();
                      });

                      // Fetch new zone data if a value is selected
                      if (value != null) {
                        ZoneList? selectedZone = zones.firstWhere(
                              (data) => data.zonename == value,
                        );
                        selectedCcZoneId = selectedZone.id.toString();
                        selectedCcZoneId1 = selectedZone.zoneid.toString();

                        // Fetch new divisions based on the selected zone
                        fetchdivision(selectedCcZoneId!);
                      }
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left:2.0,top:10),
                  child: Row(
                    children: [
                      Text("Area"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: DropdownSearch<String>(
                    selectedItem: selectedsubdivision,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    items: subdivision.map((DivisionList data) {
                      return data.divisionname;
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedsubdivision = value!;
                      });
                      if (value != null) {
                        DivisionList? selectedSubdivision = subdivision.firstWhere(
                              (data) => data.divisionname == value,
                        );
                        selectedUserID2 = selectedSubdivision.id.toString();
                        fetchcluster(selectedUserID2!);
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),


                const Padding(
                  padding: EdgeInsets.only(left:2.0,top:10),
                  child: Row(
                    children: [
                      Text("Cluster"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: DropdownSearch<String>(
                    selectedItem: selectedsubcluster,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                    ),
                    items: subcluster.map((ClusterList data) {
                      return data.clustername;
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedsubcluster = value!;
                      });
                      if (value != null) {
                        ClusterList? selectedCluster = subcluster.firstWhere(
                              (data) => data.clustername == value,
                        );
                        selectedUserID3 = selectedCluster.id.toString();
                      }
                    },
                  ),
                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Street No Field
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02, // Responsive top padding
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextFormField(
                          controller: streetnoCntr,
                          decoration: InputDecoration(
                            labelText: 'Street No',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: MediaQuery.of(context).size.width * 0.04, // Scalable hint text size
                            ),
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.04, // Horizontal padding
                              vertical: MediaQuery.of(context).size.height * 0.015, // Vertical padding
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Space between rows
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                    // Building Name Field
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01, // Adjusted top padding
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          controller: buildingname,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Building Name',
                            hintText: 'Enter building name here',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                            ),
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.04,
                              vertical: MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: subid,
                          decoration: InputDecoration(
                            labelText: 'Subscription',
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
                          controller: givenamount,
                          decoration: InputDecoration(
                            labelText: 'Total Amount',
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor('#3465D9')
                          ),
                          child: const Text('UPDATE',style: addButtonTextColor),
                          onPressed: () async {
                            await updateCoordSubcriber(widget.val_data);
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return  viewIndiviualCoordinatorsubscribers(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin, val_data: widget.val_data);
                            }));
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('DELETE', style: addButtonTextColor),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text("Are you sure want to delete"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 50),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return viewIndiviualCoordinatorsubscribers(
                                                      firstname: widget.firstname,
                                                      id: widget.id,
                                                      isAdmin: widget.isAdmin,
                                                      val_data: widget.val_data,
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  color: Colors.green,
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () async {
                                                  await deleteCoordinatorsubscribers(widget.val_data);
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return SubCoord(
                                                      firstname: widget.firstname,
                                                      id: widget.id,
                                                      isAdmin: widget.isAdmin,
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                  color: Colors.red,
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Text("Delete", style: TextStyle(color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future viewindiviualCoordinatorsubscriberdata(value) async {
    await getApiurl();

    var response = await http.post(
      Uri.parse('$apiUrl/viewCoordinatorSubData/'),
      body: {
        'id': value.toString(),
      },
    );

    if (response.statusCode == 200) {
      var result_data = json.decode(response.body);
      print('result_data type: ${result_data.runtimeType}');
      print('result_data content: $result_data');

      if (result_data is List && result_data.isNotEmpty) {
        var detail = result_data[0];
        print("details.................... $detail");

        // Use null-aware operator (??) to handle null values and provide default text.
        nameCntr.text = detail['name'] ?? '';
        mobileCntr.text = detail['mobileno'] ?? '';
        whatsnoCntr.text = detail['whatsno'] ?? '';
        startdateCntr.text = detail['startdate'] ?? '';
        enddateCntr.text = detail['enddate'] ?? '';
        officetelCntr.text = detail['officetel']?.toString() ?? '';
        residencetelCntr.text = detail['residencetel']?.toString() ?? '';
        emailCntr.text = detail['email'] ?? '';
        postboxCntr.text = detail['postbox'] ?? '';
        flatno.text = detail['flatno'] ?? '';
        floor.text = detail['floor'] ?? '';
        address.text = detail['address'] ?? '';
        regid.text = detail['reg'] ?? '';
        subscribtionID.text = detail['subscribtionID'] ?? '';
        selectedcountry_val = detail['country'] ?? '';
        selectedzone_val = detail['zone'] ?? '';
        selectedsubdivision = detail['division'];
        selectedsubcluster = detail['cluster'];
        coordinatorid.text = detail['coordinator']?.toString() ?? '';
        country_nid = detail['country_id']?.toString() ?? '';
        division_id_val = detail['division_id']?.toString() ?? '';
        cluster_id_val = detail['cluster_id']?.toString() ?? '';
        zone_id_val = detail['zone_id']?.toString() ?? '';
        print("division_id_val............. $division_id_val");
        clusterid.text = detail['cluster'] ?? '';
        givenamount.text = detail['givenamount']?.toString() ?? '';
        subid.text = detail['subid'] ?? '';
        galCntr.text = detail['galsno'] ?? '';
        batchCntr.text = detail['batch'] ?? '';
        sncntr.text = detail['subaid'] ?? '';
        bookCntr.text = detail['commity'] ?? '';
        coordinatorphone.text = detail['coordinatorphone'] ?? '' ;
        enddateCntr.text = detail['enddateCntr'] ?? '' ;
        streetnoCntr.text = detail['streetno'] ?? '' ;
        buildingname.text =  detail['buildingname'] ?? '';
        statusCntr.text = detail['status'] ?? '';
        remainingDate = detail['date_difference'] ?? 0; // Default to 0 if null
        totalDate = detail['date_difference'] ?? 0; // Default to 0 if null
      }
    }

    // Update the state to fetch additional data based on the country, zone, etc.
    setState(() {
      fetchzone(country_nid);
      fetchdivision(zone_id_val);
      fetchcluster(division_id_val);
    });
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
  // Future<void> updateCoordSubcriber(value) async {
  //   await getApiurl();
  //   var response = await http.post(
  //     Uri.parse('$apiUrl/coordinatorsubscriberUpdate/'),
  //     headers: {
  //       'Content-Type': 'application/json',  // Set Content-Type to JSON
  //       'Accept': 'application/json',  // Optional but good to include
  //     },
  //     body: jsonEncode({
  //       'id_val': value.toString(),
  //       'nameCntr': nameCntr.text,
  //       'mobileCntr': mobileCntr.text,
  //       'whatsnoCntr': whatsnoCntr.text,
  //       'emailCntr': emailCntr.text,
  //       'officetelCntr': officetelCntr.text,
  //       'residencetelCntr': residencetelCntr.text,
  //       'flatno': flatno.text,
  //       'floor': floor.text,
  //       'postboxCntr': postboxCntr.text,
  //       'address': address.text,
  //       'selectedUserID': selectedUserID,
  //       'selectedUserID2': selectedUserID2,
  //       'selectedUserID3': selectedUserID3,
  //       'selectedCcZoneId': selectedCcZoneId,
  //       'country_nid': country_nid,
  //       'zone_id_val': zone_id_val,
  //       'division_id_val': division_id_val,
  //       'cluster_id_val': cluster_id_val,
  //     }),
  //   );
  //
  //   print("response ${response.body}");
  //   if (response.statusCode == 200) {
  //     var data = response.body.trim();
  //     print("data $data");
  //     if (data.contains("success")) {
  //       final SnackBar snackBar = const SnackBar(
  //         content: Text("Success"),
  //         backgroundColor: Colors.green,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     } else {
  //       final SnackBar snackBar = const SnackBar(
  //         content: Text("Not Updated"),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //   } else {
  //     final SnackBar snackBar = SnackBar(
  //       content: Text("Error: ${response.statusCode}"),
  //       backgroundColor: Colors.red,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }
  Future<void> updateCoordSubcriber(value) async {
    await getApiurl();

    // Construct body dynamically
    Map<String, dynamic> body = {
      'id_val': value.toString(),
    };

    if (nameCntr.text.isNotEmpty) body['nameCntr'] = nameCntr.text;
    if (mobileCntr.text.isNotEmpty) body['mobileCntr'] = mobileCntr.text;
    if (whatsnoCntr.text.isNotEmpty) body['whatsnoCntr'] = whatsnoCntr.text;
    if (emailCntr.text.isNotEmpty) body['emailCntr'] = emailCntr.text;
    if (officetelCntr.text.isNotEmpty) body['officetelCntr'] = officetelCntr.text;
    if (residencetelCntr.text.isNotEmpty) body['residencetelCntr'] = residencetelCntr.text;
    if (flatno.text.isNotEmpty) body['flatno'] = flatno.text;
    if (floor.text.isNotEmpty) body['floor'] = floor.text;
    if (postboxCntr.text.isNotEmpty) body['postboxCntr'] = postboxCntr.text;
    if (address.text.isNotEmpty) body['address'] = address.text;

    // Include optional dropdown values
    if (selectedUserID != null) body['selectedUserID'] = selectedUserID;
    if (selectedUserID2 != null) body['selectedUserID2'] = selectedUserID2;
    if (selectedUserID3 != null) body['selectedUserID3'] = selectedUserID3;
    if (selectedCcZoneId != null) body['selectedCcZoneId'] = selectedCcZoneId;
    if (country_nid != null) body['country_nid'] = country_nid;
    if (zone_id_val != null) body['zone_id_val'] = zone_id_val;
    if (division_id_val != null) body['division_id_val'] = division_id_val;
    if (cluster_id_val != null) body['cluster_id_val'] = cluster_id_val;

    // Make HTTP POST request
    var response = await http.post(
      Uri.parse('$apiUrl/coordinatorsubscriberUpdate/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print("response ${response.body}");
    if (response.statusCode == 200) {
      var data = response.body.trim();
      print("data $data");
      if (data.contains("success")) {
        final SnackBar snackBar = const SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final SnackBar snackBar = const SnackBar(
          content: Text("Not Updated"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final SnackBar snackBar = SnackBar(
        content: Text("Error: ${response.statusCode}"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future fetchzone(String countryId) async {
    if (countryId == null || countryId.isEmpty) {
      print("No valid countryId provided");
      return;
    }
    print("Fetching zones for country ID: $countryId");
    await getApiurl();

    var response = await http.post(
      Uri.parse('$apiUrl/select_zone/'),
      body: {'countryname': countryId},
    );

    if (response.statusCode == 200) {
      setState(() {
        zone_val = jsonDecode(response.body);
        zones = (zone_val).map<ZoneList>((model) {
          return ZoneList.fromJson(model);
        }).toList();
        print("Zones fetched: $zones");
      });
    } else {
      print("Failed to fetch zones. Response: ${response.body}");
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
        country_val = jsonDecode(response.body);
      });
      // print("country",selectedcountryzone_val.status);
      print("countrydata $country_val");
      countries = (country_val).map<CountryList>((model) {
        return CountryList.fromJson(model);
      }).toList();
      print("countries $countries");
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
      print("subdivision..............$subdivision");
      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future deleteCoordinatorsubscribers(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/coordinatorsubscriberDelete/'),
      body: {
        'id': value.toString(),
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

}
