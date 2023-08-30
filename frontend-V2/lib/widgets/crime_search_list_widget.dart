import 'package:flutter/material.dart';
import 'package:nocrime/models/crime_model.dart';
import 'package:fl_chart/fl_chart.dart';

class CrimeSearchListWidget extends StatelessWidget {
  CrimeSearchListWidget({
    super.key,
    required this.crimeModel,
  });
  final CrimeModel crimeModel;

  final List<Color> gradientColors = [
    const Color.fromARGB(255, 255, 120, 246),
    const Color.fromRGBO(128, 255, 179, 1),
  ];

  @override
  Widget build(BuildContext context) {
    int crime1 = crimeModel.theft;
    int crime2 = crimeModel.murder;
    int crime3 = crimeModel.robbery;
    int crime4 = crimeModel.sexual_assault;
    int crime5 = crimeModel.assault;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "절도 $crime1건, 살인 $crime2건, 강도 $crime3건, 성폭력 $crime4건, 폭행 $crime5건이 발생하였습니다.",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            height: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            right: 15,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 50,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int val = value.toInt();
                        String text = value.toInt().toString();
                        if (val >= 1000) {
                          double numInK = val / 1000;
                          text =
                              '${numInK.toStringAsFixed(numInK.truncateToDouble() == numInK ? 0 : 1)}k';
                        }
                        return Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(1, crime1.toDouble()),
                      FlSpot(2, crime2.toDouble()),
                      FlSpot(3, crime3.toDouble()),
                      FlSpot(4, crime4.toDouble()),
                      FlSpot(5, crime5.toDouble()),
                    ],
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    isCurved: true,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 15,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('절도', style: style);
        break;
      case 2:
        text = const Text('살인', style: style);
        break;
      case 3:
        text = const Text('강도', style: style);
        break;
      case 4:
        text = const Text('성폭력', style: style);
        break;
      default:
        text = const Text('폭행', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
