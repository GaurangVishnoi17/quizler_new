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
            // settings button on right side of header
            IconButton(
              icon: Icon(Icons.settings, color: Colors.black87, size: 28),
              iconSize: 32,
              onPressed: () {
                // TODO: navigate to settings page
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lime[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 129, 177, 102),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Container(),
                // Container(),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
