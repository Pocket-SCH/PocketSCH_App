import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String changeDay() {
  String day = getCurrentDay();
  if (day == "월")
    return "1";
  else if (day == "화")
    return "2";
  else if (day == "수")
    return "3";
  else if (day == "목")
    return "4";
  else if (day == "금")
    return "5";
  else if (day == "토")
    return "6";
  else if (day == "일") return "0";
  return "7";
}

String getCurrentDay() {
  DateTime now = DateTime.now();
  initializeDateFormatting('ko_KR');
  final _currentDay = DateFormat.E('ko_KR').format(now).toString();
  return _currentDay;
}
