import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/custom_color.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                width: width / 4, image: AssetImage('assets/logo_noback.png')),
            SizedBox(height: 20),
            //--------------------
            //공지사항 메인 페이지로 이동
            //--------------------
            Container(
              width: width / 2,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('notify/regKeyword');
                },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 30, 5),
                    child: RichText(
                      text: TextSpan(children: const <TextSpan>[
                        TextSpan(
                            text: ' KEYWORD ',
                            style: TextStyle(
                                backgroundColor: CustomColor.primary,
                                fontSize: 12,
                                color: Colors.white)),
                        TextSpan(text: ' '),
                        TextSpan(
                            text: '공지사항',
                            style: TextStyle(color: Colors.black, fontSize: 12))
                      ]),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
            ),

            //--------------------
            //버스 메인 페이지로 이동
            //--------------------
            Container(
              margin: EdgeInsets.only(top: 10),
              width: width / 2,
              child: ElevatedButton(
                onPressed: () {
                  // 임시로 alarm으로 이동하게 했습니다. 개발하면서 변경하셔도 좋아요!  + bus로 변경
                  Get.toNamed('bus');
                },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 30, 5),
                    child: RichText(
                      text: TextSpan(children: const <TextSpan>[
                        TextSpan(
                            text: ' LIVE ',
                            style: TextStyle(
                                backgroundColor: CustomColor.primary,
                                fontSize: 12,
                                color: Colors.white)),
                        TextSpan(text: ' '),
                        TextSpan(
                            text: '버스',
                            style: TextStyle(color: Colors.black, fontSize: 12))
                      ]),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
            ),

            //--------------------
            //음식 메인 페이지로 이동
            //--------------------
            Container(
              margin: EdgeInsets.only(top: 10),
              width: width / 2,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('food/category');
                },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 30, 5),
                    child: RichText(
                      text: TextSpan(children: const <TextSpan>[
                        TextSpan(
                            text: ' RANDOM ',
                            style: TextStyle(
                                backgroundColor: CustomColor.primary,
                                fontSize: 12,
                                color: Colors.white)),
                        TextSpan(text: ' '),
                        TextSpan(
                            text: '음식',
                            style: TextStyle(color: Colors.black, fontSize: 12))
                      ]),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
