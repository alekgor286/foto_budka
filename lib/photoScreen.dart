import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter_beep/flutter_beep.dart';

class PhotoScreen extends StatefulWidget {
  final String amountOfPhotos;
  final String interval;
  const PhotoScreen(this.amountOfPhotos, this.interval, {super.key});

  @override
  _PhotoScreenState createState() {
    return _PhotoScreenState(amountOfPhotos, interval);
  }
}

class _PhotoScreenState extends State<PhotoScreen> {
  //tu sa te wartosci z poprzedniego ekranu zeby uzyc to do robienia serii zdj w odpowiednim czasie
  String amountOfPhotos;
  String interval;
  _PhotoScreenState(this.amountOfPhotos, this.interval);
  late Timer _timer;
  var _start = 5;
  List<XFile> _images = [];


  _openCamera(BuildContext context) async {
    for(int i = 0; i< int.parse(amountOfPhotos); i++) {
      var image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _images.add(image!);
        _start = int.parse(interval);
      });
      if (i + 1 != int.parse(amountOfPhotos)) {
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
      await Future.delayed(Duration(seconds: int.parse(interval)));
    }
    }
    Navigator.of(context).pop();
  }


  void startTimer() {
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("$_start",
            style: const TextStyle(fontSize: 36.0, color: Colors.black),),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                        side: const BorderSide(color: Colors.blue))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightBlue),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.only(top: 12.0, bottom: 12.0))),
            onPressed: () {
              startTimer();
            },
            child: const Text(
              'Gotowe!',
              style: TextStyle(fontSize: 36.0, color: Colors.white),              ),
          ),

        ],
      ),
      ),
    );
  }

}

