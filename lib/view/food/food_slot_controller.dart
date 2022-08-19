import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/token_controller.dart';

abstract class Disposable {
  void dispose();
}

class FoodSlotController implements Disposable {
  late FixedExtentScrollController _controller = FixedExtentScrollController();
  late List<String> _data;
  late Timer? _timer = null;
  late int selectedIndex = -1;

  @override
  void dispose() {
    _controller.dispose();
  }

  FixedExtentScrollController getController() {
    return _controller;
  }

  // 구동부분
  // 시작
  void start() {
    // 랜덤한 시간을 가지고 돌리기 시작
    // 5~8초까지의 랜덤한 시간동안 돌아가게 함
    _controller.jumpToItem(0);
    int randomDuration = Random().nextInt(8) + 5;
    int randomItem = Random().nextInt(300) + 100;

    selectedIndex = randomItem % _data.length;

    _controller.animateToItem(randomItem,
        duration: Duration(seconds: randomDuration), curve: Curves.decelerate);

    // 여러번의 START 버튼을 눌렀을 경우 기존에 것을 취소하기 위한 구문
    _timer?.cancel();
    openDialog();
    _timer = Timer(Duration(seconds: randomDuration), () {});
  }

  // 구동부분
  // 스킵
  void skip() {}

  void openDialog() {
    Get.dialog(
      Dialog(
        child: Container(
            width: Get.width * 0.8,
            height: Get.height * 0.35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Container(
                width: Get.width * 0.7,
                height: Get.height * 0.3,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _data[selectedIndex],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  int serverAdapter(int categoryId) {
    int returnVal = -1;
    switch (categoryId) {
      default:
        returnVal = 4;
    }
    return returnVal;
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

    _data = tmp;
    return tmp;
  }

  // 카드를 만들어 주는 곳
  Future<List<Widget>> makeSlotByCategory(int categoryId) async {
    List<String> textTmp = await getData(categoryId);
    List<Widget> result = [];
    for (String text in textTmp) {
      result.add(Center(
        child: Container(
          child: Text(text),
        ),
      ));
    }
    return result;
  }
}
