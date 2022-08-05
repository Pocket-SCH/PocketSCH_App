import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'alarm_page.dart';
import 'globalVariable.dart';
import 'localData.dart';

class RunAlarm extends StatefulWidget {
  const RunAlarm({Key? key}) : super(key: key);

  @override
  _RunAlarmState createState() => _RunAlarmState();
}

class _RunAlarmState extends State<RunAlarm> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
      child: CupertinoButton.filled(
        child: const Text('종료'),
        onPressed: () {
          Navigator.of(context).pop();
          FlutterRingtonePlayer.stop();
        },
      ),
    ));
  }
}

// '오전/오후 시간(1~12):분' 형식의 시간 문자열을 '시간(1~24):분' 형식으로 변환하는 함수
// 현재로써 필요없음.
_convert(String str) {
  var token = str.split(' ').map((element) => element.split(':')).toList();
  var ampm = token[0][0].toString();
  var hour = int.parse(token[1][0]);
  var minute = int.parse(token[1][1]);

  if (ampm == '오전') {
    return '$hour:$minute';
  } else {
    return '${hour + 12}:$minute';
  }
}

// 알람 타이머
runAlarm() {
  late BuildContext? context;

  // 현재 Context 가져오기
  SchedulerBinding.instance.addPostFrameCallback((_) {
    context = GlobalVariable.navigatorState.currentContext;
  });

  // 1분마다 갱신
  return Timer.periodic(const Duration(minutes: 1), (timer) async {
    // 로컬 데이터 가져오기
    LocalData _localData = LocalData();
    await _localData.init();

    // 활성화된 알람 시간 리스트
    List<String> _activatedTimeList = [];
    List<String> _activatedByDayList = [];
    // 로컬 데이터에서 활성화된 알람 리스트만 찾아 추가
    _localData.alarmListState.forEach((item) {
      // print("알람 시간 : $item");
      if (item.activated) {
        _activatedTimeList.add(item.time);
        _activatedByDayList.add(item.byDay);
      }


    });

    DateTime now = DateTime.now();
    initializeDateFormatting('ko_KR');
    final _currentTime = DateFormat('k:mm').format(now).toString();
    final _currentByDay = DateFormat.E('ko_KR').format(now).toString();
    print('금일 날짜 : $_currentByDay');
    print("현재 시각 : $_currentTime");
    print("활성화된 알람 : $_activatedTimeList");
    // 알람 시간인 경우
    if (_activatedByDayList.contains(_currentByDay) &&
        _activatedTimeList.contains(_currentTime)) {
      FlutterRingtonePlayer.playAlarm(volume: 10, looping: true);
      Navigator.push(
          context!, MaterialPageRoute(builder: (context) => RunAlarm()));
    }
  });
}
