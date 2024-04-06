import 'package:eeg/services/firebaselogin.dart';
import 'package:eeg/view/homeScreen.dart';
import 'package:eeg/view/upload.dart';
import 'package:eeg/view/navigationScreen.dart';
import 'package:eeg/view/registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//commit
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isloading = false;
  loginhere() async {
    setState(() {
      _isloading = true;
    });
    String s = await FireAuth().signIn(
        emailController: _emailController.text.trim(),
        passwordController: _passwordController.text.trim());
    if (s == "success") {
      if (FirebaseAuth.instance.currentUser!.emailVerified)
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const PatientScreen()),
            (route) => false);
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your email is not verified")));
      }
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 250,
              ),
              TextFormField(
                controller: _emailController,
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
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Enter password",
                    hintStyle: TextStyle(color: Color(0xffe6e5ed)),
                    fillColor: Color.fromARGB(255, 129, 127, 127),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const ResetPassword()));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await loginhere();
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 94, 80, 160)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
                child: _isloading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Login", style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  )),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Or continue with"),
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // if (GoogleSignInClass.googleSigniN(context) == 'success')
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => RegisterScreen()));
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 3,
                          )),
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/google.png",
                        height: 40,
                      ),
                    ),
                    iconSize: 65,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         border: Border.all(
                  //           color: Colors.white,
                  //           style: BorderStyle.solid,
                  //           width: 3,
                  //         )),
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Image.asset(
                  //       "assets/images/facebook.png",
                  //       height: 40,
                  //     ),
                  //   ),
                  //   iconSize: 65,
                  // )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not a member?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Register Now",
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
