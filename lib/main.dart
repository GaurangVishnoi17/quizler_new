import 'package:flutter/material.dart';
import 'quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/second',
      routes: {
        '/': (context) => Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: LoginPage(),
                ),
              ),
            ),
        '/second': (context) => QuizPage()
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Login Page'),
    );
  }
}

class QuizPage extends StatefulWidget {
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    bool isLoaded = await quizBrain.fetchQuestions();
    setState(() {
      _loading =
          !isLoaded; // Set loading to false if questions are loaded successfully
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
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
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
  }
}
