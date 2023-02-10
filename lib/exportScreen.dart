import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foto_budka/landing_screen.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _pdfUrl = "";
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
  }

  _downloadPDF() async {
    var url = Uri.parse("http://192.168.56.1:8080/photos/downloadPDF");
    http.Response response = await http.get(url);
    final pdfBytes = response.bodyBytes;

    final filename = '${uuid.v4()}.pdf';
    final file = await File('${(await getApplicationDocumentsDirectory()).path}/$filename').create();
    await file.writeAsBytes(pdfBytes);

    OpenFile.open(file.path);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                Colors.lightBlue),
                padding: MaterialStateProperty.all(
                const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0, right: 10.0))),
              onPressed: () {
                _downloadPDF();
              },
              child: const Text(
                'Exportuj do PDF',
                style: TextStyle(fontSize: 36.0, color: Colors.white), ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.lightBlue),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0, right: 10.0))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingScreen()),
                );
              },
              child: const Text(
                'Powrót',
                style: TextStyle(fontSize: 36.0, color: Colors.white), ),
            ),
          ],
        ),
      ),
    );
  }
}
