import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
//import 'package:latlong/latlong.dart';

class FlutterMapRoute extends StatelessWidget {
  // final LatLng startPosition;
  // final LatLng endPosition;
  // final MapController mapController;
  // final List<LatLng> pointList;

  const FlutterMapRoute();

  @override
  Widget build(BuildContext context) {
    // var points = <LatLng>[
    //   //new LatLng(35.22, -101.83),
    //   // new LatLng(32.77, -96.79),
    //   // new LatLng(29.76, -95.36),
    //   // new LatLng(29.42, -98.49),
    //   // new LatLng(35.22, -101.83),
    // ];

   

    // var map = FlutterMap(
    //   mapController: mapController,
    //   options: MapOptions(
    //     minZoom: 3.0,
    //     zoom: 14.0,
    //     maxZoom: 20.0,
    //     center: LatLng(endPosition.latitude, endPosition.longitude),
    //   ),
    //   layers: [
    //     TileLayerOptions(
    //         urlTemplate:
    //             "https://api.mapbox.com/styles/v1/rajayogan/cjl1bndoi2na42sp2pfh2483p/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVzazMiLCJhIjoiY2p5OW54cGU4MDVtNTNqcXVlc29oZXV6cCJ9.y6Fcdojw-nZrP5tzOkupJw",
    //         additionalOptions: {
    //           'accessToken':
    //               'pk.eyJ1IjoibHVzazMiLCJhIjoiY2p5OW54cGU4MDVtNTNqcXVlc29oZXV6cCJ9.y6Fcdojw-nZrP5tzOkupJw',
    //           'id': 'mapbox.mapbox-streets-v7'
    //         }
    //         // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    //         // subdomains: ['a', 'b', 'c'],
    //         ),
    //     MarkerLayerOptions(markers: [
    //       Marker(
    //         width: 45.0,
    //         height: 45.0,
    //         point: LatLng(endPosition.latitude, endPosition.longitude),
    //         builder: (context) => Container(
    //           child: IconButton(
    //             icon: Icon(Icons.location_on),
    //             onPressed: () {},
    //             color: Colors.orange,
    //           ),
    //         ),
    //       ),
    //       //if (snapshot.data)
    //       Marker(
    //         width: 45.0,
    //         height: 45.0,
    //         point: LatLng(startPosition.latitude, startPosition.longitude),
    //         builder: (context) => Container(
    //           child: IconButton(
    //             icon: Icon(Icons.location_on),
    //             onPressed: () {},
    //             color: Colors.blue,
    //           ),
    //         ),
    //       ),
    //     ]),
    //     PolylineLayerOptions(polylines: [
    //       new Polyline(points: points, strokeWidth: 5.0, color: Colors.red)
    //     ])
    //   ],
    // );
  }
}
