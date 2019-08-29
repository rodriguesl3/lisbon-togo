import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/global_position.dart';
import 'package:lisbon_togo/src/shared/model/route.dart';
import 'package:rxdart/rxdart.dart';

import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/repositories/route_repository.dart';

class RoutesBloc extends BlocBase {
  final RouteRepository routeRepository;
  RoutesBloc(this.routeRepository);

  final _fromLocationController = BehaviorSubject<LatLng>();
  final _toLocationController = BehaviorSubject<LatLng>();

  Function(LatLng) get currentLocation => _fromLocationController.sink.add;
  Function(LatLng) get destinationLocation => _toLocationController.sink.add;

  Sink<LatLng> get currentLatLng => _fromLocationController.sink;
  Sink<LatLng> get destinationLatLng => _toLocationController.sink;

  final BehaviorSubject knowPosition = BehaviorSubject.seeded(true);
  final BehaviorSubject routeList = BehaviorSubject.seeded(true);

  @override
  void dispose() {
    knowPosition.close();
    routeList.close();
    _fromLocationController.close();
    _toLocationController.close();

    super.dispose();
  }

  Observable<PositionLocationModel> get currentPosition =>
      knowPosition.stream.asyncMap((v) => getCurrentPosition());

  Observable<List<RouteModel>> get routeWays =>
      routeList.stream.asyncMap((v) => routeRepository.getRoute(
          _fromLocationController.value.latitude.toString(),
          _fromLocationController.value.longitude.toString(),
          _toLocationController.value.latitude.toString(),
          _toLocationController.value.longitude.toString(),
          DateTime.now().toString(),
          "${DateTime.now().hour}:${DateTime.now().minute}:00",
          false));

   Future<PositionLocationModel> getCurrentPosition() async {
    var currentPosition = await GlobalPosition().getCurrentPosition();
    return currentPosition;
  }
}
