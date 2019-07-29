// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) {
  return RouteModel(
    json['travelInformation'] == null
        ? null
        : TravelInformation.fromJson(
            json['travelInformation'] as Map<String, dynamic>),
    json['travelTime'] as String,
  );
}

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'travelInformation': instance.travelInformation,
      'travelTime': instance.travelTime,
    };

TravelType _$TravelTypeFromJson(Map<String, dynamic> json) {
  return TravelType(
    json['imageUrl'] as String,
    json['carrier'] as String,
  );
}

Map<String, dynamic> _$TravelTypeToJson(TravelType instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'carrier': instance.carrier,
    };

TravelInformation _$TravelInformationFromJson(Map<String, dynamic> json) {
  return TravelInformation(
    json['fromLocation'] as String,
    json['toLocation'] as String,
    json['leaveAt'] as String,
    json['arriveAt'] as String,
    json['transportTransfer'] as String,
    json['footPrintCarbon'] as String,
    json['timeDuration'] as String,
    json['price'] as String,
    json['distanceInMeters'] as String,
    (json['routeSteps'] as List)
        ?.map((e) =>
            e == null ? null : RouteStep.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TravelInformationToJson(TravelInformation instance) =>
    <String, dynamic>{
      'fromLocation': instance.fromLocation,
      'toLocation': instance.toLocation,
      'leaveAt': instance.leaveAt,
      'arriveAt': instance.arriveAt,
      'transportTransfer': instance.transportTransfer,
      'footPrintCarbon': instance.footPrintCarbon,
      'timeDuration': instance.timeDuration,
      'price': instance.price,
      'distanceInMeters': instance.distanceInMeters,
      'routeSteps': instance.routeSteps,
    };

RouteStep _$RouteStepFromJson(Map<String, dynamic> json) {
  return RouteStep(
    (json['coordinates'] as List)
        ?.map((e) => e == null
            ? null
            : RouteCoordinate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['stepIndex'] as String,
    json['leaveTime'] as String,
    json['arriveTime'] as String,
    json['waitTime'] as String,
    json['instruction'] as String,
    json['transportType'] as String,
    json['transportCarrier'] as String,
  );
}

Map<String, dynamic> _$RouteStepToJson(RouteStep instance) => <String, dynamic>{
      'coordinates': instance.coordinates,
      'stepIndex': instance.stepIndex,
      'leaveTime': instance.leaveTime,
      'arriveTime': instance.arriveTime,
      'waitTime': instance.waitTime,
      'instruction': instance.instruction,
      'transportType': instance.transportType,
      'transportCarrier': instance.transportCarrier,
    };

RouteCoordinate _$RouteCoordinateFromJson(Map<String, dynamic> json) {
  return RouteCoordinate(
    json['latitude'] as String,
    json['longitude'] as String,
  );
}

Map<String, dynamic> _$RouteCoordinateToJson(RouteCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
