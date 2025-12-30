import 'package:flutter/material.dart';
import 'package:quizzler/classes/user.dart';
import '../widgets/common_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../path.dart';
import '../classes/login_response.dart';
import '../enum/enum.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = true;
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<LoginResponse> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password required')),
      );
      return LoginResponse(status: LoginStatus.missingFields);
    }

    setState(() {
      isLoading = true;
    });

    try {
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

      final decodedBody = jsonDecode(response.body);

      if (response.statusCode == 200 && decodedBody['success'] == true) {
        return LoginResponse(
          status: LoginStatus.success,
          user: User.fromJson(decodedBody['user']),
        );
        // set data to local storage or phone storage if login is sucessful.
        // return decodedBody['user'];
      } else if (response.statusCode == 400) {
        return LoginResponse(
            status: LoginStatus.missingFields,
            message: 'All fields are required');
      } else if (response.statusCode == 401) {
        return LoginResponse(
          status: LoginStatus.invalidCredentials,
          message: 'Invalid email or password',
        );
      } else if (response.statusCode == 500) {
        return LoginResponse(
          status: LoginStatus.serverError,
          message: 'Server error',
        );
      }
      return LoginResponse(
        status: LoginStatus.unknownError,
        message: 'Something went wrong',
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      return LoginResponse(
        status: LoginStatus.networkError,
        message: 'No internet connection',
      );
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
                    onPressed: () async {
                      // No need to print the value if the values are set in to some storages.
                      final LoginResponse response = await login();

                      print(response.status);
                      if (mounted && response.status == LoginStatus.success) {
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
