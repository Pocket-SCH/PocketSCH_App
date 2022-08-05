import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TokenController extends GetxController{
  String token = '';

  //앱 실행 시 main에서 아래 함수를 통해 토큰 값이 설정되므로
  //다른 페이지들에서는 아래 함수를 통해 토큰 값 가져오지 않아도 됩니다.
  getToken() async{
    token = (await FirebaseMessaging.instance.getToken(vapidKey: "fcm 인증 키"))!;
    return token;
  }
}