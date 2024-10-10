import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/sevices/auth_services.dart';

class SignupScreen extends StatelessWidget {
  //const SignupScreen({super.key});

  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text("Create Account"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.amber),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "email",
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.amber),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "password",
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  User? user = await _auth.registerWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Wrapper()));
                  }
                },
                child: const Text("Register")),
            Row(
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            )
          ],
        ));
  }
}
