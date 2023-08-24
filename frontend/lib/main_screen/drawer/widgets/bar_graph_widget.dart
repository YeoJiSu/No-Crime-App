import 'package:flutter/material.dart';

import 'bar_widget.dart';

class BarGraphWidget extends StatelessWidget {
  const BarGraphWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        BarWidget(
          color: Colors.red,
          text: "0%~20%",
        ),
        BarWidget(
          color: Colors.orange,
          text: "20%~40%",
        ),
        BarWidget(
          color: Colors.yellow,
          text: "40%~60%",
        ),
        BarWidget(
          color: Colors.green,
          text: "60%~80%",
        ),
        BarWidget(
          color: Colors.blue,
          text: "80%~100%",
        ),
      ],
    );
  }
}
