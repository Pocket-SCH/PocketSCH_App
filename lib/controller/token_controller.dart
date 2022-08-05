import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TokenController extends GetxController{
  String token = '';

  getToken() async{
    token = (await FirebaseMessaging.instance.getToken(vapidKey: "fcm 인증 키"))!;
  }
}