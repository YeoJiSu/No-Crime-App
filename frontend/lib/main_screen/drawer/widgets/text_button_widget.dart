import 'package:flutter/material.dart';

class MyPageTextButton extends StatelessWidget {
  const MyPageTextButton(
    this.text, {
    super.key,
    required this.onTap,
  });
  final String text;
  final Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(context), child: ListTile(title: Text(text)));
  }
}
