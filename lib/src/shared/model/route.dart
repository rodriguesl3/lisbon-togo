import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable()
class RouteModel {
  final TravelInformation travelInformation;
  final String travelTime;
  //final List<TravelType> travelTypes;

  RouteModel(this.travelInformation, this.travelTime);

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}

@JsonSerializable()
class TravelType {
  final String imageUrl;
  final String carrier;
  TravelType(this.imageUrl, this.carrier);
}

@JsonSerializable()
class TravelInformation {
  final String fromLocation;
  final String toLocation;
  final String leaveAt;
  final String arriveAt;
  final String transportTransfer;
  final String footPrintCarbon;
  final String timeDuration;
  final String price;
  final String distanceInMeters;
  final List<RouteStep> routeSteps;

  TravelInformation(
      this.fromLocation,
      this.toLocation,
      this.leaveAt,
      this.arriveAt,
      this.transportTransfer,
      this.footPrintCarbon,
      this.timeDuration,
      this.price,
      this.distanceInMeters,
      this.routeSteps);

  factory TravelInformation.fromJson(Map<String, dynamic> json) =>
      _$TravelInformationFromJson(json);
}

@JsonSerializable()
class RouteStep {
  final List<RouteCoordinate> coordinates;
  final String stepIndex;
  final String leaveTime;
  final String arriveTime;
  final String waitTime;
  final String instruction;
  final String transportType;
  final String transportCarrier;

  RouteStep(
      this.coordinates,
      this.stepIndex,
      this.leaveTime,
      this.arriveTime,
      this.waitTime,
      this.instruction,
      this.transportType,
      this.transportCarrier);

  factory RouteStep.fromJson(Map json) => _$RouteStepFromJson(json);
}

@JsonSerializable()
class RouteCoordinate {
  final String latitude;
  final String longitude;

  RouteCoordinate(this.latitude, this.longitude);
  factory RouteCoordinate.fromJson(Map json) => _$RouteCoordinateFromJson(json);
}
