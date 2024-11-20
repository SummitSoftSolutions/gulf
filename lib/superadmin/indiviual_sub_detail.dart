import 'dart:convert';

import 'package:gulf_suprabhaatham/superadmin/subscriber_detail_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class viewIndiviualsubscribers extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  final int val;

  const viewIndiviualsubscribers({super.key, required this.firstname, required this.id, required this.isAdmin, required this.val});



  @override
  State<viewIndiviualsubscribers> createState() => _viewIndiviualsubscribersState();
}

class _viewIndiviualsubscribersState extends State<viewIndiviualsubscribers> {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();










  var apiUrl;

  void initState()
  {
    super.initState();
    getApiurl();
    viewindiviualsubscriberdata(widget.val);



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
        title:  Padding(
          padding: const EdgeInsets.only(left:50.0),
          child: const Text('Detailed View',style:appbarTextColor),
        ),backgroundColor: HexColor('#3465D9'),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SubDetails(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
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
                          controller: regid,
                          readOnly: true,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Reg ID',
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
                          controller: subscribtionID,
                          decoration: InputDecoration(
                            labelText: 'Subscription ID',
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
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: TextFormField(
                    controller: mobileCntr,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      hintText: 'lname',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: whatsnoCntr,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          controller: startdateCntr,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
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
                          controller: countryid,
                          decoration: InputDecoration(
                            labelText: 'Country',
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
                      padding: const EdgeInsets.only(top: 10.0,right:3),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: zoneid,
                          decoration: InputDecoration(
                            labelText: 'Zone',
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
                          controller: divisionid,
                          decoration: InputDecoration(
                            labelText: 'Area',
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
                      padding: const EdgeInsets.only(top: 10.0,right:3),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: clusterid,
                          decoration: InputDecoration(
                            labelText: 'Cluster',
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
                      padding: const EdgeInsets.only(top: 10.0,right:3),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.44,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: subid,
                          decoration: InputDecoration(
                            labelText: 'Subscription',
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
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
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
                          await updateSubcriber(widget.val);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return  viewIndiviualsubscribers(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin, val:widget.val);
                          }));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('DELETE',style: addButtonTextColor),
                        onPressed: () async {
                          await deletesubscribers(widget.val);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return  SubDetails(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin);
                          }));
                        },
                      ),
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
  Future viewindiviualsubscriberdata(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/viewSubData/'),
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
        nameCntr.text = detail['name'];
        mobileCntr.text = detail['mobileno'];
        whatsnoCntr.text = detail['whatsno'];
        startdateCntr.text = detail['startdate'].toString();
        enddateCntr.text = detail['enddate'].toString();
        officetelCntr.text = detail['officetel'].toString();
        residencetelCntr.text = detail['residencetel'].toString();
        emailCntr.text = detail['email'].toString();
        postboxCntr.text = detail['postbox'].toString();
        flatno.text = detail['flatno'].toString();
        floor.text = detail['floor'].toString();
        address.text = detail['address'].toString();
        regid.text= detail['reg'];
        subscribtionID.text =detail['subscribtionID'].toString();
        countryid.text=detail['country'];
        zoneid.text=detail['zone'];
        divisionid.text =detail['division'];
        clusterid.text=detail['cluster'];
        givenamount.text=detail['givenamount'].toString();
        subid.text=detail['subid'].toString();
      }
    }
  }

  Future updateSubcriber(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/subscriberUpdate/'),
      body: {
        'id': value.toString(),
        'name':nameCntr.text,
        'mobileno':mobileCntr.text,
        'whatsno':whatsnoCntr.text,
        'email':emailCntr.text,
        'officetel':officetelCntr.text,
        'residencetel':residencetelCntr.text,
        'flatno':flatno.text,
        'floor':floor.text,
        'postbox':postboxCntr.text,
        'address':address.text,
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

  Future deletesubscribers(value) async {
    await getApiurl();
    var response = await http.post(
      Uri.parse('$apiUrl/subscriberDelete/'),
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
