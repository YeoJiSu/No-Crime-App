import 'package:flutter/material.dart';

class TabTextWidget extends StatelessWidget {
  const TabTextWidget(
    this.tabText, {
    super.key,
  });
  final String tabText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))),
      alignment: Alignment.center,
      child: Text(tabText),
    );
  }
}
