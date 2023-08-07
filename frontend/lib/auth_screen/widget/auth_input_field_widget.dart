import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

class LoginInputField extends StatefulWidget {
  final String hintText;
  final Widget? suffix;
  const LoginInputField({
    super.key,
    required this.hintText,
    this.suffix,
  });

  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 10),
          borderRadius: radius_5,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        suffix: widget.suffix,
      ),
    );
  }
}
