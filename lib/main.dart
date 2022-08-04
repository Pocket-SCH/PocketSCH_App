import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/controller/alarm_controller.dart';
import 'package:pocket_sch/splash.dart';
import 'package:pocket_sch/view/bus/alarm/alarm_add_page.dart';
import 'package:pocket_sch/view/bus/alarm/alarm_page.dart';
import 'package:pocket_sch/view/bus/alarm/runAlarm.dart';
import 'package:pocket_sch/view/bus/bus_choice.dart';
import 'package:pocket_sch/view/bus/bus_home.dart';
import 'package:pocket_sch/view/eat_home.dart';
import 'package:pocket_sch/view/notify/notify_home.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var fcmToken =
      await FirebaseMessaging.instance.getToken(vapidKey: "fcm 인증 키");
  print(fcmToken);

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
        GetPage(
            name: '/alarm',
            page: () => AlarmPage(),
            binding: BindingsBuilder(() {
              Get.lazyPut<AlarmController>(() => AlarmController());
            })),
        GetPage(name: '/alarmAdd', page: () => AlarmAddPage()),
        GetPage(name: '/busChoice', page: () => BusChoice())
      ],
    );
  }
}
