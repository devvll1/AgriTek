import 'package:agritek/Auth/login.dart';
import 'package:agritek/CropFarming/crop_farming.dart';
import 'package:agritek/CropFarming/croptypes.dart';
import 'package:agritek/CropFarming/vegetables/ampalaya.dart';
import 'package:agritek/CropFarming/vegetables/vegetable.dart';
import 'package:flutter/material.dart';
import 'package:agritek/home_page.dart';
import 'package:agritek/startup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Your custom color class
class AppColor {
  static const Color background = Color(0xFFE5E5E5);
  // Add more custom colors here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/register': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/cropfarming': (context) => const CropFarmingScreen(),
        '/croptypes': (context) => const TypeOfCropsScreen(),
        '/vegetables': (context) => const VegetablesApp(),
        '/ampalaya': (context) => const Ampalaya(),
      },
    );
  }
}
