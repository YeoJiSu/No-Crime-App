import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nocrime/models/crime_model.dart';
import 'package:nocrime/models/population_model.dart';
import 'package:nocrime/services/api_service_crime.dart';
import 'package:nocrime/widgets/crime_ratio_graph.dart';
import 'package:nocrime/widgets/select_box_widget.dart';

late Future<List<CrimeModel>> crimeList;
late Future<PopulationModel> populationModel;

late Future<List<String>> districtList;
Future<List<String>> secondDistrictList = Future(() => []);
late Future<List<String>> placeList;
late Future<List<String>> dayList;
late Future<List<String>> timeList;

Map<String, dynamic> predictionParms = {};

class PredictOtherScreen extends StatefulWidget {
  const PredictOtherScreen({super.key});

  @override
  State<PredictOtherScreen> createState() => _PredictOtherScreenState();
}

class _PredictOtherScreenState extends State<PredictOtherScreen> {
  CrimeModel crimeModel = CrimeModel();
  String? dropDownValue1;
  String? dropDownValue2;
  String? dropDownValue3;
  String? dropDownValue4;
  String? dropDownValue5;

  bool _offstage = true;

  @override
  void initState() {
    super.initState();
    districtList = CrimeApiService().getDistrict();
    placeList = CrimeApiService().getPlaceList();
    dayList = CrimeApiService().getDayList();
    timeList = CrimeApiService().getTimeList();
  }

  void _onTap() async {
    String text = "모든";
    if (dropDownValue1 == null) {
      text = "첫번째 '도/특별시/광역시' ";
    } else if (dropDownValue2 == null) {
      text = "두번째 '시/군/구' ";
    } else if (dropDownValue3 == null) {
      text = "세번째 '장소' ";
    } else if (dropDownValue4 == null) {
      text = "네번째 '요일' ";
    } else if (dropDownValue5 == null) {
      text = "다섯번째 '시간대' ";
    }
    if (dropDownValue1 == "세종특별자치시" &&
        dropDownValue2 == null &&
        dropDownValue3 != null &&
        dropDownValue4 != null &&
        dropDownValue5 != null) {
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
      crimeModel = await CrimeApiService().getCrimeModel(predictionParms);
      setState(() {
        _offstage = false;
        dropDownValue2 = "";
      });
      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      return;
    }

    if (dropDownValue1 == null ||
        dropDownValue2 == null ||
        dropDownValue3 == null ||
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

    crimeModel = await CrimeApiService().getCrimeModel(predictionParms);
    print(predictionParms);
    setState(() {
      _offstage = false;
    });

    // 로딩 다이얼로그 닫기
    Navigator.pop(context);
  }

  void setValue1(String? value) {
    setState(() {
      _offstage = true;
      dropDownValue2 = null;
      dropDownValue1 = value;
      if (value != null) {
        secondDistrictList = CrimeApiService().getSecondDistrictList(value);
      }
    });
  }

  void setValue2(String? value) {
    setState(() {
      _offstage = true;
      dropDownValue2 = value;
    });
  }

  void setValue3(String? value) {
    setState(() {
      _offstage = true;
      dropDownValue3 = value;
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

    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 29, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(29, 29, 37, 1),
        leadingWidth: 250,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              '다른 지역 예측하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // Swiped from left to right (backwards)
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🚔 5대 범죄 안전도를 예측할 수 있어요!",
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
                                key: const Key("first"),
                                future: districtList,
                                dropDownValue: dropDownValue1,
                                onChanged: setValue1,
                                hint: '도/특별시/광역시',
                              ),
                              SelectBoxWidget(
                                key: const Key("second"),
                                future: secondDistrictList,
                                dropDownValue: dropDownValue2,
                                hint: '시/군/구',
                                onChanged: setValue2,
                              ),
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
                            heightFactor: 5.4,
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 40),
                                backgroundColor:
                                    const Color.fromRGBO(131, 131, 255, 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // 모서리를 둥글게 설정
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
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
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
                                              '$dropDownValue1 $dropDownValue2의 ${predictionParms['장소']}',
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
                                            color: Color.fromRGBO(
                                                128, 255, 179, 1),
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
                                              text: crimeModel
                                                  .getWorstRatioType(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    128, 255, 179, 1),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
