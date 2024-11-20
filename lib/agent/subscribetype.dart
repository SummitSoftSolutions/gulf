import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class SubscriberPage extends StatefulWidget {
  const SubscriberPage({super.key});

  @override
  State<SubscriberPage> createState() => _SubscriberPageState();
}

class _SubscriberPageState extends State<SubscriberPage> {

  TextEditingController subscribertypeCntr = TextEditingController();
  TextEditingController subscriberamountCntr = TextEditingController();
  var apiUrl;

  void initState()
  {
    super.initState();
    getApiurl();
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
          title: Text('Subscriber Type Creation'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: TextField(
                    controller: subscribertypeCntr,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subscriber Type Name',
                      // hintText: 'name',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: TextField(
                  controller: subscriberamountCntr,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subscription Amount',
                    // hintText: 'name',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                ),
                child: Text('ADD',style: TextStyle(color: Colors.white),),
                onPressed: (){
                  insert_subscriber();
                },
              ),
            ),


          ],
        )
    );
  }
  Future insert_subscriber() async
  {
    await getApiurl();
    var data;
    var response = await http.post(
      Uri.parse('$apiUrl/sub_insert/'),
      body: {
        'subscribertypeCntr': subscribertypeCntr.text,
        'subscriberamountCntr':subscriberamountCntr.text,
      },
    );
    if(response.statusCode == 200)
      {
        setState(() {
          data = response.body.trim();
        });
        if (data.contains("success")) {// Check if data is "success"
          final SnackBar snackBar = SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {});
        }
        else {
          final SnackBar snackBar = SnackBar(
            content: Text("Error"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
  }
}
