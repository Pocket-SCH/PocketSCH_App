import 'package:flutter/material.dart';
import 'package:pocket_sch/custom_color.dart';
import 'package:get/get.dart';
import '../../controller/notify_home_controller.dart';
import './notify_bachelor.dart';
import './notify_academy.dart';
import './notify_keyword.dart';

//공지사항 페이지 홈
class NotifyHome extends StatefulWidget {
  const NotifyHome({Key? key}) : super(key: key);

  @override
  State<NotifyHome> createState() => _NotifyHomeState();
}

class _NotifyHomeState extends State<NotifyHome> {
  //getX 사용을 위한 컨트롤러 생성
  final usedNotifyController = Get.put(notifyController());
  @override
  Widget build(BuildContext context) {
    //거리 조절을 위한 변수
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    RxString resultAcademy = 'academy'.obs;
    RxString resultBachelor = 'bachelor'.obs;
    RxString resultKeyword = 'keyword'.obs;

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
                      text: '공지사항',
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
                    child: Column(children: [
                      //여기서부터 코드 작성
                      GetBuilder<notifyController>(
                        builder: (_) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      width * 0.058,
                                      height * 0.022,
                                      width * 0.037,
                                      height * 0.024),
                                  width: width * 0.24,
                                  child: Obx(() {
                                    return TextButton(
                                        onPressed: () {
                                          // 처음엔 find로 썻다가 나중에 변수로 하는게 코드적으로 좋을 거 같아서 그렇게 바꿈
                                          // Get.find<notifyController>().changePage('academy');
                                          usedNotifyController.callApi(0);
                                          usedNotifyController
                                              .changePage(resultAcademy);
                                          ;
                                        },
                                        child: Text(
                                          '대학 공지',
                                          style: TextStyle(
                                              color: (usedNotifyController
                                                          .whichPage ==
                                                      'academy')
                                                  ? CustomColor.floatingAlarm
                                                  : CustomColor
                                                      .primaryDeepNoti),
                                        ),
                                        style: TextButton.styleFrom(
                                            side: BorderSide(
                                                color: (usedNotifyController
                                                            .whichPage ==
                                                        'academy')
                                                    ? CustomColor.floatingAlarm
                                                    : Color.fromARGB(
                                                        255, 68, 95, 95)),
                                            backgroundColor:
                                                (usedNotifyController
                                                            .whichPage ==
                                                        'academy')
                                                    ? CustomColor
                                                        .primaryDeepNoti
                                                    : Colors.white));
                                  })),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, height * 0.022,
                                      width * 0.037, height * 0.024),
                                  width: width * 0.24,
                                  child: TextButton(
                                      onPressed: () {
                                        usedNotifyController.callBachelorApi(0);
                                        usedNotifyController
                                            .changePage(resultBachelor);
                                      },
                                      child: Text(
                                        '학사 공지',
                                        style: TextStyle(
                                            color: (usedNotifyController
                                                        .whichPage ==
                                                    'bachelor')
                                                ? CustomColor.floatingAlarm
                                                : CustomColor.primaryDeepNoti),
                                      ),
                                      style: TextButton.styleFrom(
                                          side: BorderSide(
                                              color: (usedNotifyController
                                                          .whichPage ==
                                                      'bachelor')
                                                  ? CustomColor.floatingAlarm
                                                  : Color.fromARGB(
                                                      255, 68, 95, 95)),
                                          backgroundColor:
                                              (usedNotifyController.whichPage ==
                                                      'bachelor')
                                                  ? CustomColor.primaryDeepNoti
                                                  : Colors.white))),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, height * 0.022,
                                      width * 0.058, height * 0.024),
                                  width: width * 0.24,
                                  child: TextButton(
                                      onPressed: () {
                                        usedNotifyController.callKeywordApi(0);
                                        usedNotifyController
                                            .changePage(resultKeyword);
                                      },
                                      child: Text(
                                        'KEY 공지',
                                        style: TextStyle(
                                            color: (usedNotifyController
                                                        .whichPage ==
                                                    'keyword')
                                                ? CustomColor.floatingAlarm
                                                : CustomColor.primaryDeepNoti),
                                      ),
                                      style: TextButton.styleFrom(
                                          side: BorderSide(
                                              color: (usedNotifyController
                                                          .whichPage ==
                                                      'keyword')
                                                  ? CustomColor.floatingAlarm
                                                  : Color.fromARGB(
                                                      255, 68, 95, 95)),
                                          backgroundColor:
                                              (usedNotifyController.whichPage ==
                                                      'keyword')
                                                  ? CustomColor.primaryDeepNoti
                                                  : Colors.white)))
                            ],
                          );
                        },
                      ),
                      Row(children: [
                        Container(
                          child: Text('번호',
                              style: TextStyle(
                                  color: Color(0xffb2b2b2), fontSize: 12)),
                          margin: EdgeInsets.only(
                              right: width * 0.02, left: width * 0.06),
                          width: width * 0.07,
                        ),
                        Container(
                          child: Text(
                            '제목',
                            style: TextStyle(
                                color: Color(0xffb2b2b2), fontSize: 12),
                          ),
                          width: width * 0.5,
                        )
                      ]),
                      Divider(
                        height: 12,
                        thickness: 1,
                        color: Color(0xff707070),
                      ),

                      GetBuilder<notifyController>(builder: (_) {
                        if (usedNotifyController.whichPage == resultKeyword) {
                          print('getX KeyWord');
                          return Notify_keyWord();
                        } else if (usedNotifyController.whichPage ==
                            resultBachelor) {
                          print('getX KeyWord');
                          return Notify_bachelor();
                        }
                        return Notify_academy();
                      }),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
