import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:pocket_sch/view/bus/bus_method.dart';
import 'package:pocket_sch/view/bus/get_bus.dart';
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

//학내 순환
  var _text;
  List<Data> _datas = [];

//신창역 셔틀
  var _text2;
  List<Data> _datas2 = [];

  late String today = "월";

  void initState() {
    super.initState();
    today = getCurrentDay();

    String changed_day = changeDay();

    SchoolBusGetRequest(changed_day);
    StationBusGetRequest(changed_day);

    ImageGetRequest();
  }

//새로고침 버스 시간
  String RefreshBusTime() {
    var time_list = [];
    int min, not_min;
    var initM;

    double h, m;
    int h1, m1;
    setState(() {
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
        }
      }
    });

    time_list.removeWhere((e) => e == null);
    time_list.add(1000000);
    min = time_list[0];
    not_min = time_list[0];

    initM = min;

    h = initM / 3600;
    h1 = h.toInt();
    m = (initM % 3600) / 60;
    m1 = m.toInt();

    if (time_list.length != 1) {
      if (h1 == 0) return "후문정류장에서\n" + "$m1분 뒤 출발";
      return "후문정류장에서\n" + "$h1시간 $m1분 뒤 출발";
    }

    return "   버스 운행이\n종료되었습니다";
  }

//학내순환 버스 Timer (몇분 남았는지 확인하기위해) - 리스트 보여주는 부분에도 쓰일 함수
  String SchoolBusChangeTime() {
    var time_list_school = [];
    var not_time_list_school = [];
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
        time_list_school.add(duration.inSeconds);
      } else {
        time_list_school.add(null);
      }

      not_time_list_school.add(duration.inSeconds);
    }

    time_list_school.removeWhere((e) => e == null);
    time_list_school.add(1000000);
    min = time_list_school[0];

    initM = min;

    h = initM / 3600;
    h1 = h.toInt();
    m = (initM % 3600) / 60;
    m1 = m.toInt();
    if (initM == 1000000) {
      time_list_school.removeWhere((e) => e == 1000000);
      return "버스 운행이\n종료되었습니다";
    }

    if (time_list_school.length != 1) {
      if (h1 == 0) return "후문정류장에서\n" + "$m1분 뒤 출발";
      return "후문정류장에서\n" + "$h1시간 $m1분 뒤 출발";
    }

    return "   버스 운행이\n종료되었습니다";
  }

//신창역 셔틀 버스 Timer
  String StationBusChangeTime() {
    var time_list_station = [];
    var not_time_list_station = [];
    int min;
    var initM;

    double m, h;
    int m1, h1;

    for (int i = 0; i < this._datas2.length; i++) {
      String time = this._datas2[i].busTime;

      final splitted = time.split('T');
      DateTime formattedTime2 = DateFormat("hh:mm").parse(splitted[1]);

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('kk:mm').format(now);
      DateTime formattedTime1 = DateFormat("hh:mm").parse(formattedTime);

      Duration duration = formattedTime2.difference(formattedTime1);

      if (duration.inSeconds >= 0) {
        time_list_station.add(duration.inSeconds);
      } else {
        time_list_station.add(null);
      }

      not_time_list_station.add(duration.inSeconds);
    }

    String check = '0';

    for (int i = 0; i < time_list_station.length; i++) {
      if (not_time_list_station[i] == 1) {
        //갈 수 있는 시간이 하나라도 있음
        check = '0';
      } else {
        check = '1';
        break;
      }
    }
    time_list_station.removeWhere((e) => e == null);
    time_list_station.add(1000000);
    min = time_list_station[0];

    initM = min;

    h = initM / 3600;
    h1 = h.toInt();
    m = (initM % 3600) / 60;
    m1 = m.toInt();

    if (initM == 1000000) return "버스 운행이\n종료되었습니다";
    if (check == '1' && time_list_station.length != 1) {
      if (h1 == 0) return "후문정류장에서\n" + "$m1분 뒤 출발";
      return "후문정류장에서\n" + "$h1시간 $m1분 뒤 출발";
    }

    return "버스 운행이\n종료되었습니다";
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
  }

  //신창역 셔틀 버스 시간 가져오기 GET
  Future StationBusGetRequest(String day) async {
    String api = "http://13.209.200.114:8080/pocket-sch/v1/bus/timelist/1/$day";
    final Uri url = Uri.parse(api);

    final response = await http.get(url);
    _text2 = utf8.decode(response.bodyBytes);
    var dataObjsJson = jsonDecode(_text2)['data'] as List;
    final List<Data> parsedResponse =
        dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();

    setState(() {
      _datas2.clear();
      _datas2.addAll(parsedResponse);
    });
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
                            IconButton(
                              onPressed: RefreshBusTime,
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
                    FutureBuilder(
                        future: _fetch(),
                        builder:
                            (BuildContext content, AsyncSnapshot snapshot) {
                          //해당 부분은 data를 아직 받아오지 못했을 떄 실행
                          if (snapshot.hasData == false) {
                            return Text("데이터를 받아오는 중...");
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
                          } else if (today == "토") {
                            return Text(
                              "버스가 없습니다",
                              style: TextStyle(height: 2.2),
                            );
                          }

                          //데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                          else {
                            return Text(
                                SchoolBusChangeTime()); //처음에 바로 datas에 데이터가 안들어가서 오류 뜸

                          }
                        })
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
                  children: [
                    FutureBuilder(
                        future: _fetch2(),
                        builder:
                            (BuildContext content, AsyncSnapshot snapshot) {
                          //해당 부분은 data를 아직 받아오지 못했을 떄 실행
                          if (snapshot.hasData == false) {
                            return Text("데이터를 받아오는 중...");
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
                          } else if (today == "토" || today == "일") {
                            return Text(
                              "버스가 없습니다",
                              style: TextStyle(height: 2.2),
                            );
                          }
                          //데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                          else {
                            return Text(
                                StationBusChangeTime()); //처음에 바로 datas에 데이터가 안들어가서 오류 뜸

                          }
                        })
                  ],
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

Future<String> _fetch() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Call Data';
}

Future<String> _fetch2() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Call Data';
}
