import 'dart:convert';
import 'package:gulf_suprabhaatham/agent/usermode.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:flutter/rendering.dart';

import '../constants.dart';
import '../superadmin/reportPageView.dart';
import 'indiviualreportmodel.dart';

class IndiviualReport extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const IndiviualReport({super.key, required this.firstname, required this.id, required this.isAdmin});


  @override
  State<IndiviualReport> createState() => _IndiviualReportState();
}

class _IndiviualReportState extends State<IndiviualReport> {
  String? selecteduserreport;
  var apiUrl;
  var user_valreport;
  List<UserListData> usersreport = [];
  TextEditingController dateinput1 = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  String selectedUserID = '';
  List<IndiviualReportListData> tableDataList = <IndiviualReportListData>[];
  var data_records = <IndiviualReportListData>[];
  var balancedata;

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }
  @override
  void initState()
  {
    super.initState();
    selectsubcriber();
  }
  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> tableDataList = [];

    return MaterialApp(
      home: Scaffold(
        appBar:  AppBar(
          title:const Padding(
            padding: EdgeInsets.only(right:35.0),
            child: Center(child: Text('Report View',style: appbarTextColor,)),
          ),
          backgroundColor: HexColor('#3465D9'),
          automaticallyImplyLeading: true,leading: IconButton(
          icon:  const Icon(Icons.arrow_back,color: appbArrowColor,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ReportPageView(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                  (Route<dynamic> route) => false, // Removes all routes in the stack
            );

          },
        ),

        ),
        body: Column(
          children: [
            Container(
              child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.93,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: DropdownSearch<String>(
                            selectedItem: selecteduserreport,
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: usersreport.map((UserListData data) {
                              return data.name; // Assuming 'Name' holds the strings you want to display
                            }).toList(),
                            onChanged: (String? value) async { // Change the parameter to accept nullable string
                              setState(() {
                                selecteduserreport = value ?? ''; // Ensure selecteduser is not null
                              });
                              if (value != null) {
                                // Find the UserListData instance corresponding to the selected name
                                UserListData? selectedUserData = usersreport.firstWhere(
                                      (data) => data.name == value,
                                );

                                // Pass the ID to your function if available
                                selectedUserID = selectedUserData.accountid.toString();
                                // tableDataList = await select_indivual_report(selectedUserData.accountID);


                              }
                            },

                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  labelText: "From Date",
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
                                    // Picked Date output format => 2021-03-10 00:00:00.000
                                    String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1);
                                    // Formatted date output using intl package => 2021-03-16

                                    setState(() {
                                      dateinput.text = formattedDate1;
                                    });
                                  } else {
                                  }
                                },
                              ),
                            ),

                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  labelText: "To Date",
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
                                    // Picked Date output format => 2021-03-10 00:00:00.000
                                    String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1);
                                    // Formatted date output using intl package => 2021-03-16

                                    setState(() {
                                      dateinput1.text = formattedDate1;
                                    });
                                  } else {
                                  }
                                },
                              ),
                            ),

                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(style:TextButton.styleFrom(backgroundColor:HexColor('#3465D9'),),onPressed: () async{
                              await select_indivual_report().then((value) {
                                tableDataList.addAll(value);
                              });
                              fetchBalanceAmount();
                            },  child: const Text('Search',style:TextStyle(color: Colors.white),))
                          ],
                        ),
                      ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 20.0),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   height: MediaQuery.of(context).size.height * 0.5,
