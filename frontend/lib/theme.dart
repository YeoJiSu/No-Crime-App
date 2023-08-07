import 'package:flutter/material.dart';

const BorderRadiusGeometry radius_geometry_5 =
    BorderRadius.all(Radius.circular(5));
const BorderRadius radius_5 = BorderRadius.all(Radius.circular(4));
const Color mainColor = Color.fromRGBO(233, 227, 93, 1);
const Color boxColor = Color.fromRGBO(217, 217, 217, 1);
const EdgeInsets informationPadding =
    EdgeInsets.only(top: 20, bottom: 20, left: 30);

const Duration aniDuration = Duration(milliseconds: 3000);

const String avatar = "assets/images/avatar_image.jpg";

const List<String> list_Do_MetroCity = ['서울특별시', '부산광역시', '대구광역시', '울산광역시'];
const List<String> list_Si_Gun_Gu = ['김해시', '제주시', '색시'];
const List<String> list_Dong = ['개금동', '하하동', '진지동', '물금읍'];

PreferredSizeWidget authAppbar = AppBar(
  backgroundColor: mainColor,
  title: const Text(
    "No crime",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  actions: [
    IconButton(
      onPressed: () => Function,
      icon: const Icon(
        Icons.dehaze_rounded,
        size: 35,
      ),
    )
  ],
);
