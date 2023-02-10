import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_beep/flutter_beep.dart';
import 'dart:async';
import 'dart:io';

import 'exportScreen.dart';

class PhotoScreen extends StatefulWidget {
  final String amountOfPhotos;
  final String interval;
  final List<CameraDescription>? cameras;
  const PhotoScreen(this.cameras, this.amountOfPhotos, this.interval, {super.key});

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late CameraController controller;
  XFile? pictureFile;
  bool isButtonActive = true;
  int _start = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _sendImageToServer(File image) async {
    var url = Uri.parse("http://localhost:8080/photos/upload");
    var request = http.MultipartRequest("POST", url);
    var file = await http.MultipartFile.fromPath("photo", image.path);
    request.files.add(file);
    var response = await request.send();
  }

  _openCamera(BuildContext context) async {
    for(int i = 0; i< int.parse(widget.amountOfPhotos); i++) {
      controller.takePicture().then((XFile? file) {
        if(mounted) {
          if(file != null) {
            print("The picture has been taken");
            FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ANSWER);
            _sendImageToServer(File(file.path));
          }
        }
      });
      await Future.delayed(const Duration(seconds: 1));
      if (i + 1 != int.parse(widget.amountOfPhotos)) {
        setState(() {
          _start = int.parse(widget.interval);
        });
        const oneSec = Duration(seconds: 1);
        _timer = Timer.periodic(
          oneSec,
              (Timer timer) {
            if (_start == 0) {
              setState(() {
                timer.cancel();
              });
            } else {
              FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
              setState(() {
                _start--;
              });
            }
          },
        );
        await Future.delayed(Duration(seconds: int.parse(widget.interval)));
      }
    }
    await Future.delayed(const Duration(seconds: 3));
    FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_CONFIRM);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExportScreen()),
    );
  }
  
  Widget _decideView() {
    if(isButtonActive) {
      return GestureDetector(
        onTap: () {
          if(isButtonActive) {
            startTimer();
            setState(() {
              isButtonActive = false;
            });
          }
        },
        child: button( const Icon(
          Icons.camera_alt_outlined,
          color: Colors.black54,
        ), Alignment.bottomCenter),
      );
    } else {
      return button(Text(_start.toString()), Alignment.bottomCenter);
    }
    
  }


  void startTimer() {
    setState(() {
      isButtonActive = false;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          _openCamera(context);

        } else {
          FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller),
          _decideView(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: button( const Icon(
              Icons.arrow_left,
              color: Colors.black54,
            ), Alignment.bottomRight),
          ),
        ],
      ),
    );
  }

  Widget button(Widget widget, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 20,
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}