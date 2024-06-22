import 'package:flutter/material.dart';
import 'package:messeges_with_firebase/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messeges_with_firebase/notification_services_second.dart';
import 'firebase_options.dart';


void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.inilialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:HomeScreen()
    );
  }
}
