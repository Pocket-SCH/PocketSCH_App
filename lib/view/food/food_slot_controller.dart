import 'package:flutter/material.dart';

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
  List<Widget> getData() {
    List<Widget> tmp = [];

    for (int i = 0; i < 10; i++) {
      tmp.add(Container(child: Center(child: Text(i.toString()))));
    }
    return tmp;
  }
}
