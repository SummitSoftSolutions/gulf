import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'coordinatorlogin.dart';



class ReportView extends StatefulWidget {
  // const ReportView({super.key, required String firstname, required String id, required bool isAdmin});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  void initState()
  {
    super.initState();
    getuser();
  }
  String firstname='';
  var id;
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#3465D9'),
            automaticallyImplyLeading: true,leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => CoordinatorPage(firstname: firstname, id: id,isAdmin:isAdmin)),
                    (Route<dynamic> route) => false, // Removes all routes in the stack
              );

            },
          ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                // Tab(icon: Icon(Icons.group)),

              ],
            ),
            title:  const Padding(
              padding: EdgeInsets.only(left:55.0),
              child: Text('Report view'),
            ),
          ),
          body:  const TabBarView(
            children: [
              // IndiviualReport(),
              // IndiviualReport(),
            ],
          ),

        ),
      ),
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
