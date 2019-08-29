import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/shared/components/google_map_walking.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
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

  List<NextBusModel> _nextBusList;

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

    var scaffold = Scaffold(
      appBar: this._getAppBar("Stations"),
      body: Container(
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
            bloc.currentPosition.add(new LatLng(position.locationData.latitude,position.locationData.longitude));
            

            return StreamBuilder<LineModel>(
              stream: bloc.getStations,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return new Loading('Problema para encontrar estações.');
                } else if (!snapshot.hasData) {
                  return new Loading('Procurando proximidades.');
                }
                var stations = snapshot.data.stopLocationList;
                _nextBusList = snapshot.data.nextBusList;

                return ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      setState(() {
                        stations[index].isSearching = true;
                      });

                      bloc
                          .getDirections(stations[index].latitude,
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
                                builder: (context) => MapWalking(listLng,
                                    response.routes[0].legs[0].steps)));
                      });
                    },
                    title: Text(
                        "${_nextBusList[index].line}\n${_nextBusList[index].time}"),
                    leading: Image(
                      image: NetworkImage(
                          "https://www.transporlis.pt/${_nextBusList[index].image}"),
                    ),
                    subtitle: Text(
                        "${stations[index].stopCode} - ${stations[index].address}"),
                    enabled: true,
                    trailing: (stations[index].isSearching
                        ? CircularProgressIndicator()
                        : FlatButton(
                            child: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setState(() {
                                stations[index].isSearching = true;
                              });

                              bloc
                                  .getDirections(stations[index].latitude,
                                      stations[index].longitude)
                                  .then((response) {
                                var listLng = List<LatLng>();
                                response.routes[0].legs[0].steps
                                    .forEach((elm) => listLng.addAll([
                                          LatLng(elm.startLocation.lat,
                                              elm.startLocation.lng),
                                          LatLng(elm.endLocation.lat,
                                              elm.endLocation.lng)
                                        ]));

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapWalking(
                                            listLng,
                                            response.routes[0].legs[0].steps)));
                              });
                            })),
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
