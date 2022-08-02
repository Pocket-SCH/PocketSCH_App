import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../custom_color.dart';

//버스 페이지 홈
class BusHome extends StatefulWidget {
  const BusHome({Key? key}) : super(key: key);

  @override
  State<BusHome> createState() => _BusHomeState();
}

class _BusHomeState extends State<BusHome> {
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
            // mainAxisAlignment: MainAxisAlignment.center,
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
                                Text("시간 나오는 곳",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                        //사각형 4
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          width: screen_width * 0.85,
                          height: screen_height * 0.35,
                          decoration:
                              BoxDecoration(color: const Color(0xffd8fffe)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        getAlarmBox(screen_width, screen_height),

                        SizedBox(
                          height: 15,
                        ),
                        getBusBox("학내순환"),
                        SizedBox(
                          height: 15,
                        ),
                        getBusBox("신창역 셔틀"),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),

                  // height: screen_height * 0.85,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(12)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color: const Color(0x29000000),
                  //           offset: Offset(0, 0),
                  //           blurRadius: 6,
                  //           spreadRadius: 0)
                  //     ],
                  //     color: const Color(0xffffffff)),
                  // child: Column(
                  //   // mainAxisAlignment: MainAxisAlignment.center,

                  // )
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

  Widget getBusBox(String str) {
    double w = 335;
    double h = 60;

    return InkWell(
      onTap: () {
        Get.toNamed('busChoice');
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
}
