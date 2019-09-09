import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/components/google_map_walking.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
import 'package:lisbon_togo/src/shared/global_position.dart';
import 'package:lisbon_togo/src/shared/model/position_location.dart';
import 'package:lisbon_togo/src/shared/model/stations.dart';

import '../../blocs/station_bloc.dart';

class Stations extends StatefulWidget {
  Stations({Key key}) : super(key: key);

  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  List<NextBus> _nextBusList;

  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      _nextBusList = _nextBusList.where((elm) => elm.line.contains(newQuery));
    });
    print("search query " + newQuery);
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  Widget _buildTitle(BuildContext context, String textTitle) {
    var horizontalTitleAlignment = CrossAxisAlignment.center;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Text(textTitle),
          ],
        ),
      ),
    );
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  Widget _getAppBar(String textTitle) {
    var appBar = AppBar(
      leading: _isSearching ? const BackButton() : null,
      title:
          _isSearching ? _buildSearchField() : _buildTitle(context, textTitle),
      actions: _buildActions(),
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
    );
    return appBar;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.getBloc<StationsBloc>();
    LatLng currentPosition;
    if (GlobalPosition().getCurrentPosition() != null)
      currentPosition = LatLng(
          GlobalPosition.currentPosition.locationData.latitude,
          GlobalPosition.currentPosition.locationData.longitude);
    // else {
    //   GlobalPosition().getLastPositionKnown()
    //       .then((res) => currentPosition = res);
      // while (currentPosition == null) {
      //   Future.delayed(Duration(seconds: 1));
      // }
    //}

    List<LineModel> stations;
    Set<Marker> _markers = {};
    _markers.add(Marker(
        markerId: MarkerId('sdfçajsdjfasdf'),
        position: currentPosition,
        infoWindow: InfoWindow(title: 'Você está aqui'),
        visible: true));
    var container = Container(
      child: StreamBuilder<PositionLocationModel>(
        stream: bloc.curretPosition,
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Loading('Procurando sua localização.');
          } else if (snapshot.hasError) {
            return new Loading('Problema para encontrar localização');
          }

          var position = snapshot.data;
          bloc.currentPosition.add(new LatLng(
              position.locationData.latitude, position.locationData.longitude));

          return StreamBuilder<List<LineModel>>(
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
                    position: LatLng(double.parse(elm.latitude),
                        double.parse(elm.longitude)),
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
                                LatLng(elm.startLocation.lat,
                                    elm.startLocation.lng),
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
                        .map((station) =>
                            Text('${station.line} - ${station.time}'))
                        .toList(),
                  ),
                  //Text("${stations[index].stopCode} - ${stations[index].address}"),
                  enabled: true,
                  // trailing: (stations[index].isSearching
                  //     ? CircularProgressIndicator()
                  //     : FlatButton(
                  //         child: Icon(Icons.arrow_forward_ios),
                  //         onPressed: () {
                  //           setState(() {
                  //             stations[index].isSearching = true;
                  //           });

                  //           bloc
                  //               .getDirections(stations[index].latitude,
                  //                   stations[index].longitude)
                  //               .then((response) {
                  //             var listLng = List<LatLng>();
                  //             response.routes[0].legs[0].steps
                  //                 .forEach((elm) => listLng.addAll([
                  //                       LatLng(elm.startLocation.lat,
                  //                           elm.startLocation.lng),
                  //                       LatLng(elm.endLocation.lat,
                  //                           elm.endLocation.lng)
                  //                     ]));

                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => MapWalking(
                  //                         listLng,
                  //                         response.routes[0].legs[0].steps)));
                  //           });
                  //         })),
                  isThreeLine: true,
                  dense: true,
                ),
              );
            },
          );
        },
      ),
    );
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height / 1.5,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Paragens Próximas",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              background: Container(
                  color: Colors.lightBlue,
                  child: GoogleMap(
                    // polylines: _polyline,
                    markers: _markers,
                    mapType: MapType.hybrid,
                    initialCameraPosition:
                        CameraPosition(target: currentPosition, zoom: 17.0),
                    onMapCreated: (GoogleMapController controller) {},
                  )),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: container,
          )
        ],
      ),
    );
  }
}
