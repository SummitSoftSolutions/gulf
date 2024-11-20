import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/superadmin/zone_page.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../agent/coordinatorlogin.dart';
import 'cluster_page.dart';
import 'divsion_page.dart';

class Region extends StatefulWidget {

  final String firstname;
  final bool isAdmin;
  final String id;
  const Region({super.key,required this.firstname, required this.id, required this.isAdmin,});

  @override
  State<Region> createState() => _RegionState();
}

class _RegionState extends State<Region> {
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
          padding: EdgeInsets.all(80.0),
          child: Text('Region',style: TextStyle(color: Colors.white),),
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
              Padding(
                padding: const EdgeInsets.only(top:20,left: 20),
                child: Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: HexColor('#274DA6'),
                                      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/location-pointer.png',
                                            height: MediaQuery.of(context).size.height * 0.05, // Responsive image size
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'ZONE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '$zone_data',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: HexColor('#274DA6'),
                                      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/area (1).png',
                                            height: MediaQuery.of(context).size.height * 0.05, // Responsive image size
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'AREA',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '$area_data',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: HexColor('#274DA6'),
                                      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/cluster (1).png',
                                            height: MediaQuery.of(context).size.height * 0.05, // Responsive image size
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'CLUSTER',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '$cluster_data',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const ZonePage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                      child: Center(
                        child: Text(
                          'ZONE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DivisonPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                      child: Center(
                        child: Text(
                          'AREA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClusterPage(
                            firstname: widget.firstname,
                            id: widget.id,
                            isAdmin: widget.isAdmin,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.15, // Responsive height
                      child: Center(
                        child: Text(
                          'CLUSTER',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
