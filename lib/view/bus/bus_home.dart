import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:http/http.dart' as http;

import '../../controller/token_controller.dart';
import '../../custom_color.dart';

//버스 페이지 홈
class BusHome extends StatefulWidget {
  const BusHome({Key? key}) : super(key: key);

  @override
  State<BusHome> createState() => _BusHomeState();
}

class _BusHomeState extends State<BusHome> {
  File? _image;

  var _text;

  List<Data> _datas = [];

  void initState() {
    super.initState();
    print(_datas);
    String changed_day = changeDay();

    SchoolBusGetRequest(changed_day);

    ImageGetRequest();
  }

  void dispose() {
    super.dispose();
    // RefreshTime();
  }

  String getCurrentDay() {
    DateTime now = DateTime.now();
    initializeDateFormatting('ko_KR');
    final _currentDay = DateFormat.E('ko_KR').format(now).toString();
    return _currentDay;
  }

  // String RefreshTime() {
  //   var time_list = [];
  //   time_list.add(0);
  //   int min;
  //   var initM;

  //   double h, m;
  //   int h1, m1;
  //   double tmp;
  //   Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       for (int i = 0; i < this._datas.length; i++) {
  //         String time = this._datas[i].busTime;

  //         // String time_list=this._datas[0]
  //         final splitted = time.split('T');
  //         // print("학내순환 시간 : " + splitted[1]); //학내순환이니까 10분 간격으로 나옴
  //         DateTime formattedTime2 = DateFormat("hh:mm").parse(splitted[1]);

  //         DateTime now = DateTime.now();
  //         String formattedTime = DateFormat('kk:mm').format(now);
  //         // print("현재시간 : " + formattedTime);
  //         DateTime formattedTime1 = DateFormat("hh:mm").parse(formattedTime);
  //         // print("formateedTime: " + formattedTime);

  //         Duration duration = formattedTime2.difference(formattedTime1);
  //         // print(duration.inSeconds); //계산해서 나온 초

  //         if (duration.inSeconds >= 0) {
  //           time_list.add(duration.inSeconds);
  //         }
  //       }
  //       // print(time_list); //모든 시간 넣은 리스트(데이터 정제 이전)
  //     });
  //   });

  //   min = time_list[0];
  //   // print(min); //가장 얼마 안남은 시간

  //   initM = min;

  //   // h = initM / 3600;
  //   // h1 = h.toInt();
  //   m = (initM % 3600) / 60;
  //   m1 = m.toInt();

