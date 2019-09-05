import 'dart:convert';

List<LineModel> lineModelFromJson(String str) => new List<LineModel>.from(json.decode(str).map((x) => LineModel.fromJson(x)));

String lineModelToJson(List<LineModel> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class LineModel {
    String latitude;
    String longitude;
    String address;
    String stopCode;
    List<NextBus> nextBuses;

    LineModel({
        this.latitude,
        this.longitude,
        this.address,
        this.stopCode,
        this.nextBuses,
    });

    factory LineModel.fromJson(Map<String, dynamic> json) => new LineModel(
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        stopCode: json["stopCode"],
        nextBuses: new List<NextBus>.from(json["nextBuses"].map((x) => NextBus.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "stopCode": stopCode,
        "nextBuses": new List<dynamic>.from(nextBuses.map((x) => x.toJson())),
    };
}

class NextBus {
    String image;
    String time;
    String nextBusOperator;
    String code;
    String address;
    String line;

    NextBus({
        this.image,
        this.time,
        this.nextBusOperator,
        this.code,
        this.address,
        this.line,
    });

    factory NextBus.fromJson(Map<String, dynamic> json) => new NextBus(
        image: json["image"],
        time: json["time"],
        nextBusOperator: json["operator"],
        code: json["code"],
        address: json["address"],
        line: json["line"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "time": time,
        "operator": nextBusOperator,
        "code": code,
        "address": address,
        "line": line,
    };
}



// import 'package:json_annotation/json_annotation.dart';

// //flutter packages pub run build_runner build
// part 'stations.g.dart';

// @JsonSerializable()
// class LineModel {
//   final List<NextBusModel> nextBusList;
//   final List<StopLocationModel> stopLocationList;

//   LineModel(this.nextBusList, this.stopLocationList);

//   factory LineModel.fromJson(Map<String, dynamic> json) =>
//       _$LineModelFromJson(json);
// }

// @JsonSerializable()
// class NextBusModel {
//   final String image;
//   final String time;
//   final String operator;
//   final String code;
//   final String address;
//   final String line;

//   NextBusModel(
//       this.image, this.time, this.operator, this.code, this.address, this.line);

//   factory NextBusModel.fromJson(Map<String, dynamic> json) =>
//       _$NextBusModelFromJson(json);
// }

// @JsonSerializable()
// class StopLocationModel {
//   final String latitude;
//   final String longitude;
//   final String address;
//   final String stopCode;
//   bool isSearching;

//   StopLocationModel(this.latitude, this.longitude, this.address, this.stopCode,
//       {this.isSearching: false});

//   factory StopLocationModel.fromJson(Map<String, dynamic> json) =>
//       _$StopLocationModelFromJson(json);
// }
