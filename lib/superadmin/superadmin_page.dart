import 'package:flutter/material.dart';


import '../agent/coordinator_form.dart';
import 'account_groupmaster.dart';
import 'divsion_page.dart';



class SuperadminPage extends StatefulWidget {

  final String firstname;
  final bool isAdmin;
  final String id;
  final String coordinatorid;
  const SuperadminPage({Key? key, required this.firstname, required this.id, required this.isAdmin,required this.coordinatorid}) : super(key: key);

  @override
  State<SuperadminPage> createState() => _SuperadminPageState();
}


class _SuperadminPageState extends State<SuperadminPage> {

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    print('Clicked index: $index');
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==1)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context){return const FormApp();}));

        }
      else if(_selectedIndex==2)
        {
          // Navigator.push(context, MaterialPageRoute(builder: (context){return  ProfilePage(firstname: , isAdmin: null,);}));

        }
    });
  }


  Color myColor = const Color(0xFF7EC8E3);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Create Master'),),
     body: SafeArea(
       child: CustomScrollView(
         primary: false,
         slivers: <Widget>[
           SliverPadding(
             padding: const EdgeInsets.all(20),
             sliver: SliverGrid.count(
               crossAxisSpacing: 10,
               mainAxisSpacing: 10,
               crossAxisCount: 2,
               children: <Widget>[


                 GestureDetector(
                   onTap: ()
                   {
                     // Navigator.push(context, MaterialPageRoute(builder: (context){return const ZonePage();}));
                   },
                   child: SizedBox(
                     width: 10, // Adjust the width as needed
                     height: 10, // Adjust the height as needed
                     child: Card(
                       elevation: 10,
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(80), // Adjust the radius as needed
                       ),
                       child: const Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.location_on, // Replace with your desired icon
                               size: 30, // Adjust the icon size as needed
                               color: Colors.blue, // Replace with your desired icon color
                             ),
                             SizedBox(height: 10), // Adjust the space between icon and text
                             Text(
                               'Zone',
                               style: TextStyle(
                                 fontSize: 12, // Adjust the text size as needed
                                 fontWeight: FontWeight.bold, // Adjust the font weight as needed
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: ()
                   {
                     Navigator.push(context, MaterialPageRoute(builder: (context){return  DivisonPage();}));

                   },
                   child: SizedBox(
                     width: 40, // Adjust the width as needed
                     height: 40, // Adjust the height as needed
                     child: Card(
                       elevation: 10,
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(80), // Adjust the radius as needed
                       ),
                       child: const Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                           Icon(
                           Icons.more_vert, // Replace with your desired icon
                           size: 30, // Adjust the icon size as needed
                           color: Colors.blue, // Replace with your desired icon color
                         ),
                         SizedBox(height: 10), // Adjust the space between icon and text
                         Text(
                           'Division',
                           style: TextStyle(
                             fontSize: 12, // Adjust the text size as needed
                             fontWeight: FontWeight.bold, // Adjust the font weight as needed
                           ),
                         ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: ()
                   {
                     // Navigator.push(context, MaterialPageRoute(builder: (context){return const ClusterPage(fir);}));
                   },
                   child: SizedBox(
                     width: 10, // Adjust the width as needed
                     height: 10, // Adjust the height as needed
                     child: Card(
                       elevation: 10,
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(80), // Adjust the radius as needed
                       ),
                       child: const Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.group, // Replace with your desired icon
                               size: 30, // Adjust the icon size as needed
                               color: Colors.blue, // Replace with your desired icon color
                             ),
                             SizedBox(height: 10), // Adjust the space between icon and text
                             Text(
                               'Cluster',
                               style: TextStyle(
                                 fontSize: 12, // Adjust the text size as needed
                                 fontWeight: FontWeight.bold, // Adjust the font weight as needed
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: ()
                   {
                     // Navigator.push(context, MaterialPageRoute(builder: (context){return const AccountMaster();}));
                   },
                   child: SizedBox(
                     width: 10, // Adjust the width as needed
                     height: 10, // Adjust the height as needed
                     child: Card(
                       elevation: 10,
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(80), // Adjust the radius as needed
                       ),
                       child: const Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.manage_accounts, // Replace with your desired icon
                               size: 30, // Adjust the icon size as needed
                               color: Colors.blue, // Replace with your desired icon color
                             ),
                             SizedBox(height: 10), // Adjust the space between icon and text
                             Text(
                               'Account Master',
                               style: TextStyle(
                                 fontSize: 12, // Adjust the text size as needed
                                 fontWeight: FontWeight.bold, // Adjust the font weight as needed
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: ()
                   {
                     Navigator.push(context, MaterialPageRoute(builder: (context){return  AccountGroupMaster();}));
                   },
                   child: SizedBox(
                     width: 10, // Adjust the width as needed
                     height: 10, // Adjust the height as needed
                     child: Card(
                       elevation: 10,
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(80), // Adjust the radius as needed
                       ),
                       child: const Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.account_box, // Replace with your desired icon
                               size: 30, // Adjust the icon size as needed
                               color: Colors.blue, // Replace with your desired icon color
                             ),
                             SizedBox(height: 10), // Adjust the space between icon and text
                             Text(
                               'Account Group Master',
                               style: TextStyle(
                                 fontSize: 12, // Adjust the text size as needed
                                 fontWeight: FontWeight.bold, // Adjust the font weight as needed
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
     ),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   // await authService.signOut();
      // }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Masters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Coordinator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
