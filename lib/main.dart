import 'package:agritek/CropFarming/crop_farming.dart';
import 'package:agritek/CropFarming/croptypes.dart';
import 'package:agritek/CropFarming/vegetables/ampalaya.dart';
import 'package:agritek/CropFarming/vegetables/vegetable.dart';
import 'package:flutter/material.dart';
import 'package:agritek/home_page.dart';
import 'package:agritek/startup_page.dart';

// Your custom color class
class AppColor {
  static const Color background = Color(0xFFE5E5E5);
  // Add more custom colors here
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Urbanist',
        scaffoldBackgroundColor: AppColor.background,
        // You can add more theme properties here
      ),
      home: const StartupPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/cropfarming': (context) => CropFarmingScreen(),
        '/croptypes': (context) => TypeOfCropsScreen(),
        '/vegetables': (context) => VegetablesApp(),
        '/ampalaya': (context) => Ampalaya(),
      },
    );
  }
}
