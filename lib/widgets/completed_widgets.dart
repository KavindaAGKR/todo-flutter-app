import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/sevices/database_services.dart';

class CompletedWidgets extends StatefulWidget {
  const CompletedWidgets({super.key});

  @override
  State<CompletedWidgets> createState() => _CompletedWidgetsState();
}

class _CompletedWidgetsState extends State<CompletedWidgets> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uidd;

  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uidd = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Hello world"),
      ],
    );
  }



}
