import 'package:flutter/material.dart';
import 'pages/loginpage.dart';
import 'pages/quizpage.dart';
import 'pages/mainpage.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      routes: {
        '/': (context) => LoginPage(),
        '/quizpage': (context) => QuizPage(),
        '/mainpage': (context) => MainPage(),
      },
    );
  }
}
