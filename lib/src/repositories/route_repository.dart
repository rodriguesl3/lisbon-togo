import 'package:dio/dio.dart';

import 'package:lisbon_togo/src/shared/model/route.dart';

class RouteRepository {
  final Dio requestClient;
  RouteRepository(this.requestClient);

  

  Future<List<RouteModel>> getRoute(
    String fromLatitude,
    String fromLongitude,
    String toLatitude,
    String toLongitude,
    String date,
    String hour,
    bool isArrivalTime
  ) async {

    var path = "/routes?startLatitude=$fromLatitude&startLongitude=$fromLongitude";
    path+="&endLatitude=$toLatitude&endLongitude=$toLongitude";
    path+="&data=$date&hora=$hour&isArrivalTime=$isArrivalTime";

    Response response = await requestClient.get(path);
    return (response.data as List)
        .map((routes) => RouteModel.fromJson(routes))
        .toList();
  }
}
