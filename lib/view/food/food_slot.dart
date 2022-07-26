import 'dart:math';

import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    foodSlotController = FoodSlotController();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                                                    flex: 110,
                                                    child: Container()),
                                                Flexible(
                                                    flex: 300,
                                                    //여기에 룰렛 삽입
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 8,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                              width: double
                                                                  .infinity,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
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
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                        child: SolidButtonBuilder(
                                      hegiht: 80,
                                      width: 100,
                                      text: 'START',
                                      shadowcolor:
                                          Color.fromARGB(255, 114, 14, 47),
                                      color: Colors.pink,
                                      onPressed: () {
                                        foodSlotController
                                            .start(_confettiController);
                                      },
                                    )),
                                    Positioned(
                                      right: Get.width * 0.1,
                                      child: Container(
                                          child: SolidButtonBuilder(
                                        hegiht: 50,
                                        width: 70,
                                        text: 'SKIP',
                                        textstyle: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                        shadowcolor: Colors.green,
                                        color: Colors.greenAccent,
                                        onPressed: () {
                                          foodSlotController
                                              .skip(_confettiController);
                                        },
                                      )),
                                    )
                                  ],
                                ),
                              ))
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi, // radial value - LEFT
            particleDrag: 0.05, // apply drag to the confetti
            emissionFrequency: 0.02, // how often it should emit
            numberOfParticles: 20, // number of particles to emit
            gravity: 0.05, // gravity - or fall speed
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink
            ], // manually specify the colors to be used
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 0, // radial value - LEFT
            particleDrag: 0.05, // apply drag to the confetti
            emissionFrequency: 0.02, // how often it should emit
            numberOfParticles: 10, // number of particles to emit
            gravity: 0.05, // gravity - or fall speed
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink
            ], // manually specify the colors to be used
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
