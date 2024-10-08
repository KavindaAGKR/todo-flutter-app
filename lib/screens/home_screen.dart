import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/sevices/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          actions: [
            ElevatedButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                  print(
                      "============================================== user loged out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                label: Icon(Icons.logout))
          ],
        ),
        body: const Text("Helloooo"));
  }
}
