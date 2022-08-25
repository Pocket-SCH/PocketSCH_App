import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/view/food/food_game_select.dart';
import 'package:pocket_sch/view/food/food_slot.dart';
import '../../custom_color.dart';

class FoodCategory extends StatefulWidget {
  FoodCategory({Key? key}) : super(key: key);

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  int touchedIndex = -1;
  String touchedString = '오늘은...';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                      text: ' RANDOM ',
                      style: TextStyle(
                          backgroundColor: CustomColor.primary,
                          fontSize: 18,
                          color: Colors.white)),
                  TextSpan(text: ' '),
                  TextSpan(
                      text: '음식',
                      style: TextStyle(color: Colors.black, fontSize: 18))
                ]),
              ),
              SizedBox(height: 15),
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
                    child: Column(children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(touchedString,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff000000))),
                            ),
                            PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if ( //!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;

                                      if (pieTouchResponse
                                              .touchedSection!.touchedSection ==
                                          null) {
                                        touchedString = "오늘은...";
                                      } else {
                                        touchedString = pieTouchResponse
                                            .touchedSection!
                                            .touchedSection!
                                            .title;
                                      }

                                      //print('선택된 카테고리 인덱스 넘버: ' +
                                      //    touchedIndex.toString());
                                    });
                                    /*

                                    if (touchedIndex != -1) {
                                      Get.off(() => FoodSlot(),
                                          arguments: touchedIndex);
                                    }
                                    */
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 5,
                                  centerSpaceRadius: screenWidth * 0.2,
                                  sections: showingSections()),
                            ),
                            Positioned(
                                bottom: Get.height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: Get.width * 0.6,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(touchedIndex);
                                          if (touchedIndex != -1) {
                                            Get.to(() => FoodGameSelection(),
                                                arguments: touchedIndex);
                                          }
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 5, 30, 5),
                                            child: RichText(
                                              text: TextSpan(
                                                  children: const <TextSpan>[
                                                    TextSpan(
                                                        text: '게임 고르기',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12))
                                                  ]),
                                            )),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                      ),
                                    ),

                                    // 추후 추천 음식점 추가 시 등록 예정
                                    /*
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: Get.width * 0.6,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // foodCategory 기반 음식점 추천이면 여기
                                          // 음식 id 기반 음식점 추천이면 food_slot_controller.dart으로
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 5, 30, 5),
                                            child: RichText(
                                              text: TextSpan(
                                                  children: const <TextSpan>[
                                                    TextSpan(
                                                        text: '추천 음식점',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12))
                                                  ]),
                                            )),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                      ),
                                    ),
                                    */
                                  ],
                                )),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(8, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 15.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xffEBEB81),
            value: 1,
            title: '분식',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfffC2E49C),
            value: 1,
            title: '치킨',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xffB7E3DF),
            value: 1,
            title: '한식',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff7DCDC5),
            value: 1,
            title: '라면',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xffCDA4E4),
            value: 1,
            title: '중식',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 5:
          return PieChartSectionData(
            color: const Color(0xffEDA5ED),
            value: 1,
            title: '일식',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 6:
          return PieChartSectionData(
            color: const Color(0xffEDA1A1),
            value: 1,
            title: '고기',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        case 7:
          return PieChartSectionData(
            color: const Color(0xffF3D079),
            value: 1,
            title: '기타',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff000000)),
          );
        default:
          throw Error();
      }
    });
  }
}
