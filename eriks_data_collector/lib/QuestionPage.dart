import 'package:flutter/material.dart';
import 'constants.dart';

class QuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Questions'),
        backgroundColor: Constants.buttonCol,
      ),
      backgroundColor: Constants.backgroundCol,
      body: Column(
        children: <Widget>[
          // TODO: Add your questions and input fields here
        ],
      ),
    );
  }
}