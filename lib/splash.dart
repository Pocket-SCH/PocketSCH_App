import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/custom_color.dart';
import 'package:pocket_sch/view/home.dart';

class Splash extends StatefulWidget {
  const Splash({ Key? key }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => Get.off(Home()));
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColor.splashMint,
      body: Center(
        child: Image(
          width: width * 2 / 5,
          image: AssetImage('assets/logo_color.png'),
        ),
      ),
    );
  }
}