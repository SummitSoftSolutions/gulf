import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/agent/usermode.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../superadmin/SubcriptionAgentPage.dart';
import '../superadmin/accountmodel.dart';
import 'cashtomodel.dart';

class ReceiptForm extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
   const ReceiptForm({super.key, required this.firstname, required this.id, required this.isAdmin});

  @override
  State<ReceiptForm> createState() => _ReceiptFormState();
}

class _ReceiptFormState extends State<ReceiptForm> {

  String? selectedaccountval;
  String selectedUserID = '';
  // Model data
  var name;
  var date;
  var amount_data;
  var coordinatorname;
  String dateinputs = '';

  var account_val;
  List<AccountList> accounts = [];
  TextEditingController amount = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinput1 = TextEditingController();
  TextEditingController receiptno = TextEditingController();
  TextEditingController refcheckNumber = TextEditingController();
  TextEditingController narration = TextEditingController();
  TextEditingController dateinput2 = TextEditingController();
  String firstname='';
  var id;
  String itemSelected = '';
  String balance = '0.000';
  var apiUrl;
  bool isAdmin = false;
  var user_val;
  List<UserListData> users = [];
  String?  selecteduser;
  var maxData=[];
  bool isloading = false;
  String? maxrecept;

  var cashto_val;
  List<CashList> cashTo = [];
  String?  selectedcashto;
  bool isVisible = false;
  bool isDate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> payementmode = [
    'Cheque',
    'Deposit',
    'Direct Transfer',
  ];
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateinputs = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    loadInitialData();
  }


  Future<void> loadInitialData()
  async {
    await getuser();
    await selectsubcriber();
    await selecttoreciept();
    await fetchreceiptmax();

}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SubscriberAgentPage(firstname: firstname, id: id,isAdmin:isAdmin)),
              (Route<dynamic> route) => false, // Removes all routes in the stack
        );
        return false; // Returning false prevents the default back navigation
      },
      child: Scaffold(
        backgroundColor:Colors.grey.shade100,
          appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
            padding: EdgeInsets.only(left:50.0),
            child: Text('Reciept Form',style: appbarTextColor,),
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

          body: Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 10),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white,),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: isVisible
                            ? MediaQuery.of(context).size.height // Increase the height when the content is visible
                            : MediaQuery.of(context).size.height * 0.67,
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //
                        //     width: 1.0,
                        //   ),
                        // ),
                        child: SingleChildScrollView(
                          child:isloading? const Center(child: Padding(
                            padding: EdgeInsets.only(top:100.0),
                            child: CircularProgressIndicator(),
                          )): Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height:30,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width:10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.40,
                                      height: MediaQuery.of(context).size.height * 0.05,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black, // Border color
                                          ),
                                          borderRadius: BorderRadius.circular(5), // Optional: Rounded corners
                                        ),
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                              dateinputs
                                          ),
                                          IconButton(onPressed: () async {
                                            DateTime? pickedDate1 = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 365 * 10)),
                                            );
                                            // dateinput.text = "gdfhshd";


                                            if (pickedDate1 != null) {
                                              print(
                                                  pickedDate1); // Picked Date output format => 2021-03-10 00:00:00.000
                                              String formattedDate1 = DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate1);
                                              print(
                                                  "d.....$formattedDate1"); // Formatted date output using intl package => 2021-03-16

                                              setState(() {
                                                dateinputs = formattedDate1;
                                              });
                                              print("date....${dateinput.text}");
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },  icon:Icon(Icons.calendar_today))


                                        ],
                                      )
                                    ),
                                    const SizedBox(
                                      width:10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.418,
                                      height: MediaQuery.of(context).size.height * 0.05,
                                      child: TextField(
                                        controller: receiptno,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left:12.0),
                                      child: Text('From'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.84,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: DropdownSearch<String>(
                                    selectedItem: selecteduser,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    items: users.map((UserListData data) {
                                      return data.name; // Assuming 'Name' holds the strings you want to display
                                    }).toList(),
                                    onChanged: (String? value) { // Change the parameter to accept nullable string
                                      setState(() {
                                        selecteduser = value ?? ''; // Ensure selecteduser is not null
                                      });
                                      if (value != null) {
                                        // Find the UserListData instance corresponding to the selected name
                                        UserListData? selectedUserData = users.firstWhere(
                                              (data) => data.name == value,
                                        );

                                        // Pass the ID to your function if available
                                        print("selectedUserData ${selectedUserData.accountid}");
                                        selectedUserID = selectedUserData.accountid.toString();
                                        fetchbalance(selectedUserData.accountid);

                                      }
                                    },

                                  ),
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left:12.0),
                                      child: Text('Cash To'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.84,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: DropdownSearch<String>(
                                    selectedItem: selectedcashto,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    items: cashTo.map((CashList data) {
                                      return data.name; // Assuming 'Name' holds the strings you want to display
                                    }).toList(),
                                    onChanged: (String? value) { // Change the parameter to accept nullable string
                                      setState(() {
                                        selectedcashto = value ?? '';
                                        if(selectedcashto=='Bank') {
                                          isVisible = !isVisible;
                                        }
                                        else
                                        {
                                          isVisible=false;
                                        }
                                      });

                                    },

                                  ),
                                ),
                                Visibility(
                                  visible: isVisible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.84,
                                      height: MediaQuery.of(context).size.height * 0.300,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
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
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              height: MediaQuery.of(context).size.height * 0.06,

                                              child:  DropdownSearch<String>(
                                                items: payementmode,
                                                onChanged: (value) {
                                                  setState(() {

                                                    itemSelected = value.toString();
                                                    if(itemSelected=='Cheque')
                                                    {
                                                      isDate=true;// Assign only if the value is a String
                                                    }
                                                    else
                                                    {
                                                      isDate=false;
                                                    }

                                                  });
                                                },
                                                selectedItem: itemSelected,
                                              ),

                                            ),
                                          ),
                                          Visibility(
                                            visible: isDate,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                height: MediaQuery.of(context).size.height * 0.07,
                                                child: TextFormField(
                                                  controller: dateinput,
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
                                                        dateinput.text = formattedDate1;
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
                                                  child:  TextField(
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
                                  padding: const EdgeInsets.all(13),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the amount';
                                      }
                                      return null; // Return null for no validation error
                                    },
                                    controller: amount,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Amount',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: TextField(
                                    controller: narration,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Narration',
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:10.0),
                                      child: Text('Balance:  $balance',style: const TextStyle(fontSize: 20,color: Colors.black87),),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:10.0,top:10),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.05,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor('#3465D9'),
                                          ),
                                          child: const SizedBox(
                                            width: 250,
                                            child: Center(
                                              child: Text('ADD', style: TextStyle(color: Colors.white)),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState?.validate() ?? false) {
                                              await insert_recipt().then((value) async {
                                                if (value == "success") {
                                                  isloading= true;
                                                 await viewReceiptData();
                                                 Future.delayed(const Duration(microseconds: 500),(){
                                                   showDialog(
                                                     context: context,
                                                     builder: (BuildContext context) {
                                                       return AlertDialog(
                                                         backgroundColor: Colors.white,
                                                         content: SizedBox(
                                                           width: MediaQuery.of(context).size.width * 0.8,
                                                           height: MediaQuery.of(context).size.height * 0.12,
                                                           child: Table(
                                                             border: TableBorder.all(color: Colors.black),
                                                             defaultColumnWidth: const IntrinsicColumnWidth(),
                                                             children: [
                                                               TableRow(
                                                                 children: [
                                                                   const TableCell(
                                                                     verticalAlignment: TableCellVerticalAlignment.middle,
                                                                     child: Padding(
                                                                       padding: EdgeInsets.all(8.0),
                                                                       child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                     ),
                                                                   ),
                                                                   TableCell(
                                                                     verticalAlignment: TableCellVerticalAlignment.middle,
                                                                     child: Padding(
                                                                       padding: const EdgeInsets.all(8.0),
                                                                       child: Text('$name', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                               TableRow(
                                                                 children: [
                                                                   const TableCell(
                                                                     verticalAlignment: TableCellVerticalAlignment.middle,
                                                                     child: Padding(
                                                                       padding: EdgeInsets.all(8.0),
                                                                       child: Text('Coordinator Name'),
                                                                     ),
                                                                   ),
                                                                   TableCell(
                                                                     verticalAlignment: TableCellVerticalAlignment.middle,
                                                                     child: Padding(
                                                                       padding: const EdgeInsets.all(8.0),
                                                                       child: Text('$coordinatorname'),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                               TableRow(
                                                                 children: [
                                                                   const TableCell(
                                                                     verticalAlignment: TableCellVerticalAlignment.middle,
                                                                     child: Padding(
                                                                       padding: EdgeInsets.all(8.0),
                                                                       child: Text('Amount'),
                                                                     ),
                                                                   ),
                                                                   TableCell(
                                                                     verticalAlignment: TableCellVerticalAlignment.middle,
                                                                     child: Padding(
                                                                       padding: const EdgeInsets.all(8.0),
                                                                       child: Text('$amount_data'),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ],
                                                           ),
                                                         ),
                                                         actions: [
                                                           Row(
                                                             children: [
                                                               // Expanded(
                                                               //   child: TextButton(
                                                               //     style: TextButton.styleFrom(
                                                               //       backgroundColor: Colors.white,
                                                               //     ),
                                                               //     onPressed: () {},
                                                               //     child: const Text(
                                                               //       "Edit",
                                                               //       style: TextStyle(
                                                               //         color: Colors.black,
                                                               //         fontSize: 20,
                                                               //         fontWeight: FontWeight.w300,
                                                               //       ),
                                                               //     ),
                                                               //   ),
                                                               // ),
                                                               // SizedBox(width: 20),
                                                               Expanded(
                                                                 child: TextButton(
                                                                   style: TextButton.styleFrom(
                                                                     backgroundColor: HexColor('#3465D9'),
                                                                   ),
                                                                   onPressed: () {
                                                                     Navigator.push(
                                                                         context, MaterialPageRoute(builder: (context) {
                                                                       return  ReceiptForm(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin);
                                                                     }));
                                                                   },
                                                                   child: const Text(
                                                                     "OK",
                                                                     style: TextStyle(
                                                                       color: Colors.white,
                                                                       fontSize: 20,
                                                                       fontWeight: FontWeight.w300,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                             ],
                                                           ),
                                                         ],
                                                       );
                                                     },
                                                   );
                                                 });
                                              }
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) {
                                                  return  ReceiptForm(firstname:widget.firstname, id:widget.id, isAdmin:widget.isAdmin);
                                                }));
                                              });
                                              // After showing the dialog, navigate to the next screen
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(builder: (context) {
                                              //     return ReceiptForm(
                                              //       firstname: widget.firstname,
                                              //       id: widget.id,
                                              //       isAdmin: widget.isAdmin,
                                              //     );
                                              //   }),
                                              // );
                                            }
                                          },
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
                    ),
                  ),






                ],
              ),
            ),
          )
      ),
    );
  }
  void alertFunction()
  {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Area Creation'),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Column(
                      children: [
                        const Text('Please Select Country and Zone'),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the division';
                              }
                              return null; // Return null for no validation error
                            },
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
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#3465D9'),
                ),
                child: const Text('ADD', style: addButtonTextColor),
                onPressed: () {
                },
              ),
            ],

          );
        });
  }
  Future selectsubcriber() async {
    print("selectsubcriber.............................");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/select_subscribers/'));

    if (response.statusCode == 200) {
      setState(() {
        user_val = jsonDecode(response.body);
      });

      print("user_val: $user_val");

      users = (user_val).map<UserListData>((model) {
        return UserListData.fromJson(model);
      }).toList();
      print("users................$users");
      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch states");
    }
  }

  Future selecttoreciept() async {
    print("selectto.............................");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/selected_toreciept/'));
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        cashto_val = jsonDecode(response.body);
      });

      print("cashto_val: $cashto_val");



      cashTo = (cashto_val).map<CashList>((model) {
        return CashList.fromJson(model);
      }).toList();

      print("cashTo................$cashTo");
      // You can parse and update state data here if needed
    } else {
      // Handle API error
      print("Failed to fetch cashTo");
    }
  }
  Future fetchbalance(accountID) async {

    print("accountID................${accountID}");
    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/select_customerbalance/'),
        body: {
          'accountID': accountID.toString(),
        });
    print("dfdsf $response.body");
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      var balanceList = decodedResponse as List<dynamic>;
      print("decodedResponse $decodedResponse");
      if(balanceList.isNotEmpty) {
        var balanceAmount = balanceList[0]['SUM(`Debit`)-SUM(`Credit`)'];
        print("balanceAmount $balanceAmount");
        setState(() {
          balance=balanceAmount;
        });
      }
    }
  }
  Future insert_recipt() async {
    var data;
    print("receipt.............................");

var status;
    await getApiurl();
    print("itemSelected $itemSelected");// Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/insert_receipt/'),
        body: {
          'amount': amount.text,
          'refcheckNumber':refcheckNumber.text,
          'narration':narration.text,
          'dateinput':dateinput.text,
          'dateinput1':dateinput1.text,
          'payementmode':itemSelected,
          'selectedcashto':selectedcashto,
          'selecteduser':selecteduser,
          'selectedUserData':selectedUserID,
          'receiptno':receiptno.text,
          'id':id.toString(),
        });

    if (response.statusCode == 200) {
      setState(() {
        data = response.body.trim(); // No
        if (data.contains("success")) {
          status="success";
          // Check if data is "success"
          print("data........... $data");
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
      print("Failed to insert receipt");
    }
    return status;
  }


  Future fetchreceiptmax() async {


    await getApiurl(); // Assuming this function sets the API URL

    var response = await http.post(Uri.parse('$apiUrl/selected_max_recept/'),);
    print("dfdsf ${response.body}");
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      var maxData = decodedResponse as List<dynamic>;
      print("decodedResponse $decodedResponse");


        if (maxData.isNotEmpty) {
          var maxDataVal = maxData[0]['MAX(`id`)'];
          print("maxDataVal type: ${maxDataVal.runtimeType}, value: $maxDataVal");

          int newVal = 1;
          int parseVal = int.tryParse(maxDataVal?.toString() ?? '') ?? 0;
          newVal = parseVal + 1;

          print("parseVal type: ${parseVal.runtimeType}, value: $parseVal");

          setState(() {
            receiptno.text = newVal.toString();
          });

          print("newVal type: ${newVal.runtimeType}, value: $newVal");
        }





    }
  }

  Future viewReceiptData() async {
    var data;
    print("viewusers.............................$selecteduser");

    await getApiurl(); // Assuming this function sets the API URL
    var response = await http.post(Uri.parse('$apiUrl/view_last_insert_receipt/'));
    var result = json.decode(response.body);
    print("result $result");
    print('result_data type: ${result.runtimeType}');
    if(result.isNotEmpty)
    {
      name=result[0]['accountname'];
      coordinatorname = result[0]['coordinatorid_id'];
      amount_data = result[0]['amount'];
      print("name.text ${result[0]['accountname']}");
      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
          data = response.body.trim(); // No
        });

        print("data: $data");


        // You can parse and update state data here if needed
      } else {
        // Handle API error
        print("Failed to fetch states");
      }

    }

  }

  Future<void> getuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    firstname = prefs.getString('firstname')!;
    print('...........firstname.....$firstname');
    id = prefs.getString('id');
    print('...........id.....$id');
    // await fetchcountofusers(id);
    return;
  }
}

