import 'package:crime/auth_screen/widget/push_button_widget.dart';
import 'package:crime/main_screen/drawer/widgets/select_box.dart';
import 'package:crime/main_screen/widgets/my_bottom_nav_bar.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  bool _offstage = true;

  void _onTap() {
    setState(() {
      if (_offstage) {
        _offstage = false;
      } else {
        _offstage = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppbar,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("예측하고 싶은 지역을 골라주세요"),
                Row(
                  children: [
                    const Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectBox(
                            list: list_Do_MetroCity,
                            hint: '도/특별시/광역시',
                          ),
                          SelectBox(
                            list: list_Si_Gun_Gu,
                            hint: '시/군/구',
                          ),
                          SelectBox(
                            list: list_Dong,
                            hint: '읍/면/동',
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Align(
                        heightFactor: 4.5,
                        alignment: Alignment.bottomCenter,
                        child: PushButton(
                          text: "예측하기",
                          onTap: _onTap,
                          width: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Offstage(
                offstage: _offstage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("OO광역시 OO구 OO동"),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints.expand(),
                        color: boxColor,
                        child: const Center(child: Text("그래프")),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
