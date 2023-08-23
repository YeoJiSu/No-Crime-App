import 'dart:developer';

import 'package:crime/auth_screen/widget/push_button_widget.dart';
import 'package:crime/main_screen/widgets/my_bottom_nav_bar.dart';
import 'package:crime/models/crime_model.dart';
import 'package:crime/models/population_model.dart';
import 'package:crime/services/api_sevice_crime.dart';
import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

late Future<List<CrimeModel>> crimeList;
late Future<PopulationModel> populationModel;

late Future<List<String>> districtList;
Future<List<String>> secondDistrictList = Future(() => []);
late Future<List<String>> placeList;
late Future<List<String>> dayList;
late Future<List<String>> timeList;

Map<String, dynamic> predictionParms = {};

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
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
    crimeModel = await CrimeApiService().getCrimeModel(predictionParms);
    setState(() {
      _offstage = false;
    });
  }

  void onDistrictChanged(String firstDistrict) {
    setState(() {
      dropDownValue2 = null;
      secondDistrictList =
          CrimeApiService().getSecondDistrictList(firstDistrict);
    });
  }

  void setValue1(String? value) {
    setState(() {
      dropDownValue2 = null;
      dropDownValue1 = value;
      if (value != null) {
        secondDistrictList = CrimeApiService().getSecondDistrictList(value);
      }
    });
  }

  void setValue2(String? value) {
    setState(() {
      dropDownValue2 = value;
    });
  }

  void setValue3(String? value) {
    setState(() {
      dropDownValue3 = value;
    });
  }

  void setValue4(String? value) {
    setState(() {
      dropDownValue4 = value;
    });
  }

  void setValue5(String? value) {
    setState(() {
      dropDownValue5 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> yearMonthDay =
        DateTime.now().toString().split(' ')[0].split('-');
    String month = yearMonthDay[1];
    String day = yearMonthDay[2];

    return Scaffold(
      appBar: authAppbar,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("5대 범죄 안전도를 예측할 수 있어요!"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectBox2Widget(
                              key: const Key("first"),
                              future: districtList,
                              dropDownValue: dropDownValue1,
                              onChanged: setValue1,
                              hint: '도/특별시/광역시',
                            ),
                            SelectBox2Widget(
                              key: const Key("second"),
                              future: secondDistrictList,
                              dropDownValue: dropDownValue2,
                              hint: '시/군/구',
                              onChanged: setValue2,
                            ),
                            SelectBox2Widget(
                              key: const Key("장소"),
                              future: placeList,
                              hint: '장소',
                              dropDownValue: dropDownValue3,
                              onChanged: setValue3,
                            ),
                            SelectBox2Widget(
                              key: const Key("요일"),
                              future: dayList,
                              hint: '요일',
                              dropDownValue: dropDownValue4,
                              onChanged: setValue4,
                            ),
                            SelectBox2Widget(
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
                        flex: 1,
                        child: Align(
                          heightFactor: 8.05,
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
              const Text("5대 범죄도 예측 결과!"),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Offstage(
                    offstage: _offstage,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Column(
                        children: [
                          const Text("막대 이미지"),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 20,
                            spacing: constraints.maxWidth / 4,
                            children: [
                              CrimeRatioGraph(
                                crimeModel: crimeModel,
                                crimeType: "절도",
                              ),
                              CrimeRatioGraph(
                                crimeModel: crimeModel,
                                crimeType: "살인",
                              ),
                              CrimeRatioGraph(
                                crimeModel: crimeModel,
                                crimeType: "강도",
                              ),
                              CrimeRatioGraph(
                                crimeModel: crimeModel,
                                crimeType: "성폭력",
                              ),
                              CrimeRatioGraph(
                                crimeModel: crimeModel,
                                crimeType: "폭행",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "오늘 $month월 $day일 ${predictionParms["요일"]}요일 ${predictionParms['위치']} ${predictionParms['장소']}은\n${crimeModel.getBestRatioType()}로 부터 안전하지만,\n${crimeModel.getWorstRatioType()}으로 부터는 안전해야합니다.",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class CrimeRatioGraph extends StatelessWidget {
  const CrimeRatioGraph({
    super.key,
    required this.crimeModel,
    required this.crimeType,
  });

  final CrimeModel crimeModel;
  final String crimeType;

  @override
  Widget build(BuildContext context) {
    int crimeRatio;

    int getCrimeRatio(String type) {
      int ratio;
      if (crimeType == "절도") {
        ratio = crimeModel.theft;
      } else if (crimeType == "살인") {
        ratio = crimeModel.murder;
      } else if (crimeType == "강도") {
        ratio = crimeModel.robbery;
      } else if (crimeType == "성폭력") {
        ratio = crimeModel.sexual_assault;
      } else {
        ratio = crimeModel.assault;
      }
      return ratio;
    }

    Color getMatchColor(int crimeRatio) {
      int quote = crimeRatio ~/ 20;
      Color matchColor;
      switch (quote) {
        case 0:
          matchColor = Colors.red;
          break;
        case 1:
          matchColor = Colors.orange;
          break;
        case 2:
          matchColor = Colors.yellow;
          break;
        case 3:
          matchColor = Colors.green;
          break;
        case 4:
          matchColor = Colors.blue;
          break;
        default:
          matchColor = Colors.black;
          break;
      }
      return matchColor;
    }

    crimeRatio = getCrimeRatio(crimeType);

    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 15, color: getMatchColor(crimeRatio)),
          ),
          child: Text(
            "$crimeRatio%",
            style: const TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 10),
        Text("$crimeType 안전도"),
      ],
    );
  }
}

class SelectBox2Widget extends StatefulWidget {
  final Future<List<String>> future;
  final String hint;
  final void Function(String) onChanged;
  final String? dropDownValue;

  const SelectBox2Widget({
    required Key key,
    required this.future,
    required this.dropDownValue,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectBox2Widget> createState() => _SelectBox2WidgetState();
}

class _SelectBox2WidgetState extends State<SelectBox2Widget> {
  String? dropDownValue;

  void setPredictionParms(String? value) {
    var keyTag = widget.key.toString();
    predictionParms[
        keyTag.substring(2, keyTag.length - 2).replaceAll('\'', '')] = value;
  }

  @override
  Widget build(BuildContext context) {
    const double paddingSize = 14;
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.only(
                    right: 8, top: paddingSize, bottom: paddingSize),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: radius_5,
                  ),
                  child: DropdownButton(
                    value: widget.dropDownValue,
                    hint: Text(widget.hint),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      log('$value');
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

class SelectBox3Widget extends StatefulWidget {
  final Future<List<String>> future;
  final String hint;
  final void Function(String)? onChanged;
  final String? dropDownValue;

  const SelectBox3Widget({
    required Key key,
    required this.future,
    required this.hint,
    required this.dropDownValue,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SelectBox3Widget> createState() => _SelectBox3WidgetState();
}

class _SelectBox3WidgetState extends State<SelectBox3Widget> {
  String? dropDownValue;

  void setValue(String? value) {
    setState(() {
      if (value != null) {
        dropDownValue = value;
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      }
    });
    var keyTag = widget.key.toString();
    predictionParms[
        keyTag.substring(2, keyTag.length - 2).replaceAll('\'', '')] = value;
  }

  @override
  Widget build(BuildContext context) {
    dropDownValue = widget.dropDownValue;
    const double paddingSize = 14;
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.only(
                    right: 8, top: paddingSize, bottom: paddingSize),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(strokeAlign: BorderSide.strokeAlignOutside),
                    borderRadius: radius_5,
                  ),
                  child: DropdownButton(
                    value: dropDownValue,
                    hint: Text(widget.hint),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      log('$value');
                      setValue(value);
                    },
                    onTap: () {
                      dropDownValue = null;
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
