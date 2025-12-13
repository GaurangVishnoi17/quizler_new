import 'package:flutter/material.dart';
import '../widgets/common_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../path.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = true;
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password required')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('$apiPath' 'users/login');
      final response = await http.post(
        Uri.parse('$apiPath' 'users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      isLoading = false;

      print(response);
        print(jsonDecode(response.body));

      if (response.statusCode == 200) {
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                CommonTextField(
                  label: 'USERNAME',
                  controller: emailController,
                ),
                CommonTextField(
                    label: 'PASSWORD',
                    controller: passwordController,
                    obscureText: true),
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
                      String email = emailController.text;
                      String password = passwordController.text;

                      login();

                      if (1 == 1) {
                        // Navigator.pushNamed(
                        //     context, '/quizpage'); // <-- Routing here
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
