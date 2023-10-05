import 'package:flutter/material.dart';
import 'QuestionPage.dart';
import 'constants.dart';

void main() => runApp(MyApp());

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
        title: Text('Eriks Data Collector'),
        backgroundColor: Constants.buttonCol,
      ),
      backgroundColor: Constants.backgroundCol,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(50.0),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.buttonCol
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/questionPage');
              },
              child: Text('Daily Questions'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.buttonCol
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/questionPage');
              },
              child: Text('Copy Answers File'),
            ),
          ]
        )
      ),
    );
  }
}
