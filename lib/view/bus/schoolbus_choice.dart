import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pocket_sch/view/bus/bus_Widget.dart';
import 'package:pocket_sch/view/bus/get_bus.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_sch/view/bus/bus_method.dart';
import '../../custom_color.dart';

class SchoolBusChoice extends StatefulWidget {
  const SchoolBusChoice({Key? key}) : super(key: key);

  @override
  State<SchoolBusChoice> createState() => _SchoolBusChoiceState();
}

class _SchoolBusChoiceState extends State<SchoolBusChoice> {
  late String today = "월";

  int index = 1;

  void initState() {
    super.initState();
    today = getCurrentDay();
    String changed_day = changeDay();
    SchoolBusGetRequest1(changed_day);
    SchoolBusGetRequest(changed_day);

    setState(() {
      leftmessage.clear();
      rightmessage.clear();
    });
  }

  String api = "http://13.209.200.114:8080/pocket-sch/v1/bus/timelist/0/";
  var busTime_list = [];
  var busTime_list1 = [];

  var _text;
  List<Data> _datas = [];
  var _text1;
  List<Data> _datas1 = [];

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
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ])),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: FutureBuilder(
                      future: _fetch4(),
                      builder: (BuildContext content, AsyncSnapshot snapshot) {
                        //해당 부분은 data를 아직 받아오지 못했을 떄 실행
                        if (snapshot.hasData == false) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 300, 0, 300),
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          );
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
                        //데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                        else {
                          SchoolBusChangeTime();
                          SchoolBusChangeTime1();
                          index = getIndex();

                          return Show_List(screen_width, screen_height,
                              index); //처음에 바로 datas에 데이터가 안들어가서 오류 뜸

                        }
                      })
                  //
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Container Show_List(double screen_width, double screen_height, int index) {
    return Container(
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
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Expanded(
                flex: 10,
                child: Scrollbar(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    itemCount: index,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ListTile(
                            title: comments[index],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ),
              Spacer(),
              getAlarmBox(screen_width, screen_height),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }

  final List<Container> comments = <Container>[];

  List<Container> contents(int num) {
    for (int i = 0; i < num; i++) comments.add(timeblock(355, 60, i));

    return comments;
  }

  Container timeblock(double w, double h, int index) {
    return Container(
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
                  child: Text(
                    leftmessage[index],
                    style: TextStyle(fontSize: 15),
                  ),
                )),
          ),
          Container(
              width: w * 0.5,
              height: h,
              child: Center(
                child: Text(rightmessage[index],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400)),
              )),
        ],
      ),
    );
  }

  int getIndex() {
    int num = 0;
    var time_list = [];

    for (int i = 0; i < this._datas1.length; i++) {
      String time = this._datas1[i].busTime;

      final splitted = time.split('T');
      DateTime formattedTime2 = DateFormat("hh:mm").parse(splitted[1]);

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('kk:mm').format(now);
      DateTime formattedTime1 = DateFormat("hh:mm").parse(formattedTime);

      Duration duration = formattedTime2.difference(formattedTime1);

      if (duration.inSeconds >= 0) {
        time_list.add(duration.inSeconds);
        num = num + 1;
      }
    }

    num = time_list.length;
    contents(num);
    return num;
  }

  final List<String> leftmessage = <String>[];
  int left_count = 0;
  final List<String> resleftmessage = <String>[];

