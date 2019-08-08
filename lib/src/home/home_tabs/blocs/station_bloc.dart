import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/repositories/stations_repository.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class StationsBloc extends BlocBase {
  final StationsRepository stationRepository;

  StationsBloc(this.stationRepository);

  final _positionController = BehaviorSubject<LatLng>();
  final _stationsController = BehaviorSubject<List<LineModel>>();

  final currentLocation = BehaviorSubject.seeded(true);
  final stationsLocation = BehaviorSubject.seeded(true);

  Sink<LatLng> get currentPosition => _positionController.sink;

  Observable<PositionLocationModel> get curretPosition =>
      currentLocation.stream.asyncMap((v) => getCurrentPosition());

  Observable<LineModel> get getStations => stationsLocation.stream
      .asyncMap((station) => stationRepository.getStations(
          _positionController.value.latitude.toString(),
          _positionController.value.longitude.toString(),
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          "${DateTime.now().hour}:${DateTime.now().minute}:00"));

  Future<PositionLocationModel> getCurrentPosition() async {
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
    return positionLocation;
  }

  @override
  void dispose() {
    _stationsController.close();
    _positionController.close();

    currentLocation.close();
    stationsLocation.close();
    super.dispose();
  }
}
