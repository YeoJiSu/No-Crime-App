import 'package:crime/auth_screen/widget/push_button_widget.dart';
import 'package:crime/main_screen/drawer/drawer.dart';
import 'package:crime/main_screen/drawer/safety_prediction/prediction_screen.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'widgets/my_bottom_nav_bar.dart';

Future<List<String>> locationList = Future(() => []);

class HomeScreen extends StatefulWidget {
  static const String routesName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late GoogleMapController _googleMapController;
  final LatLng _center = const LatLng(35.23409794921352, 129.08066941841653);

  String? dropDownValue;
  void setValue(String? value) {
    setState(() {
      dropDownValue = value;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text(
            "No crime",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        endDrawer: MyDrawer(height: height, width: width),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            children: [
              Text("현재 나의 위치",
                  style: Theme.of(context).textTheme.headlineSmall),
              Stack(
                children: [
                  Positioned(
                    top: 10,
                    child: Container(
                      height: height / 3 + 20,
                      width: width,
                      decoration: const BoxDecoration(color: mainColor),
                      child: const SizedBox(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      height: height / 3,
                      width: width,
                      child: GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: _center, zoom: 15),
                        onMapCreated: _onMapCreated,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("당신은 어느 부근에 있나요?"),
              SelectBox2Widget(
                key: const Key("장소"),
                future: locationList,
                dropDownValue: dropDownValue,
                hint: "장소",
                onChanged: setValue,
              ),
              const PushButton(text: "범죄 안전도 예측하기"),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Flexible(
              //           fit: FlexFit.tight,
              //           child: Image.asset(
              //             "assets/images/image1.png",
              //           )),
              //       const SizedBox(height: 20),
              //       Flexible(
              //         fit: FlexFit.tight,
              //         child: PageView(
              //           controller: _pageController,
              //           children: [
              //             Column(
              //                 crossAxisAlignment: CrossAxisAlignment.stretch,
              //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                 children: [
              //                   Container(
              //                     color: boxColor,
              //                     alignment: Alignment.center,
              //                     child: const Text("현재 나의 위치 범죄 안전도 예측하기"),
              //                   ),
              //                   Center(
              //                     child: Icon(
              //                       Icons.question_mark_sharp,
              //                       size:
              //                           MediaQuery.of(context).size.height / 4,
              //                     ),
              //                   ),
              //                 ]),
              //             Container(
              //               margin: const EdgeInsets.symmetric(horizontal: 10),
              //               color: boxColor,
              //               child: const Center(child: Text("그래프")),
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        bottomNavigationBar: const MyBottomNavBar(),
      ),
    );
  }
}
