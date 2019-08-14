import 'package:flutter/services.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:location/location.dart';

class GlobalPosition {
  static PositionLocationModel currentPosition;

  Future<PositionLocationModel> refreshLocation() async {
    LocationData currentLocation;
    PositionLocationModel positionLocation;

    var location = Location();
    try {
      currentLocation = await location.getLocation();
      positionLocation = PositionLocationModel(currentLocation, "", true);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        positionLocation = PositionLocationModel(null, e.code, false);
      }
      positionLocation = PositionLocationModel(null, e.code, false);
    } catch (err) {
      print(err);
    }

    GlobalPosition.currentPosition = positionLocation;
    return positionLocation;
  }

  Future<PositionLocationModel> getCurrentPosition() async {
    if (GlobalPosition.currentPosition != null) {
      refreshLocation().then((response) => GlobalPosition.currentPosition = response);
      return GlobalPosition.currentPosition;
    } else {
      GlobalPosition.currentPosition = await refreshLocation();
      return GlobalPosition.currentPosition;
    }
  }
}