//                   child: HorizontalDataTable(
//                     leftHandSideColumnWidth: 100.0,
//                     rightHandSideColumnWidth: 600.0,
//                     isFixedHeader: true,
//                     rowSeparatorWidget: const Divider(height: 5, thickness: 0.5),
//                     headerWidgets: <Widget>[
//                       Container(
//                         width: 100,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1.0, color: Colors.grey),
//                         ),
//                         child: const Text('Name'),
//                       ),
//                       Container(
//                         width: 150,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1.0, color: Colors.grey),
//                         ),
//                         child: const Text('Date'),
//                       ),
//                       Container(
//                         width: 150,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1.0, color: Colors.grey),
//                         ),
//                         child: const Text('Debit'),
//                       ),
//                       Container(
//                         width: 150,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1.0, color: Colors.grey),
//                         ),
//                         child: const Text('Credit'),
//                       ),
//                       Container(
//                         width: 150,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1.0, color: Colors.grey),
//                         ),
//                         child: const Text('Action'),
//                       ),
//                       // Add more header widgets as needed
//                     ],
//                     // Assuming responseData holds the data retrieved from the API
//                     leftSideItemBuilder: (context, index) {
//                       var rowData = tableDataList[index];
//                       return Container(
//                         width: 100,
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 1.0, color: Colors.grey),
//                         ),
//                         child:Text(rowData.name),
//                       );
//                     },
//                     rightSideItemBuilder: (context, index) {
//
//                       if (index < tableDataList.length) {
//                         var rowData = tableDataList[index];
//                         return Row(
//                           children: [
//                             Container(
//                               width: 150,
//                               height: 50,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 border: Border.all(width: 1.0, color: Colors.grey),
//                               ),
//                               child: Text(rowData.date), // Access 'name' from the rowData
//                             ),
//                             Container(
//                               width: 150,
//                               height: 50,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 border: Border.all(width: 1.0, color: Colors.grey),
//                               ),
//                               child: Text(rowData.Debit), // Access 'date' from the rowData
//                             ),
//                             Container(
//                               width: 150,
//                               height: 50,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 border: Border.all(width: 1.0, color: Colors.grey),
//                               ),
//                               child: Text(rowData.Credit), // Access 'date' from the rowData
//                             ),
//                             Container(
//                               width: 150,
//                               height: 50,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 border: Border.all(width: 1.0, color: Colors.grey),
//                               ),
//                               child: const Row(
//                                 children: [
//                                   Icon(Icons.edit,color: Colors.blue,),
//                                   Icon(Icons.delete,color: Colors.red,)
//                                 ],
//                               ),// Access 'date' from the rowData
//                             ),
//
//                           ],
//                         );
//                       } else {
//                         return const SizedBox(); // Return an empty container if index exceeds responseData length
//                       }
//                     },
//                     itemCount: tableDataList.length, // Set itemCount based on the responseData length
// // Set itemCount based on the responseData length
//                     // Number of rows based on fetched data
//                   ),
//                   ),
//                 ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        color: HexColor('#3465D9'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            const Text('Balance:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                            const SizedBox(
                              width: 65,
                            ),
                            Text('$balancedata',style: const TextStyle(fontSize: 20,color: Colors.white),),
                            const SizedBox(
                              width: 40,
                            ),
                          ],
                        ),
                      )





                    ],
                  )
              ),
            ),
          ],
        ),

      ),
    );
  }
  Future selectsubcriber() async {

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/select_subscribers/'));

    if (response.statusCode == 200) {
      setState(() {
        user_valreport = jsonDecode(response.body);
      });


      usersreport = (user_valreport).map<UserListData>((model) {
        return UserListData.fromJson(model);
      }).toList();
      // You can parse and update state data here if needed
    } else {
      // Handle API error
    }
  }
  // Future select_indivual_report(accountID) async {
  //   var data;
  //   print("accountID.............................");
  //
  //   await getApiurl(); // Assuming this function sets the API URL
  //   var response = await http.post(Uri.parse('$apiUrl/searched_indivual_report/'), body: {
  //   'accountID': accountID.toString(),
  //   });
  //
  //  print(response.body);
  // }
  Future select_indivual_report() async {
    tableDataList=[];
    data_records=[];

    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(
      Uri.parse('$apiUrl/searched_indivual_report/'),
      body: {
        'accountID': selectedUserID,
        'dateinput':dateinput.text,
        'dateinput1':dateinput1.text,
      },
    );
    if (response.statusCode == 200) {
      var responseData;
      setState(() {
        responseData = json.decode(response.body);
      });

      for (var reportJson in responseData) {
        data_records.add(IndiviualReportListData.fromJson(reportJson));
      }
      return data_records;
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future  fetchBalanceAmount() async
  {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/find_balance_amount/'),
      body: {
        'accountID': selectedUserID,
      },
    );
    if(response.statusCode==200)
      {
        var decodeResponse = jsonDecode(response.body);
        var balanceData = decodeResponse as List<dynamic>;
        if(balanceData.isNotEmpty)
          {
            var balanceData1 = balanceData[0]['total_balance'];
            setState(() {
              balancedata=balanceData1;
            });
          }
      }
  }
}
