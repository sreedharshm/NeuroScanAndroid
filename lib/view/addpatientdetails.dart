import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addpatientt extends StatefulWidget {
  const Addpatientt({super.key});

  @override
  State<Addpatientt> createState() => _AddpatienttState();
}

class _AddpatienttState extends State<Addpatientt> {
  String name = '';
  int age = 0;
  String gender = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Patient Details',
                style: TextStyle(
                    color: const Color.fromARGB(255, 229, 224, 224),
                    fontSize: 25)),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  Text('Add Details',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 229, 224, 224),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 10.0),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        age = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.black,
                    value: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                    items: <String>['Male', 'Female', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Handle the data submission here
                        // const print('Name: $name, Age: $age, Gender: $gender');
                        await FirebaseFirestore.instance
                            .collection('patient')
                            .add({
                          'name': name.trim(),
                          'age': age,
                          'gender': gender,
                          'doctorid': FirebaseAuth.instance.currentUser!.uid
                        });
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
