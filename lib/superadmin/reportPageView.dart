import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../agent/agent_report.dart';
import '../agent/coordinatorlogin.dart';
import '../agent/individaul_report.dart';

class ReportPageView extends StatefulWidget {

  final String firstname;
  final bool isAdmin;
  final String id;
  const ReportPageView({super.key,required this.firstname, required this.id, required this.isAdmin,});

  @override
  State<ReportPageView> createState() => _ReportPageViewState();
}

class _ReportPageViewState extends State<ReportPageView> {
  @override
  void initState() {
    super.initState();
    getApiurl();
    regionList();

  }
  String? apiUrl;
  var zone_data;
  var area_data;
  var cluster_data;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title:   const Padding(
          padding: EdgeInsets.all(70.0),
          child: Text('REPORT',style: TextStyle(color: Colors.white),),
        ),backgroundColor: HexColor('#3465D9'), leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return CoordinatorPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin);}))
        ), ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.shade50,
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width*0.95,
                      height: MediaQuery.of(context).size.width*0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // First Column (Image)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                  color: HexColor('#274DA6'),
                                  width:MediaQuery.of(context).size.width*0.38,
                                  height: 100,
                                  child: const Padding(
                                    padding: EdgeInsets.only(top:10.0),
                                    child: Column(
                                      children: [
                                        // Image.asset(
                                        //   'images/cluster (1).png',
                                        //   width: 30,
                                        //   height: 25,
                                        // ),

                                        Center(child: Text('SUBSCRIBERS',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                                      ],
                                    ),
                                  )
                                // Adjust the height as needed
                                // child: Image.asset(
                                //   'images/locations.png',
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return  IndiviualReport(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin);
                                    }));
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                            // SizedBox(width: 10,),
                            // Text('Zone')
                            // Second Column (Text)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width*0.95,
                      height: MediaQuery.of(context).size.width*0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // First Column (Image)
                            GestureDetector(
                              onTap: () {

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                    color: HexColor('#274DA6'),
                                    width:MediaQuery.of(context).size.width*0.38,
                                    height: 100,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top:10.0),
                                      child: Column(
                                        children: [
                                          // Image.asset(
                                          //   'images/cluster (1).png',
                                          //   width: 30,
                                          //   height: 25,
                                          // ),

                                          Center(child: Text('MY REPORT',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                                        ],
                                      ),
                                    )
                                  // Adjust the height as needed
                                  // child: Image.asset(
                                  //   'images/locations.png',
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){return Renweal();}));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  AgentAmountReport(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                        (Route<dynamic> route) =>
                                    false, // Removes all routes in the stack
                                  );
                                },child: const Icon(Icons.arrow_forward_ios_rounded,
                                color:Colors.grey))
                            // SizedBox(width: 10,),
                            // Text('Zone')
                            // Second Column (Text)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),





              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         // Navigator.push(context, MaterialPageRoute(builder: (context){return ReceiptForm();}));
              //         Navigator.pushAndRemoveUntil(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //               const DivisonPage()),
              //               (Route<dynamic> route) =>
              //           false, // Removes all routes in the stack
              //         );
              //       },
              //       child: Card(
              //         color: Colors.white,
              //         child: SizedBox(
              //           width: MediaQuery.of(context).size.width *
              //               0.96,
              //           height: MediaQuery.of(context).size.height *
              //               0.13,
              //           child: Column(
              //             children: [
              //               const SizedBox(height: 10),
              //               Image.asset(
              //                 'images/division.png',
              //                 height: 40,
              //               ),
              //               const SizedBox(height: 3),
              //               // Adjust the space between icon and text
              //               Text(
              //                 'Area',
              //                 style: GoogleFonts.roboto(
              //                     textStyle: const TextStyle(
              //                         fontSize: 11)),
              //               ),
              //             ],
              //           ),
              //         ), //SizedBox
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) {
              //               return  ClusterPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin);
              //             }));
              //       },
              //       child: Card(
              //         color: Colors.white,
              //         child: SizedBox(
              //           width: MediaQuery.of(context).size.width *
              //               0.96,
              //           height: MediaQuery.of(context).size.height *
              //               0.13,
              //           child: Column(
              //             children: [
              //               const SizedBox(height: 15),
              //               Image.asset(
              //                 'images/cluster.png',
              //                 height: 28,
              //               ),
              //               // Adjust the space between icon and text
              //               const SizedBox(height: 11),
              //               Padding(
              //                 padding:
              //                 const EdgeInsets.only(left: 5.0),
              //                 child: Text(
              //                   'Cluster',
              //                   style: GoogleFonts.roboto(
              //                       textStyle: const TextStyle(
              //                           fontSize: 10)),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ), //SizedBox
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(
              //   width: 2,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }
  Future<void> regionList() async {
    // Make your HTTP request here
    await getApiurl();
    var response = await http.post(Uri.parse('$apiUrl/RegionCount/'));
    if(response.statusCode==200)
    {
      final List<dynamic> parsedJson = json.decode(response.body);
      final Map<String, dynamic> data = parsedJson[0];
      print(data);
      setState(() {
        zone_data = data['Zone'];
        area_data = data['Area'];
        cluster_data = data['Cluster'];
      });

    }
  }
}
