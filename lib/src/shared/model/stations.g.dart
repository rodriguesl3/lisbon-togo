// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineModel _$LineModelFromJson(Map<String, dynamic> json) {
  return LineModel(
    (json['nextBusList'] as List)
        ?.map((e) =>
            e == null ? null : NextBusModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['stopLocationList'] as List)
        ?.map((e) => e == null
            ? null
            : StopLocationModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LineModelToJson(LineModel instance) => <String, dynamic>{
      'nextBusList': instance.nextBusList,
      'stopLocationList': instance.stopLocationList,
    };

NextBusModel _$NextBusModelFromJson(Map<String, dynamic> json) {
  return NextBusModel(
    json['image'] as String,
    json['time'] as String,
    json['operator'] as String,
    json['code'] as String,
    json['address'] as String,
    json['line'] as String,
  );
}

Map<String, dynamic> _$NextBusModelToJson(NextBusModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'time': instance.time,
      'operator': instance.operator,
      'code': instance.code,
      'address': instance.address,
      'line': instance.line,
    };

StopLocationModel _$StopLocationModelFromJson(Map<String, dynamic> json) {
  return StopLocationModel(
    json['latitude'] as String,
    json['longitude'] as String,
    json['address'] as String,
    json['stopCode'] as String,
  );
}

Map<String, dynamic> _$StopLocationModelToJson(StopLocationModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'stopCode': instance.stopCode,
    };
