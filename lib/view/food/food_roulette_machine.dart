import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';

import 'arrow.dart';

class FoodRouletteMachine extends StatefulWidget {
  final RouletteController controller;
  const FoodRouletteMachine({Key? key, required this.controller})
      : super(key: key);

  @override
  State<FoodRouletteMachine> createState() =>
      _FoodRouletteMachineState(controller);
}

class _FoodRouletteMachineState extends State<FoodRouletteMachine> {
  late final RouletteController controller;

  _FoodRouletteMachineState(RouletteController controller) {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              // Provide controller to update its state
              controller: controller,
              // Configure roulette's appearance
              style: const RouletteStyle(
                dividerThickness: 4,
                textLayoutBias: .8,
                centerStickerColor: Colors.white,
              ),
            ),
          ),
        ),
        const Arrow(),
      ],
    );
  }
}
