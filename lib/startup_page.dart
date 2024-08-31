import 'package:agritek/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Container(
          width: 393,
          height: 852,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'AgriTek',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Your Agriculture Companion',
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
                      backgroundColor: Color.fromARGB(255, 7, 207, 0),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                      print('Log in is clicked');
                    },
                    child:
                        Text('ENTER', style: TextStyle(color: AppColor.white)),
                  ),
                ),
                SizedBox(
                  height: 76,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
