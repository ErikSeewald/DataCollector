import 'package:flutter/material.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadQuestions() async {
  String jsonString = await rootBundle.loadString('assets/questions/daily_questions.json');
  List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.cast<Map<String, dynamic>>();
}

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