import 'package:flutter/material.dart';
import 'package:foto_budka/landing_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter_beep/flutter_beep.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late final MyLandingScreenWidget landingScreen;
  late Timer _timer;
  var _start = 10;


  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    // Navigator.of(context).pop();
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


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
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

