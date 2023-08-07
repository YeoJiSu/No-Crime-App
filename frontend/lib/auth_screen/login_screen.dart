import 'package:crime/main_screen/home_screen.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'widget/auth_format.dart';
import 'find_id_screen.dart';
import 'find_pass_screen.dart';
import 'sign_up_screen.dart';
import 'widget/auth_input_field_widget.dart';
import 'widget/push_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _findId() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FindIdScreen()),
    );
  }

  void _findPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FindPasswordScreen()),
    );
  }

  void _moveScreenToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: SafeArea(
        child: AuthFormat(
          tabText: "로그인",
          children: [
            // const SizedBox(height: 10),
            const LoginInputField(hintText: "아이디를 입력해주세요"),
            const SizedBox(height: 20),
            const LoginInputField(hintText: "비밀번호를 입력해주세요"),
            const SizedBox(height: 20),
            PushButton(
              text: "로그인",
              onTap: _moveScreenToHome,
            ),
            // const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _findId,
                  child: const Text("아이디 찾기", style: TextStyle(fontSize: 10)),
                ),
                const Divider(color: Colors.red),
                TextButton(
                  onPressed: _findPassword,
                  child: const Text("비밀번호 찾기", style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton(
                style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: radius_geometry_5)),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ));
                },
                child: const Text("회원가입")),
          ],
        ),
      ),
    );
  }
}
