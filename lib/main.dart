import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/splash.dart';
import 'package:pocket_sch/view/bus/alarm/alarm_add_page.dart';
import 'package:pocket_sch/view/bus/alarm/alarm_page.dart';
import 'package:pocket_sch/view/bus/alarm/runAlarm.dart';
import 'package:pocket_sch/view/bus/bus_home.dart';
import 'package:pocket_sch/view/eat_home.dart';
import 'package:pocket_sch/view/notify_home.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  runAlarm();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      getPages: [
        //다른 페이지로 파라미터를 간단하게 넘길 때 사용
        //이름 뒤에 /:사용할 파라미터명 적으면 됨
        GetPage(name: '/notify', page: () => NotifyHome()),
        GetPage(name: '/bus', page: () => BusHome()),
        GetPage(name: '/eat', page: () => EatHome()),
        GetPage(name: '/alarm', page: () => AlarmPage()),
        GetPage(name: '/alarmAdd', page: () => AlarmAddPage())
      ],
    );
  }
}
