import 'package:dio/dio.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';

class LinesRepository {
  final Dio requestClient;

  LinesRepository(this.requestClient);

  Future<CarrierLineModel> getLines(String searchQuery) async {
    var path = "/time/carriers?searchQuery=$searchQuery";

    Response response = await requestClient.get(path);

    return CarrierLineModel.fromJson(response.data);
  }

  Future<CarrierLineModel> getLocalLines(dynamic lines) async{
    return CarrierLineModel.fromJson(lines);
  }
}
