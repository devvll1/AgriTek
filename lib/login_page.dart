import 'package:agritek/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Padding(
        padding: EdgeInsets.all(155),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/letterboxd.png',
            ),
            SizedBox(
              height: 16,
            ),
            Text('Numberboxd',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 16,
            ),
            Text(
              'My Movie Diary and Ratings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 47,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 207, 0)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                    print('Log in is clicked');
                  },
                  child:
                      Text('ENTER', style: TextStyle(color: AppColor.white))),
            ),
            SizedBox(
              height: 76,
            ),
          ],
        ),
      ),
    );
  }
}
