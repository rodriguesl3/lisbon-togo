import 'package:location/location.dart';

class PositionLocationModel 
{

  final LocationData locationData;
  final String response;
  final bool hasPermission;
  
  PositionLocationModel(this.locationData, this.response,this.hasPermission);
}