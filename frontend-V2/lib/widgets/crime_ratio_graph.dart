import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:nocrime/models/crime_model.dart';

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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 8, color: getMatchColor(ratio1)),
                    ),
                    child: Text(
                      "$ratio1%",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "절도",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 8, color: getMatchColor(ratio2)),
                    ),
                    child: Text(
                      "$ratio2%",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "살인",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 8, color: getMatchColor(ratio3)),
                    ),
                    child: Text(
                      "$ratio3%",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "강도",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 8, color: getMatchColor(ratio4)),
                    ),
                    child: Text(
                      "$ratio4%",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "성폭력",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 8, color: getMatchColor(ratio5)),
                    ),
                    child: Text(
                      "$ratio5%",
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "폭력",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                vertical: false,
                defaultRenderer: charts.BarRendererConfig(
                  cornerStrategy: const charts.ConstCornerStrategy(30),
                  groupingType: charts.BarGroupingType.stacked,
                  fillPattern: charts.FillPatternType.solid,
                  strokeWidthPx: 2.0,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  customRendererId: 'customColor',
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec:
                      charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
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
