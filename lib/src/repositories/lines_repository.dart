import 'package:dio/dio.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';
import 'package:lisbon_togo/src/shared/model/line_detail.dart';

class LinesRepository {
  final Dio requestClient;

  LinesRepository(this.requestClient);

  Future<CarrierLineModel> getLines(String searchQuery) async {
    final path = "/time/carriers?searchQuery=$searchQuery";
    Response response = await requestClient.get(path);
    return CarrierLineModel.fromJson(response.data);
  }

  Future<CarrierLineModel> getLocalLines(dynamic lines) async {
    return CarrierLineModel.fromJson(lines);
  }
}

class LineDetailRepository {
  final Dio requestClient;
  LineDetailRepository(this.requestClient);

  Future<List<LineRouteDetailModel>> getLineDetails(
      String codOp, String lineId, String hour, String minutes,
      {String date}) async {
    date = date == null
        ? "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString().padLeft(2, '0')}"
        : date;

    final path =
        "/time/detail?$codOp&$lineId&hour=$hour&minutes=$minutes&date=$date";

    Response response = await requestClient.get(path);

    return (response.data as List)
        .map((lines) => LineRouteDetailModel.fromJson(lines))
        .toList();
  }
}
