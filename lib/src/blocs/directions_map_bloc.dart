import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class DirectionsMapBloc extends BlocBase {
  final _makerController = BehaviorSubject<Set<Marker>>.seeded({});
  final _polylineController = BehaviorSubject<Set<Polyline>>.seeded({});

  Sink<Set<Marker>> get sinkMarker => _makerController.sink;
  Sink<Set<Polyline>> get sinkPolyline => _polylineController.sink;

  Observable<Set<Polyline>> get polylineObserver =>
      _polylineController.stream.map((v) => _getCurrentPolyline());

  Observable<Set<Marker>> get markerObserver =>
      _makerController.stream.map((v) => _getCurrentMarkers());

  Set<Marker> _getCurrentMarkers() {
    return _makerController.value.toSet();
  }

  Set<Polyline> _getCurrentPolyline() {
    return _polylineController.value.toSet();
  }

  @override
  void dispose() {
    _makerController.close();
    _polylineController.close();
    
    super.dispose();
  }
}
