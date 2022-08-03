class Alarm {
  late String byDay;
  late String time;
  late bool activated;

  Alarm(this.byDay, this.time, this.activated);

  @override
  String toString() {
    return '{"byDay": "$byDay", "time": "$time", "activated": "$activated"}';
  }
}
