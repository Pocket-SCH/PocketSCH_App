import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/view/food/food_slot_controller.dart';

class FoodSlotMachine extends StatefulWidget {
  //FixedExtentScrollController를 커스텀한 FoodSlotController 생성
  late final FoodSlotController controller;
  FoodSlotMachine({Key? key, required this.controller}) : super(key: key);

  @override
  State<FoodSlotMachine> createState() => _FoodSlotMachineState();
}

class _FoodSlotMachineState extends State<FoodSlotMachine> {
  int counter = 0;

  // 여기서 글자가 쓰여진 카드를 만든다
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
    widget.controller.dispose();
    super.dispose();
  }

  //데이터를 받아오는 곧
  List<Widget> getData() {
    List<Widget> tmp = [];

    for (int i = 0; i < 10; i++) {
      tmp.add(Container(
          child: Center(
              child: Text(
        i.toString(),
        style: TextStyle(fontSize: 20),
      ))));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> initData = [];

    return FutureBuilder(
        future: widget.controller.makeSlotByCategory(Get.arguments),
        initialData: initData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return Container(
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: ListWheelScrollView.useDelegate(
                      controller: widget.controller.getController(),
                      physics: const FixedExtentScrollPhysics(),
                      itemExtent: 80,
                      childDelegate: ListWheelChildLoopingListDelegate(
                          children: snapshot.data),
                      squeeze: 1.3,
                      //useMagnifier: true,
                      //magnification: 1.5,
                      onSelectedItemChanged: (value) {},
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Opacity(
                      opacity: 0.9,
                      child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/img_shadow.png')),
                    ),
                  )
                ],
              ),
            );
          }
        });
    /*
    return Container(
      color: Colors.white,
      child: ListWheelScrollView.useDelegate(
        controller: widget.controller.getController(),
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 80,
        childDelegate: ListWheelChildLoopingListDelegate(
            children: widget.controller.getData()),
        squeeze: 1.3,
        //useMagnifier: true,
        //magnification: 1.5,
        onSelectedItemChanged: (value) {},
      ),
    );
  }
  */
  }
}
