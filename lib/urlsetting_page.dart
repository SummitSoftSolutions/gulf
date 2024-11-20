import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class Urletting extends StatefulWidget {
  const Urletting({super.key});

  @override
  State<Urletting> createState() => _UrlettingState();
}

class _UrlettingState extends State<Urletting> {

  TextEditingController urlName = TextEditingController();
  Future<Null> addurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('api_url', urlName.text);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  controller:urlName,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'URL',
                  ),
                ),
              ),

              Container(
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),backgroundColor: Colors.blue.shade600,
                    ),
                    child: const Text('SET',style: TextStyle(color:Colors.white),),
                    onPressed: () async{
                  await    addurl();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    },
                  )),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     'Forgot Password?',
              //     style: TextStyle(color: Colors.grey[600]),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
