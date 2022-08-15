import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_color.dart';

class StationBusChoice extends StatefulWidget {
  const StationBusChoice({Key? key}) : super(key: key);

  @override
  State<StationBusChoice> createState() => _StationBusChoiceState();
}

class _StationBusChoiceState extends State<StationBusChoice> {
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
                    text: '신창역 셔틀 버스',
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
                        getBusBox("2분 뒤 출발", "12:10 후문 정류장 출발"),
                        SizedBox(
                          height: 15,
                        ),
                        getBusBox("2분 뒤 출발", "12:20 후문 정류장 출발"),
                        SizedBox(
                          height: 15,
                        ),
                        getBusBox("2분 뒤 출발", "12:30 후문 정류장 출발"),
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
                child: Center(child: Text(str1))),
          ),
          Container(
            width: w * 0.5,
            height: h,
            child: Center(
                child: Text(str2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400))),
          ),
        ],
      ),
    );
  }
}
