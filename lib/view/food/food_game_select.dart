import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/view/food/food_roulette.dart';
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
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                            top: Get.height * 0.2,
                            child: Text(
                              '종류',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Get.height * 0.25,
                                    width: Get.width * 0.4,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => FoodSlot(),
                                            arguments: Get.arguments);
                                      },
                                      child: Center(
                                          child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.2,
                                        child: Image(
                                            fit: BoxFit.contain,
                                            color: Colors.white,
                                            image: AssetImage(
                                                'assets/logo_slot.png')),
                                      )),
                                      style: ElevatedButton.styleFrom(
                                          primary: CustomColor.primaryDeepNoti,
                                          shape: CircleBorder()),
                                    ),
                                  ),
                                  Text(
                                    '슬롯머신',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Get.height * 0.25,
                                    width: Get.width * 0.4,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => FoodRoulette(),
                                            arguments: Get.arguments);
                                      },
                                      child: Center(
                                          child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.width * 0.2,
                                        child: Image(
                                            fit: BoxFit.contain,
                                            color: Colors.white,
                                            image: AssetImage(
                                                'assets/logo_roulette.png')),
                                      )),
                                      style: ElevatedButton.styleFrom(
                                          primary: CustomColor.primary,
                                          shape: CircleBorder()),
                                    ),
                                  ),
                                  Text(
                                    '룰렛',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
