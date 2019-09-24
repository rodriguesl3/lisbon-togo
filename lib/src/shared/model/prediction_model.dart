import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/database/database_creator.dart';

class PredictionModel {
  String description;
  String id;
  String placeId;
  String reference;
  String phoneNumber;
  String name;
  double latitude;
  double longitude;
  LatLng position;

  PredictionModel(this.description, this.id, this.placeId, this.reference,
      this.phoneNumber, this.name, this.latitude, this.longitude,
      {this.position});

  PredictionModel.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.description = json[DatabaseCreator.description];
    this.placeId = json[DatabaseCreator.placeId];
    this.reference = json[DatabaseCreator.reference];
    this.phoneNumber = json[DatabaseCreator.phoneNumber];
    this.name = json[DatabaseCreator.name];
    this.latitude = double.parse(json[DatabaseCreator.latitude] ?? "0.0");
    this.longitude = double.parse(json[DatabaseCreator.longitude] ?? "0.0");
  }
}
