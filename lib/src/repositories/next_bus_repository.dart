import 'package:dio/dio.dart';
import 'package:lisbon_togo/src/shared/model/next_bus.dart';

class NextBusRepository {
  final Dio requestClient;

  NextBusRepository(this.requestClient);

  Future<List<NextBusModel>> getNextBus(String fromLatitude,
      String fromLongitude, List<String> destinations) async {
    var path =
        "/routes/next?startLatitude=$fromLatitude&startLongitude=$fromLongitude&";
    path +=
        "dateTime=${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}";
    for (var destination in destinations) {
      path += "&destinations=$destination";
    }
    Response response = await requestClient.get(path);
    return (response.data["data"] as List)
        .map((nextBus) => NextBusModel.fromJson(nextBus))
        .toList();
  }
}
