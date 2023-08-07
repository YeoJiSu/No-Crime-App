import 'package:crime/auth_screen/widget/auth_format.dart';
import 'package:crime/auth_screen/widget/auth_input_field_widget.dart';
import 'package:crime/auth_screen/widget/push_button_widget.dart';
import 'package:crime/main_screen/drawer/widgets/my_info_widget.dart';
import 'package:crime/main_screen/drawer/widgets/text_button_widget.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  void _movePasswordChangeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PasswordChangeScreen(),
    ));
  }

  void _moveNicknameChangeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NicknameChangeScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: informationPadding.copyWith(left: 20, right: 30),
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(borderRadius: radius_5, color: boxColor),
              child: const MyInfoWidget(),
            ),
            MyPageTextButton("비밀번호 변경하기",
                onTap: (context) => _movePasswordChangeScreen(context)),
            MyPageTextButton(
              "닉네임 변경하기",
              onTap: (context) => _moveNicknameChangeScreen(context),
            ),
            MyPageTextButton(
              "고객센터",
              onTap: (context) {},
            ),
            MyPageTextButton(
              "로그아웃",
              onTap: (context) {},
            ),
          ],
        ),
      ),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // bool _check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: authAppbar,
        backgroundColor: boxColor,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingToggleList(
                  title: "푸시",
                  subTitle: "앱에서 보내는 정보성 알림을 받을 수 있습니다.",
                ),
                SettingToggleList(
                  title: "이메일",
                  subTitle: "앱에서 보내는 마케팅 알림을 받을 수 있습니다.",
                )
              ],
            ),
          ),
        ));
  }
}

class SettingToggleList extends StatefulWidget {
  const SettingToggleList({
    super.key,
    required this.title,
    this.subTitle,
  });

  final String title;
  final String? subTitle;

  @override
  State<SettingToggleList> createState() => _SettingToggleListState();
}

class _SettingToggleListState extends State<SettingToggleList> {
  bool _setValue = false;
  void _onToggleChanged(bool value) {
    setState(() {
      _setValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              Switch.adaptive(
                  value: _setValue,
                  onChanged: (value) => _onToggleChanged(value))
            ],
          ),
        ),
        if (widget.subTitle != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.subTitle!),
          ),
      ],
    );
  }
}

class PasswordChangeScreen extends StatelessWidget {
  const PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: const SafeArea(
          child: AuthFormat(
        tabText: "비밀번호 변경하기",
        children: [
          SizedBox(height: 20),
          LoginInputField(hintText: "비밀번호"),
          SizedBox(height: 20),
          LoginInputField(hintText: "비밀번호 확인"),
          SizedBox(height: 20),
          PushButton(text: "변경하기")
        ],
      )),
    );
  }
}

class NicknameChangeScreen extends StatelessWidget {
  const NicknameChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: const SafeArea(
          child: AuthFormat(
        tabText: "닉네임 변경하기",
        children: [
          SizedBox(height: 20),
          LoginInputField(hintText: "닉네임"),
          SizedBox(height: 20),
          PushButton(text: "변경하기")
        ],
      )),
    );
  }
}
