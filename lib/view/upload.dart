import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadFile extends StatefulWidget {
  final String patientid;
  const UploadFile({super.key, required this.patientid});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  File? _file;

  String? csrfToken1;

  Future<String?> fetchCSRFToken() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/'));
    final Map<String, dynamic> responseData = json.decode(response.body);
    final csrfToken = responseData['csrf_token'];
    csrfToken1 = csrfToken;
    print(csrfToken1);
    return csrfToken;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    } else {
      // User canceled the file picker
    }
  }

  Future<void> _uploadFile(String patientid) async {
    if (_file == null) {
      // Show error message or handle the case when no file or CSRF token is available
      return;
    }

    var url = 'http://10.0.2.2:8000/input/'; // Replace with your API endpoint

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('files', _file!.path));

    request.fields['csrfmiddlewaretoken'] = csrfToken1!;
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // Handle success
      Map<String, dynamic> data = json.decode(response.body);

      print('File uploaded successfully');
      DateTime timenow = DateTime.now();
      await FirebaseFirestore.instance.collection('test').add({
        'time': timenow.hour.toString() +
            ':' +
            timenow.minute.toString() +
            ", " +
            timenow.day.toString() +
            "/" +
            timenow.month.toString(),
        'result': data['ans'],
        'patient_id': patientid,
      });
    } else {
      // Handle failure
      print('Failed to upload file: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    late String patientid = widget.patientid;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('test')
            .where('patient_id', isEqualTo: patientid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: Color.fromARGB(31, 82, 82, 82),

                    title: Text(
                      document['time'].toString(),
                      style: TextStyle(color: Colors.white),
                    ), // Adjust this to your document structure
                    subtitle: Text(
                      (document['result'].toString() == '1')
                          ? 'Seizure detected'
                          : 'No seizure detected',
                      style: TextStyle(color: Colors.white),
                    ), // Adjust this to your document structure
                    // Add more details as needed
                  ),
                );
              },
            );
          } else {
            print("here");
            return const Center(
                child: Text(
              'No tests found for this patient',
              style: TextStyle(color: Colors.white),
            ));
          }
        },
      ),
      backgroundColor: Color.fromARGB(250, 22, 22, 22),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await fetchCSRFToken();
          await _pickFile();
          await _uploadFile(patientid);
        },
        label: const Text("Add File"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
