import 'dart:convert';
import 'package:gulf_suprabhaatham/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../superadmin/reportPageView.dart';

class AgentAmountReport extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  const AgentAmountReport({super.key, required this.firstname, required this.id, required this.isAdmin});
  @override
  State<AgentAmountReport> createState() => _AgentAmountReportState();
}

class _AgentAmountReportState extends State<AgentAmountReport> {
  TextEditingController dateinput1 = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  var total=0.0;
  var cash=0.0;
  var bank=0.0;
  var apiUrl;
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Subscriber Payment Report'),backgroundColor: HexColor('#3465D9'),automaticallyImplyLeading: true,leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.17,
        color: HexColor('#3465D9'),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.99,
                height: MediaQuery.of(context).size.height * 0.3,
                // color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
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
                                fillColor: Colors.white,
                                filled: true
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
                                  fillColor: Colors.white,
                                  filled: true
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(style:TextButton.styleFrom(backgroundColor:Colors.white,),onPressed: () async{
                                await selectCoordinatorReport();
                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (context) {
                                //   return  AgentAmountReport(firstname:widget.firstname,id: widget.id,isAdmin:widget.isAdmin);
                                // }));

                              },  child: const Text('Search',style:TextStyle(color: Colors.black),))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
       Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Header
            const ListTile(
              tileColor: Colors.grey,
              title: Text(
                'Summary',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ),
            // // Divider or any other widget to separate the header from content
            // Divider(),
            // Content
            ListTile(
              leading: const Icon(Icons.attach_money),
              trailing:Text('$total'),
              title: const Text('Total Amount'),
            ),
            ListTile(
              leading: const Icon(Icons.money),
              trailing: Text('$cash'),
              title: const Text('Cash'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              trailing:Text('$bank'),
              title: const Text('Bank'),
            ),
            // Additional content widgets can be added here
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
  Future selectCoordinatorReport() async {
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(
      Uri.parse('$apiUrl/viewCoorAmount/'),
      body: {
        'id': widget.id,
        'dateinput':dateinput.text,
        'dateinput1':dateinput1.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var responseData = json.decode(response.body);
        cash = double.parse(responseData['cash']);
        bank = double.parse(responseData['bank'].toString());
        total = double.parse(responseData['total']);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
}
