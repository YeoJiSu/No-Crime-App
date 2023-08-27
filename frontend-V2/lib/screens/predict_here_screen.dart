import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import the Google Maps package
import 'package:geolocator/geolocator.dart';

class PredictHereScreen extends StatefulWidget {
  const PredictHereScreen({super.key});

  @override
  State<PredictHereScreen> createState() => _PredictHereScreenState();
}

class _PredictHereScreenState extends State<PredictHereScreen> {
  late GoogleMapController _controller;

  double latitude = 37;
  double longitude = 127;
  bool locationStatus = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        locationStatus = false;
      });
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        locationStatus = true;
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
  }

  void _updateMapPosition() {
    CameraPosition newPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.0,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (locationStatus == false)
          Column(
            children: [
              ListTile(
                iconColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '잠시만요!  ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Container(), // 초기에는 아무 내용도 표시하지 않음
                secondChild: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                      ),
                      child: Flexible(
                        child: Text(
                          '현재 실시간 위치 정보로 예측을 하려면 앱 내 위치 접근 허용을 해줘야해요!  📱 설정 -> nocrime -> 위치 허용',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                          maxLines: 2, // 최대 두 줄까지 표시
                          overflow: TextOverflow.ellipsis, // 생략 부호 (...) 표시
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 45,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              "📍 경기도 안성시 죽산면 죽산 초교길 69-4 주소 길면 옆으로 스크롤 가능함",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          height: 300, // Set an appropriate height
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20), // Add this line for rounded corners
          ),
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37, 127),
              zoom: 12.0,
            ),
            myLocationEnabled: true, // Show user's location
            markers: <Marker>{
              Marker(
                markerId: const MarkerId("user_location"),
                position:
                    LatLng(latitude, longitude), // User's current position
                infoWindow: const InfoWindow(title: "Your Location"),
              ),
            },
            onMapCreated: (controller) {
              _controller = controller;
              _updateMapPosition(); // Update map camera position after map is created
            },
          ),
        ),
      ],
    );
  }
}
