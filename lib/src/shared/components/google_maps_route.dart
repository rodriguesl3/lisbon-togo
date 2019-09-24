import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:lisbon_togo/src/blocs/directions_map_bloc.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/model/route.dart';

class MapSample extends StatefulWidget {
  final LatLng startPosition;
  final LatLng endPosition;
  final List<RouteModel> routeList;

  MapSample(this.startPosition, this.endPosition, {this.routeList});

  @override
  State<MapSample> createState() =>
      MapSampleState(this.startPosition, this.endPosition,
          routeList: this.routeList);
}

class MapSampleState extends State<MapSample> {
  final LatLng startPosition;
  final LatLng endPosition;
  final List<RouteModel> routeList;

  MapSampleState(this.startPosition, this.endPosition, {this.routeList});

  Completer<GoogleMapController> _controller = Completer();

  Set<Polyline> _polyline = {};
  List<LatLng> latlng = List();
  GoogleMap googleMaps;
  Set<Marker> _markers = {};
  PolylineUpdates polylineUpdate;
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.getBloc<DirectionsMapBloc>();

    _markers.add(Marker(
      markerId: MarkerId(startPosition.toString()),
      position: startPosition,
      infoWindow: InfoWindow(title: 'Você está aqui'),
    ));

    _markers.add(Marker(
      markerId: MarkerId(endPosition.toString()),
      position: endPosition,
      infoWindow: InfoWindow(title: 'Seu destino'),
    ));

    latlng.add(startPosition);
    latlng.add(endPosition);

    bloc.sinkMarker.add(_markers);

    return new Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          StreamBuilder<Set<Marker>>(
              stream: bloc.markerObserver,
              builder: (context, snapshot) {
                var makerSnapshot = snapshot.data;

                return StreamBuilder<Set<Polyline>>(
                    stream: bloc.polylineObserver,
                    builder: (context, snapshot) {
                      var polylineSnapshot = snapshot.data;

                      return GoogleMap(
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer()))
                          ..add(
                            Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer()),
                          )
                          ..add(
                            Factory<HorizontalDragGestureRecognizer>(
                                () => HorizontalDragGestureRecognizer()),
                          )
                          ..add(
                            Factory<ScaleGestureRecognizer>(
                                () => ScaleGestureRecognizer()),
                          ),
                        polylines: polylineSnapshot,
                        markers: makerSnapshot,
                        mapType: MapType.hybrid,
                        initialCameraPosition: CameraPosition(
                          target: this.startPosition,
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        indoorViewEnabled: true,
                      );
                    });
              }),
          Positioned(
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            top: 350,
            child: ListView.builder(
                itemCount: routeList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                      width: 200.0,
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
                        elevation: 20.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  'https://placeimg.com/470/280/any'),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Distancia:',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    Text(
                                      'Preço:',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    Text(
                                      'Duração:',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(routeList[index]
                                        .travelInformation
                                        .distanceInMeters),
                                    Text(routeList[index]
                                        .travelInformation
                                        .price),
                                    Text(routeList[index]
                                        .travelInformation
                                        .timeDuration),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    _markers.clear();
                                    _polyline.clear();

                                    bloc.sinkMarker.add(_markers);
                                    bloc.sinkPolyline.add(_polyline);

                                    routeList[index]
                                        .travelInformation
                                        .routeSteps
                                        .forEach((step) {
                                      var colors = [
                                        Colors.blue,
                                        Colors.yellow,
                                        Colors.green,
                                        Colors.indigo,
                                        Colors.lime,
                                        Colors.orange,
                                        Colors.red
                                      ];

                                      Random rnd;
                                      int min = 0;
                                      int max = colors.length;
                                      rnd = new Random();
                                      var r = min + rnd.nextInt(max - min);

                                      var color = colors[r];
                                      var routeStep = step.coordinates
                                          .map((coordinate) => LatLng(
                                              double.parse(coordinate.latitude),
                                              double.parse(
                                                  coordinate.longitude)))
                                          .toList();

                                      _markers.add(Marker(
                                          markerId:
                                              MarkerId(routeStep[0].toString()),
                                          position: routeStep[0],
                                          infoWindow: InfoWindow(
                                              title: step.transportCarrier,
                                              snippet: step.instruction,
                                              onTap: () {
                                                print('dsajfkhlaksdfhajksf');
                                              }),
                                          onTap: () {
                                            print('text');
                                          }));

                                      _polyline.add(Polyline(
                                          polylineId: PolylineId(Uuid().v1()),
                                          visible: true,
                                          points: routeStep,
                                          color: color,
                                          geodesic: true,
                                          onTap: () {
                                            print('pressed me');
                                          }));

                                      bloc.sinkMarker.add(_markers);
                                      bloc.sinkPolyline.add(_polyline);
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.directions),
                                      Text('Exibir rota')
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  Future<void> goToDestination(LatLng endPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: endPosition,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }
}
