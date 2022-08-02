import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/alarm.dart';

class LocalData {
  // 로컬 저장소 객체
  late SharedPreferences prefs;

  // 로컬 저장소에 저장된 알람 목록 (String)
  late List<String> alarmList = [];

  // 상태로 저장된 알람 목록 (Alarm)
  late List<Alarm> alarmListState = [];

  init() async {
    prefs = await SharedPreferences.getInstance();
    alarmList = prefs.getStringList('alarmList') ?? [];

    alarmList.forEach((element) {
      var decoded = jsonDecode(element);
      String _byDay = decoded['byDay'];
      String _time = decoded['time'];
      bool _activated = decoded['activated'] == 'true' ? true : false;

      Alarm _alarm = Alarm(_byDay, _time, _activated);
      alarmListState.add(_alarm);
    });
  }

  // 알람 저장
  save({
    required Alarm alarm,
    required BuildContext context,
  }) {
    // 알람 객체 갱신
    alarmList.add(alarm.toString());
    alarmListState.add(alarm);
    // 로컬 저장소 갱신
    prefs.setStringList('alarmList', alarmList);
  }

  // 알람 삭제
  remove({required Alarm alarm}) {
    // 알람 객체 삭제
    alarmList.remove(alarm.toString());
    alarmListState.remove(alarm);
    // 로컬 저장소 갱신
    prefs.setStringList('alarmList', alarmList);
  }

  // 활성화 상태 onChanged 핸들러
  onChangedActivated({required bool activated, required int index}) {
    // 기존 알람 객체
    Alarm alarm = alarmListState[index];
    // 활성화 상태 변경
    alarm.activated = activated;
    // 알람 객체 갱신
    alarmList[index] = alarm.toString();
    alarmListState[index] = alarm;
    // 로컬 저장소 갱신
    prefs.setStringList('alarmList', alarmList);
  }
}
