import 'package:flutter/material.dart';
import 'package:nocrime/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          fullscreenDialog: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(29, 29, 37, 1),
      body: Center(
        child: Text(
          "No Crime",
          style: TextStyle(
            color: Color.fromRGBO(128, 255, 179, 1),
            fontSize: 45,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
