import 'dart:convert';

List<LineRouteDetailModel> lineRouteDetailModelFromJson(String str) =>
    new List<LineRouteDetailModel>.from(
        json.decode(str).map((x) => LineRouteDetailModel.fromJson(x)));

String lineRouteDetailModelToJson(List<LineRouteDetailModel> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class LineRouteDetailModel {
  String stopCode;
  String stopName;
  String stopLatitude;
  String stopLongitude;
  String time;
  List<RoutGeolocationList> routGeolocationList;

  LineRouteDetailModel({
    this.stopCode,
    this.stopName,
    this.stopLatitude,
    this.stopLongitude,
    this.time,
    this.routGeolocationList,
  });

  factory LineRouteDetailModel.fromJson(Map<String, dynamic> json) =>
      new LineRouteDetailModel(
        stopCode: json["stopCode"],
        stopName: json["stopName"],
        stopLatitude: json["stopLatitude"],
        stopLongitude: json["stopLongitude"],
        time: json["time"],
        routGeolocationList: json["routGeolocationList"] == null
            ? null
            : new List<RoutGeolocationList>.from(json["routGeolocationList"]
                .map((x) => RoutGeolocationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stopCode": stopCode,
        "stopName": stopName,
        "stopLatitude": stopLatitude,
        "stopLongitude": stopLongitude,
        "time": time,
        "routGeolocationList":
            new List<dynamic>.from(routGeolocationList.map((x) => x.toJson())),
      };
}

class RoutGeolocationList {
  String latitude;
  String longitude;

  RoutGeolocationList({
    this.latitude,
    this.longitude,
  });

  factory RoutGeolocationList.fromJson(Map<String, dynamic> json) =>
      new RoutGeolocationList(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
