import 'package:flutter/material.dart';
import './../path.dart';
import 'package:quizzler/classes/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../helper.dart';

final storage = FlutterSecureStorage();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
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
    return User(data['id'], data['firstname'], data['lastname'], data['email']);
  } else if (response.statusCode == 401) {
    // await refreshToken(); // token expired
    return await fetchProfile(); // retry
  }
  throw Exception('Failed to fetch profile');
}

class _MainPageState extends State<MainPage> {
  String? userName;
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final response = await fetchProfile();
    if (!mounted) return;
    setState(() {
      user = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lime[50],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WELCOME BACK,',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4),
                Text(
                  capitalize(
                      '${user?.firstname ?? ''} ${user?.lastname ?? ''}'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Text('Main Page'),
          ],
        ),
      ),
      body: const Center(child: Text('main page')),
    );
  }
}
