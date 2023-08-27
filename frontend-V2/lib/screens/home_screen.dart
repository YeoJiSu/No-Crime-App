import 'package:flutter/material.dart';

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

  String showBigTitle() {
    switch (_selectedIndex) {
      case 0:
        return "AI가 예측하는 범죄 안전도";
      case 1:
        return "5대 강력 범죄 건수 조회";
      case 2:
        return "No Crime만의 방범용 CCTV 지도";
      case 3:
        return "No Crime 사용 백서";
    }
    return "";
  }

  String showSmallTitle() {
    switch (_selectedIndex) {
      case 0:
        return "No Crime의 인공지능은 위치와 장소를 바탕으로 시간대별  범죄 안전도를 예측해줘요!";
      case 1:
        return "지역별로 각 연도에 5대 강력 범죄가 총 몇 건 발생했는지 조회할 수 있어요!";
      case 2:
        return "저희 No Crime이 방범용 CCTV 데이터들을 모아 직접 제작해보았습니다!";
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
        child: Column(
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
                          horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonTitles[index],
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : const Color.fromRGBO(206, 206, 206, 1),
                              fontSize: 19,
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
                              fontSize: 20,
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
                        ],
                      ),
                    ),
                    const Text(
                      "hi",
                      style: TextStyle(fontSize: 600),
                    ),
                  ],
                ),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: Color.fromRGBO(128, 255, 179, 1),
          ),
        ],
      ),
    );
  }
}
