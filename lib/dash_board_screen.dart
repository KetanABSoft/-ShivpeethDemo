import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessage.listen((message) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text("App is Open By Message",style: TextStyle(
    //               color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
    //         duration: Duration(seconds: 10),
    //         backgroundColor: Colors.green,
    //       ));
    //   // print("########Message Recieved ${message.notification!.title}");
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("DashBoard",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 30),))
        ],
      ),
    );
  }
}
