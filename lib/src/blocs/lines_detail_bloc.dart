import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/repositories/lines_repository.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';
import 'package:lisbon_togo/src/shared/model/line_detail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:uuid/uuid.dart';

class LinesDetailBloc extends BlocBase {
  final LineDetailRepository repository;

  LinesDetailBloc(this.repository);

  final BehaviorSubject<Set<Marker>> _markersController =
      BehaviorSubject<Set<Marker>>.seeded({});
  Sink<Set<Marker>> get sinkMarker => _markersController.sink;
  Observable<Set<Marker>> get listMarker => _markersController.stream;

  final BehaviorSubject<Set<Polyline>> _polylineController =
      BehaviorSubject<Set<Polyline>>.seeded({});
  Sink<Set<Polyline>> get sinkPolyline => _polylineController.sink;
  Observable<Set<Polyline>> get listPolyline => _polylineController.stream;

  final BehaviorSubject<List<LineRouteDetailModel>> _informationController =
      BehaviorSubject<List<LineRouteDetailModel>>.seeded(
          List<LineRouteDetailModel>());

  final BehaviorSubject<Data> _lineInformationController =
      BehaviorSubject<Data>.seeded(Data());

  Sink<Data> get sinkInformation => _lineInformationController.sink;

  Sink<List<LineRouteDetailModel>> get sinkLineDetail =>
      _informationController.sink;

  Observable<List<LineRouteDetailModel>> get listLineDetail =>
      _informationController.stream;

  Observable<List<Object>> get readySubmit => Observable.combineLatest3(
      listLineDetail,
      listMarker,
      listPolyline,
      (linesDetail, markers, polylines) => [linesDetail, markers, polylines]);

  Future buildLines() async {
    final Set<Polyline> _polyline = {};
    final Set<Marker> _markers = {};

    await repository
        .getLineDetails(
      _lineInformationController.value.detailLineUrl.split('&')[2],
      _lineInformationController.value.detailLineUrl.split('&')[3],
      DateTime.now().hour.toString(),
      DateTime.now().minute.toString(),
    )
        .then((data) {
      data.forEach((elm) {
        _markers.add(Marker(
          infoWindow: InfoWindow(
            title: 'Stop: ${elm.stopName}' ,
            snippet: 'Time: ${elm.time}'
          ),
          markerId: MarkerId(Uuid().v4()),
          position: LatLng(
              double.parse(elm.stopLatitude), double.parse(elm.stopLongitude)),
        ));
      });

      data.where((elm) => elm.routGeolocationList != null).forEach((elm) {
        var positionList = elm.routGeolocationList
            .map((location) => LatLng(double.parse(location.longitude),
                double.parse(location.latitude)))
            .toList();

        _polyline.add(Polyline(
            points: positionList,
            color: Colors.blue,
            polylineId: PolylineId(Uuid().v4())));
      });

      sinkMarker.add(_markers);
      sinkPolyline.add(_polyline);

      sinkLineDetail.add(data);
    });
  }

  @override
  void dispose() {
    _markersController.close();
    _polylineController.close();
    _lineInformationController.close();
    _informationController.close();

    super.dispose();
  }
}
