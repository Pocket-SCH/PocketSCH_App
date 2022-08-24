import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/view/food/food_slot.dart';

import '../../custom_color.dart';

class FoodGameSelection extends StatefulWidget {
  const FoodGameSelection({Key? key}) : super(key: key);

  @override
  State<FoodGameSelection> createState() => _FoodGameSelectionState();
}

class _FoodGameSelectionState extends State<FoodGameSelection> {
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
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Get.height * 0.2,
                            width: Get.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => FoodSlot(),
                                    arguments: Get.arguments);
                              },
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      fit: BoxFit.contain,
                                      image:
                                          AssetImage('assets/logo_slot.png')),
                                  Text(
                                    '슬롯머신',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )
                                ],
                              )),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: Get.height * 0.2,
                            width: Get.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                // foodCategory 기반 음식점 추천이면 여기
                                // 음식 id 기반 음식점 추천이면 food_slot_controller.dart으로
                              },
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 30, 5),
                                  child: Text('추천 음식점',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12))),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
