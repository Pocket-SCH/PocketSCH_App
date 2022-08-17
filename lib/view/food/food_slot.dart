import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/controller/solid_button_builder.dart';
import 'package:pocket_sch/view/food/food_category.dart';
import 'package:pocket_sch/view/food/food_slot_controller.dart';
import 'package:pocket_sch/view/food/food_slot_machine.dart';
import '../../custom_color.dart';

class FoodSlot extends StatefulWidget {
  FoodSlot({Key? key}) : super(key: key);

  @override
  State<FoodSlot> createState() => _FoodSlotState();
}

class _FoodSlotState extends State<FoodSlot> {
  late FoodSlotController foodSlotController;
  @override
  void initState() {
    super.initState();
    foodSlotController = FoodSlotController();
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
          onPressed: () => Get.off(() => FoodCategory()),
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
                      Flexible(
                          flex: 3,
                          child: Container(
                            height: double.infinity,
                            color: Colors.black,
                            child: Stack(
                              children: [
                                Container(
                                  height: double.infinity,
                                  color: Colors.white,
                                  child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/img_slot_modified.png')),
                                ),
                                Column(
                                  children: [
                                    Flexible(flex: 150, child: Container()),
                                    Flexible(
                                        flex: 130,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                flex: 110, child: Container()),
                                            Flexible(
                                                flex: 300,
                                                //여기에 룰렛 삽입
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 8,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.4)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        child: FoodSlotMachine(
                                                            controller:
                                                                foodSlotController),
                                                      ),
                                                      Center(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              width: 3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      253,
                                                                      242,
                                                                      145),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            Flexible(
                                              flex: 100,
                                              child: Container(),
                                            )
                                          ],
                                        )),
                                    Flexible(flex: 130, child: Container())
                                  ],
                                )
                              ],
                            ),
                          )),

                      //돌리기 버튼 부분
                      //3D 로 제작예정
                      Flexible(
                          flex: 1,
                          child: Center(
                            child: Container(
                                child: SolidButtonBuilder(
                              hegiht: 80,
                              width: 100,
                              text: 'START',
                              shadowcolor: Color.fromARGB(255, 114, 14, 47),
                              color: Colors.pink,
                              onPressed: () {
                                foodSlotController.start();
                              },
                            )),
                          ))
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
}
