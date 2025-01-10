import 'package:agritek/Authentication/auth.dart';
import 'package:agritek/farmguide.dart';
import 'package:agritek/homepage.dart';
import 'package:agritek/Login/login.dart';
import 'package:agritek/welcome_page.dart'; // Import your WelcomePage
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool _showWelcomePage = true; // Tracks if the WelcomePage should be shown

  @override
  void initState() {
    super.initState();
    _checkWelcomePageStatus(); // Check if the user has already seen the WelcomePage
  }

  Future<void> _checkWelcomePageStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Check the saved flag to determine whether to show the WelcomePage
      _showWelcomePage = prefs.getBool('hasSeenWelcomePage') ?? true;
    });
  }

  Future<void> _markWelcomePageSeen() async {
    final prefs = await SharedPreferences.getInstance();
    // Save the flag to indicate the WelcomePage has been seen
    await prefs.setBool('hasSeenWelcomePage', false);
  }

  @override
  Widget build(BuildContext context) {
    // Show WelcomePage if it hasn't been seen
    if (_showWelcomePage) {
      return WelcomePage(
        onComplete: () async {
          // Mark the WelcomePage as seen and update the state
          await _markWelcomePageSeen();
          setState(() {
            _showWelcomePage = false;
          });
        },
      );
    }

    // Proceed to the regular app flow after the WelcomePage
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage(); // Navigate to HomePage if user is authenticated
        } else {
          return const StartupPage(); // Navigate to StartupPage if not authenticated
        }
      },
    );
  }
}
