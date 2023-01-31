import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatelessWidget {
  final File image;

  const DetailScreen({Key? key, required this.image}) : super(key: key);

  _deleteFile() async {
    await image.delete();
  }

  // Funkcja wysyłająca request do Rest API
  _sendImageToServer() async {
    var url = Uri.parse("http://localhost:8080/photos/upload");
    var request = http.MultipartRequest("POST", url);
    var file = await http.MultipartFile.fromPath("photo", image.path);
    request.files.add(file);
    var response = await request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły zdjęcia'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[Colors.lightBlueAccent, Colors.blue]),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: Image(
                image: FileImage(image),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _deleteFile();
                Navigator.pop(context);
              },
              child: Text("Usuń zdjęcie"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              )),
        ],
      ),
    );
  }
}

class PhotoItem {
  final File image;

  PhotoItem(this.image);
}
