import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      print('error to get position $err');
    }

    GlobalPosition.currentPosition = positionLocation;
    return positionLocation;
  }

  Future<PositionLocationModel> getCurrentPosition() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      bool requestService = await Location().requestService();
      if (!requestService) {
        var _lastPosition = await getLastPositionKnown();

        return PositionLocationModel(null, null, false, lastPosition: _lastPosition);
      }

      if (GlobalPosition.currentPosition != null) {
        refreshLocation().then((response) {
          GlobalPosition.currentPosition = response;
          _setLastPositionKnown(LatLng(
              response.locationData.latitude, response.locationData.longitude));
        }).catchError((err) => print('error to get posistion $err'));
        return GlobalPosition.currentPosition;
      } else {
        GlobalPosition.currentPosition = await refreshLocation();
        return GlobalPosition.currentPosition;
      }
    } catch (err) {
      print('error to get position $err');
    }
  }

  Future _setLastPositionKnown(LatLng position) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('lastPosition',
        [position.latitude.toString(), position.longitude.toString()]);
  }

  Future<LatLng> getLastPositionKnown() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPosition = prefs.getStringList('lastPosition');
    return LatLng(
                double.parse(lastPosition[0]), double.parse(lastPosition[1]));
  }
}
