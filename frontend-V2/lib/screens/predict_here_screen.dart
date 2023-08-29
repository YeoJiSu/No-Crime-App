import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import the Google Maps package
import 'package:geolocator/geolocator.dart';
import 'dart:convert'; // JSON 파싱을 위한 패키지
import 'package:flutter/services.dart' show rootBundle;
// import 'package:http/http.dart' as http;
import 'package:nocrime/models/crime_model.dart';
import 'package:nocrime/services/api_service_crime.dart';
import 'package:nocrime/widgets/crime_ratio_graph.dart';
import 'package:nocrime/widgets/select_box_widget.dart'; // asset 파일 접근을 위한 패키지
import 'package:http/http.dart' as http;

late Future<List<String>> placeList;
late Future<List<String>> dayList;
late Future<List<String>> timeList;

Map<String, dynamic> predictionParms = {
  // default로 값 넣어줬음.
  "first": "서울특별시",
  "second": "중구",
  "위치": "서울중구", // first와 second에 값 넣으면 자동으로 바뀜
  "장소": "노상",
  "요일": "화",
  "시간대": "06:00-08:59",
  "인구수": "95094" // first와 second에 값 넣으면 자동으로 바뀜
};

class PredictHereScreen extends StatefulWidget {
  const PredictHereScreen({super.key});

  @override
  State<PredictHereScreen> createState() => _PredictHereScreenState();
}

class _PredictHereScreenState extends State<PredictHereScreen> {
  CrimeModel crimeModel = CrimeModel();
  late GoogleMapController _controller;
  // 북위 33~43, 동경 124~132도
  double latitude = 37.5665;
  double longitude = 126.9780;
  bool locationStatus = false;
  String _address = '주소를 가져오고 있는 중입니다...';

  late Map<String, dynamic> districts = {};
  String? dropDownValue3;
  String? dropDownValue4;
  String? dropDownValue5;

