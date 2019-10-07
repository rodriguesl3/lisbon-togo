import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:lisbon_togo/src/blocs/routes_bloc.dart';
import 'package:lisbon_togo/src/blocs/welcome_bloc.dart';
import 'package:lisbon_togo/src/repositories/prediction_repository.dart';
import 'package:lisbon_togo/src/shared/components/google_maps_route.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
import 'package:lisbon_togo/src/shared/model/prediction_model.dart';
import 'package:lisbon_togo/src/shared/model/route.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const kGoogleApiKey = "AIzaSyC7Exvy4fyWdWyONtpptneRWU4J54wHoF0";
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  Widget _widgetContent;
  Mode _mode = Mode.overlay;
  List<PredictionModel> predictionList;
  var bloc = BlocProvider.getBloc<WelcomeBloc>();
  var blocRoute = BlocProvider.getBloc<RoutesBloc>();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));
  Widget _buildAppButton() {
    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://www.incimages.com/uploaded_files/image/970x450/getty_874661962_200013331653767149166_347892.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
            ),
            boxShadow: [new BoxShadow(blurRadius: 15.0)],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFff8400), Color(0xFF140085)])),
        child: Container(
          margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 50.0),
          child: RaisedButton.icon(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: _handlePressButton,
            label: Text(
              'Search',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black54,
            elevation: 30.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        ));
  }

  @override
  void initState() {
    bloc.getCurrentPosition();

    _widgetContent = _buildContentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50],
        key: homeScaffoldKey,
        body:
            CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height / 4,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                alignment: Alignment.bottomCenter,
                width: 200.0,
                height: 50.0,
                child: Text('Lisbon To Go'),
              ),
              background: _buildAppButton(),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              width: MediaQuery.of(context).size.height,
              child: AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: _widgetContent,
              ),
            ),
          )
        ]));
  }

  List<Widget> _buildLastSearch(List<PredictionModel> predictionList) {
    var listRow = List<Widget>();

    for (var item in predictionList) {
      listRow.add(Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _widgetContent =
                    _buildMaps(LatLng(item.latitude, item.longitude));
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.update),
                SizedBox(
                  width: 20.0,
                ),
                Text("${item.name}..."),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Partida: ${item.nextBus.leaveAt}',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Chegada: ${item.nextBus.arriveAt}',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w900),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            height: 20.0,
          ),
        ],
      ));
    }
    return listRow;
  }

  Widget _buildContentList() {
    return StreamBuilder<List<PredictionModel>>(
      stream: bloc.streamPredictionSQL,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading('Buscando últimas consultas');
        }
        var predictionList = snapshot.data;

        return ListView(children: _buildLastSearch(predictionList));
      },
    );
  }

  Widget _buildMaps(LatLng destination) {
    LatLng curPosition;

    return StreamBuilder<LatLng>(
        stream: bloc.streamCurrentPosition,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == WelcomeBloc.initialData) {
            return Loading('Procurando sua localização.');
          } else if (snapshot.hasError) {
            return Loading('Problema para encontrar sua localização.');
          }

          curPosition = snapshot.data;
          blocRoute.currentLatLng.add(curPosition);
          blocRoute.destinationLatLng.add(destination);

          return StreamBuilder<List<RouteModel>>(
              stream: blocRoute.routeWays,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Calculando a melhor rota.',
                        style: TextStyle(fontSize: 32.0, color: Colors.black),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ));
                }

                return MapSample(curPosition, destination,
                    routeList: snapshot.data.toList());
              });
        });
  }

  Future<void> _handlePressButton() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "pt",
      components: [Component(Component.country, "pt")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeDetail = detail.result;

      await PredictionRepository.addPrediction(PredictionModel(
          p.description,
          p.id,
          p.placeId,
          p.reference,
          placeDetail.internationalPhoneNumber,
          placeDetail.name,
          placeDetail.geometry.location.lat,
          placeDetail.geometry.location.lng));

      var destination = LatLng(detail.result.geometry.location.lat,
          detail.result.geometry.location.lng);

      setState(() {
        _widgetContent = Stack(
          children: <Widget>[
            _buildMaps(destination),
            RaisedButton(
              child: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _widgetContent = _buildContentList();
                });
              },
            ),
          ],
        );
      });
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }
}
