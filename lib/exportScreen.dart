import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'details_screen.dart';
import 'main.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final List<PhotoItem> _items = [];
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openFile();
    });
  }

  _downloadPDF() {
      var url = Uri.parse("http://localhost:8080/photos/downloadPDF");
  }

  _openFile() async {
    setState(() {
      _items.clear();
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var fileSystemEntity = appDocDir.listSync();
    log('data: $fileSystemEntity');
    fileSystemEntity
        .removeWhere((element) => !basename(element.path).contains(".jpg"));

    for (var element in fileSystemEntity) {
      setState(() {
        _items.add(PhotoItem(File(element.path)));
      });
    }
  }

  List<Widget> _decideImageView() {
    if (_items.isEmpty) {
      return [const Text("Nie wybrano zdjeć!"),
        Row(mainAxisAlignment: MainAxisAlignment.center)
      ];
    } else {
      return [DragAndDropGridView(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            crossAxisCount: 3,
          ),
          padding: const EdgeInsets.all(20),
          itemCount: _items.length,
          onWillAccept: (oldIndex, newIndex) {
            return true;
          },
          onReorder: (oldIndex, newIndex) {
            final temp = _items[oldIndex];
            _items[oldIndex] = _items[newIndex];
            _items[newIndex] = temp;

            setState(() {});
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      image: _items[index].image,
                    ),
                  ),
                ).then((value) => _openFile());
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(_items[index].image),
                  ),
                ),
              ),
            );
          }),
        ElevatedButton(
          onPressed: () {
            _downloadPDF();
          },
          child: Text("Exportuj do PDF"),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center)
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appTitle),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[Colors.lightBlueAccent, Colors.blue]),
          ),
        ),
      ),
        body: Stack(
            children: <Widget>[
              Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _decideImageView(),
                    ),
                  )),
            ]),);
  }
}
