import 'package:json_annotation/json_annotation.dart';

//flutter packages pub run build_runner build
part 'stations.g.dart';

@JsonSerializable()
class LineModel {
  final List<NextBusModel> nextBusList;
  final List<StopLocationModel> stopLocationList;

  LineModel(this.nextBusList, this.stopLocationList);

  factory LineModel.fromJson(Map<String, dynamic> json) =>
      _$LineModelFromJson(json);
}

@JsonSerializable()
class NextBusModel {
  final String image;
  final String time;
  final String operator;
  final String code;
  final String address;
  final String line;

  NextBusModel(
      this.image, this.time, this.operator, this.code, this.address, this.line);

  factory NextBusModel.fromJson(Map<String, dynamic> json) =>
      _$NextBusModelFromJson(json);
}

@JsonSerializable()
class StopLocationModel {
  final String latitude;
  final String longitude;
  final String address;
  final String stopCode;
  bool isSearching;

  StopLocationModel(this.latitude, this.longitude, this.address, this.stopCode,
      {this.isSearching: false});

  factory StopLocationModel.fromJson(Map<String, dynamic> json) =>
      _$StopLocationModelFromJson(json);
}
