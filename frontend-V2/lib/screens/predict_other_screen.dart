import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nocrime/models/crime_model.dart';
import 'package:nocrime/models/population_model.dart';
import 'package:nocrime/services/api_service_crime.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
      text = "첫번째";
    } else if (dropDownValue2 == null) {
      text = "두번째";
    } else if (dropDownValue3 == null) {
      text = "세번째";
    } else if (dropDownValue4 == null) {
      text = "네번째";
    } else if (dropDownValue5 == null) {
      text = "다섯번째";
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                      " 5대 범죄 안전도를 예측할 수 있어요!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                            heightFactor: 6.85,
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 47),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
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
                                    "[ 예측 결과 ]",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
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
                                            fontSize: 18,
                                            height: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '$dropDownValue1 $dropDownValue2의 ${predictionParms['장소']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            height: 1.5,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '은 "',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            height: 1.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: crimeModel.getBestRatioType(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18,
                                            height: 1.5,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' 안전도"는 높지만, "',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
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
                                                color: Colors.white,
                                                fontSize: 18,
                                                height: 1.5,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' 안전도"는 낮으니 주의하셔야 합니다!',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
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

class SelectBoxWidget extends StatefulWidget {
  final Future<List<String>> future;
  final String hint;
  final void Function(String) onChanged;
  final String? dropDownValue;

  const SelectBoxWidget({
    required Key key,
    required this.future,
    required this.dropDownValue,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectBoxWidget> createState() => _SelectBoxWidgetState();
}

class _SelectBoxWidgetState extends State<SelectBoxWidget> {
  String? dropDownValue;

  void setPredictionParms(String? value) {
    var keyTag = widget.key.toString();
    predictionParms[
        keyTag.substring(2, keyTag.length - 2).replaceAll('\'', '')] = value;
  }

  @override
  Widget build(BuildContext context) {
    const double paddingSize = 11;
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 0, top: paddingSize, bottom: paddingSize),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(131, 131, 255, 0.4),
                    border:
                        Border.all(strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton(
                    elevation: 8,
                    dropdownColor: const Color.fromARGB(255, 37, 37, 47),
                    value: widget.dropDownValue,
                    hint: Text(
                      widget.hint,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                    menuMaxHeight: 400,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print('$value');
                      if (value != null) {
                        widget.onChanged(value);
                        setPredictionParms(value);
                      }
                    },
                  ),
                ),
              )
            : const CircularProgressIndicator();
      },
      future: widget.future,
    );
  }
}

class CrimeRatioGraph extends StatelessWidget {
  const CrimeRatioGraph({
    super.key,
    required this.crimeModel,
  });

  final CrimeModel crimeModel;
  @override
  Widget build(BuildContext context) {
    int ratio1 = crimeModel.theft;
    int ratio2 = crimeModel.murder;
    int ratio3 = crimeModel.robbery;
    int ratio4 = crimeModel.sexual_assault;
    int ratio5 = crimeModel.assault;
    List<int> ratios = [ratio1, ratio2, ratio3, ratio4, ratio5];
    ratios.sort();

    Color getMatchColor(int crimeRatio) {
      Color matchColor = Colors.blue;

      if (crimeRatio == ratios[0]) {
        matchColor = Colors.red;
      } else if (crimeRatio == ratios[1]) {
        matchColor = Colors.orange;
      } else if (crimeRatio == ratios[2]) {
        matchColor = Colors.yellow;
      } else if (crimeRatio == ratios[3]) {
        matchColor = Colors.green;
      } else if (crimeRatio == ratios[4]) {
        matchColor = Colors.blue;
      }

      return matchColor;
    }

    final List<charts.Series<CrimeData, String>> seriesList = [
      charts.Series<CrimeData, String>(
        id: 'Crimes',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            const Color.fromARGB(255, 66, 63, 73)),
        domainFn: (CrimeData crime, _) => crime.crimeType,
        measureFn: (CrimeData crime, _) => crime.percentage,
        data: [
          CrimeData('절도', ratio1),
          CrimeData('살인', ratio2),
          CrimeData('강도', ratio3),
          CrimeData('성폭력', ratio4),
          CrimeData('폭행', ratio5),
        ],
      ),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 9, color: getMatchColor(ratio1)),
                  ),
                  child: Text(
                    "$ratio1%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "절도 안전도",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 9, color: getMatchColor(ratio2)),
                  ),
                  child: Text(
                    "$ratio2%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "살인 안전도",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 9, color: getMatchColor(ratio3)),
                  ),
                  child: Text(
                    "$ratio3%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "강도 안전도",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 9, color: getMatchColor(ratio4)),
                  ),
                  child: Text(
                    "$ratio4%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "성폭력 안전도",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 9, color: getMatchColor(ratio5)),
                  ),
                  child: Text(
                    "$ratio5%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "폭력 안전도",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400, // 적절한 너비를 설정해주세요
              height: 240, // 적절한 높이를 설정해주세요

              child: charts.BarChart(
                seriesList,
                animate: true,
                vertical: false, // 수평 막대 그래프 설정

                defaultRenderer: charts.BarRendererConfig(
                  // 여기서 색깔을 지정합니다.

                  cornerStrategy: const charts.ConstCornerStrategy(30),
                  groupingType: charts.BarGroupingType.stacked,
                  fillPattern: charts.FillPatternType.solid,
                  strokeWidthPx: 2.0,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  customRendererId: 'customColor',

                  // 막대 그래프의 색상을 변경하는 방법입니다.
                  // 리스트의 각 항목에 색상을 할당합니다.
                  // 여기서는 colors 리스트를 임의로 지정하겠습니다.
                  // colors: [charts.ColorUtil.fromDartColor(Colors.blue), charts.ColorUtil.fromDartColor(Colors.red), ...],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CrimeData {
  final String crimeType;
  final int percentage;

  CrimeData(this.crimeType, this.percentage);
}
