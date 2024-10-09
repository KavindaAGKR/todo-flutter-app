import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //prepares Flutter for asynchronous initialization.
  await Firebase.initializeApp(); //initializes Firebase for use in the app.
  runApp(MyApp()); // Removed `const`
}

class MyApp extends StatelessWidget {
  MyApp({super.key}); // Removed `const`

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ignore: prefer_const_constructors
      home: _auth.currentUser != null
          ? HomeScreen()
          : LoginScreen(), // Removed `const` from HomeScreen
    );
  }
}
