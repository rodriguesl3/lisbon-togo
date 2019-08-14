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

  final _positionController = BehaviorSubject<LatLng>();
  final _stationsController = BehaviorSubject<LineModel>();

  final currentLocation = BehaviorSubject.seeded(true);
  final stationsLocation = BehaviorSubject.seeded(true);
  final stationRoute = BehaviorSubject.seeded(false);

  Sink<LatLng> get currentPosition => _positionController.sink;
  Sink<bool> get stationLoad => stationRoute.sink;

  Observable<PositionLocationModel> get curretPosition =>
      currentLocation.stream.asyncMap((v) => getCurrentPosition());

  Observable<bool> get loadingStationRoute =>
      stationsLocation.stream.asyncMap((v) => isLoadingPosition(v));

  bool isLoadingPosition(index) {
    return index;
  }

  Observable<LineModel> get getStations => stationsLocation.stream.asyncMap(
      (station) => stationRepository.getStations(
          _positionController.value.latitude.toString(),
          _positionController.value.longitude.toString(),
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          "${DateTime.now().hour}:${DateTime.now().minute}:00"));

  Future<Directions> getDirections(
      String stationLatitude, String stationLongitude) async {
    var directions = await directionrepository.getDirections(
        _positionController.value.latitude.toString(),
        _positionController.value.longitude.toString(),
        stationLatitude,
        stationLongitude);

    return directions;
  }

  Future<PositionLocationModel> getCurrentPosition() async {
    var currentPosition = await GlobalPosition().getCurrentPosition();
    return currentPosition;
  }

  @override
  void dispose() {
    _stationsController.close();
    _positionController.close();
    stationRoute.close();

    currentLocation.close();
    stationsLocation.close();
    super.dispose();
  }
}
