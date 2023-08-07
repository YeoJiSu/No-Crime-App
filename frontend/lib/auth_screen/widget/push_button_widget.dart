import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

class PushButton extends StatefulWidget {
  const PushButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
  });
  final String text;
  final Function()? onTap;
  final double? width;

  @override
  State<PushButton> createState() => _PushButtonState();
}

class _PushButtonState extends State<PushButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          alignment: Alignment.center,
          width: widget.width,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
              color: mainColor, borderRadius: radius_geometry_5),
          child: Text(widget.text)),
    );
  }
}
