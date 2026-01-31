import 'package:flutter/material.dart';
import 'package:quizzler/classes/user.dart';
import '../widgets/common_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../path.dart';
import '../classes/login_response.dart';
import '../enum/enum.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class IllustrationImg extends StatelessWidget {
  final String path;
  final double width;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final double angle;

  const IllustrationImg({
    super.key,
    required this.path,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.angle = 0,
    this.width = 10,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Image.asset(
          path,
          width: width,
        ),
      ),
    );
  }
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
        Uri.parse('$apiPath' 'auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'accessToken', value: data['accessToken']);
        await storage.write(key: 'refreshToken', value: data['refreshToken']);
        await storage.write(key: 'email', value: email);
        return LoginResponse(
          status: LoginStatus.success,
        );
      }
      // final response = await http.post(
      //   Uri.parse('$apiPath' 'users/login'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode({
      //     'email': email,
      //     'password': password,
      //   }),
      // );

      // isLoading = false;

      // final decodedBody = jsonDecode(response.body);

      // if (response.statusCode == 200 && decodedBody['success'] == true) {
      //   return LoginResponse(
      //     status: LoginStatus.success,
      //     user: User.fromJson(decodedBody['user']),
      //   );
      //   // set data to local storage or phone storage if login is sucessful.
      //   // return decodedBody['user'];
      // }
      else if (response.statusCode == 400) {
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

  Future<User> fetchProfile() async {
    final token = await storage.read(key: 'accessToken');
    final response = await http.get(
      Uri.parse('$apiPath' 'users/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(
          data['id'], data['firstname'], data['lastname'], data['email']);
    } else if (response.statusCode == 401) {
      await refreshToken(); // token expired
      return await fetchProfile(); // retry
    }
    throw Exception('Failed to fetch profile');
  }

  Future<void> refreshToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    final response = await http.post(
      Uri.parse('$apiPath' 'auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'accessToken', value: data['accessToken']);
    } else {
      // Force logout
      await storage.deleteAll();
      Navigator.pushNamedAndRemoveUntil(
          context, '/loginpage', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.lime[50]),
            child: const Stack(
              children: [
                IllustrationImg(
                  path: 'images/lightbulb.png',
                  bottom: 680,
                  right: 30,
                  angle: 26,
                  width: 40,
                ),
                IllustrationImg(
                  path: 'images/lightbulb.png',
                  bottom: 190,
                  right: 410,
                  angle: 31,
                  width: 55,
                ),
                IllustrationImg(
                  path: 'images/mario-question-mark.png',
                  bottom: 600,
                  right: 450,
                  angle: 31,
                  width: 40,
                ),
                IllustrationImg(
                  path: 'images/question-mark-cartoon.png',
                  bottom: 220,
                  right: 120,
                  angle: 32,
                  width: 100,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 40.0),
                    child: Text(
                      'Quizzler',
                      style: TextStyle(
                          fontSize: 62,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[500]),
                    ),
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
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 45.0, vertical: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.lightBlue, // White background
                        padding: const EdgeInsets.symmetric(
                          // Add padding
                          vertical: 20,
                          horizontal: 24,
                        ),
                        side: const BorderSide(
                          color: Colors.blueAccent, // Border color
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
                        if (response.status == LoginStatus.success) {
                          // final profile = await fetchProfile();
                          // print(profile.firstname);
                          Navigator.pushNamed(
                              context, '/mainpage'); // <-- Routing here
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(response.message ?? 'Login failed')),
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontWeight: FontWeight.bold, // Bold text
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
