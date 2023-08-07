import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'widget/auth_format.dart';
import 'widget/auth_input_field_widget.dart';
import 'widget/push_button_widget.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: const AuthFormat(
        tabText: "비밀번호 찾기",
        children: [
          LoginInputField(hintText: "등록하신 이메일을 입력해주세요"),
          SizedBox(height: 20),
          PushButton(text: "확인"),
        ],
      ),
    );
  }
}
