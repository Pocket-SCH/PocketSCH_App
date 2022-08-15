import 'package:get/get.dart';
//flutter pub add http로 추가함
import 'package:http/http.dart' as http;
//json 파일에 한글이 깨져서 utf8을 사용하기 위해서 참조
import 'dart:convert';
import 'package:pocket_sch/controller/token_controller.dart';

class notifyController extends GetxController {
  RxString whichPage = 'academy'.obs;
  //기본 공지 = academy / 학사공지 = bachelor / key 공지 = keyword
  void changePage(string) {
    this.whichPage = string;
    print('whichPage값이 ${this.whichPage}로 변경되었습니다.');
    update();
  }

  Map<String, dynamic> allResponseJson = {
    'data': {'totalPages': 'first'}
  };
  List<dynamic> contentResponseJson = [];

  void callApi(int page) async {
    print('callApi');
    final url = Uri.parse(
        'http://13.209.200.114:8080/pocket-sch/v1/info/university-notices?page=${page}&size=20');
    var request = http.Request('Get', url);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('response success!!');
      this.allResponseJson = jsonDecode(await response.stream.bytesToString());
      // print(responseJson);
      this.contentResponseJson = await this.allResponseJson['data']['content'];
      print(contentResponseJson);
      print(allResponseJson);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  void callBachelorApi(int page) async {
    print('callBachelorApi');
    final url = Uri.parse(
        'http://13.209.200.114:8080/pocket-sch/v1/info/bachelor-notices?page=${page}&size=20');
    var request = http.Request('Get', url);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('response success!!');
      this.allResponseJson = jsonDecode(await response.stream.bytesToString());
      // print(responseJson);
      this.contentResponseJson = await this.allResponseJson['data']['content'];
      print(contentResponseJson);
      print(allResponseJson);
      update();
    } else {
      print(response.reasonPhrase);
    }
  }

  void callKeywordApi(int page) async {
    print('callKeywordApi');
    var headers = {'Authorization': '${Get.find<TokenController>().token}'};
    final url = Uri.parse(
        'http://13.209.200.114:8080/pocket-sch/v1/info/search-keyword?page=${page}&size=20');
    var request = http.Request('Get', url);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('response success!!');
      this.allResponseJson = jsonDecode(await response.stream.bytesToString());
      // print(responseJson);
      this.contentResponseJson = await this.allResponseJson['data']['content'];
      print('content ${contentResponseJson}');
      print('all ${allResponseJson}');
      update();
    } else {
      print(response.reasonPhrase);
    }
  }
}
