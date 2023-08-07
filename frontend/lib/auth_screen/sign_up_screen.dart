import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'widget/auth_format.dart';
import 'widget/auth_input_field_widget.dart';
import 'widget/auth_signup_field_widget.dart';
import 'widget/push_button_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: AuthFormat(
            tabText: "회원가입",
            children: [
              SizedBox(height: 10),
              SignUpInputField(hintText: "아이디", suffixText: "중복확인"),
              SizedBox(height: 10),
              LoginInputField(hintText: "닉네임"),
              SizedBox(height: 10),
              LoginInputField(hintText: "비밀번호"),
              SizedBox(height: 10),
              LoginInputField(hintText: "비밀번호 확인"),
              SizedBox(height: 10),
              SignUpInputField(hintText: "이메일", suffixText: "인증하기"),
              SizedBox(height: 10),
              SignUpInputField(hintText: "이메일 인증 번호 입력", suffixText: "확인"),
              SizedBox(height: 100),
              PushButton(text: "회원가입 완료")
            ],
          ),
        ),
      ),
    );
  }
}
