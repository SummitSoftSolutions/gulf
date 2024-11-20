import 'dart:convert';

import 'package:hexcolor/hexcolor.dart';
import 'package:animate_do/animate_do.dart';

import 'agent/coordinatorlogin.dart';
import 'agent/login_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override

  TextEditingController usernameCntr = TextEditingController();
  TextEditingController passwordCntr = TextEditingController();
  var roleVal;
  var apiUrl;
  late List credential;
  int role=0;
  late List posts;
  var coordinatorid;
  var id;
  var firstname;
  var isAdmin;
  bool passwordVisible=true;
  void initState()
  {
    super.initState();
    getApiurl();
    passwordVisible=false;
  }

  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apiUrl = prefs.getString('api_url');
    print('............getApiurl..getApiurl.....$apiUrl');
    return;
  }

  Widget build(BuildContext context) {
    return  Scaffold(
      // backgroundColor: HexColor('#7EC8E3'),
        body:Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: HexColor('#3465D9'),
              // gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     colors: [
              //       Colors.orange.shade900,
              //       Colors.orange.shade800,
              //       Colors.orange.shade400
              //     ]
              // )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80,),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(duration: const Duration(milliseconds: 1000), child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    const SizedBox(height: 10,),
                    FadeInUp(duration: const Duration(milliseconds: 1300), child: const Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 60,),
                          FadeInUp(duration: const Duration(milliseconds: 1400), child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [const BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                  ),
                                  child: TextField(
                                    controller:usernameCntr,
                                    decoration: const InputDecoration(
                                        hintText: "Username",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: TextField(
                                controller: passwordCntr,
                                obscureText: !passwordVisible,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                  alignLabelWithHint: false,
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                              ],
                            ),
                          )),
                          const SizedBox(height: 40,),
                          // FadeInUp(duration: const Duration(milliseconds: 1500), child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                          const SizedBox(height: 40,),
                          FadeInUp(duration: const Duration(milliseconds: 1600), child: MaterialButton(
                            onPressed: () async{
                             await fetchuserpass().then((value) async{
                               await putUser();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {return CoordinatorPage(firstname:firstname,id:id,isAdmin:isAdmin);}));

                              });
                            },
                            height: 50,
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            color: HexColor('#3465D9'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),

                            ),
                            // decoration: BoxDecoration(
                            // ),
                            child: const Center(
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          )),
                          // SizedBox(height: 50,),
                          // FadeInUp(duration: Duration(milliseconds: 1700), child: Text("Continue with social media", style: TextStyle(color: Colors.grey),)),
                          // SizedBox(height: 30,),
                          // Row(
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: FadeInUp(duration: Duration(milliseconds: 1800), child: MaterialButton(
                          //         onPressed: (){},
                          //         height: 50,
                          //         color: Colors.blue,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(50),
                          //         ),
                          //         child: Center(
                          //           child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          //         ),
                          //       )),
                          //     ),
                          //     SizedBox(width: 30,),
                          //     Expanded(
                          //       child: FadeInUp(duration: Duration(milliseconds: 1900), child: MaterialButton(
                          //         onPressed: () {},
                          //         height: 50,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(50),
                          //
                          //         ),
                          //         color: Colors.black,
                          //         child: Center(
                          //           child: Text("Github", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          //         ),
                          //       )),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
    );



  }
  Future<String?> fetchuserpass() async {
    print("Hello");
    await getApiurl();

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/superadmin_page/'),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode({
          'username': usernameCntr.text,
          'password': passwordCntr.text,
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData.isEmpty) {
          final SnackBar snackBar = const SnackBar(
              content: Text("Either Username or Password is incorrect"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return null;  // Return null if the response data is empty
        } else {
          setState(() {
            credential = responseData;
          });

          posts = credential.map<User>((model) => User.fromJson(model)).toList();
          role = posts[0].role;
          firstname = posts[0].firstname;
          coordinatorid = posts[0].coordinatorid;
          id = posts[0].id;

          print("Values: $role, $firstname, $coordinatorid, $id");

          return role.toString();  // Convert role to String before returning
        }
      } else {
        var responseData = jsonDecode(response.body);
        if (responseData.containsKey("error")) {
          final SnackBar snackBar = SnackBar(
            content: Text(responseData["error"]),
            backgroundColor: Colors.grey.shade500,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return null;
        } else {
          return null;
        }
      }
    } catch (e) {
      print("Exception: $e");
      final SnackBar snackBar = const SnackBar(
        content: Text("Failed to connect to the server."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }


  Future putUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('role', role);
    prefs.setString('coordinatorid', coordinatorid);
    prefs.setString('firstname', firstname);
    prefs.setString('id', id);
    print("firstname1 $firstname");
    setState(() {
      if(role==1)
      {
        isAdmin=true;
        print("isAdmint $isAdmin");
      }
      else
        {
          isAdmin=false;
          print("isAdminf $isAdmin");
        }
    });

    // email_cntr.clear();
    // pass_cntr.clear();
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
