import 'package:eeg/services/reportdata.dart';
import 'package:flutter/material.dart';

class PdfPreview extends StatelessWidget {
  final lis = [Report("aaa"), Report("bb")];

  PdfPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        ...lis.map((e) => ListTile(
              title: Text(
                e.patientname,
                style: TextStyle(color: Colors.black),
              ),
            ))
      ],
    ));
  }
}
