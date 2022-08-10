import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/controller/token_controller.dart';
import 'package:pocket_sch/custom_color.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_sch/model/reg_keyword.dart';

class NotifyRegKeyword extends StatefulWidget {
  const NotifyRegKeyword({Key? key}) : super(key: key);

  @override
  State<NotifyRegKeyword> createState() => _NotifyRegKeywordState();
}

class _NotifyRegKeywordState extends State<NotifyRegKeyword> {
  final _addKeywordController = TextEditingController();
  List<RegKeyword> keyList = [];

  @override
  void initState() {
    loadKeyword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/btn_back.png',
              color: Color.fromARGB(255, 0, 0, 0), width: 15),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              RichText(
                text: TextSpan(children: const <TextSpan>[
                  TextSpan(
                      text: ' KEYWORD ',
                      style: TextStyle(
                          backgroundColor: CustomColor.primary,
                          fontSize: 18,
                          color: Colors.white)),
                  TextSpan(text: ' '),
                  TextSpan(
                      text: '추가하기',
                      style: TextStyle(color: Colors.black, fontSize: 18))
                ]),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('나의 KEYWORD',
                                  style: TextStyle(
                                      color: Color(0xff78c5bd), fontSize: 15)),
                              //---------------
                              //알림 키워드 추가
                              //---------------
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 35),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: width * 7 / 11,
                                      height: 45,
                                      child: TextField(
                                          controller: _addKeywordController,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffd2d2d2)),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomColor.primary),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white70)),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: CustomColor.primary,
                                            fixedSize:
                                                Size(width / 15, width / 15),
                                            shape: CircleBorder()),
                                        onPressed: () {
                                          regKeyword(
                                              _addKeywordController.text);
                                          _addKeywordController.clear();
                                        },
                                        child: Icon(Icons.add))
                                  ],
                                ),
                              ),
                              //---------------
                              //알림 키워드 리스트
                              //---------------
                              Text('추가된 KEYWORD',
                                  style: TextStyle(
                                      color: Color(0xffb2b2b2), fontSize: 12)),
                              Divider(
                                height: 12,
                                thickness: 1,
                                color: Color(0xff707070),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: keyList.length,
                                itemBuilder: (BuildContext context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(keyList[index].keyword),
                                    IconButton(onPressed: (){
                                      deleteKeyword(keyList[index].id.toString(), keyList[index].keyword);
                                    }, icon: Image.asset('assets/btn_delete.png'))

                                  ],
                                );
                              })
                            ])),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //서버에 키워드 등록
  regKeyword(String data) async {
    var headers = {
      'Authorization': '${Get.find<TokenController>().token}',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('http://13.209.200.114:8080/pocket-sch/v1/info/keywords'));
    request.body = json.encode({"keyword": data});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print('Success');
    } else {
      print(await response.stream.bytesToString());
    }
  }

  //키워드 불러오기
  loadKeyword() async {
    var headers = {'Authorization': '${Get.find<TokenController>().token}'};
    var request = http.Request('GET',
        Uri.parse('http://13.209.200.114:8080/pocket-sch/v1/info/keywords'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  //키워드 삭제
  deleteKeyword(String id, String keyword) async {
    var headers = {
      'Authorization': '${Get.find<TokenController>().token}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'http://13.209.200.114:8080/pocket-sch/v1/info/keywords/$id'));
    request.body = json.encode({"keyword": "$keyword"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
