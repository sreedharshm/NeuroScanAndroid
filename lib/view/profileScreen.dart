import 'package:eeg/services/firebaselogin.dart';
import 'package:eeg/view/loginScreen.dart';
import 'package:flutter/material.dart';

class ProfileScreeen extends StatelessWidget {
  const ProfileScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          ListTile(
              title: Text("Log Out"),
              trailing: IconButton(
                onPressed: () {
                  FireAuth().logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                },
                icon: Icon(Icons.arrow_right),
              ))
        ],
      ),
    );
  }
}
