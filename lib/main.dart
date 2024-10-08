import 'package:flutter/material.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //prepares Flutter for asynchronous initialization.
  await Firebase.initializeApp(); //initializes Firebase for use in the app.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo app",
      theme: ThemeData(primarySwatch: Colors.red, primaryColor: Colors.blue),
      home: LoginScreen(),
    );
  }
}
