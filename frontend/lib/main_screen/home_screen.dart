import 'package:crime/main_screen/drawer/drawer.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'widgets/my_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routesName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "No crime",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      endDrawer: MyDrawer(height: height, width: width),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            children: [
              Text("현재 나의 위치",
                  style: Theme.of(context).textTheme.headlineSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: Image.asset(
                          "assets/images/image1.png",
                        )),
                    const SizedBox(height: 20),
                    Flexible(
                      fit: FlexFit.tight,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  color: boxColor,
                                  alignment: Alignment.center,
                                  child: const Text("현재 나의 위치 범죄 안전도 예측하기"),
                                ),
                                Center(
                                  child: Icon(
                                    Icons.question_mark_sharp,
                                    size:
                                        MediaQuery.of(context).size.height / 4,
                                  ),
                                ),
                              ]),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: boxColor,
                            child: const Center(child: Text("그래프")),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
