import 'package:flutter/material.dart';
import 'package:nocrime/screens/cctv_map_screen.dart';
import 'package:nocrime/screens/predict_here_screen.dart';
import 'package:nocrime/screens/predict_other_screen.dart';
import 'package:nocrime/screens/search_crime_screen.dart';
import 'package:nocrime/screens/white_paper_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<String> buttonTitles = [
    "예측하기",
    "건수 조회",
    "CCTV 지도",
    "사용 백서",
  ];
  @override
  void initState() {
    super.initState();
  }

  String showBigTitle() {
    switch (_selectedIndex) {
      case 0:
        return "AI가 예측하는 범죄 안전도";
      case 1:
        return "5대 강력 범죄 건수 조회";
      case 2:
        return "생활 방범용 CCTV 지도";
      case 3:
        return "No Crime 사용 백서";
    }
    return "";
  }

  String showSmallTitle() {
    switch (_selectedIndex) {
      case 0:
        return "No Crime의 인공지능은 사용자의 실시간 위치와 장소를 바탕으로 시간대별  범죄 안전도를 예측해줘요!";
      case 1:
        return "지역별로 각 연도에 5대 강력 범죄가 총 몇 건 발생했는지 조회할 수 있어요!";
      case 2:
        return "저희 No Crime이 생활 방범용 CCTV 데이터들을 모아 직접 제작해보았습니다!";
      case 3:
        return "처음 사용해보시는 분들을 위해 알려드립니다! 잘 숙지하시고, 사용해주세요~!";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 29, 37, 1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const firstAppBar(),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(buttonTitles.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                buttonTitles[index],
                                style: TextStyle(
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : const Color.fromRGBO(206, 206, 206, 1),
                                  fontSize: 17.5,
                                  fontWeight: _selectedIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 300), // Animation duration
                                height: 3,
                                width: 80,
                                alignment: _selectedIndex == index
                                    ? Alignment.center
                                    : Alignment
                                        .centerLeft, // Adjust alignment based on selection
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            border: const Border.fromBorderSide(BorderSide(
                                color: Color.fromRGBO(64, 64, 64, 1),
                                width: 1)), // 테두리 스타일과 색상 설정
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                showBigTitle(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                showSmallTitle(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  letterSpacing: 0.9,
                                  height: 1.5,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  if (_selectedIndex == 0)
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            131, 131, 255, 0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PredictOtherScreen()),
                                        );
                                      },
                                      child: const Text(
                                        '다른 지역 예측하기 >',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
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
                        if (_selectedIndex == 0) const PredictHereScreen(),
                        if (_selectedIndex == 1) const SearchCrimeScreen(),
                        if (_selectedIndex == 2) const CctvMapScreen(),
                        if (_selectedIndex == 3) const WhitePaperScreen(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 50.0, // 아래 여백 조정
              right: 16.0, // 우측 여백 조정
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(100, 100),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: const Color.fromRGBO(128, 255, 179, 1),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 115, 166, 255),
                    ),
                    borderRadius: BorderRadius.circular(50.0), // 버튼을 둥글게 만듭니다.
                  ), // 버튼 텍스트 색상을 변경합니다.
                  elevation: 8.0, // 버튼의 그림자를 추가합니다.
                ),
                onPressed: () {
                  // 버튼을 눌렀을 때 실행할 작업을 추가하세요.
                },
                child: const Text('SOS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class firstAppBar extends StatelessWidget {
  const firstAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "No Crime",
            style: TextStyle(
              color: Color.fromRGBO(128, 255, 179, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Icon(
          //   Icons.settings,
          //   size: 30,
          //   color: Color.fromRGBO(128, 255, 179, 1),
          // ),
        ],
      ),
    );
  }
}
