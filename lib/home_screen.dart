import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messeges_with_firebase/dash_board_screen.dart';

import 'notice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _notificationCount = 1;
  List<RemoteMessage> _notifications = [];

  void getInitialMessage() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleMessage(message, fromDialog: false);
    }
  }

  void _handleMessage(RemoteMessage message, {bool fromDialog = true}) {
    if (fromDialog) {
      Navigator.of(context).pop(); // Close the dialog before navigation
    }
    if (message.data["page"] == "home") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (message.data["page"] == "dashboard") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
    } else if (message.data["page"] == "notice") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid page in notification data"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      setState(() {
        _notifications.add(message);
        _notificationCount++;
      });
      _showSnackBar(message.notification?.title ?? "Notification", message.notification?.body ?? "");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        _notifications.add(message);
        _notificationCount++;
      });
      _handleMessage(message, fromDialog: false); // Directly call the handler to manage navigation
    });
  }

  void _showSnackBar(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
      duration: Duration(seconds: 10),
      backgroundColor: Colors.green,
    ));
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notifications"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_notifications[index].notification?.body ?? "Invalid Notification"),
                  onTap: () {
                    _handleMessage(_notifications[index]); // Navigate based on notification
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _showNotificationsDialog,
            child: Stack(
              children: [
                Icon(Icons.notifications_none_outlined, color: Colors.black, size: 50),
                if (_notificationCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Center(
            child: Text(
              "Home Screen",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
