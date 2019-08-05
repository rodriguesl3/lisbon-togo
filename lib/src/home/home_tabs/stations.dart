import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';

import 'blocs/station_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';

class Stations extends StatefulWidget {
  Stations({Key key}) : super(key: key);

  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.getBloc<StationsBloc>();

    var scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Stations", textAlign: TextAlign.center),
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
      body: Container(
        child: StreamBuilder<PositionLocationModel>(
          stream: bloc.curretPosition,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Loading('Procurando sua localização.');
            } else if (snapshot.hasError) {
              return new Loading('Problema para encontrar localização');
            }
            var position = snapshot.data;
            bloc.currentPosition.add(new LatLng(position.locationData.latitude,
                position.locationData.longitude));
            return StreamBuilder<List<LineModel>>(
              stream: bloc.getStations,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Loading('Procurando proximidades.');
                } else if (snapshot.hasError) {
                  return new Loading('Problema para encontrar estações.');
                }
                Text('yes it works!!!');
                print(snapshot.data);
              },
            );
          },
        ),
      ),
    );
    return SafeArea(child: scaffold);
  }
}