  bool _offstage = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    placeList = CrimeApiService().getPlaceList();
    dayList = CrimeApiService().getDayList();
    timeList = CrimeApiService().getTimeList();
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&sourcecrs=epsg:4326&output=json',
      ),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': "네이버 client id",
        'X-NCP-APIGW-API-KEY': "네이버 client secret",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      if (results != null && results.isNotEmpty) {
        final address = results[0]['region']['area1']['name'] +
            '/' +
            results[0]['region']['area2']['name'] +
            '/' +
            results[0]['region']['area3']['name'] +
            '/' +
            results[0]['region']['area4']['name'];

        return address;
      }
    }
    return 'No address';
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        locationStatus = false;
      });
    } else {
      String jsonData = await rootBundle.loadString('assets/district.json');
      districts = json.decode(jsonData);
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        String address = await getAddressFromCoordinates(
            position.latitude, position.longitude);

        if (address == "No address") {
          print("get함수를 못써요");
          return;
        }
        String addr0 = address.split("/")[0];
        String addr1 = address.split("/")[1];
        String addr2 = address.split("/")[2];
        String addr3 = address.split("/")[3];

        if (districts.containsKey(addr0)) {
          predictionParms["first"] = addr0;
          List<String> localityList = List<String>.from(districts[addr0]);
          if (localityList.contains(addr1)) {
            predictionParms["second"] = addr1;
          } else {
            predictionParms["second"] = "전체";
          }
        } else {
          print("message: $addr0는 jsonData에 없습니다. ");
        }

        setState(() {
          locationStatus = true;
          latitude = position.latitude;
          longitude = position.longitude;
          districts = json.decode(jsonData);
          _address = '실시간 나의 위치: $addr0 $addr1 $addr2 $addr3';
        });
      } catch (e) {
        print("error1: $e");

        setState(() {
          locationStatus = true;
          _address = "죄송합니다. 주소를 가져올 수 없습니다!!";
        });
      }
    }
  }

  void _onTap() async {
    String text = "모든";

    if (dropDownValue3 == null) {
      text = "첫번째 '장소' ";
    } else if (dropDownValue4 == null) {
      text = "두번째 '요일' ";
    } else if (dropDownValue5 == null) {
      text = "세번째 '시간대' ";
    }

    if (dropDownValue3 == null ||
        dropDownValue4 == null ||
        dropDownValue5 == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 설정
            side: const BorderSide(
                color: Color.fromARGB(255, 168, 226, 191), width: 3),
          ),
          backgroundColor: const Color.fromRGBO(29, 29, 37, 1),
          title: const Text(
            "🚨 경고 🚨",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          content: Text(
            "$text 선택 상자에서 값을 선택해주세요!",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "넹",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // 로딩 중에는 SpinKit를 보여줍니다.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(
          color: Color.fromRGBO(128, 255, 179, 1), // 로딩 애니메이션 색상 설정
          size: 60, // 로딩 애니메이션 크기 설정
        ),
      ),
    );

    try {
      crimeModel = await CrimeApiService().getCrimeModel(predictionParms);

      setState(() {
        _offstage = false;
      });
    } catch (e) {
      print("error2: $e");
    }

    // 로딩 다이얼로그 닫기
    Navigator.pop(context);
  }

  void setValue3(String? value) {
    setState(() {
      _offstage = true;
      dropDownValue3 = value;
      predictionParms["장소"] = value;
    });
  }

  void setValue4(String? value) {
    setState(() {
      _offstage = true;
      dropDownValue4 = value;
    });
  }

  void setValue5(String? value) {
    setState(() {
      _offstage = true;
      dropDownValue5 = value;
    });
  }

  int getDayNum(String? weekday) {
    switch (weekday) {
      case '월':
        return 1;
      case '화':
        return 2;
      case '수':
        return 3;
      case '목':
        return 4;
      case '금':
        return 5;
      case '토':
        return 6;
      case '일':
        return 7;
      default:
        return 0;
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
    int todayDayNum = DateTime.now().weekday; // 1,2,3,4,5,6,7
    int predictDayNum = getDayNum(dropDownValue4);
    int diff = (predictDayNum - todayDayNum + 7) % 7;

    List<String> yearMonthDay = DateTime.now()
        .add(Duration(days: diff))
        .toString()
        .split(' ')[0]
        .split('-');
    String month = yearMonthDay[1];
    String day = yearMonthDay[2];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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
        SizedBox(
          height: 45,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              "📍 $_address",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
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
        const SizedBox(
          height: 20,
        ),
        const Text(
          " 🚔 현재 위치 5대 범죄 안전도 예측하기!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectBoxWidget(
                    key: const Key("장소"),
                    future: placeList,
                    hint: '장소',
                    dropDownValue: dropDownValue3,
                    onChanged: setValue3,
                  ),
                  SelectBoxWidget(
                    key: const Key("요일"),
                    future: dayList,
                    hint: '요일',
                    dropDownValue: dropDownValue4,
                    onChanged: setValue4,
                  ),
                  SelectBoxWidget(
                    key: const Key("시간대"),
                    future: timeList,
                    hint: '시간대',
                    dropDownValue: dropDownValue5,
                    onChanged: setValue5,
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Align(
                heightFactor: 1,
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 40),
                    backgroundColor: const Color.fromRGBO(131, 131, 255, 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 모서리를 둥글게 설정
                    ),
                  ),
                  onPressed: _onTap,
                  child: const Text(
                    "예측하기",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Offstage(
              offstage: _offstage,
              child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🚔 예측 결과",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "아래는 5대 범죄별 '안전도' 수치를 나타낸 그래프입니다! 수치가 높을수록 해당 범죄에 대해 안전합니다 😊",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CrimeRatioGraph(
                        crimeModel: crimeModel,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: diff == 0
                                  ? "오늘 $month월 $day일 ${predictionParms["요일"]}요일 ${predictionParms["시간대"]} 시간 동안에, "
                                  : '$diff일 후, $month월 $day일 ${predictionParms["요일"]}요일 ${predictionParms["시간대"]} 시간 동안에, ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${predictionParms["first"]} ${predictionParms["second"]}의 ${predictionParms['장소']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const TextSpan(
                              text: '은 "',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: crimeModel.getBestRatioType(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(128, 255, 179, 1),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const TextSpan(
                              text: ' 안전도"는 높지만, "',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: crimeModel.getWorstRatioType(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(128, 255, 179, 1),
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 안전도"는 낮으니 주의하셔야 합니다!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
