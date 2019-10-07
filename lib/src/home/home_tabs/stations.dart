import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/components/google_map_walking.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';
import 'package:uuid/uuid.dart';

import '../../blocs/station_bloc.dart';

class Stations extends StatefulWidget {
  Stations({Key key}) : super(key: key);

  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  String searchQuery = "Search query";
  Set<Marker> _markers = {};
  StationsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.getBloc<StationsBloc>();
    bloc.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LatLng>(
        stream: bloc.streamCurrentPosition,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == StationsBloc.initialData) {
            return new Loading('Procurando sua localização.');
          } else if (snapshot.hasError) {
            return new Loading('Problema para encontrar localização');
          }

          var position = snapshot.data;
          _markers = {};
          _markers.add(Marker(
              markerId: MarkerId(Uuid().v4()),
              position: position,
              infoWindow: InfoWindow(title: 'Você está aqui'),
              visible: true));

          return Scaffold(
              body: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: AppBarTheme.of(context).color,
                  floating: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height / 1.5,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      alignment: Alignment.bottomCenter,
                      width: 400.0,
                      height: 300.0,
                      child: Text(
                        "Paragens Próximas",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    background: Container(
                        color: Colors.lightBlue,
                        child: buildMap(position)),
                  ),
                ),
                SliverFillRemaining(hasScrollBody: true, child: buildList(bloc))
              ]));
        });
  }

  Widget buildMap(LatLng position) {
    return GoogleMap(
      // polylines: _polyline,
      markers: _markers,
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(target: position, zoom: 17.0),
      onMapCreated: (GoogleMapController controller) {
        if (position != StationsBloc.initialData) {
          CameraPosition startRoute = CameraPosition(
              bearing: 192.8334901395799,
              target: position,
              // tilt: 59.440717697143555,
              zoom: 16.151926040649414);
          controller.animateCamera(CameraUpdate.newCameraPosition(startRoute));
        }
      },
    );
  }

  Widget buildList(StationsBloc bloc) {
    return Container(
        child: StreamBuilder<List<LineModel>>(
      stream: bloc.getStations,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Loading('Problema para encontrar estações.');
        } else if (!snapshot.hasData) {
          return new Loading('Procurando proximidades.');
        }
        var stations = snapshot.data
            .where((station) => station.nextBuses.length > 0)
            .toList();

        stations.forEach((elm) {
          _markers.add(Marker(
              markerId: MarkerId(elm.stopCode),
              position: LatLng(
                  double.parse(elm.latitude), double.parse(elm.longitude)),
              infoWindow: InfoWindow(
                  title: elm.address,
                  snippet: elm.nextBuses
                      .map((bus) => "${bus.line} - ${bus.time}")
                      .join('\n')),
              visible: true));
        });

        return ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: stations.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              // setState(() {
              //   stations[index].isSearching = true;
              // });

              bloc
                  .getDirections(
                      stations[index].latitude, stations[index].longitude)
                  .then((response) {
                var listLng = List<LatLng>();
                response.routes[0].legs[0].steps
                    .forEach((elm) => listLng.addAll([
                          LatLng(elm.startLocation.lat, elm.startLocation.lng),
                          LatLng(elm.endLocation.lat, elm.endLocation.lng)
                        ]));

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapWalking(
                            listLng, response.routes[0].legs[0].steps)));
              });
            },
            title: Text("${stations[index].nextBuses[0].address}"),
            leading: Image(
              image: NetworkImage(
                  "https://www.transporlis.pt/${stations[0].nextBuses[0].image}"),
            ),
            subtitle: Column(
              children: stations[index]
                  .nextBuses
                  .map((station) => Text('${station.line} - ${station.time}'))
                  .toList(),
            ),
            enabled: true,
            isThreeLine: true,
            dense: true,
          ),
        );
      },
    ));
  }
}
