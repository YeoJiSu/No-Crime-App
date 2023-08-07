import 'package:crime/theme.dart';
import 'package:flutter/material.dart';

import 'emergency_box.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({
    super.key,
  });

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 1;

  void _showEmergencyCallPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const EmergencyCallBox(),
    );
  }

  void _onNavigatorTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      _showEmergencyCallPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onNavigatorTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.sos), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
        BottomNavigationBarItem(
            icon: Icon(Icons.query_stats_rounded), label: "")
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      backgroundColor: boxColor,
      iconSize: 34,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
