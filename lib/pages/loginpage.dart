import 'package:flutter/material.dart';
import '../widgets/common_text_field.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool x = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF003366), // Deep Blue
                Color(0xFF66CCFF), // Light Blue
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                // Text fields
                const CommonTextField(label: 'USERNAME'),
                const CommonTextField(label: 'PASSWORD', obscureText: true),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      padding: const EdgeInsets.symmetric(
                        // Add padding
                        vertical: 20,
                        horizontal: 24,
                      ),
                      side: const BorderSide(
                        color: Colors.white, // Border color
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      if (x) {
                        Navigator.pushNamed(
                            context, '/quizpage'); // <-- Routing here
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontWeight: FontWeight.bold, // Bold text
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
