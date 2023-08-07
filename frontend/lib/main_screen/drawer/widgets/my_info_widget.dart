import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

class MyInfoWidget extends StatelessWidget {
  const MyInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0.0, 6.0),
                    color: Colors.black26,
                    blurRadius: 2)
              ],
              shape: BoxShape.circle,
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Colors.black,
                  width: 1)),
          child: Image.asset(avatar),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "강준우",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "jangtai",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
