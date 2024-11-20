import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gulf_suprabhaatham/agent/chardatamodel.dart';
import 'package:gulf_suprabhaatham/agent/coordinator_form.dart';
import 'package:gulf_suprabhaatham/agent/graphmodel.dart';
import 'package:gulf_suprabhaatham/agent/profile.dart';
import 'package:gulf_suprabhaatham/superadmin/account.dart';
import 'package:gulf_suprabhaatham/superadmin/coordinatordetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../login_page.dart';
import '../superadmin/SubcriptionAgentPage.dart';
import '../superadmin/SubscriberDetailPage.dart';
import '../superadmin/receiptPageView.dart';
import '../superadmin/region.dart';
import '../superadmin/reportPageView.dart';
import 'cancelation/CancelPageList.dart';
import 'notificationpage.dart';


const bottomcContaineColor = Colors.red;
const containeColor = Color(0xFF2C2C38);
const inactiveColor = Color(0xFF111328);

class CoordinatorPage extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;


  const CoordinatorPage(
      {super.key, required this.firstname, required this.id, required this.isAdmin,});

  @override
  State<CoordinatorPage> createState() => _CoordinatorPageState();
}

class _CoordinatorPageState extends State<CoordinatorPage> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        print("widget.isAdmin..${widget.isAdmin}");
        print("widget.id....${widget.id}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return ProfilePage(firstname: widget.firstname, isAdmin: widget.isAdmin, id: widget.id);
        }));
      } else if (_selectedIndex == 1) {
        widget.isAdmin
            ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const FormApp();
        }))
            : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return ProfilePage(firstname: widget.firstname, isAdmin: widget.isAdmin, id: widget.id);
        }));
      } else if (_selectedIndex == 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return CoordinatorPage(firstname: widget.firstname, id: widget.id, isAdmin: widget.isAdmin);
        }));
      }
    });
  }


  int _selectedIndex = 0;
  Color kActiveCardColour = const Color(0xFF1D1E33);
  String? apiUrl;
  var role = 0;
  var isAdmin;
  int userReg=0;
  int adminUserReg=0;
  List<ChartData> chartData = [
    ChartData('Label 1', 30, Colors.blue),
    ChartData('Label 2', 30, Colors.white),
  ];
  List<SalesData> graphData = [];
  List<SalesData> graphDataCoord = [];

  final List<double> data = [10, 20, 15, 25, 30, 20, 35];
  Color maleColor = inactiveColor;
  Color femaleColor = inactiveColor;
  int height = 180;
  int weight = 74;
  int age = 19;
  List<Map<String, dynamic>> graphData1 = [];


  @override
  void initState() {
    super.initState();
    getApiurl();
    // getuser();
    fetchcountofusers(widget.id);
    graphdata();
    graphdataCoordinator(widget.id);
  }

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }

  @override
  Widget build(BuildContext context) {
    print("isAdmin11 $widget.id");
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body:kIsWeb?
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
                top:0,
                left: 0,
                right: 0,
                child: buildAppbarWidget(context)),
            Positioned(
              top:150,
              left: 10,
              right: 10,
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.height*0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0), // Top left corner
                    topRight: Radius.circular(5.0), // Top right corner
                    bottomRight:
                    Radius.circular(5.0), // Bottom right corner
                    bottomLeft: Radius.circular(5.0), // Bottom left corner
                  ),
                ),
                child:   widget.isAdmin
                    ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10,right:5),
                      child: Row(
                        children: [
                          Card(
                            color: Colors.white,
                            child: Container(
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
                              width: MediaQuery.of(context).size.width *
                                  0.86,
                              height: MediaQuery.of(context).size.height *
                                  0.1,
                              child:Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0,left:45),
                                        child: Image.asset('images/registered.png',width: 30,height: 30,),
                                      ),
                                      Text('REGISTERED USERS :  $adminUserReg',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontSize: 13,))),

                                    ],
                                  ),
                                ],
                              ),
                            ), //SizedBox
                          ),

                          //Card
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0,left:10,bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.89,
                            height: MediaQuery.of(context).size.height*0.23,
                            decoration:  BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0), // Top left corner
                                topRight: Radius.circular(5.0), // Top right corner
                                bottomRight:
                                Radius.circular(5.0), // Bottom right corner
                                bottomLeft: Radius.circular(5.0), // Bottom left corner
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: SfCartesianChart(
                              backgroundColor: const Color(0xFF5A9DED),
                              title: ChartTitle(text: 'SUBSCRIBER REGISTERATION',textStyle: const TextStyle(fontSize: 10,color:Colors.white,fontWeight: FontWeight.bold)),
                              // legend: Legend(isVisible: true),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries>[
                                LineSeries<SalesData, String>(
                                  dataSource: graphData,
                                  xValueMapper: (SalesData sales, _) => sales.month,
                                  yValueMapper: (SalesData sales, _) => sales.number,
                                  name: 'Count',
                                  markerSettings: const MarkerSettings(isVisible: true),
                                ),
                              ],
                              primaryXAxis: CategoryAxis(
                                axisLine: const AxisLine(color: Colors.white),
                                labelStyle: const TextStyle(color: Colors.white),
                                majorTickLines: const MajorTickLines(color: Colors.white),
                                majorGridLines: const MajorGridLines(color: Colors.white),
                              ),
                              primaryYAxis: NumericAxis(
                                axisLine: const AxisLine(color: Colors.white),
                                labelStyle: const TextStyle(color: Colors.white),
                                majorTickLines: const MajorTickLines(color: Colors.white),
                                majorGridLines: const MajorGridLines(color: Colors.white),
                              ),
                              // primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number')),
                            ),
                          )

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Region(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/locations.png',
                                      height: 30,
                                    ),
                                    // Adjust the space between icon and text
                                    Text(
                                      'REGION',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Accounts(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/accounting (2).png',
                                      height: 30,
                                    ),
                                    // const SizedBox(height: 10),
                                    // Adjust the space between icon and text
                                    Text(
                                      'ACCOUNTS',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),
                          // const SizedBox(
                          //   width: 1,
                          // ),



                          //Card
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CoordinatorDetailPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/agent.png',
                                      height: 30,
                                    ),
                                    // Adjust the space between icon and text
                                    Text(
                                      'COORDINATORS',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SubscriberDetailPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/user (2).png',
                                      height: 30,
                                    ),
                                    // const SizedBox(height: 10),
                                    // Adjust the space between icon and text
                                    Text(
                                      'SUBSCRIPTION',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),
                          // const SizedBox(
                          //   width: 1,
                          // ),



                          //Card
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 1.0, left: 7,right:4),
                    //   child: Row(
                    //     children: [
                    //       // GestureDetector(
                    //       //   onTap: () {
                    //       //     // Navigator.push(context, MaterialPageRoute(builder: (context){return Renweal();}));
                    //       //     Navigator.pushAndRemoveUntil(
                    //       //       context,
                    //       //       MaterialPageRoute(
                    //       //           builder: (context) =>  AccountMaster(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                    //       //           (Route<dynamic> route) =>
                    //       //       false, // Removes all routes in the stack
                    //       //     );
                    //       //   },
                    //       //   child: Card(
                    //       //     color: HexColor('#EEF5FF'),
                    //       //     child: SizedBox(
                    //       //       width: MediaQuery.of(context).size.width *
                    //       //           0.28,
                    //       //       height: MediaQuery.of(context).size.height *
                    //       //           0.1,
                    //       //       child: Column(
                    //       //         children: [
                    //       //           const SizedBox(height: 10),
                    //       //           Image.asset(
                    //       //             'images/addmaster.png',
                    //       //             height: 40,
                    //       //           ),
                    //       //           const SizedBox(height: 5),
                    //       //           // Adjust the space between icon and text
                    //       //           Text(
                    //       //             'Account Master',
                    //       //             overflow: TextOverflow.ellipsis,
                    //       //             style: GoogleFonts.roboto(
                    //       //                 textStyle: const TextStyle(
                    //       //                     fontSize: 10.5)),
                    //       //           ),
                    //       //         ],
                    //       //       ),
                    //       //     ), //SizedBox
                    //       //   ),
                    //       // ),
                    //       // GestureDetector(
                    //       //   onTap: () {
                    //       //     Navigator.push(context,
                    //       //         MaterialPageRoute(builder: (context) {
                    //       //           return const AccountGroupMaster();
                    //       //         }));
                    //       //   },
                    //       //   child: Card(
                    //       //     color: HexColor('#EEF5FF'),
                    //       //     child: SizedBox(
                    //       //       width: MediaQuery.of(context).size.width *
                    //       //           0.28,
                    //       //       height: MediaQuery.of(context).size.height *
                    //       //           0.1,
                    //       //       child: Column(
                    //       //         children: [
                    //       //           const SizedBox(height: 10),
                    //       //           Image.asset(
                    //       //             'images/addgroupmaster.png',
                    //       //             height:
                    //       //             40, // Adjust the height to fit within the CircleAvatar
                    //       //             // Maintain aspect ratio while covering the circle
                    //       //           ),
                    //       //
                    //       //           // Adjust the space between icon and text
                    //       //           const SizedBox(height: 5),
                    //       //           Padding(
                    //       //             padding: const EdgeInsets.only(left:3.0),
                    //       //             child: Text(
                    //       //               'Account Group Master',
                    //       //               overflow: TextOverflow.ellipsis,
                    //       //               style: GoogleFonts.roboto(
                    //       //                   textStyle: const TextStyle(
                    //       //                       fontSize: 10)),
                    //       //             ),
                    //       //           ),
                    //       //         ],
                    //       //       ),
                    //       //     ), //SizedBox
                    //       //   ),
                    //       // ),
                    //
                    //       // const SizedBox(
                    //       //   width: 2,
                    //       // ),
                    //
                    //
                    //
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 1.0, left: 7,right:4),
                    //   child: Row(
                    //     children: [
                    //
                    //       // const SizedBox(
                    //       //   width: 2,
                    //       // ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(context, MaterialPageRoute(builder: (context){return Renweal();}));
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>  MyApp(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                    //                 (Route<dynamic> route) =>
                    //             false, // Removes all routes in the stack
                    //           );
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 10),
                    //                 Image.asset(
                    //                   'images/agent.png',
                    //                   height: 40,
                    //                 ),
                    //                 // Adjust the space between icon and text
                    //                 Text(
                    //                   'View Coordinators',
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: GoogleFonts.roboto(
                    //                       textStyle: const TextStyle(
                    //                           fontSize: 11)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>  SubDetails(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                    //                 (Route<dynamic> route) =>
                    //             false, // Removes all routes in the stack
                    //           );
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 10),
                    //                 Image.asset(
                    //                   'images/viewsubscribers.png',
                    //                   height:
                    //                   40, // Adjust the height to fit within the CircleAvatar
                    //                   // Maintain aspect ratio while covering the circle
                    //                 ),
                    //
                    //                 // Adjust the space between icon and text
                    //
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(left:15.0),
                    //                   child: Text(
                    //                     'View Subscribers',
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: GoogleFonts.roboto(
                    //                         textStyle: const TextStyle(
                    //                             fontSize: 11)),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>  AdminReceiptView(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                    //                 (Route<dynamic> route) =>
                    //             false, // Removes all routes in the stack
                    //           );
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 10),
                    //                 Image.asset(
                    //                   'images/receiptviewpic.png',
                    //                   height:
                    //                   40, // Adjust the height to fit within the CircleAvatar
                    //                   // Maintain aspect ratio while covering the circle
                    //                 ),
                    //
                    //                 // Adjust the space between icon and text
                    //
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(left:15.0),
                    //                   child: Text(
                    //                     'View Receipts',
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: GoogleFonts.roboto(
                    //                         textStyle: const TextStyle(
                    //                             fontSize: 11)),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //
                    //
                    //       // const SizedBox(
                    //       //   width: 2,
                    //       // ),
                    //
                    //     ],
                    //   ),
                    //
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top:5.0),
                    //   child: Row(
                    //     children: [
                    //      Container(
                    //         width: MediaQuery.of(context).size.width*0.89,
                    //         height: MediaQuery.of(context).size.height*0.23,
                    //         decoration: const BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(5.0), // Top left corner
                    //             topRight: Radius.circular(5.0), // Top right corner
                    //             bottomRight:
                    //             Radius.circular(5.0), // Bottom right corner
                    //             bottomLeft: Radius.circular(5.0), // Bottom left corner
                    //           ),
                    //         ),
                    //         child: SfCartesianChart(
                    //           title: ChartTitle(text: 'Subscriber Registration',textStyle: const TextStyle(fontSize: 10)),
                    //           // legend: Legend(isVisible: true),
                    //           tooltipBehavior: TooltipBehavior(enable: true),
                    //           series: <ChartSeries>[
                    //             LineSeries<SalesData, String>(
                    //               dataSource: graphData,
                    //               xValueMapper: (SalesData sales, _) => sales.month,
                    //               yValueMapper: (SalesData sales, _) => sales.number,
                    //               name: 'Count',
                    //               markerSettings: const MarkerSettings(isVisible: true),
                    //             ),
                    //           ],
                    //           primaryXAxis: CategoryAxis(),
                    //           primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number')),
                    //         ),
                    //       )
                    //
                    //     ],
                    //   ),
                    // ),
                  ],
                )

                    : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 7,right:5),
                      child: Row(
                        children: [
                          Card(
                            color: HexColor('#EEF5FF'),
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.87,
                              height: MediaQuery.of(context).size.height *
                                  0.1,
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
                              child:Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0,left:40),
                                        child: Image.asset('images/registered.png',width: 35,height: 50,),
                                      ),
                                      Text('Registered Users :  $userReg',
                                          style: GoogleFonts.aboreto(
                                              textStyle: const TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.bold))),

                                    ],
                                  ),
                                ],
                              ),
                            ), //SizedBox
                          ),

                          //Card
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0,left:10,bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.89,
                            height: MediaQuery.of(context).size.height*0.23,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0), // Top left corner
                                topRight: Radius.circular(5.0), // Top right corner
                                bottomRight:
                                Radius.circular(5.0), // Bottom right corner
                                bottomLeft: Radius.circular(5.0), // Bottom left corner
                              ),
                            ),
                            child: SfCartesianChart(
                              backgroundColor: const Color(0xFF5A9DED),
                              title: ChartTitle(text: 'COORDINATOR SUBSCRIBERS',textStyle: const TextStyle(fontSize: 12,color: Colors.white)),
                              // legend: Legend(isVisible: true),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries>[
                                LineSeries<SalesData, String>(
                                  dataSource: graphDataCoord,
                                  xValueMapper: (SalesData sales, _) => sales.month,
                                  yValueMapper: (SalesData sales, _) => sales.number,
                                  name: 'Count',
                                  markerSettings: const MarkerSettings(isVisible: true),
                                ),
                              ],
                              primaryXAxis: CategoryAxis(
                                axisLine: const AxisLine(color: Colors.white),
                                labelStyle: const TextStyle(color: Colors.white),
                                majorTickLines: const MajorTickLines(color: Colors.white),
                                majorGridLines: const MajorGridLines(color: Colors.white),
                              ),
                              primaryYAxis: NumericAxis(
                                axisLine: const AxisLine(color: Colors.white),
                                labelStyle: const TextStyle(color: Colors.white),
                                majorTickLines: const MajorTickLines(color: Colors.white),
                                majorGridLines: const MajorGridLines(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SubscriberAgentPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/user (2).png',
                                      height: 30,
                                    ),
                                    // const SizedBox(height: 10),
                                    // Adjust the space between icon and text
                                    Text(
                                      'SUBSCRIPTION',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReceiptPageData(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/agent.png',
                                      height: 30,
                                    ),
                                    // Adjust the space between icon and text
                                    Text(
                                      'RECEIPT',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),

                          // const SizedBox(
                          //   width: 1,
                          // ),



                          //Card
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReportPageView(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/user (2).png',
                                      height: 30,
                                    ),
                                    // const SizedBox(height: 10),
                                    // Adjust the space between icon and text
                                    Text(
                                      'REPORT',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PageViewCancel(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                    (Route<dynamic> route) =>
                                false, // Removes all routes in the stack
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
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
                                width: MediaQuery.of(context).size.width *
                                    0.43,
                                height: MediaQuery.of(context).size.height *
                                    0.10,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'images/cancel.png',
                                      height: 30,
                                    ),
                                    // const SizedBox(height: 10),
                                    // Adjust the space between icon and text
                                    Text(
                                      'CANCEL',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ), //SizedBox
                            ),
                          ),

                          // const SizedBox(
                          //   width: 1,
                          // ),



                          //Card
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0, left: 5,right:5),
                    //   child: Row(
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                 const SubscriberPage()),
                    //                 (Route<dynamic> route) =>
                    //             false, // Removes all routes in the stack
                    //           );
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 5),
                    //                 Image.asset(
                    //                   'images/add-user.png',
                    //                   height: 40,
                    //                 ),
                    //                 const SizedBox(height: 7),
                    //                 // Adjust the space between icon and text
                    //                 Text(
                    //                   'Subscriber',
                    //                   style: GoogleFonts.roboto(
                    //                       textStyle: const TextStyle(
                    //                           fontSize: 13)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //
                    //
                    //       GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(context, MaterialPageRoute(builder: (context){return ReceiptForm();}));
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     ReceiptForm(firstname: widget.firstname,
                    //                       id: widget.id,
                    //                       isAdmin: widget.isAdmin,)),
                    //                 (Route<dynamic> route) =>
                    //             false, // Removes all routes in the stack
                    //           );
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 10),
                    //                 Image.asset(
                    //                   'images/receipt.png',
                    //                   height: 40,
                    //                 ),
                    //                 const SizedBox(height: 3),
                    //                 // Adjust the space between icon and text
                    //                 Text(
                    //                   'Receipt',
                    //                   style: GoogleFonts.roboto(
                    //                       textStyle: const TextStyle(
                    //                           fontSize: 13)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //                 return  CoordinatorUserView(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin,);
                    //               }));
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height:10),
                    //                 Image.asset(
                    //                   'images/reload1.png',
                    //                   height: 35,
                    //                 ),
                    //                 // Adjust the space between icon and text
                    //                 Padding(
                    //                   padding:
                    //                   const EdgeInsets.only(left: 21.0),
                    //                   child: Text(
                    //                     'User Details Updation',
                    //                     style: GoogleFonts.roboto(
                    //                         textStyle: const TextStyle(
                    //                             fontSize: 12)),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //       //Card
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 5,right:2),
                    //   child: Row(
                    //     children: [
                    //       // GestureDetector(
                    //       //   onTap: () {
                    //       //     Navigator.pushAndRemoveUntil(
                    //       //       context,
                    //       //       MaterialPageRoute(
                    //       //           builder: (context) =>  const Renweal()),
                    //       //           (Route<dynamic> route) =>
                    //       //       false, // Removes all routes in the stack
                    //       //     );
                    //       //   },
                    //       //   child: Card(
                    //       //     color: HexColor('#EEF5FF'),
                    //       //     child: SizedBox(
                    //       //       width: MediaQuery.of(context).size.width *
                    //       //           0.28,
                    //       //       height: MediaQuery.of(context).size.height *
                    //       //           0.1,
                    //       //       child: Column(
                    //       //         children: [
                    //       //           const SizedBox(height: 10),
                    //       //           Image.asset(
                    //       //             'images/update.png',
                    //       //             height: 40,
                    //       //           ),
                    //       //           // Adjust the space between icon and text
                    //       //           Text(
                    //       //             'Renewal',
                    //       //             style: GoogleFonts.roboto(
                    //       //                 textStyle: const TextStyle(
                    //       //                     fontSize: 13)),
                    //       //           ),
                    //       //         ],
                    //       //       ),
                    //       //     ), //SizedBox
                    //       //   ),
                    //       // ),
                    //
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //                 return  ViewReceiptPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin,);
                    //               }));
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 10),
                    //                 Image.asset(
                    //                   'images/receipt21.png',
                    //                   height:
                    //                   40, // Adjust the height to fit within the CircleAvatar
                    //                   // Maintain aspect ratio while covering the circle
                    //                 ),
                    //                 const SizedBox(height: 2),
                    //                 // Adjust the space between icon and text
                    //                 Text(
                    //                   'Receipt view',
                    //                   style: GoogleFonts.roboto(
                    //                       textStyle: const TextStyle(
                    //                           fontSize: 13)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //                 return  IndiviualReport(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin,);
                    //               }));
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height:10),
                    //                 Image.asset(
                    //                   'images/report11.png',
                    //                   height:
                    //                   35, // Adjust the height to fit within the CircleAvatar
                    //                   // Maintain aspect ratio while covering the circle
                    //                 ),
                    //                 const SizedBox(height: 9),
                    //                 // Adjust the space between icon and text
                    //                 Text(
                    //                   'Subscriber Report',
                    //                   style: GoogleFonts.roboto(
                    //                       textStyle: const TextStyle(
                    //                           fontSize: 12)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 5,right:2),
                    //   child: Row(
                    //     children: [
                    //       // GestureDetector(
                    //       //   onTap: () {
                    //       //     // Navigator.push(context, MaterialPageRoute(builder: (context){return Renweal();}));
                    //       //     Navigator.pushAndRemoveUntil(
                    //       //       context,
                    //       //       MaterialPageRoute(
                    //       //           builder: (context) => SubCoord(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                    //       //           (Route<dynamic> route) =>
                    //       //       false, // Removes all routes in the stack
                    //       //     );
                    //       //   },
                    //       //   child: Card(
                    //       //     color: HexColor('#EEF5FF'),
                    //       //     child: SizedBox(
                    //       //       width: MediaQuery.of(context).size.width *
                    //       //           0.28,
                    //       //       height: MediaQuery.of(context).size.height *
                    //       //           0.1,
                    //       //       child: Column(
                    //       //         children: [
                    //       //           const SizedBox(height: 10),
                    //       //           Image.asset(
                    //       //             'images/useradmin.png',
                    //       //             height: 40,
                    //       //           ),
                    //       //           // Adjust the space between icon and text
                    //       //           Text(
                    //       //             'View Subscribers',
                    //       //             overflow: TextOverflow.ellipsis,
                    //       //             style: GoogleFonts.roboto(
                    //       //                 textStyle: const TextStyle(
                    //       //                     fontSize: 12)),
                    //       //           ),
                    //       //         ],
                    //       //       ),
                    //       //     ), //SizedBox
                    //       //   ),
                    //       // ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(context, MaterialPageRoute(builder: (context){return Renweal();}));
                    //           Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>  AgentAmountReport(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin,)),
                    //                 (Route<dynamic> route) =>
                    //             false, // Removes all routes in the stack
                    //           );
                    //         },
                    //         child: Card(
                    //           color: HexColor('#EEF5FF'),
                    //           child: SizedBox(
                    //             width: MediaQuery.of(context).size.width *
                    //                 0.28,
                    //             height: MediaQuery.of(context).size.height *
                    //                 0.1,
                    //             child: Column(
                    //               children: [
                    //                 const SizedBox(height: 7),
                    //                 Image.asset(
                    //                   'images/userreport.png',
                    //                   height: 40,
                    //                 ),
                    //                 // Adjust the space between icon and text
                    //                 Text(
                    //                   'My  Report',
                    //                   style: GoogleFonts.roboto(
                    //                       textStyle: const TextStyle(
                    //                           fontSize: 13)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ), //SizedBox
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                  ],
                ),

              ),
            ),

            // Positioned(
            //   top:535,
            //   left:10,
            //   child: widget.isAdmin
            //       ?Container(
            //     width: MediaQuery.of(context).size.width*0.95,
            //     height: MediaQuery.of(context).size.height*0.25,
            //     decoration: const BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(5.0), // Top left corner
            //         topRight: Radius.circular(5.0), // Top right corner
            //         bottomRight:
            //         Radius.circular(5.0), // Bottom right corner
            //         bottomLeft: Radius.circular(5.0), // Bottom left corner
            //       ),
            //     ),
            //     child: SfCartesianChart(
            //       title: ChartTitle(text: 'Subscriber Registration',textStyle: const TextStyle(fontSize: 10)),
            //       // legend: Legend(isVisible: true),
            //       tooltipBehavior: TooltipBehavior(enable: true),
            //       series: <ChartSeries>[
            //         LineSeries<SalesData, String>(
            //           dataSource: graphData,
            //           xValueMapper: (SalesData sales, _) => sales.month,
            //           yValueMapper: (SalesData sales, _) => sales.number,
            //           name: 'Count',
            //           markerSettings: const MarkerSettings(isVisible: true),
            //         ),
            //       ],
            //       primaryXAxis: CategoryAxis(),
            //       primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number')),
            //     ),
            //   ):
            //   Container(
            //     width: MediaQuery.of(context).size.width*0.95,
            //     height: MediaQuery.of(context).size.height*0.26,
            //     decoration: const BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(5.0), // Top left corner
            //         topRight: Radius.circular(5.0), // Top right corner
            //         bottomRight:
            //         Radius.circular(5.0), // Bottom right corner
            //         bottomLeft: Radius.circular(5.0), // Bottom left corner
            //       ),
            //     ),
            //     child: SfCartesianChart(
            //       title: ChartTitle(text: 'Coordinators Subscribers',textStyle: const TextStyle(fontSize: 12)),
            //       // legend: Legend(isVisible: true),
            //       tooltipBehavior: TooltipBehavior(enable: true),
            //       series: <ChartSeries>[
            //         LineSeries<SalesData, String>(
            //           dataSource: graphDataCoord,
            //           xValueMapper: (SalesData sales, _) => sales.month,
            //           yValueMapper: (SalesData sales, _) => sales.number,
            //           name: 'Count',
            //           markerSettings: const MarkerSettings(isVisible: true),
            //         ),
            //       ],
            //       primaryXAxis: CategoryAxis(),
            //       primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number')),
            //     ),
            //   ),
            // ),



          ],
        ),
      ):


      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
                top:0,
                left: 0,
                right: 0,
                child: buildAppbarWidget(context)),
            Positioned(
              top:150,
              left: 10,
              right: 10,
              child: LayoutBuilder(
                  builder: (context, constraints) {
                  return Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height*0.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0), // Top left corner
                        topRight: Radius.circular(5.0), // Top right corner
                        bottomRight:
                        Radius.circular(5.0), // Bottom right corner
                        bottomLeft: Radius.circular(5.0), // Bottom left corner
                      ),
                    ),
                    child:   widget.isAdmin
                        ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10,right:5),
                          child: Row(
                            children: [
                              Card(
                                color: Colors.white,
                                child: Container(
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
                                  width: MediaQuery.of(context).size.width *
                                      0.86,
                                  height: MediaQuery.of(context).size.height *
                                      0.1,
                                  child:Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:10.0,left:45),
                                            child: Image.asset('images/registered.png',width: 60,height: 60,),
                                          ),
                                          Text('REGISTERED USERS :  $adminUserReg',
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13,))),

                                        ],
                                      ),
                                    ],
                                  ),
                                ), //SizedBox
                              ),

                              //Card
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:5.0,left:10,bottom: 5),
                          child: Row(
                            children: [
                             Container(
                                width: MediaQuery.of(context).size.width*0.89,
                                height: MediaQuery.of(context).size.height*0.23,
                                decoration:  BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5.0), // Top left corner
                                    topRight: Radius.circular(5.0), // Top right corner
                                    bottomRight:
                                    Radius.circular(5.0), // Bottom right corner
                                    bottomLeft: Radius.circular(5.0), // Bottom left corner
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: SfCartesianChart(
                                  backgroundColor: const Color(0xFF5A9DED),
                                  title: ChartTitle(text: 'SUBSCRIBER REGISTERATION',textStyle: const TextStyle(fontSize: 10,color:Colors.white,fontWeight: FontWeight.bold)),
                                  // legend: Legend(isVisible: true),
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries>[
                                    LineSeries<SalesData, String>(
                                      dataSource: graphData,
                                      xValueMapper: (SalesData sales, _) => sales.month,
                                      yValueMapper: (SalesData sales, _) => sales.number,
                                      name: 'Count',
                                      markerSettings: const MarkerSettings(isVisible: true),
                                    ),
                                  ],
                                  primaryXAxis: CategoryAxis(
                                    axisLine: const AxisLine(color: Colors.white),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    majorTickLines: const MajorTickLines(color: Colors.white),
                                    majorGridLines: const MajorGridLines(color: Colors.white),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(color: Colors.white),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    majorTickLines: const MajorTickLines(color: Colors.white),
                                    majorGridLines: const MajorGridLines(color: Colors.white),
                                  ),
                                  // primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number')),
                                ),
                              )

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                         Region(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                        (Route<dynamic> route) =>
                                    false, // Removes all routes in the stack
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Image.asset(
                                          'images/locations.png',
                                          height: 40,
                                        ),
                                        // Adjust the space between icon and text
                                        Text(
                                          'REGION',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ), //SizedBox
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Accounts(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                        (Route<dynamic> route) =>
                                    false, // Removes all routes in the stack
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Image.asset(
                                          'images/accounting (2).png',
                                          height: 30,
                                        ),
                                        const SizedBox(height: 10),
                                        // Adjust the space between icon and text
                                        Text(
                                          'ACCOUNTS',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ), //SizedBox
                                ),
                              ),
                              // const SizedBox(
                              //   width: 1,
                              // ),



                              //Card
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7,right:5),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CoordinatorDetailPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                        (Route<dynamic> route) =>
                                    false, // Removes all routes in the stack
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Image.asset(
                                          'images/agent.png',
                                          height: 40,
                                        ),
                                        // Adjust the space between icon and text
                                        Text(
                                          'COORDINATORS',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ), //SizedBox
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubscriberDetailPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                        (Route<dynamic> route) =>
                                    false, // Removes all routes in the stack
                                  );
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Container(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Image.asset(
                                          'images/user (2).png',
                                          height: 30,
                                        ),
                                        const SizedBox(height: 10),
                                        // Adjust the space between icon and text
                                        Text(
                                          'SUBSCRIPTION',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ), //SizedBox
                                ),
                              ),
                              // const SizedBox(
                              //   width: 1,
                              // ),



                              //Card
                            ],
                          ),
                        ),

                      ],
                    )

                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 7,right:5),
                          child: Row(
                            children: [
                              Card(
                                color: HexColor('#EEF5FF'),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.87,
                                  height: MediaQuery.of(context).size.height *
                                      0.1,
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
                                  child:Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:10.0,left:40),
                                            child: Image.asset('images/registered.png',width: 60,height: 60,),
                                          ),
                                          Text('Registered Users :  $userReg',
                                              style: GoogleFonts.aboreto(
                                                  textStyle: const TextStyle(
                                                      fontSize: 13, fontWeight: FontWeight.bold))),

                                        ],
                                      ),
                                    ],
                                  ),
                                ), //SizedBox
                              ),

                              //Card
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:5.0,left:10,bottom: 5),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.89,
                                height: MediaQuery.of(context).size.height*0.23,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0), // Top left corner
                                    topRight: Radius.circular(5.0), // Top right corner
                                    bottomRight:
                                    Radius.circular(5.0), // Bottom right corner
                                    bottomLeft: Radius.circular(5.0), // Bottom left corner
                                  ),
                                ),
                                child: SfCartesianChart(
                                  backgroundColor: const Color(0xFF5A9DED),
                                  title: ChartTitle(text: 'COORDINATOR SUBSCRIBERS',textStyle: const TextStyle(fontSize: 12,color: Colors.white)),
                                  // legend: Legend(isVisible: true),
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <ChartSeries>[
                                    LineSeries<SalesData, String>(
                                      dataSource: graphDataCoord,
                                      xValueMapper: (SalesData sales, _) => sales.month,
                                      yValueMapper: (SalesData sales, _) => sales.number,
                                      name: 'Count',
                                      markerSettings: const MarkerSettings(isVisible: true),
                                    ),
                                  ],
                                  primaryXAxis: CategoryAxis(
                                    axisLine: const AxisLine(color: Colors.white),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    majorTickLines: const MajorTickLines(color: Colors.white),
                                    majorGridLines: const MajorGridLines(color: Colors.white),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(color: Colors.white),
                                    labelStyle: const TextStyle(color: Colors.white),
                                    majorTickLines: const MajorTickLines(color: Colors.white),
                                    majorGridLines: const MajorGridLines(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SubscriberAgentPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                          (Route<dynamic> route) =>
                                      false, // Removes all routes in the stack
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: Container(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      height: MediaQuery.of(context).size.height *
                                          0.15,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 30),
                                          Image.asset(
                                            'images/user (2).png',
                                            height: 30,
                                          ),
                                          const SizedBox(height: 10),
                                          // Adjust the space between icon and text
                                          Text(
                                            'SUBSCRIPTION',
                                            style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    fontSize: 11)),
                                          ),
                                        ],
                                      ),
                                    ), //SizedBox
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context){return SubscriberPage();}));
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReceiptPageData(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                                          (Route<dynamic> route) =>
                                      false, // Removes all routes in the stack
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: Container(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      height: MediaQuery.of(context).size.height *
                                          0.15,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 30),
                                          Image.asset(
                                            'images/agent.png',
                                            height: 40,
                                          ),
                                          // Adjust the space between icon and text
                                          Text(
                                            'RECEIPT',
                                            style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    fontSize: 11)),
                                          ),
                                        ],
                                      ),
                                    ), //SizedBox
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 7,right:5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReportPageView(
                                          firstname: widget.firstname,
                                          id: widget.id,
                                          isAdmin: widget.isAdmin,
                                        ),
                                      ),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/user (2).png',
                                            height: 30,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'REPORT',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16), // Space between cards
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PageViewCancel(
                                          firstname: widget.firstname,
                                          id: widget.id,
                                          isAdmin: widget.isAdmin,
                                        ),
                                      ),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/cancel.png',
                                            height: 30,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'CANCEL',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),

                  );
                }
              ),
            ),




          ],
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade200,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          if (widget.isAdmin == true) ...[
            BottomNavigationBarItem(
              icon:  Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor('#3465D9'), // Set your desired color
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white, // Set your desired color
                  ),
                ),
              ),
              label: 'Coordinator',
            ),
          ],
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: HexColor('#3465D9'),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }



  Widget buildAppbarWidget(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: screenSize.width,
      height: screenSize.height * 0.22 + statusBarHeight,
      decoration: BoxDecoration(
        color: HexColor('#3465D9'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Welcome Back',
                      style: GoogleFonts.aboreto(
                        textStyle: TextStyle(
                          fontSize: screenSize.width * 0.06,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (!widget.isAdmin)
                        IconButton(
                          icon: const Icon(Icons.notifications_on, color: Colors.white),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationAgent(firstname: widget.firstname, isAdmin: widget.isAdmin, id: widget.id)),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          logoutUser();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                widget.firstname,
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    prefs.remove('password');
    // bool arePrefsCleared = prefs.getKeys().isEmpty;
  }

  Future fetchcountofusers(String? id) async {

    print("zone_name................${widget.id}");
    print("fetchdivision.............................");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/selected_userscount/'),
        body: {
          'id': id,
        });
    print("fetchcount.............................");
    print(response.body);
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Access data_count and user_count directly
      var dataCount;
      var userCount;
      dataCount = responseData['data_count'];
      userCount = responseData['user_count'];


      setState(() {
        userReg=dataCount;
        adminUserReg=userCount;
      });
      print('Data Count: $dataCount');

      print('User Count: $userCount');

    } else {
      // Handle errors
      print('Failed to load data: ${response.statusCode}');
    }
  }


  Future<void> graphdata() async {
    // Make your HTTP request here
    await getApiurl();
    var response = await http.post(Uri.parse('$apiUrl/plot_graph/'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print("responseData $responseData");
      List<dynamic> result = responseData['result'];
      print("result $result");
      List<SalesData> data = result.map((item) => SalesData(item['month'], item['number'].toDouble())).toList();
      setState(() {
        graphData = data;
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> graphdataCoordinator(coordid) async {
    // Make your HTTP request here
    await getApiurl();
    var response = await http.post(Uri.parse('$apiUrl/plot_graph_coordinator/'),body: {
      'id':coordid
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print("responseData $responseData");
      List<dynamic> result = responseData['result'];
      print("result $result");
      List<SalesData> data = result.map((item) => SalesData(item['month'], item['number'].toDouble())).toList();
      setState(() {
        graphDataCoord = data;
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

}

