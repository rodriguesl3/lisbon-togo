import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/components/google_map_walking.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';

import 'blocs/station_bloc.dart';

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
            return StreamBuilder<LineModel>(
              stream: bloc.getStations,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return new Loading('Problema para encontrar estações.');
                } else if (!snapshot.hasData) {
                  return new Loading('Procurando proximidades.');
                }
                var stations = snapshot.data.stopLocationList;
                var nextBus = snapshot.data.nextBusList;

                return ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      bloc.stationLoad.add(true);
                      
                      bloc.getDirections(stations[index].latitude,
                              stations[index].longitude)
                          .then((response) {

                        var listLng = List<LatLng>();
                        response.routes[0].legs[0].steps.forEach((elm) =>
                            listLng.addAll([
                              LatLng(
                                  elm.startLocation.lat, elm.startLocation.lng),
                              LatLng(elm.endLocation.lat, elm.endLocation.lng)
                            ]));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapWalking(listLng)));
                      });
                    },
                    title: Text(
                        "${stations[index].stopCode} - ${stations[index].address}"),
                    leading: Image(
                      image: NetworkImage(
                          "https://www.transporlis.pt/${nextBus[index].image}"),
                    ),
                    subtitle: Text(
                        "${nextBus[index].time} \n ${nextBus[index].line}"),
                    enabled: true,
                    trailing: StreamBuilder<bool>(
                      stream: bloc.loadingStationRoute,
                      builder: (context, snapshot) {
                        //if (!snapshot.data)
                          return Icon(Icons.arrow_forward_ios);

                        //if (snapshot.data) return CircularProgressIndicator();
                      },
                    ),
                    isThreeLine: true,
                    dense: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
    return SafeArea(child: scaffold);
  }
}
