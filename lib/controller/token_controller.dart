import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

//TokenController.to.token 또는
//Get.find<TokenController>().token 를 입력하시면
//토큰 값을 가져올 수 있습니다
class TokenController extends GetxController{
  static TokenController get to => Get.find();
  String token = '';

  //앱 실행 시 main에서 아래 함수를 통해 토큰 값이 설정되므로
  //다른 페이지들에서는 아래 함수를 통해 토큰 값 가져오지 않아도 됩니다.
  getToken() async{
    token = (await FirebaseMessaging.instance.getToken(vapidKey: "fcm 인증 키"))!;
    return token;
  }
}