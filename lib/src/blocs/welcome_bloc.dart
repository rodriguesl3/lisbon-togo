import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/repositories/prediction_repository.dart';
import 'package:lisbon_togo/src/shared/global_position.dart';
import 'package:lisbon_togo/src/shared/model/prediction_model.dart';
import 'package:rxdart/rxdart.dart';

class WelcomeBloc extends BlocBase {
  WelcomeBloc();

  static final LatLng initialData = LatLng(38.732343, -9.204530);
  
  final BehaviorSubject<List<PredictionModel>> _predictionSQLController =
      BehaviorSubject.seeded(List<PredictionModel>());
  Sink<List<PredictionModel>> get sinkPrediction =>
      _predictionSQLController.sink;
  Observable<List<PredictionModel>> get streamPredictionSQL =>
      _predictionSQLController.stream
          .asyncMap((prediction) => PredictionRepository.getAllPredictions());

  final BehaviorSubject<LatLng> _currentLocationController =
      BehaviorSubject.seeded(initialData);
  Sink<LatLng> get sinkCurrentPosition => _currentLocationController.sink;
  Observable<LatLng> get streamCurrentPosition =>
      _currentLocationController.stream;

  void getCurrentPosition() async {
    var currentPositionValue = await GlobalPosition().getCurrentPosition();

    if (currentPositionValue?.hasPermission ?? false)
      sinkCurrentPosition.add(LatLng(currentPositionValue.locationData.latitude,
          currentPositionValue.locationData.longitude));
    else
      sinkCurrentPosition.add(currentPositionValue.lastPosition);
  }

  @override
  void dispose() {
    _currentLocationController.close();
    _predictionSQLController.close();
    super.dispose();
  }
}