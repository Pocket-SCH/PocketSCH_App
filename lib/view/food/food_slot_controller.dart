import 'package:flutter/material.dart';

abstract class Disposable {
  void dispose();
}

class FoodSlotController implements Disposable {
  late FixedExtentScrollController _controller = FixedExtentScrollController();

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
}
