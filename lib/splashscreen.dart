import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/urlsetting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';



class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

var api_url;
bool _isloading=false;





class _SplashscreenState extends State<Splashscreen> {


  @override
  void initState() {
    super.initState();

    getApiurl();
    //TODO :IMPLEMENT initState

    jumptohome();
  }



  Future<void> getApiurl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    api_url = prefs.getString('api_url');
    if(prefs.containsKey('api_url')){
      _isloading=true;
    }
    print('............getApiurl..getApiurl.....$api_url');
    return;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: Image.asset("images/splashscreen.jpeg"),



      ),
    );
  }

  void jumptohome() async{
    await Future.delayed(Duration(milliseconds: 2500),(){});
    _isloading?
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()))
        :
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Urletting()));

  }
}
