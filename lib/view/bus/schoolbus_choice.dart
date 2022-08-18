import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pocket_sch/view/bus/get_bus.dart';
import 'package:http/http.dart' as http;
import '../../custom_color.dart';

class SchoolBusChoice extends StatefulWidget {
  const SchoolBusChoice({Key? key}) : super(key: key);

  @override
  State<SchoolBusChoice> createState() => _SchoolBusChoiceState();
}

class _SchoolBusChoiceState extends State<SchoolBusChoice> {
  void initState() {
    super.initState();

    String changed_day = changeDay();

    SchoolBusGetRequest(changed_day);
    // SchoolBusGetRequest1(changed_day);
  }

  var _text;
  List<Data> _datas = [];
  var _text1;
  List<Data> _datas1 = [];

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

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/btn_back.png',
            color: Color.fromARGB(255, 0, 0, 0),
            width: 15,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: <Widget>[
              RichText(
                  text: TextSpan(children: const <TextSpan>[
                TextSpan(
                    text: 'LIVE',
                    style: TextStyle(
                        backgroundColor: CustomColor.primary,
                        fontSize: 18,
                        color: Colors.white)),
                TextSpan(text: ' '),
                TextSpan(
                    text: '학내순환 버스',
                    style: TextStyle(color: Colors.black, fontSize: 18))
              ])),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        // Center(
                        //   child: ListView.separated(
                        //     itemCount: this._datas.length,
                        //     itemBuilder: (context, index) {
                        //       final data = this._datas[index];
                        //       return ListTile(
                        //         title: getBusBox("0분 뒤 출발", "10:10 후문 정류장 출발"),
                        //       );
                        //     },
                        //     separatorBuilder:
                        //         (BuildContext context, int index) {
                        //       return Divider(
                        //         thickness: 3,
                        //       );
                        //     },
                        //   ),
                        // ),
                        getBusBox("0분 뒤 출발", "10:10 후문 정류장 출발"),
                        SizedBox(
                          height: 30,
                        ),
                        Spacer(),
                        getAlarmBox(screen_width, screen_height),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        style: ElevatedButton.styleFrom(
          primary: Color(0xffa4c9c9),
        ),
      ),
    );
  }

  Widget getBusBox(String str1, String str2) {
    double w = 335;
    double h = 60;

    return Container(
        child: SingleChildScrollView(
      child: Column(
        //
        children: [
          Container(
            //한 블럭
            width: w,
            height: h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 0),
                      blurRadius: 6,
                      spreadRadius: 0)
                ],
                color: Color(0xff87aaaa)),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: w * 0.4,
                  height: h,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5))),
                      child: Center(
                          child: FutureBuilder(
                              future: _fetch3(),
                              builder: (BuildContext content,
                                  AsyncSnapshot snapshot) {
                                //해당 부분은 data를 아직 받아오지 못했을 떄 실행
                                if (snapshot.hasData == false) {
                                  return Text(
                                    "데이터를 받아오는 중...",
                                    style: TextStyle(fontSize: 12),
                                  );
                                  // CircularProgressIndicator();
                                }
                                //error가 발생하게 될 경우 반환하게 되는 부분
                                else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                }
                                // else if (SchoolBusChangeTime() == "버스 없음") {
                                //   return Text(SchoolBusChangeTime());
                                // }
                                //데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                else {
                                  // ChangeTime(); //몇 분 남았는지 가져오게 하는 함수

                                  return Text(
                                    SchoolBusChangeTime(),
                                    style: TextStyle(fontSize: 15),
                                  ); //처음에 바로 datas에 데이터가 안들어가서 오류 뜸

                                }
                              }))),
                ),
                Container(
                  width: w * 0.5,
                  height: h,
                  child: Center(
                      child: FutureBuilder(
                          future: _fetch3(),
                          builder:
                              (BuildContext content, AsyncSnapshot snapshot) {
                            //해당 부분은 data를 아직 받아오지 못했을 떄 실행
                            if (snapshot.hasData == false) {
                              return Text(
                                "데이터를 받아오는 중...",
                                style: TextStyle(fontSize: 12),
                              );
                              // CircularProgressIndicator();
                            }
                            //error가 발생하게 될 경우 반환하게 되는 부분
                            else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }
                            // else if (SchoolBusChangeTime() == "버스 없음") {
                            //   return Text(SchoolBusChangeTime());
                            // }
                            //데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                            else {
                              // ChangeTime(); //몇 분 남았는지 가져오게 하는 함수

                              return Text(SchoolBusChangeTime1() + " 후문 정류장 출발",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight
                                          .w400)); //처음에 바로 datas에 데이터가 안들어가서 오류 뜸

                            }
                          })),
                ),
              ],
            ),
          ), //여기까지가 한 블럭
          SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }

  String SchoolBusChangeTime() {
    var time_list = [];
    var not_time_list = [];
    int min, not_min;
    var initM;

    double m, h;
    int m1, h1;

    for (int i = 0; i < this._datas.length; i++) {
      String time = this._datas[i].busTime;

      // String time_list=this._datas[0]
      final splitted = time.split('T');
      // print("학내순환 시간 : " + splitted[1]); //학내순환이니까 10분 간격으로 나옴
      DateTime formattedTime2 = DateFormat("hh:mm").parse(splitted[1]);

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('kk:mm').format(now);
      // print("현재시간 : " + formattedTime);
      DateTime formattedTime1 = DateFormat("hh:mm").parse(formattedTime);
      // print("formateedTime: " + formattedTime);

      Duration duration = formattedTime2.difference(formattedTime1);
      // print(duration.inSeconds); //계산해서 나온 초

      if (duration.inSeconds >= 0) {
        time_list.add(duration.inSeconds);
      } else {
        time_list.add(-duration.inSeconds);
      }

      not_time_list.add(duration.inSeconds);
    }

    time_list.sort();
    // print("데이터 정제 전 :");
    // print(time_list); //모든 시간 넣은 리스트(데이터 정제 이전)
    // print(not_time_list);

    String check = '0';

    for (int i = 0; i < time_list.length; i++) {
      if (not_time_list[i] == 1) {
        //갈 수 있는 시간이 하나라도 있음
        check = '0';
      } else {
        check = '1';
        break;
      }
    }
    // print("check: " + check);
    time_list.removeWhere((e) => e == 1000000);
    time_list.add(0);
    // print(time_list);
    min = time_list[0];
    not_min = not_time_list[0];
    // print(min); //가장 얼마 안남은 시간

    initM = min;

    h = initM / 3600;
    h1 = h.toInt();
    m = (initM % 3600) / 60;
    m1 = m.toInt();

    if (check == '1' && time_list.length != 1) {
      if (h1 == 0) return "$m1분 뒤 출발";
      return "$h1시간 $m1분 뒤 출발";
    }

    return "버스 없음";
    // String result = "$m1분 뒤 출발"; //남은 시간
    // return result;
  }

  String SchoolBusChangeTime1() {
    var time_list = [];
    var not_time_list = [];
    int min, not_min;
    var initM;
    String formattedTime = "";

    double m, h;
    int m1, h1;

    for (int i = 0; i < this._datas.length; i++) {
      String time = this._datas[i].busTime;

      final splitted = time.split('T');
      DateTime formattedTime2 = DateFormat("hh:mm").parse(splitted[1]);

      DateTime now = DateTime.now();
      formattedTime = DateFormat('kk:mm').format(now);
      DateTime formattedTime1 = DateFormat("hh:mm").parse(formattedTime);

      Duration duration = formattedTime2.difference(formattedTime1);
      // print(duration.inSeconds); //계산해서 나온 초

      if (duration.inSeconds >= 0) {
        time_list.add(duration.inSeconds);
      } else {
        time_list.add(-duration.inSeconds);
      }

      not_time_list.add(duration.inSeconds);
    }

    time_list.sort();

    String check = '0';
    String hour, minute;
    int hour1, minute1;
    for (int i = 0; i < time_list.length; i++) {
      if (not_time_list[i] == 1) {
        //갈 수 있는 시간이 하나라도 있음
        check = '0';
      } else {
        check = '1';
        break;
      }
    }
    time_list.removeWhere((e) => e == 1000000);
    time_list.add(0);
    min = time_list[0];
    not_min = not_time_list[0];

    initM = min;

    h = initM / 3600;
    h1 = h.toInt();
    m = (initM % 3600) / 60;
    m1 = m.toInt();
    min = m1;

    print(formattedTime);
    final splitted1 = formattedTime.split(':');
    hour = splitted1[0];
    minute = splitted1[1];
    hour1 = int.parse(hour);
    minute1 = int.parse(minute); //현재 시간

    minute1 = minute1 + m1;
    print(hour1);
    print(minute1);

    if (check == '1' && time_list.length != 1) {
      return "$hour1:$minute1";
    }

    return "버스 없음";
  }

//학내 순환 버스 시간 가져오기 GET
  Future SchoolBusGetRequest(String day) async {
    String api = "http://13.209.200.114:8080/pocket-sch/v1/bus/timelist/0/$day";
    final Uri url = Uri.parse(api);

    final response = await http.get(url);
    _text = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<Data> parsedResponse =
        dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();

    setState(() {
      _datas.clear();
      _datas.addAll(parsedResponse);
    });
    print(parsedResponse);
  }

// //학내 순환 버스 시간 가져오기 GET
//   Future SchoolBusGetRequest1(String day) async {
//     String api = "http://13.209.200.114:8080/pocket-sch/v1/bus/timelist/0/$day";
//     final Uri url = Uri.parse(api);

//     final response = await http.get(url);
//     _text1 = utf8.decode(response.bodyBytes);
//     var dataObjsJson = jsonDecode(_text1)['data'] as List;
//     final List<Data> parsedResponse =
//         dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();

//     setState(() {
//       _datas1.clear();
//       _datas1.addAll(parsedResponse);
//     });
//     print(parsedResponse);
//   }
}

Future<String> _fetch3() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Call Data';
}
