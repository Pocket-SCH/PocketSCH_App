import 'dart:convert';

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

  @override
  void dispose() {
    _controller.dispose();
  }

  FixedExtentScrollController getController() {
    return _controller;
  }

  void start() {
    _controller.animateToItem(500,
        duration: const Duration(seconds: 25), curve: Curves.decelerate);
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
      List list = data['data'];
      for (Map a in list) {
        tmp.add(a['name']);
      }
    } else {
      print(response.reasonPhrase);
    }

    return tmp;
  }

  // 카드를 만들어 주는 곳
  Future<List<Widget>> makeSlotByCategory(int categoryId) async {
    List<String> textTmp = await getData(1);
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
