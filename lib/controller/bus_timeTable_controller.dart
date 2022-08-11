import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/bus_timeTable.dart';

class BusTimeTableController extends GetxController {
  var busTimeTableController = [].obs;

  getBusTimeTable(int weekDay) async {
    var headers = {
      'Authorization': 'nnewtokennn',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://13.209.200.114:8080/pocket-sch/v1/bus/timelist/2/${weekDay}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List<BusTimeTable> responses =
          parseBusTimeTable(await response.stream.bytesToString());

      busTimeTableController = responses.obs;

      print("controller에 잘 왔는지 확인 : $busTimeTableController");
    } else {
      print(response.reasonPhrase);
    }
  }

  // BusTimeTable list all parse
  List<BusTimeTable> parseBusTimeTable(String responseBody) {
    List<dynamic> parsed = json.decode(responseBody)["data"];

    return parsed
        .map<BusTimeTable>((json) => BusTimeTable.fromJson(json))
        .toList();
  }
}
