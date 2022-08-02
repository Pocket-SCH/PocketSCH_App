import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/view/home.dart';

import '../../../custom_color.dart';
import '../../../model/alarm.dart';
import 'localData.dart';

class AlarmAddPage extends StatefulWidget {
  const AlarmAddPage({Key? key}) : super(key: key);

  @override
  State<AlarmAddPage> createState() => _AlarmAddPageState();
}

class _AlarmAddPageState extends State<AlarmAddPage> {
  // 로컬 저장소 객체
  late LocalData localData;
  @override
  void initState() {
    super.initState();
    // 알람 로컬 저장소 객체 초기화
    localData = LocalData();
    localData.init();
  }

  List<bool> categoryPicked = [true, false, false, false, false];
  String currentByDay = "월";

  List<String> times = [
    "10:00",
    "10:10",
    "10:20",
    "10:30",
    "10:40",
    "10:50",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
    "11:00",
  ];

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        // // 이전 페이지로 이동
        Navigator.pop(context);
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 33, 0, 0),
          child: Icon(Icons.abc)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/btn_back.png',
              color: Color.fromARGB(255, 0, 0, 0), width: 15),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              RichText(
                text: TextSpan(children: const <TextSpan>[
                  TextSpan(
                      text: ' LIVE ',
                      style: TextStyle(
                          backgroundColor: CustomColor.primary,
                          fontSize: 18,
                          color: Colors.white)),
                  TextSpan(text: ' '),
                  TextSpan(
                      text: '버스',
                      style: TextStyle(color: Colors.black, fontSize: 18))
                ]),
              ),
              SizedBox(height: 15),
              _build()
              // Expanded(
              //   child: Container(
              //     width: double.infinity,
              //     child: Card(
              //       color: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(6),
              //         side: BorderSide(
              //           color: Colors.grey.withOpacity(0.3),
              //           width: 1,
              //         ),
              //       ),
              //       child: Column(children: [
              //         //여기서부터 코드 작성
              //       ]),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _build() {
    return Padding(
      padding: const EdgeInsets.all(10.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                EdgeInsets.only(left: 7.5, right: 7.5, top: 7.5, bottom: 18.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xffffffff),
            ),
            child: Center(
              child: Column(
                children: [
                  Text("요일",
                      style: const TextStyle(
                          color: const Color(0xff1d5349),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 23.3)),
                  SizedBox(
                    height: 6,
                  ),
                  getByDayToggle(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding:
                EdgeInsets.only(left: 23, right: 23, top: 6.5, bottom: 20.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color(0xffffffff),
            ),
            child: Center(
              child: Column(
                children: [
                  Text("버스",
                      style: const TextStyle(
                          color: const Color(0xff1d5349),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 23.3),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 10.5,
                  ),
                  buildBody(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getByDayToggle() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getByDayBox(0, '월'),
          getByDayBox(1, '화'),
          getByDayBox(2, '수'),
          getByDayBox(3, '목'),
          getByDayBox(4, '금'),
        ]);
  }

  Widget getByDayBox(int categoryNum, String categoryName) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 7,
              height: MediaQuery.of(context).size.height / 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0)
                  ],
                  color: const Color(0xffeeeeee)),
              child: Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                      color: const Color(0xff9ba4a1),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 18),
                ),
              )),
          AnimatedOpacity(
            opacity: categoryPicked[categoryNum] ? 1.0 : 0.0, // 2
            duration: Duration(milliseconds: 100),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 7,
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                    color: Color(0xffb7e3df),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                Container(
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                        color: const Color(0xff444444),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          for (int i = 0; i < 5; i++) {
            categoryPicked[i] = false;
          }
          categoryPicked[categoryNum] = true;

          currentByDay = categoryName;
        });
      },
    );
  }

  Widget buildBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0)
          ],
          color: const Color(0xffb7e3df)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.38,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          spreadRadius: 0)
                    ],
                    color: const Color(0xffffffff)),
              ),
            ),
            RefreshIndicator(
                onRefresh: refresh,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, child: _buildList())),
          ],
        ),
      ),
    );
    // StreamBuilder를 통해 요일별 버스 시간표 업데이트
    // return StreamBuilder(
    //   stream:
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasError) return Text("Error: ${snapshot.error}");
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Center(
    //             child: CircularProgressIndicator(
    //           color: Colors.green,
    //         ));
    //       default:
    //         return _buildList();
    //     }
    //   },
    // );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: times.map((e) {
          return _buildListItem(e);
        }).toList(),
      ),
    );
    //   // 버스 시간표가 없으면
    //   if (snapshot.length == 0) {
    //     return Column(children: [
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Text("버스 시간표가 없습니다."),
    //     ]);

    //     // 버스 시간표가 있으면
    //   } else {
    //     return Column(
    //       children: snapshot.map((DocumentSnapshot document) {
    //         return _buildListItem(context, document);
    //       }).toList(),
    //     );
    //   }
  }

  // 버스 시간표를 리스트로 출력
  Widget _buildListItem(item) {
    return Column(
      children: [
        ListTile(
          // dense:true,
          title: Text(
            item,
            style: const TextStyle(
                color: const Color(0xff444444),
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 18),
          ),
          subtitle: Text("신창역 -> 순천향대 후문"),
          trailing: IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(Icons.add),
            onPressed: () {
              print(11);
              Alarm alarm = Alarm(
                currentByDay,
                item,
                true,
              );

              localData.save(alarm: alarm, context: context);
            },
          ),
        ),
        Divider(thickness: 1)
      ],
    );
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         SizedBox(
    //           child: Text(
    //             item,
    //             style: const TextStyle(
    //                 color: const Color(0xff444444),
    //                 fontWeight: FontWeight.w500,
    //                 fontFamily: "Roboto",
    //                 fontStyle: FontStyle.normal,
    //                 fontSize: 18),
    //           ),
    //         ),
    //         _getAddButton(),
    //       ],
    //     ),
    //     Divider(thickness: 1)
    //   ],
    // );
  }

// 시간 추가 버튼 객체를 반환하는 함수
  _getAddButton() {
    return CupertinoButton(
      child: Text(
        "추가",
        style: const TextStyle(
            fontFamily: "Roboto", fontStyle: FontStyle.normal, fontSize: 16),
      ),
      onPressed: () {},
    );
  }

  // build 업데이트
  Future refresh() async {
    await Future.delayed(Duration(seconds: 1)); //thread sleep 같은 역할을 함.

    setState(() {
      // build 업데이트
    });
  }
}
