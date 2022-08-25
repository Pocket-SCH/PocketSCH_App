import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/view/food/food_roulette_machine.dart';
import 'package:roulette/roulette.dart';
import 'package:http/http.dart' as http;

import '../../controller/solid_button_builder.dart';
import '../../controller/token_controller.dart';
import '../../custom_color.dart';
import 'arrow.dart';

class FoodRoulette extends StatefulWidget {
  const FoodRoulette({Key? key}) : super(key: key);

  @override
  State<FoodRoulette> createState() => _FoodRouletteState();
}

class _FoodRouletteState extends State<FoodRoulette>
    with SingleTickerProviderStateMixin {
  static final _random = Random();

  late RouletteController _controller;
  late ConfettiController _confettiController;

  late List<String> _data;
  late List<Color> _color = [];
  int _selectedIndex = -1;

  final colors = <Color>[
    Colors.red.withAlpha(80),
    Colors.green.withAlpha(80),
    Colors.blue.withAlpha(80),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(80),
    Colors.indigo.withAlpha(80),
  ];

  @override
  void initState() {
    // Initialize the controller
    /*
    final group = RouletteGroup.uniform(
      colors.length,
      colorBuilder: colors.elementAt,
    );
    _controller = RouletteController(vsync: this, group: group);
    */
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  Future<RouletteController> makeUnit() async {
    _data = await getData(Get.arguments);

    for (int i = 0; i < _data.length; i++) {
      _color.add(colors[i % colors.length]);
    }

    final group = RouletteGroup.uniform(
      _data.length,
      colorBuilder: _color.elementAt,
      textBuilder: (index) => _data[index],
      textStyleBuilder: (index) {
        // Set the text style here!
        TextStyle(color: Colors.black);
      },
    );

    return RouletteController(vsync: this, group: group);
    ;
  }

  //데이터를 받아오는 곧
  Future<List<String>> getData(int categoryId) async {
    List<String> tmp = [];

    var headers = {'Authorization': '${Get.find<TokenController>().token}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://13.209.200.114:8080/pocket-sch/v1/food/food-list/category/' +
                categoryId.toString()));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parseData = await http.Response.fromStream(response);
      var body = utf8.decode(parseData.bodyBytes);
      var data = jsonDecode(body);
      print(data);
      List list = data['data'];
      for (Map a in list) {
        tmp.add(a['name']);
      }
    } else {
      print(response.reasonPhrase);
    }
    return tmp;
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
                              flex: 5,
                              child: Container(
                                child: Center(
                                    child: FutureBuilder(
                                  future: makeUnit(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData == false) {
                                      return CircularProgressIndicator();
                                    } else {
                                      _controller = snapshot.data;
                                      return FoodRouletteMachine(
                                          controller: snapshot.data);
                                    }
                                  },
                                )),
                              )),
                          //돌리기 버튼 부분
                          //3D 로 제작예정
                          Flexible(
                              flex: 2,
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
                                      onPressed: () async {
                                        _selectedIndex =
                                            _random.nextInt(_data.length);
                                        await _controller.rollTo(_selectedIndex,
                                            offset: _random.nextDouble());
                                        _confettiController.play();
                                        openDialog();

                                        _selectedIndex = -1;
                                      },
                                    )),
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

  @override
  void dispose() {
    _confettiController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void openDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            width: Get.width * 0.8,
            height: Get.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Container(
                          width: Get.width * 0.7,
                          height: Get.height * 0.3,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _data[_selectedIndex],
                                style: TextStyle(fontSize: 30),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: CustomColor.mustard,
                                ),
                                onPressed: () {
                                  // 음식 id 기반으로 음식점 추천
                                },
                                child: Text('추천 음식점')),
                            SizedBox(
                              width: 10,
                            ),
                            */
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: CustomColor.primary,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('확인'))
                          ],
                        ),
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
