import 'package:flutter/material.dart';
import 'pages/loginpage.dart';
import 'pages/quizpage.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/quizpage': (context) => QuizPage()
      },
    );
  }
}
