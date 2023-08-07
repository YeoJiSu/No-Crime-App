import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'auth_input_field_widget.dart';

class SignUpInputField extends StatefulWidget {
  const SignUpInputField({
    super.key,
    required this.hintText,
    required this.suffixText,
  });
  final String hintText;
  final String suffixText;
  @override
  State<SignUpInputField> createState() => _SignUpInputFieldState();
}

class _SignUpInputFieldState extends State<SignUpInputField> {
  void _onTap() {}
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LoginInputField(hintText: widget.hintText),
        Positioned(
            right: 3,
            top: 4,
            child: GestureDetector(
              onTap: _onTap,
              child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  decoration: const BoxDecoration(
                      borderRadius: radius_5, color: mainColor),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(widget.suffixText)),
            )),
      ],
    );
  }
}