//왼쪽 블럭
  List<String> SchoolBusChangeTime() {
    var time_list = [];
    var not_time_list = [];
    int min;
    var initM;

    double m, h;
    int m1, h1;
    for (int i = 0; i < this._datas.length; i++) {
      String time = this._datas[i].busTime;

      final splitted = time.split('T');
      DateTime formattedTime2 = DateFormat("hh:mm").parse(splitted[1]);

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('kk:mm').format(now);
      DateTime formattedTime1 = DateFormat("hh:mm").parse(formattedTime);

      Duration duration = formattedTime2.difference(formattedTime1);

      if (duration.inSeconds >= 0) {
        time_list.add(duration.inSeconds);
        busTime_list.add(duration.inSeconds);
      } else {
        time_list.add(1000000);
        busTime_list.add(1000000);
      }
      not_time_list.add(duration.inSeconds);
    }

    left_count = busTime_list.length;
    busTime_list.sort();

    time_list.removeWhere((e) => e == 1000000);
    busTime_list.removeWhere((e) => e == 1000000);

    time_list.add(1000000);
    busTime_list.add(1000000);

    index = busTime_list.length;
    for (int i = 0; i < time_list.length; i++) {
      min = time_list[0];
      min = busTime_list[0];

      initM = min;

      h = initM / 3600;
      h1 = h.toInt();
      m = (initM % 3600) / 60;
      m1 = m.toInt();

      if (initM == 1000000) {
        leftmessage.add("버스 운행이\n종료되었습니다");
        break;
      }

      if (busTime_list.length != 1) {
        if (h1 == 0)
          leftmessage.add("$m1분 뒤 출발");
        else
          leftmessage.add("$h1시간 $m1분 뒤 출발");
      } else {
        leftmessage.add("   버스 운행이\n종료되었습니다");
        break;
      }

      busTime_list.removeAt(0);
    }

    return leftmessage;
  }

  final List<String> rightmessage = <String>[];

//오른쪽 블럭
  List<String> SchoolBusChangeTime1() {
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

      if (duration.inSeconds >= 0) {
        time_list.add(duration.inSeconds);
        busTime_list1.add(duration.inSeconds);
      } else {
        time_list.add(1000000);
        busTime_list1.add(1000000);
      }

      not_time_list.add(duration.inSeconds);
    }

    busTime_list1.sort();
    time_list.sort();

    String hour, minute;
    int hour1, minute1, hour2, minute2;
    time_list.removeWhere((e) => e == 1000000);
    busTime_list1.removeWhere((e) => e == 1000000);
    time_list.add(1000000);
    busTime_list1.add(1000000);

    for (int i = 0; i < time_list.length; i++) {
      min = time_list[0];
      min = busTime_list1[0];
      not_min = not_time_list[0];

      initM = min;

      h = initM / 3600;
      h1 = h.toInt();
      m = (initM % 3600) / 60;
      m1 = m.toInt();

      final splitted1 = formattedTime.split(':');
      hour = splitted1[0];
      minute = splitted1[1];
      hour1 = int.parse(hour);
      minute1 = int.parse(minute); //현재 시간

      minute2 = minute1 + m1;
      hour2 = hour1 + h1;

      if (time_list.length != 1) {
        if (minute2 >= 60) {
          minute2 = minute2 % 60;

          if (minute2 == 0) {
            String minute3 = minute2.toString();
            minute3 = "00";
            hour2 = hour2 + 1;
            rightmessage.add("$hour2:" + minute3 + " 후문 정류장 출발");
          } else {
            hour2 = hour2 + 1;
            rightmessage.add("$hour2:$minute2" + " 후문 정류장 출발");
          }
        } else
          rightmessage.add("$hour2:$minute2" + " 후문 정류장 출발");
      } else {
        rightmessage.add("버스 없음");
        break;
      }

      busTime_list1.removeAt(0);
    }
    return rightmessage;
  }

//학내 순환 버스 시간 가져오기 GET
  Future SchoolBusGetRequest(String day) async {
    final Uri url = Uri.parse(api + "$day");

    final response = await http.get(url);
    _text = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text)['data'] as List;
    final List<Data> parsedResponse =
        dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();

    setState(() {
      _datas.clear();
      _datas.addAll(parsedResponse);
    });
  }

//학내 순환 버스 시간 가져오기 GET
  Future SchoolBusGetRequest1(String day) async {
    final Uri url = Uri.parse(api + "$day");

    final response = await http.get(url);
    _text1 = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text1)['data'] as List;
    final List<Data> parsedResponse =
        dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();

    setState(() {
      _datas1.clear();
      _datas1.addAll(parsedResponse);
    });
  }
}

Future<String> _fetch4() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Call Data';
}
