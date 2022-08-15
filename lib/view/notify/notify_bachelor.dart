import 'package:flutter/material.dart';
import 'package:pocket_sch/custom_color.dart';
import 'package:get/get.dart';
import '../../controller/notify_home_controller.dart';
//flutter pub add http로 추가함
import 'package:http/http.dart' as http;
//json 파일에 한글이 깨져서 utf8을 사용하기 위해서 참조
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class Notify_bachelor extends StatelessWidget {
  final usedNotifyController = Get.put(notifyController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // usedNotifyController.callApi();
    return Container(
      child: Column(children: [
        // Text(usedNotifyController.allResponseJson['data']['totalPages']
        //     .toString()),
        // Text(usedNotifyController.contentResponseJson.length.toString()),
        Container(
          height: height * 0.6,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: usedNotifyController.contentResponseJson.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  width: width * 0.06,
                  height: height * 0.03,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.only(
                              top: 0, right: 0, left: width * 0.06, bottom: 0)),
                      onPressed: () async {
                        final url = Uri.parse(usedNotifyController
                            .contentResponseJson[index]['url']);
                        print(url);
                        await launchUrl(url);
                      },
                      child: Row(children: [
                        Container(
                            child: Text(
                              usedNotifyController.contentResponseJson[index]
                                      ['id']
                                  .toString(),
                              style: TextStyle(color: Color(0xffb2b2b2)),
                            ),
                            margin: EdgeInsets.only(
                                right: width * 0.03, left: width * 0.015),
                            width: width * 0.05),
                        Container(
                          child: Text(
                            (usedNotifyController
                                        .contentResponseJson[index]['title']
                                        .length >
                                    19)
                                ? usedNotifyController
                                    .contentResponseJson[index]['title']
                                    .substring(0, 19)
                                : usedNotifyController
                                    .contentResponseJson[index]['title'],
                            style: TextStyle(color: Color(0xffb2b2b2)),
                          ),
                          margin: EdgeInsets.only(right: width * 0.06),
                          width: width * 0.5,
                        ),
                        Container(
                          child: Text(
                            usedNotifyController.contentResponseJson[index]
                                    ['infoDate']
                                .substring(2, 10),
                            style: TextStyle(color: Color(0xffb2b2b2)),
                          ),
                        )
                      ])),
                );
              }),
        ),
        Container(
            height: height * 0.06,
            child: usedNotifyController.allResponseJson['data']['totalPages'] ==
                    'first'
                ? Text('')
                : Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: usedNotifyController.allResponseJson['data']
                            ['totalPages'],
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            height: height * 0.06,
                            child: TextButton(
                              onPressed: () {
                                usedNotifyController.callApi(index);
                              },
                              child: Text('${index + 1}'),
                            ),
                          );
                        })))
      ]),
    );
  }
}
