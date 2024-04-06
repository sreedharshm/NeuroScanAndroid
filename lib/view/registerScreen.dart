import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eeg/view/upload.dart';
import 'package:eeg/view/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebaselogin.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool? val = false;

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();

  // ignore: unused_field
  bool _isloading = false;

  signuphere() async {
    _isloading = true;
    String s = await FireAuth().signUp(
        emailController: _emailController.text.trim(),
        passwordController: _passwordController.text.trim());
    if (s == "success") {
      await FirebaseFirestore.instance
          .collection('doctor')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });
      FirebaseAuth.instance.currentUser!.sendEmailVerification();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerify()),
          (route) => false);
    } else {
      setState(() {
        _isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 12, 0, 0),
              Color.fromARGB(255, 0, 0, 0)
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const Text(
                "Sign Up",
                //textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25, color: Colors.grey),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Name",
                    hintStyle: TextStyle(color: Color(0xffe6e5ed)),
                    fillColor: Color.fromARGB(255, 129, 127, 127),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Enter email or phone",
                    hintStyle: TextStyle(color: Color(0xffe6e5ed)),
                    fillColor: Color.fromARGB(255, 129, 127, 127),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Enter password",
                    hintStyle: TextStyle(color: Color(0xffe6e5ed)),
                    fillColor: Color.fromARGB(255, 129, 127, 127),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  signuphere();
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 94, 80, 160)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
                child: const Text(
                  "Sign up",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
