import 'package:flutter/material.dart';
import '../classes/quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

class QuizPage extends StatefulWidget {
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _loading;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    int isLoaded = await quizBrain.fetchQuestions();
    setState(() {
      if (isLoaded != 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Something went wrong! we\'re unable to verify your account'),
        ));
      }
      _loading =
          isLoaded; // Set loading to false if questions are loaded successfully
    });
  }

  List<Icon> scoreKeeper = [];
  int correctAnswerCount = 0;

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getAnswer();
    if (correctAnswer == userPickedAnswer) {
      scoreKeeper.add(const Icon(
        Icons.check,
        color: Colors.green,
      ));
      correctAnswerCount++;
    } else {
      scoreKeeper.add(const Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
    setState(() {
      if (quizBrain.isFinished()) {
        showPopup();
        scoreKeeper = [];
        quizBrain.resetQuiz();
        correctAnswerCount = 0;
      } else {
        quizBrain.nextQuestion();
      }
    });
  }

  void showPopup() {
    Alert(
      context: context,
      // type: AlertType.errRor,
      style: const AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
      title: correctAnswerCount >= 2 ? "Wow!" : "ugh!",
      desc: "You scored $correctAnswerCount / ${scoreKeeper.length}",
      buttons: [
        DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ))
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == 200) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quizzler')),
        backgroundColor: Colors.blueGrey[900],
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          quizBrain.getQuestion(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          checkAnswer(true);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          checkAnswer(false);
                        },
                      ),
                    ),
                  ),
                  Row(children: scoreKeeper)
                ],
              )),
        ),
      );
    } else if (_loading == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text(
            'Failed to load questions. Please try again later.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
