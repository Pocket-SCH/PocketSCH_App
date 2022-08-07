import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_sch/custom_color.dart';

class NotifyRegKeyword extends StatefulWidget {
  const NotifyRegKeyword({Key? key}) : super(key: key);

  @override
  State<NotifyRegKeyword> createState() => _NotifyRegKeywordState();
}

class _NotifyRegKeywordState extends State<NotifyRegKeyword> {
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
                                    color: CustomColor.primary, fontSize: 15)),
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
                                      fixedSize: Size(width / 15, width / 15),
                                      shape: CircleBorder()
                                    ),
                                      onPressed: () {},
                                      child: Icon(Icons.add))
                                ],
                              ),
                            )
                          ]),
                    ),
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
