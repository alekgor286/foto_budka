import 'package:flutter/material.dart';
import 'package:foto_budka/photoScreen.dart';

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

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: amountOfPhotos,
            ),
            const Text('Ilość zdjęć wykonanych w serii'),
            TextField(
              controller: interval,
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
              onPressed: () {
                Navigator.of(
                    context).push(
                    MaterialPageRoute(
                        builder: (context) => PhotoScreen(amountOfPhotos.text, interval.text)));
              },
              child: const Text(
                'Gotowe!',
                style: TextStyle(fontSize: 16.0, color: Colors.white),              ),
            )
          ],        ),
      );
    }
  }