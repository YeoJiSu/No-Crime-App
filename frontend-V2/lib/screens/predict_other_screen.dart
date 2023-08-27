import 'package:flutter/material.dart';

class PredictOtherScreen extends StatefulWidget {
  const PredictOtherScreen({super.key});

  @override
  State<PredictOtherScreen> createState() => _PredictOtherScreenState();
}

class _PredictOtherScreenState extends State<PredictOtherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('다른 지역 예측하기')),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swiped from left to right (backwards)
            Navigator.pop(context);
          }
        },
        child: const Center(
          child: Text('Swipe right to go back'),
        ),
      ),
    );
  }
}
