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

class MenuPageItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imgPath;

  MenuPageItem(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 200,
      decoration: BoxDecoration(
          // color: Colors.blue[600],
          border: Border.all(color: Colors.blue[600]!, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imgPath, width: 80, height: 80),
          Text(title,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
          Text(subTitle,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
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
