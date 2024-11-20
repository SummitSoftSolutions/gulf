import 'package:flutter/material.dart';
import 'package:gulf_suprabhaatham/agent/cancelation/subscriber_cancel_by_agent.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../superadmin/SubcriptionAgentPage.dart';

class PageViewCancel extends StatefulWidget {
  final String firstname;
  final bool isAdmin;
  final String id;

  const PageViewCancel({
    super.key,
    required this.firstname,
    required this.id,
    required this.isAdmin,
  });

  @override
  State<PageViewCancel> createState() => _PageViewCancelState();
}
class _PageViewCancelState extends State<PageViewCancel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(40.0),
            child: Text(
              'CANCELLATION',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: HexColor('#3465D9'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubscriberAgentPage(
                  firstname: widget.firstname,
                  id: widget.id,
                  isAdmin: widget.isAdmin,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.shade50,
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionCancel(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin)),
                              (Route<dynamic> route) =>
                          false, // Removes all routes in the stack
                        );
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width*0.9,
                          height: MediaQuery.of(context).size.width*0.30,
                          child: const Center(child: Text('ADD CANCELLATION'))
                      ),
                    ),
                    // const Spacer(),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.3),
                    //         spreadRadius: 2,
                    //         blurRadius: 5,
                    //         offset: const Offset(0, 3), // changes position of shadow
                    //       ),
                    //     ],
                    //   ),
                    //   width: MediaQuery.of(context).size.width*0.45,
                    //   height: MediaQuery.of(context).size.width*0.30,
                    //   child: const Center(child: Text('VIEW CANCELLATION'))
                    // ),



                  ],
                ),
              ),







              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         // Navigator.push(context, MaterialPageRoute(builder: (context){return ReceiptForm();}));
              //         Navigator.pushAndRemoveUntil(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //               const DivisonPage()),
              //               (Route<dynamic> route) =>
              //           false, // Removes all routes in the stack
              //         );
              //       },
              //       child: Card(
              //         color: Colors.white,
              //         child: SizedBox(
              //           width: MediaQuery.of(context).size.width *
              //               0.96,
              //           height: MediaQuery.of(context).size.height *
              //               0.13,
              //           child: Column(
              //             children: [
              //               const SizedBox(height: 10),
              //               Image.asset(
              //                 'images/division.png',
              //                 height: 40,
              //               ),
              //               const SizedBox(height: 3),
              //               // Adjust the space between icon and text
              //               Text(
              //                 'Area',
              //                 style: GoogleFonts.roboto(
              //                     textStyle: const TextStyle(
              //                         fontSize: 11)),
              //               ),
              //             ],
              //           ),
              //         ), //SizedBox
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) {
              //               return  ClusterPage(firstname:widget.firstname,id:widget.id,isAdmin:widget.isAdmin);
              //             }));
              //       },
              //       child: Card(
              //         color: Colors.white,
              //         child: SizedBox(
              //           width: MediaQuery.of(context).size.width *
              //               0.96,
              //           height: MediaQuery.of(context).size.height *
              //               0.13,
              //           child: Column(
              //             children: [
              //               const SizedBox(height: 15),
              //               Image.asset(
              //                 'images/cluster.png',
              //                 height: 28,
              //               ),
              //               // Adjust the space between icon and text
              //               const SizedBox(height: 11),
              //               Padding(
              //                 padding:
              //                 const EdgeInsets.only(left: 5.0),
              //                 child: Text(
              //                   'Cluster',
              //                   style: GoogleFonts.roboto(
              //                       textStyle: const TextStyle(
              //                           fontSize: 10)),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ), //SizedBox
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(
              //   width: 2,
              // ),
            ],
          ),
        ),
      ),
    );
  }

}
