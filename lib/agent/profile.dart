import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'coordinatorlogin.dart';

class ProfilePage extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;
  const ProfilePage({super.key, required  this.firstname, required this.isAdmin, required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isContainerVisible = false;
  Offset containerPosition = Offset.zero;
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController  confirmPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const borderSide = Radius.circular(10);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var apiUrl;
  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    return;
  }

  @override
  void initState()
  {
    super.initState();
    getApiurl();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(backgroundColor:HexColor('#3465D9'),title: const Padding(
        padding: EdgeInsets.only(top:10.0,left: 50),
        child: Text('Profile Page',style: appbarTextColor,),
      ),automaticallyImplyLeading: true,leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: appbArrowColor,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CoordinatorPage(firstname: widget.firstname, id: widget.id,isAdmin:widget.isAdmin)),
                (Route<dynamic> route) => false, // Removes all routes in the stack
          );

        },
      ),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child:GestureDetector(
                onTap: () {
                  // Implement the logic to replace the image when the icon is tapped
                  // This might include opening a file picker to select a new image
                  // and updating the 'backgroundImage' accordingly
                },
                child: Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: Column(
                    children: [
                      // CircleAvatar(
                      //   radius: 80,
                      //   backgroundImage: AssetImage('images/splashscreen.jpeg'),
                      // ),

                     Container(
                       width: MediaQuery.of(context).size.width * 0.9,
                       height: MediaQuery.of(context).size.height * 0.15,
                       decoration:   BoxDecoration(
                           color: HexColor('#3465D9'),
                         borderRadius: const BorderRadius.only(topRight:borderSide,topLeft: borderSide,bottomRight: borderSide,bottomLeft: borderSide)
                       ),
                       child:     Padding(
                         padding: const EdgeInsets.only(left:10.0,top:10),
                         child: Text(
                           widget.firstname,
                           style: GoogleFonts.aclonica(
                             textStyle: const TextStyle(
                               fontSize: 18,
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ),
                       ),

                     ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration:   const BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.only(topRight:borderSide,topLeft: borderSide,bottomRight: borderSide,bottomLeft: borderSide)
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Card(
                                  child: ExpansionTile(
                                    title: const Text(
                                      "Change Password",
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          title: Container(
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            height: MediaQuery.of(context).size.height * 0.4,
                                            child: Form(
                                              key: _formKey,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      obscureText: true,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Please enter your Current Password';
                                                        }
                                                        return null; // Return null for no validation error
                                                      },
                                                      controller: oldPassword,
                                                      decoration: InputDecoration(
                                                        labelText: 'Enter Current Password',
                                                        hintText: 'Oldpassword',
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        contentPadding: const EdgeInsets.symmetric(
                                                            horizontal: 16.0, vertical: 14.0),
                                                      ),

                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      obscureText: true,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Please enter your New  Password';
                                                        }
                                                        return null; // Return null for no validation error
                                                      },
                                                      controller: newPassword,
                                                      decoration: InputDecoration(
                                                        labelText: 'Enter New Password',
                                                        hintText: 'newPassword',
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        contentPadding: const EdgeInsets.symmetric(
                                                            horizontal: 16.0, vertical: 14.0),
                                                      ),


                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    TextFormField(
                                                      obscureText: true,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return 'Please enter your Confirm Password';
                                                        }
                                                        return null; // Return null for no validation error
                                                      },
                                                      controller: confirmPassword,
                                                      decoration: InputDecoration(
                                                        labelText: 'Enter Confirm Password',
                                                        hintText: 'Confirm Password',
                                                          filled: true,
                                                          fillColor: Colors.white,
                                                        suffixIcon: GestureDetector(
                                                          onTap: (){
                                                            Clipboard.setData(ClipboardData(text: confirmPassword.text))
                                                                .then((_) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(content: Text('Copied to your clipboard !')));
                                                            });
                                                          },
                                                          child: const Icon(Icons.copy),
                                                        ),
                                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        contentPadding: const EdgeInsets.symmetric(
                                                            horizontal: 16.0, vertical: 14.0),
                                                      ),


                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width*0.5,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:HexColor('#3465D9'),
                                                        ),
                                                        child: const Text('Change Password',style: TextStyle(color: Colors.white),),
                                                        onPressed: () async{
                                          if (_formKey.currentState?.validate() ?? false) {
                                            await change_password();
                                            Navigator.push(_scaffoldKey
                                                  .currentContext!,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                        return ProfilePage(
                                                          firstname: widget
                                                              .firstname,
                                                          id: widget.id,
                                                          isAdmin: widget
                                                              .isAdmin,);
                                                      }));
                                          }

                                                        },
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),

                      ),

                    ],
                  ),
                ),

              )

            )
          ],
        ),
      ),
    );
  }
  Future<void> change_password() async {
    var data;
    print("newPassword: $newPassword");
    print("oldPassword: $oldPassword");

    await getApiurl(); // Assuming this function sets the API URL

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/changePassword/'),
        body: {
          'newPassword': newPassword.text,
          'oldPassword': oldPassword.text,
          'confirmPassword': confirmPassword.text,
          'idval': widget.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          data = response.body.trim();
          print("Response data: $data");

          if (data.contains("success")) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password successfully changed"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (data.contains("mismatch")) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("New and confirm passwords do not match"),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (data.contains("error")) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("An error occurred while changing the password"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Unexpected error"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      } else {
        print("Failed to change password. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to change password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Exception caught: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}



