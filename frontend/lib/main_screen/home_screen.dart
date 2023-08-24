import 'dart:async';
import 'dart:developer';

import 'package:crime/auth_screen/widget/push_button_widget.dart';
import 'package:crime/main_screen/drawer/drawer.dart';
import 'package:crime/main_screen/drawer/safety_prediction/prediction_screen.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LatLng _center = const LatLng(30, 120);

  String? dropDownValue;
  void setValue(String? value) {
    setState(() {
      dropDownValue = value;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _googleMapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    // _controller.complete(controller);
    // _googleMapController.
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> logCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log("${position.latitude}");
    log("${position.longitude}");
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    _googleMapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLatLng,
          zoom: 15,
        ),
      ),
    );
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
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
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
              PushButton(
                text: "범죄 안전도 예측하기",
                onTap: logCurrentLocation,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
