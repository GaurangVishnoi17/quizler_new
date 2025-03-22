import 'questions.dart';

class QuizBrain {
  int _questionNumber = 0;

  final List<Question> _questionBank = [
    Question('Question 1', false),
    Question('Question 2', true),
    Question('Question 3', false),
  ];

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
