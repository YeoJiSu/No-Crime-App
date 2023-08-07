import 'package:crime/auth_screen/widget/push_button_widget.dart';
import 'package:flutter/material.dart';

class EmergencyCallBox extends StatelessWidget {
  const EmergencyCallBox({super.key});

  @override
  Widget build(BuildContext context) {
    void onTapCancel(BuildContext context) {
      Navigator.of(context).pop();
    }

    return SizedBox(
      height: 150,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("정말 현재 위치가 위험하다고 신고 하시겠습니까?"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PushButton(
                text: "네",
                width: 70,
              ),
              const SizedBox(width: 30),
              PushButton(
                text: "아니오",
                width: 70,
                onTap: () => onTapCancel(context),
              )
            ],
          )
        ],
      )),
    );
  }
}
