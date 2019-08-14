import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MapWalking extends StatefulWidget {
  final List<LatLng> positionList;

  MapWalking(this.positionList);

  MapWalkingState createState() => MapWalkingState(this.positionList);
}

class MapWalkingState extends State<MapWalking> {
  final List<LatLng> positionList;
  MapWalkingState(this.positionList);

  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    _markers.add(Marker(
      markerId: MarkerId(Uuid().v4()),
      position: positionList[0],
      infoWindow: InfoWindow(title: 'Você está aqui!'),
    ));

    _markers.add(Marker(
        markerId: MarkerId(Uuid().v4()),
        position: positionList[positionList.length - 1],
        infoWindow: InfoWindow(title: 'Esse é o seu destino!!!')));

    _polyline.add(Polyline(
        polylineId: PolylineId(Uuid().v4()),
        color: Colors.blue,
        geodesic: true,
        points: positionList,
        onTap: () {
          print('tapped');
        }));

    var googleMap = GoogleMap(
      polylines: _polyline,
      markers: _markers,
      mapType: MapType.hybrid,
      initialCameraPosition:
          CameraPosition(target: positionList[0], zoom: 18.0),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Estação',textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
            boxShadow: [new BoxShadow(blurRadius: 15.0)],
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.centerRight,
                colors: [Color(0xFF673ab7), Color(0xFF3f51b5)]),
          ),
        ),
        
        leading: FlatButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: googleMap,
      endDrawer: Drawer(
        elevation: 20.0,
        child: Container(
          color: Colors.purple,
        ),
      ),
      
    );
  }
}
