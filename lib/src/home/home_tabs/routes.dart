import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lisbon_togo/src/shared/components/flutter_map_route.dart';
import 'package:lisbon_togo/src/shared/components/google_maps_route.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/shared/model/route.dart';
import 'package:location/location.dart';
// import 'package:latlong/latlong.dart';

import 'blocs/routes_bloc.dart';

class Routes extends StatefulWidget {
  double initialLatitude, initialLongitude;
  String pointName;
  Routes({Key key, this.initialLatitude, this.initialLongitude, this.pointName})
      : super(key: key);

  _RoutesState createState() =>
      _RoutesState(this.initialLatitude, this.initialLongitude, this.pointName);
}

class _RoutesState extends State<Routes> {
  //MapController mapController;
  double initialLatitude, initialLongitude;
  String pointName;

  _RoutesState(this.initialLatitude, this.initialLongitude, this.pointName);

  @override
  void initState() {
    //mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<RoutesBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        title: Text(
          this.pointName,
          textAlign: TextAlign.center,
        ),
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
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<PositionLocationModel>(
            stream: bloc.currentPosition,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Procurando sua localização.',
                      style: TextStyle(fontSize: 30.0, color: Colors.black),
                    ),
                    CircularProgressIndicator(),
                  ],
                ));
              }
              var position = snapshot.data;
              var endPosition = LatLng(initialLatitude, initialLongitude);
              var startPosition = LatLng(position.locationData.latitude,
                  position.locationData.longitude);
              bloc.currentLatLng.add(startPosition);
              bloc.destinationLatLng.add(endPosition);
              return StreamBuilder<List<RouteModel>>(
                  stream: bloc.routeWays,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Calculando a melhor rota.',
                            style:
                                TextStyle(fontSize: 32.0, color: Colors.black),
                          ),
                          CircularProgressIndicator(),
                        ],
                      ));
                    }
                    return MapSample(startPosition, endPosition,
                        routeList: snapshot.data.toList());
                  });
            },
          )
        ],
      ),
    );
  }
}
