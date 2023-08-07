import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'widget/auth_format.dart';
import 'widget/auth_input_field_widget.dart';
import 'widget/push_button_widget.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: const SafeArea(
          child: AuthFormat(
        tabText: '아이디 찾기',
        children: [
          LoginInputField(hintText: "등록하신 이메일을 입력해주세요"),
          SizedBox(height: 20),
          PushButton(text: "확인"),
        ],
      )),
    );
  }
}
