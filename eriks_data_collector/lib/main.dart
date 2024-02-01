import 'package:flutter/material.dart';
import 'QuestionPage.dart';
import 'constants.dart';
import 'FileContentCopier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      routes: {
        '/questionPage': (context) => QuestionPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eriks Data Collector'),
        backgroundColor: Constants.buttonCol,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Constants.backgroundCol,
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(50.0),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.buttonCol),
              onPressed: () {
                Navigator.pushNamed(context, '/questionPage');
              },
              child: const Text(
                'Daily Questions',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.buttonCol),
              onPressed: () {
                FileContentCopier.share();
              },
              child: const Text(
                'Share Answers',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
