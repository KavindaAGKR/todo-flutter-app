import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/signup_screen.dart';
import 'package:todoapp/sevices/auth_services.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = AuthService();
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.sendEmailVerificationLink();

    //Timer to check the email is verified by user and reload the auth status and check it and proceed
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Wrapper()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                "We have sent email verification link to your account. please check your mails and confirm the email.",
                style: TextStyle(color: Colors.green),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                  onPressed: () async {
                    _auth.sendEmailVerificationLink();
                  },
                  child: const Text(
                    "Resend the email",
                    style: TextStyle(color: Colors.red),
                  )),
              
              TextButton(
                  onPressed: () {
                    AuthService().signOut();
                  },
                  child: const Text(
                    "Hello world",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    AuthService().signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: const Text(
                    "Use another email",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
