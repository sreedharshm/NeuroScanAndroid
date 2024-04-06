import 'package:eeg/view/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Column(
              children: [
                Text(
                  "Verify your email address",
                  style: TextStyle(
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text("We have sent an email to verfiy your email account")
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                var user = FirebaseAuth.instance.currentUser;
                if (!user!.emailVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.transparent,
                      content: Center(
                          child: Container(
                              color: Colors.transparent,
                              child: const Text(
                                  "Try Again!. Email is not verified")))));
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientScreen()),
                      (route) => false);
                }
              },
              child: const Text("Login"))
        ],
      ),
    );
  }
}
