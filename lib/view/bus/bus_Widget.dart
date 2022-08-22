import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget getAlarmBox(double screen_width, double screen_height) {
  return SizedBox(
    width: screen_width * 0.78,
    height: screen_height * 0.07,
    child: ElevatedButton.icon(
      onPressed: () {
        Get.toNamed('alarmAdd');
      },
      icon: Icon(Icons.alarm, size: 20),
      label: Text("알람 추가",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
      style: ElevatedButton.styleFrom(
        primary: Color(0xffa4c9c9),
      ),
    ),
  );
}
