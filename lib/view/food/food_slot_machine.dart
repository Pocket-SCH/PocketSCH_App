import 'package:flutter/material.dart';
import 'package:pocket_sch/view/food/food_slot_controller.dart';

class FoodSlotMachine extends StatefulWidget {
  late final FoodSlotController? controller;
  FoodSlotMachine({Key? key, this.controller}) : super(key: key);

  @override
  State<FoodSlotMachine> createState() => _FoodSlotMachineState();
}

class _FoodSlotMachineState extends State<FoodSlotMachine> {
  int counter = 0;

  List<Widget> _getSlots() {
    List<Widget> result = [];
    for (int i = 0; i <= 1; i++) {
      result.add(Container(
        padding: EdgeInsets.all(4.0),
        color: Colors.white,
        child: Image.asset(
          "assets/$i.png",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 240, 212, 103),
      child: ListWheelScrollView.useDelegate(
        controller: widget.controller?.getController(),
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 250,
        childDelegate: ListWheelChildLoopingListDelegate(children: _getSlots()),
        squeeze: 1.2,
        onSelectedItemChanged: (value) {
          counter++;
          if (counter == 10) {
            widget.controller?.start();
          }
        },
      ),
    );
  }
}
