import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_sch/controller/token_controller.dart';
import '../model/reg_keyword.dart';

class RegKeywordController extends GetxController{
  static RegKeywordController get to => Get.find();
  var keyList = <RegKeyword>[].obs;
  
  @override
  void onInit() async {
    super.onInit();
    loadKeyword();
  }
  
  //키워드 불러오기
  loadKeyword() async {
    var headers = {'Authorization': '${Get.find<TokenController>().token}'};
    var request = http.Request('GET',
        Uri.parse('http://13.209.200.114:8080/pocket-sch/v1/info/keywords'));

    request.headers.addAll(headers);
    
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parseData = await http.Response.fromStream(response);
      var body = utf8.decode(parseData.bodyBytes);
      var data = jsonDecode(body);
      List list = data['data']['content'];
      keyList.clear();
      for(Map a in list){
        keyList.add(RegKeyword(a['id'], a['keyword']));
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}