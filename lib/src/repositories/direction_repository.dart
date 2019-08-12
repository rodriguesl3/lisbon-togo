import 'package:dio/dio.dart';

import 'package:lisbon_togo/src/shared/constant.dart';
import 'package:lisbon_togo/src/shared/model/direction.dart';

class DirectionRepository {
  final Dio http;
  DirectionRepository(this.http);

  Future<Directions> getDirections(String fromLatitude, String fromLongitude,
      String toLatitude, String toLongitude) async{

        var apiUrl = ConstantsValues.getDirection(fromLatitude, fromLongitude, toLatitude, toLongitude);
        Response response = await http.get(apiUrl);

        return Directions.fromJson(response.data);
      }
}