  //   String result = "$m1분 뒤 출발"; //남은 시간
  //   return result;
  // }

//학내순환 버스 Timer (몇분 남았는지 확인하기위해) - 리스트 보여주는 부분에도 쓰일 함수
  String ChangeTime() {
    // String time =
    //     this._datas[0].busTime; //첫 번쨰 버스 시간을 가져온거임 -> 가까운 시간을 가져올 수 있도록 하기
    var time_list = [];
    // time_list.add(1);
    int min;
    var initM;

    double h, m;
    int h1, m1;
    double tmp;

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
      }
    }
    // print(time_list); //모든 시간 넣은 리스트(데이터 정제 이전)

    min = time_list[0];
    // print(min); //가장 얼마 안남은 시간

    initM = min;

    // h = initM / 3600;
    // h1 = h.toInt();
    m = (initM % 3600) / 60;
    m1 = m.toInt();

    // if (time_list[0] == 1) {
    //   return "버스가 없습니다.";
    // } else {
    //   String result = "$m1분 뒤 출발"; //남은 시간
    //   return result;
    // }

    String result = "$m1분 뒤 출발"; //남은 시간
    return result;
  }

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

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    getCurrentDay();
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
                    text: '버스',
                    style: TextStyle(color: Colors.black, fontSize: 18))
              ])),
              SizedBox(
                height: 15,
              ),
              // 사각형 2 - 흰색 그림자
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
                        Container(
                          margin: EdgeInsets.all(25),
                          width: screen_width * 0.85,
                          height: screen_height * 0.12,
                          decoration:
                              BoxDecoration(color: const Color(0xff87aaaa)),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, //center로 하는게 나을지 start가 나을지..
                              children: [
                                Text("현재 시간",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 5,
                                ),
                                TimerBuilder.periodic(
                                    const Duration(seconds: 1),
                                    builder: (context) {
                                  return Text(
                                    formatDate(DateTime.now(), [
                                      MM,
                                      ' ',
                                      dd,
                                      ' ',
                                      getCurrentDay(),
                                      '\n',
                                      hh,
                                      ':',
                                      nn,
                                      ':',
                                      ss,
                                      ' ',
                                      am
                                    ]),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screen_height * 0.32,
                          width: screen_width * 0.80,
                          child: _image == null //가져오는 이미지가 없을 경우
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffd8fffe)),
                                )
                              : Image.file(File(_image!.path)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: selectFromGallery,
                              icon: Icon(Icons.image_outlined),
                              iconSize: 30,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            // FutureBuilder(builder:
                            //     (BuildContext context, AsyncSnapshot snapshot) {
                            //   //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                            //   if (snapshot.hasData == false) {
                            //     return IconButton(
                            //       onPressed: RefreshTime,
                            //       icon: Icon(Icons.refresh_outlined),
                            //       iconSize: 30,
                            //     );
                            //   }
                            //   //error가 발생하게 될 경우 반환하게 되는 부분
                            //   else if (snapshot.hasError) {
                            //     return Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Text(
                            //         'Error: ${snapshot.error}',
                            //         style: TextStyle(fontSize: 15),
                            //       ),
                            //     );
                            //   }
                            //   // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                            //   else {
                            //     return Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: IconButton(
                            //         onPressed: RefreshTime,
                            //         icon: Icon(Icons.refresh_outlined),
                            //         iconSize: 30,
                            //       ),
                            //     );
                            //   }
                            // }),
                            IconButton(
                              onPressed: ChangeTime,
                              icon: Icon(Icons.refresh_outlined),
                              iconSize: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        getAlarmBox(screen_width, screen_height),
                        SizedBox(
                          height: 15,
                        ),
                        getSchoolBusBox("학내순환"),
                        SizedBox(
                          height: 15,
                        ),
                        getStationBusBox("신창역 셔틀"),
                        SizedBox(
                          height: 30,
                        ),
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
          Get.toNamed('alarm');
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

//학내 순환
  Widget getSchoolBusBox(String str) {
    double w = 335;
    double h = 60;

    return InkWell(
      onTap: () {
        Get.toNamed('schoolbusChoice');
      },
      child: Container(
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
            color: Color(0xffb9e2e2)),
        child: Row(
          children: [
            Container(
              width: w * 0.3,
              child: Center(child: Text(str)),
            ),
            Container(
              width: w * 0.7,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Column(
                  children: [
                    Text("후문정류장에서"),
                    FutureBuilder(
                        future: _fetch(),
                        builder:
                            (BuildContext content, AsyncSnapshot snapshot) {
                          //해당 부분은 data를 아직 받아오지 못했을 떄 실행
                          if (snapshot.hasData == false) {
                            return Text("데이터를 받아오는 중...");
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
                          //데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                          else {
                            // ChangeTime(); //몇 분 남았는지 가져오게 하는 함수

                            return Text(
                                ChangeTime()); //처음에 바로 datas에 데이터가 안들어가서 오류 뜸

                          }
                        })
                    // Text(this._datas[0].busTime) //처음에 바로 datas에 데이터가 안들어가서 오류 뜸
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//신창역 셔틀
  Widget getStationBusBox(String str) {
    double w = 335;
    double h = 60;

    return InkWell(
      onTap: () {
        Get.toNamed('stationbusChoice');
      },
      child: Container(
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
            color: Color(0xffb9e2e2)),
        child: Row(
          children: [
            Container(
              width: w * 0.3,
              child: Center(child: Text(str)),
            ),
            Container(
              width: w * 0.7,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Column(
                  children: [Text("후문정류장에서"), Text("2분 뒤 출발")],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  selectFromGallery() async {
    XFile? ximage = await ImagePicker().pickImage(source: ImageSource.gallery);
    File image = File(ximage!.path);
    if (image == null) return;
    setState(() {
      _image = image;
    });
    await ImagePostRequest(File(image.path));
  }

  //이미지 전달 POST
  Future ImagePostRequest(File image) async {
    var headers = {'Authorization': Get.find<TokenController>().token};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://13.209.200.114:8080/pocket-sch/v1/bus/image/image-upload'));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

//이미지 가져오기 GET
  Future ImageGetRequest() async {
    var headers = {'Authorization': Get.find<TokenController>().token};
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'http://13.209.200.114:8080/pocket-sch/v1/bus/image/my-image'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Uint8List imageInUnit8List = await response.stream.toBytes();
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(imageInUnit8List);
      setState(() {
        file.writeAsBytesSync(imageInUnit8List);
        _image = file;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}

class Data {
  int id;
  int type;
  String busTime;
  int busWeekDay;

  Data(this.id, this.type, this.busTime, this.busWeekDay);

  factory Data.fromJson(dynamic json) {
    return Data(json['id'] as int, json['type'] as int,
        json['busTime'] as String, json['busWeekDay'] as int);
  }
  @override
  String toString() {
    return '{${this.id}, ${this.type}, ${this.busTime}, ${this.busWeekDay}}';
  }
}

Future<String> _fetch() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Call Data';
}
