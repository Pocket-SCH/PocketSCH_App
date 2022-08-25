import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../custom_color.dart';
import 'package:http/http.dart' as http;
//import 'dart:async';
import 'dart:convert';
import '../../controller/token_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodStore extends StatefulWidget {
  const FoodStore({Key? key}) : super(key: key);

  @override
  State<FoodStore> createState() => _FoodStoreState();
}

class _FoodStoreState extends State<FoodStore> {
  List<String> _data1 = [""];
  List<String> _data2 = [""];

  Future<List<String>> getData2(int menuId) async {
    List<String> tmp1 = [];
    List<String> tmp2 = [];

    var headers = {'Authorization': '${Get.find<TokenController>().token}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://13.209.200.114:8080/pocket-sch/v1/food/food-store-list/menu/' +
                menuId.toString()));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var parseData = await http.Response.fromStream(response);
      var body = utf8.decode(parseData.bodyBytes);
      var data = jsonDecode(body);
      print(data);
      List list = data['data'];
      for (Map a in list) {
        tmp1.add(a['storeName']);
        tmp2.add(a['storeUrl']);
      }
    } else {
      print(response.reasonPhrase);
    }

    _data1 = tmp1;
    _data2 = tmp2;
    print(_data1); //
    print(_data2); //
    return tmp1;
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            RichText(
              text: TextSpan(children: const <TextSpan>[
                TextSpan(
                    text: ' RANDOM ',
                    style: TextStyle(
                        backgroundColor: CustomColor.primary,
                        fontSize: 18,
                        color: Colors.white)),
                TextSpan(text: ' '),
                TextSpan(
                    text: '음식',
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                          child: Text(
                            '[ ${Get.arguments['name']} ] 추천 음식점',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                        //
                        FutureBuilder(
                            future: getData2(Get.arguments['id']),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                return CircularProgressIndicator();
                              } else {
                                List<String> tmp = snapshot.data;
                                print(tmp);
                                return Expanded(
                                  child: Container(
                                    child: ListView.builder(
                                        itemCount: tmp.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: ListTile(
                                              title: Text(tmp[index],
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              trailing: IconButton(
                                                  onPressed: () async {
                                                    final url = Uri.parse(
                                                        _data2[index]
                                                            .toString());
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      launchUrl(url);
                                                    } else {
                                                      print('실패다실패 다시다싣사ㅣ');
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.room,
                                                    size: 30,
                                                  )),
                                            ),
                                          );
                                        }),
                                  ),
                                );
                              }
                            }),
                        /*
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: ListTile(
                            title: Text('중국집', style: TextStyle(fontSize: 18)),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.room,
                                  size: 30,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: ListTile(
                            title: Text('진시황', style: TextStyle(fontSize: 18)),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.room,
                                  size: 30,
                                )),
                          ),
                        ),
                        */
                        /*
                        ListView.builder(
                          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                          itemCount: _data.length,
                          itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: ListTile(
                                  title: Text(_data[index],
                                      style: TextStyle(fontSize: 18)),
                                  trailing: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.room,
                                        size: 30,
                                      )),
                                ),
                              );
                            //return ListTile(
                            //  title: Text('피자'),
                            //  trailing: Icon(Icons.room),
                            //);
                          },
                        )
                        */
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
