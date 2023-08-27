import 'package:flutter/material.dart';
import 'package:nocrime/screens/splash_screen.dart'; // screens 폴더의 splash_screen.dart 임포트

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(), // SplashScreen를 첫 화면으로 지정
    );
  }
}
