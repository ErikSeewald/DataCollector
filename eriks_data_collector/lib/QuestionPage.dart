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
  //PROGRAM VARIABLES
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> answersJson = {};
  int questionIndex = 0;
  TextEditingController answerController = TextEditingController();

  //FILE VARIABLES
  String currentDate = DateTime.now().toString().split(' ')[0];
  late Directory directory;
  late File answerFile;
  bool answerFileInitialized = false;

  //INITIALIZATION
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    await _initAnswerFile();
    _loadQuestions();
  }

  Future<void> _initAnswerFile() async {
    if (answerFileInitialized) {
      return;
    }
    directory = await getApplicationDocumentsDirectory();
    answerFile = File('${directory.path}/answers.json');
    answerFileInitialized = true;
  }

  //FILE MANAGEMENT
  Future<void> _loadQuestions() async {
    String jsonString;
    try {
      jsonString =
          await rootBundle.loadString('assets/questions/daily_questions.json');
    } catch (e) {
      //FALLBACK
      jsonString = await rootBundle
          .loadString('assets/questions/example_questions.json');
    }
    List<dynamic> jsonData = jsonDecode(jsonString);

    //Load previous answers of the day
    Map<String, dynamic> jsonContent = await _getAnswersJson();
    if (jsonContent[currentDate] == null) {
      jsonContent[currentDate] = {};
    }

    setState(() {
      questions = jsonData.cast<Map<String, dynamic>>();
      answersJson = jsonContent;
      answerController.text = getAnswerForIndex(questionIndex) ?? "";
    });
  }

  Future<Map<String, dynamic>> _getAnswersJson() async {
    Map<String, dynamic> jsonContent = {};
    if (await answerFile.exists()) {
      String fileContent = await answerFile.readAsString();
      jsonContent = jsonDecode(fileContent);
    }
    return jsonContent;
  }

  void _appendAnswers(String date, Map<dynamic, dynamic> answers) async {
    Map<String, dynamic> jsonContent = await _getAnswersJson();
    jsonContent[date] = answers;

    await answerFile.writeAsString(jsonEncode(jsonContent));
  }

  //CONTROL
  void _loadNextQuestion() {
    String questionId = questions[questionIndex]['id'];
    answersJson[currentDate][questionId] = answerController.text;

    setState(() {
      int nextIndex = questionIndex + 1;
      answerController.clear();

      //Load saved answer if available
      if (nextIndex < questions.length) {
        String? savedAnswer = getAnswerForIndex(questionIndex + 1);
        if (savedAnswer != null) {
          answerController.text = savedAnswer;
        }
      } else {
        //Final question answered
        _appendAnswers(currentDate, answersJson[currentDate]);
        Navigator.pop(context);
        return;
      }
      questionIndex = nextIndex;
    });
  }

  void _loadPreviousQuestion() {
    if (questionIndex < 1) {
      return;
    }

    setState(() {
      answerController.text = getAnswerForIndex(questionIndex - 1) ?? "";
      questionIndex--;
    });
  }

  String? getAnswerForIndex(int index) {
    if (index < 0 || index >= questions.length) {
      return null;
    }
    return answersJson[currentDate][questions[index]['id']];
  }

  //WIDGET
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Questions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.buttonCol,
      ),
      backgroundColor: Constants.backgroundCol,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: questions.isEmpty || !answerFileInitialized
              ? []
              : [
                  Text(
                    questions[questionIndex]['title'],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      questions[questionIndex]['text'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: CupertinoColors.lightBackgroundGray,
                      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _loadPreviousQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.buttonCol,
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 20.0),
                      ElevatedButton(
                        onPressed: _loadNextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.buttonCol,
                        ),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
        ),
      ),
    );
  }
}
