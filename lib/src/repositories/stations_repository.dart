import 'package:dio/dio.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';

class StationsRepository {
  final Dio requestClient;
  StationsRepository(this.requestClient);

  Future<List<LineModel>> getStations(
      String latitude, String longitude, String date, String hour) async {
    var path =
        "/stops?latitude=${latitude}&longitude=${longitude}&data=${date}&hora=$hour";
    Response response = await requestClient.get(path);
    return (response.data as List)
        .map((stations) => LineModel.fromJson(stations))
        .toList();
  }
}
