import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../agent/coordinatorlogin.dart';
import '../constants.dart';

class viewIndiviualAdminReceipt extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  final int data_val;

   const viewIndiviualAdminReceipt({super.key, required this.firstname, required this.id, required this.isAdmin, required this.data_val});



  @override
  State<viewIndiviualAdminReceipt> createState() => _viewIndiviualAdminReceiptState();
}

class _viewIndiviualAdminReceiptState extends State<viewIndiviualAdminReceipt> {
  TextEditingController receiptidCntr = TextEditingController();
  TextEditingController amountCntr = TextEditingController();
  TextEditingController dateCntr = TextEditingController();
  TextEditingController transcationidCntr =  TextEditingController();
  TextEditingController coordinatorid_idCntr =  TextEditingController();
  TextEditingController accountnameCntr =  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();










  var apiUrl;

  void initState()
  {
    super.initState();
    getApiurl();
    viewindiviualRecieptdata(widget.data_val);



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
            MaterialPageRoute(builder: (context) => CoordinatorPage(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                          controller: receiptidCntr,
                          decoration: InputDecoration(
                            labelText: 'Receipt Number',
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
                          controller: transcationidCntr,
                          decoration: InputDecoration(
                            labelText: 'Transcation ID',
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
                    readOnly: true,
                    enabled: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: accountnameCntr,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Name',
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
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: coordinatorid_idCntr,
                    decoration: InputDecoration(
                      labelText: 'Coordinator Name',
                      hintText: 'Coordinator Name',
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
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Amount';
                      }
                      return null; // Return null for no validation error
                    },
                    controller: amountCntr,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Amount',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 110,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#3465D9')
                        ),
                        child: const Text('UPDATE',style: addButtonTextColor),
                        onPressed: () async {
                          await updateAdminRecipt(widget.data_val);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return  viewIndiviualAdminReceipt(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin, data_val: widget.data_val);
                          }));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  Future viewindiviualRecieptdata(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/viewAdminRecData/'),
      body: {
        'id': value.toString(),
      },
    );

    if (response.statusCode == 200) {
      var result_data;
      result_data = json.decode(response.body);
      print('result_data type: ${result_data.runtimeType}');
      print('result_data content: $result_data');

      if (result_data is List && result_data.isNotEmpty) {
        var detail = result_data[0];
        print("detail $detail");
        receiptidCntr.text = detail['receiptid'].toString();
        amountCntr.text = detail['amount'].toString();
        transcationidCntr.text = detail['transcationid'];
        accountnameCntr.text = detail['accountname'];
        dateCntr.text = detail['date'];
        coordinatorid_idCntr.text = detail['coordinatorid_id'].toString();
      }
    }
  }

  Future updateAdminRecipt(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/adminSubscriberUpdate/'),
      body: {
        'id': value.toString(),
        'amount':amountCntr.text,
        'transcationidCntr':transcationidCntr.text,
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
