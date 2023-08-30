import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nocrime/models/crime_model.dart';
import 'package:nocrime/screens/splash_screen.dart';
import 'package:nocrime/widgets/crime_search_list_widget.dart';
import 'package:nocrime/widgets/select_box_widget.dart';
import 'package:nocrime/services/api_service_crime.dart';

Future<List<String>> secondDistrictList = Future(() => []);

class SearchCrimeScreen extends StatefulWidget {
  const SearchCrimeScreen({super.key});

  @override
  State<SearchCrimeScreen> createState() => _SearchCrimeScreenState();
}

class _SearchCrimeScreenState extends State<SearchCrimeScreen> {
  CrimeModel crimeModel = CrimeModel();
  String? dropDownValue1;
  String? dropDownValue2;
  String? dropDownValue3;
  bool _offstage = true;

  void _onTap() async {
    String text = "모든";
    if (dropDownValue1 == null) {
      text = "첫번째 '도/특별시/광역시' ";
    } else if (dropDownValue2 == null) {
      text = "두번째 '시/군/구' ";
    } else if (dropDownValue3 == null) {
      text = "세번째 '연도' ";
    }
    if (dropDownValue1 == "세종특별자치시" &&
        dropDownValue2 == null &&
        dropDownValue3 != null) {
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
      crimeModel = await CrimeApiService()
          .getSearch(dropDownValue1!, " ", dropDownValue3!);
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
        dropDownValue3 == null) {
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

    crimeModel = await CrimeApiService()
        .getSearch(dropDownValue1!, dropDownValue2!, dropDownValue3!);

    setState(() {
      _offstage = false;
    });

    // 로딩 다이얼로그 닫기
    Navigator.pop(context);
  }

  void setValue1(String? value) {
    setState(() {
      if (value != null) {
        secondDistrictList = CrimeApiService().getSecondDistrictList(value);
      }
      _offstage = true;
      dropDownValue2 = null;
      dropDownValue1 = value;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "🚔 5대 강력 범죄 건수를 조회할 수 있어요!",
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
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectBoxWidget(
                      key: const Key("first"),
                      future: getList(1),
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
                      key: const Key("연도"),
                      future: getList(5),
                      hint: '연도',
                      dropDownValue: dropDownValue3,
                      onChanged: setValue3,
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Align(
                  heightFactor: 3.2,
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
                      "조회하기",
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
                child: Column(
                  children: [
                    Text(
                      "$dropDownValue3년에 발생한 $dropDownValue1 $dropDownValue2 지역의 5대 강력 범죄 건수를 알려드립니다.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                    CrimeSearchListWidget(
                      crimeModel: crimeModel,
                    ),
                  ],
                ));
          })
        ],
      ),
    );
  }
}
