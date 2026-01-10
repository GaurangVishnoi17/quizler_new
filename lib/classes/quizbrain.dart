import 'dart:convert';
import 'questions.dart';
import 'package:http/http.dart' as http;
import '../path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class QuizBrain {
  int _questionNumber = 0;

  List<Question> _questionBank = [];

  // Fetch questions from the API and map them to Question objects using the fromJson factory constructor
  Future<int> fetchQuestions() async {
    final token = await storage.read(key: 'accessToken');
    final fetchedQuestions =
        await http.get(Uri.parse('$apiPath' 'questions/get'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (fetchedQuestions.statusCode == 200) {
    final List <dynamic> data = jsonDecode(fetchedQuestions.body);
      _questionBank = data.map((item) => Question.fromJson(item)).toList();
    }
    return fetchedQuestions.statusCode;
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
