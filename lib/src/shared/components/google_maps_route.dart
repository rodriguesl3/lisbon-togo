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
  Set<Polyline> _newPolyline = {};
  List<LatLng> latlng = List();
  GoogleMap googleMaps;
  Set<Marker> _markers = {};
  PolylineUpdates polylineUpdate;

  void updatePolylineRoute(List<LatLng> routeStep, Color color) async {
    _polyline.clear();

    _markers.add(Marker(
      markerId: MarkerId(routeStep[0].toString()),
      position: routeStep[0],
      infoWindow: InfoWindow(title: 'Change Vehicle'),
    ));

    final GoogleMapController controller = await _controller.future;

    polylineUpdate = PolylineUpdates.from(googleMaps.polylines, null);
    controller.updatePolylines(polylineUpdate);

    _polyline.add(Polyline(
        polylineId:
            PolylineId(DateTime.now().millisecondsSinceEpoch.toString()),
        visible: true,
        points: routeStep,
        color: color,
        geodesic: true,
        onTap: () {
          print('pressed me');
        }));

    polylineUpdate = PolylineUpdates.from(null, _polyline);
    var markerUpdate = MarkerUpdates.from(null, _markers);
    controller.updatePolylines(polylineUpdate);
    controller.updateMarkers(markerUpdate);
  }

  @override
  Widget build(BuildContext context) {
    _markers.add(Marker(
      markerId: MarkerId(startPosition.toString()),
      position: startPosition,
      infoWindow: InfoWindow(title: 'You are here'),
    ));

    _markers.add(Marker(
      markerId: MarkerId(endPosition.toString()),
      position: endPosition,
      infoWindow: InfoWindow(title: 'Your destination'),
    ));

    latlng.add(startPosition);
    latlng.add(endPosition);

    googleMaps = GoogleMap(
      polylines: _polyline,
      markers: _markers,
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

    return new Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          googleMaps,
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
                            FlatButton(
                              onPressed: () {
                                var routeCoordinates = routeList[index]
                                    .travelInformation
                                    .routeSteps
                                    .map((step) {
                                  var routes = step.coordinates.map(
                                      (coordinate) => LatLng(
                                          double.parse(coordinate.latitude),
                                          double.parse(coordinate.longitude)));

                                  //return routes;
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

                                  updatePolylineRoute(routes.toList(), color);

                                  return routes;
                                });

                                var routoeCoordinateList =
                                    routeCoordinates.expand((x) => x).toList();
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.directions),
                                  Text('Mostrar Rota')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     goToDestination(this.endPosition);
      //   },
      //   label: Text('Vamos lá!'),
      //   icon: Icon(Icons.directions),
      // ),
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
