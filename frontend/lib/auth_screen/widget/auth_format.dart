import 'package:flutter/material.dart';

import 'tab_text_widget.dart';

class AuthFormat extends StatelessWidget {
  const AuthFormat({
    super.key,
    required this.tabText,
    required this.children,
  });
  final String tabText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabTextWidget(tabText),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
