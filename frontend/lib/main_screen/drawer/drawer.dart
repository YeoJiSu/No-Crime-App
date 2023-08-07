import 'package:crime/main_screen/drawer/inquiring_screen/inquiring_screen.dart';
import 'package:crime/main_screen/drawer/my_page_screen/my_page_screen.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'safety_prediction/prediction_screen.dart';
import 'widgets/my_info_widget.dart';
import 'widgets/text_button_widget.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  void _moveMyPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyPageScreen(),
        ));
  }

  void _moveSettingScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingScreen(),
    ));
  }

  void _moveSafetyPrediction(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PredictionScreen(),
    ));
  }

  void _moveSafetyInquiring(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const InquiringScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: height * 0.1,
          bottom: kBottomNavigationBarHeight,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45), bottomLeft: Radius.circular(45)),
            child: Container(
              height: height * 0.85,
              width: width * 0.8,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      color: mainColor,
                      padding: informationPadding,
                      child: const MyInfoWidget()),
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      MyPageTextButton(
                        "마이페이지",
                        onTap: (context) => _moveMyPage(context),
                      ),
                      MyPageTextButton(
                        "메인 화면",
                        onTap: (context) => Navigator.of(context).pop(),
                      ),
                      MyPageTextButton(
                        "범죄 안전도 예측하기",
                        onTap: (context) => _moveSafetyPrediction(context),
                      ),
                      MyPageTextButton(
                        "지역별 범죄 조회하기",
                        onTap: (context) => _moveSafetyInquiring(context),
                      ),
                      MyPageTextButton(
                        "설정",
                        onTap: (context) => _moveSettingScreen(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: height * 0.1,
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.cancel)),
        )
      ],
    );
  }
}
