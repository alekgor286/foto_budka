import 'package:flutter/material.dart';
import 'package:foto_budka/photoScreen.dart';
import 'package:camera/camera.dart';

  class LandingScreen extends StatefulWidget {
    const LandingScreen({super.key});

    @override
    _LandingScreenState createState() => _LandingScreenState();

  }

  class _LandingScreenState extends State<LandingScreen> {

    @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Wpisz twoje preferencje'),
      ),
      body: const MyLandingScreenWidget(),
      );
      }
    }

  class MyLandingScreenWidget extends StatefulWidget {
    const MyLandingScreenWidget({super.key});

    @override
    State<MyLandingScreenWidget> createState() => _MyLandingScreenWidgetState();
  }

  class _MyLandingScreenWidgetState extends State<MyLandingScreenWidget> {
    final amountOfPhotos = TextEditingController();
    final interval = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      amountOfPhotos.dispose();
      interval.dispose();
      super.dispose();
    }

    void _showErrorDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Błąd!"),
            content: Text("Wprowadzono błędne wartości"),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: amountOfPhotos,
              keyboardType: TextInputType.number,
            ),
            const Text('Ilość zdjęć wykonanych w serii'),
            TextField(
              controller: interval,
              keyboardType: TextInputType.number,
            ),
            const Text('Ilość sekund pomiędzy zdjęciami'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.blue))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.lightBlue),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.only(top: 12.0, bottom: 12.0))),
              onPressed: () async {
                int? amountOfPhotosNumber = int.tryParse(amountOfPhotos.text);
                int? intervalNumber = int.tryParse(interval.text);
                if (amountOfPhotosNumber==0 || intervalNumber==0
                || amountOfPhotosNumber==null || intervalNumber==null) {
                  _showErrorDialog();
                } else {
                  await availableCameras().then(
                        (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoScreen(value, amountOfPhotos.text, interval.text),
                      ),
                    ),
                  );
                }
             },
              child: const Text(
                'Gotowe!',
                style: TextStyle(fontSize: 16.0, color: Colors.white),              ),
            )
          ],        ),
      );
    }
  }