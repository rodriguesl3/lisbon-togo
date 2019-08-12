import 'package:dio/dio.dart';
import 'package:lisbon_togo/src/shared/constant.dart';

class RequestClient {
  Dio dio = Dio();


  RequestClient() {
    dio.options.baseUrl = ConstantsValues.URL_API;
  }

  Dio requestHttp() => dio;
}

class RequestDirection{
  Dio dio = Dio();

  RequestDirection();

  Dio requestHttp()=> dio;
}
