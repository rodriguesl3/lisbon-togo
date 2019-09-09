import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PositionLocationModel {
  final LocationData locationData;
  final String response;
  final bool hasPermission;
  final LatLng lastPosition;

  PositionLocationModel(this.locationData, this.response, this.hasPermission,
      {this.lastPosition});
}
