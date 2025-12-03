import 'dart:convert';
import 'questions.dart';
import 'package:http/http.dart' as http;

class QuizBrain {
  int _questionNumber = 0;

  List<Question> _questionBank = [];

  // Fetch questions from the API and map them to Question objects using the fromJson factory constructor
  Future<bool> fetchQuestions() async {
    final fetchedQuestions =
        await http.get(Uri.parse('http://10.192.158.62:3000/api/questions/get'));
    final List<dynamic> data = jsonDecode(fetchedQuestions.body);
    _questionBank = data.map((item) => Question.fromJson(item)).toList();
    return true;
  }

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }

  String getQuestion() {
    return _questionBank[_questionNumber].questionText;
  }

  bool getAnswer() {
    return _questionBank[_questionNumber].answerVal;
  }

  bool isFinished() {
    return _questionNumber == _questionBank.length - 1;
  }

  void resetQuiz() {
    _questionNumber = 0;
  }
}

// Basic code to fetch data from the server
    // if (kDebugMode) {
    //   print("fetching details from server");
    //   try {
    //     if (fetchedQuestions.statusCode == 200) {
    //       String data = fetchedQuestions.body;
    //       var decodedData = jsonDecode(data);
    //       print(decodedData);
    //     } else {
    //       print("Error: ${fetchedQuestions.statusCode}");
    //     }
    //   } catch (e) {
    //     print("Error: $e");
    //   }
    //   // print(fetchedQuestions);
    // }