import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Map<String, dynamic>> questions = [];
  Map<String, String> answers = {};
  int questionIndex = 0;
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    String jsonString = await rootBundle.loadString('assets/questions/daily_questions.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      questions = jsonData.cast<Map<String, dynamic>>();
    });
  }

  void _answerQuestion() {
    String questionId = questions[questionIndex]['id'];
    answers[questionId] = answerController.text;

    setState(() {
      questionIndex = (questionIndex + 1) % questions.length;
      answerController.clear();

      //Final question answered
      if (questionIndex == 0) {
        String currentDate = DateTime.now().toString().split(' ')[0];
        _appendAnswers(currentDate, answers);
        Navigator.pop(context); //return
      }
    });
  }

  Future<void> _appendAnswers(String date, Map<String, String> answers) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/answers.txt');

    Map<String, dynamic> jsonContent = {};
    if (await file.exists()) {
      String fileContent = await file.readAsString();
      jsonContent = jsonDecode(fileContent);
    }
    jsonContent[date] = answers;

    await file.writeAsString(jsonEncode(jsonContent));
    print(await file.readAsString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Questions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.buttonCol,
      ),
      backgroundColor: Constants.backgroundCol,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: questions.isEmpty
              ? [Text('Loading questions...')]
              : [
            Text(
              questions[questionIndex]['title'],
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: CupertinoColors.lightBackgroundGray),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                questions[questionIndex]['text'],
                style: TextStyle(fontSize: 18.0, color: CupertinoColors.lightBackgroundGray),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Your Answer',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                cursorColor: Colors.blueGrey,
              ),
            ),
            ElevatedButton(
              onPressed: _answerQuestion,
              child: Text('Answer'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.buttonCol
              ),
            ),
          ],
        ),
      ),
    );
  }
}