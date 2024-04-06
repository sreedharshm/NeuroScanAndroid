import 'package:eeg/services/firebaselogin.dart';
import 'package:eeg/view/addpatientdetails.dart';
import 'package:eeg/view/upload.dart';
import 'package:eeg/view/profileScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseData {
  final String name;
  final int age;
  final String gender;
  final String docid;

  FirebaseData(
      {required this.name,
      required this.age,
      required this.gender,
      required this.docid});
}

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final List<FirebaseData> firebaseDataList = []; // Exa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(250, 22, 22, 22),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 22, 22, 22),
        leadingWidth: 150,
        // leading: Row(
        //   children: [
        //     SizedBox(
        //       width: 30,
        //     ),
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const ProfileScreeen()),
        //           );
        //         },
        //         icon: Image.asset("assets/images/profileavatar.png")),
        //   ],
        // ),
        leading: Center(
          child: Text(
            "Patients",
            style: TextStyle(
                fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        actions: [
          // TextButton(
          //     onPressed: () {},
          //     child: const Row(
          //       children: [
          //         Text(
          //           "Add New",
          //           style: TextStyle(
          //               fontSize: 20, color: Color.fromARGB(255, 42, 6, 202)),
          //         ),
          //         SizedBox(
          //           width: 20,
          //         )
          //       ],
          //     ))
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreeen()),
                    );
                  },
                  icon: Image.asset("assets/images/profileavatar.png")),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patient')
            .where('doctorid',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<FirebaseData> firebaseDataList =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return FirebaseData(
                  name: data['name'],
                  age: data['age'],
                  gender: data['gender'],
                  docid: document.id);
            }).toList();

            return ListView.builder(
              itemCount: firebaseDataList.length,
              itemBuilder: (context, index) {
                final data = firebaseDataList[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to another page with the details of the user
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadFile(
                          patientid: data.docid,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tileColor: Color.fromARGB(31, 82, 82, 82),
                      title: Text(
                        data.name,
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                      subtitle: Text(
                        'Age: ${data.age}, Gender: ${data.gender}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
                child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Addpatientt()));
          // You can add functionality here to add new data to firebase
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
