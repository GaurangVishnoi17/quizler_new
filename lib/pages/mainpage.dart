import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lime[50],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'WELCOME BACK,',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text('Main Page'),
          ],
        ),
      ),
      body: const Center(
        child: Text('main page'),
      ),
    );
  }
}
