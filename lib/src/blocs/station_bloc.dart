import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/repositories/direction_repository.dart';
import 'package:lisbon_togo/src/repositories/stations_repository.dart';
import 'package:lisbon_togo/src/shared/global_position.dart';
import 'package:lisbon_togo/src/shared/model/direction.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class StationsBloc extends BlocBase {
  final StationsRepository stationRepository;
  final DirectionRepository directionrepository;

  StationsBloc(this.stationRepository, this.directionrepository);

  final BehaviorSubject<LatLng> _currentLocationController =
      BehaviorSubject.seeded(LatLng(38.732343, -9.204530));
  final BehaviorSubject<List<LineModel>> _stationsController =
      BehaviorSubject.seeded(List<LineModel>());
  final _positionController =
      BehaviorSubject<LatLng>.seeded(new LatLng(0.0, 0.0));

  Sink<LatLng> get sinkCurrentPosition => _currentLocationController.sink;
  Observable<LatLng> get streamCurrentPosition => _currentLocationController.stream;

  Sink<List<LineModel>> get setStation => _stationsController.sink;
  Observable<List<LineModel>> get listStation => _stationsController.stream;

  Observable<List<LineModel>> get getStations => _stationsController.stream
      .asyncMap((station) => stationRepository.getStations(
          _currentLocationController.value.latitude.toString(),
          _currentLocationController.value.longitude.toString(),
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          "${DateTime.now().hour}:${DateTime.now().minute}:00"));

  void requestStations() async {
    setStation.add(await stationRepository.getStations(
        _positionController.value.latitude.toString(),
        _positionController.value.longitude.toString(),
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        "${DateTime.now().hour}:${DateTime.now().minute}:00"));
  }

  Future<Directions> getDirections(
      String stationLatitude, String stationLongitude) async {
    var directions = await directionrepository.getDirections(
        _currentLocationController.value.latitude.toString(),
        _currentLocationController.value.longitude.toString(),
        stationLatitude,
        stationLongitude);

    return directions;
  }

  void getCurrentPosition() async {
    var currentPositionValue = await GlobalPosition().getCurrentPosition();

    if (currentPositionValue.hasPermission)
      sinkCurrentPosition.add(LatLng(currentPositionValue.locationData.latitude,
          currentPositionValue.locationData.longitude));
    else
      sinkCurrentPosition.add(currentPositionValue.lastPosition);
  }

  @override
  void dispose() {
    _stationsController.close();
    _positionController.close();
    _currentLocationController.close();
    // stationRoute.close();

    // currentLocation.close();
    // stationsLocation.close();
    super.dispose();
  }
}
