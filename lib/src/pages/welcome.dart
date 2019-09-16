import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const kGoogleApiKey = "AIzaSyC7Exvy4fyWdWyONtpptneRWU4J54wHoF0";
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  Mode _mode = Mode.overlay;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      key: homeScaffoldKey,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDropdownMenu(),
          RaisedButton(
            onPressed: _handlePressButton,
            child: Text("Search places"),
          ),
          RaisedButton(
            child: Text("Custom"),
            onPressed: () {
              Navigator.of(context).pushNamed("/search");
            },
          ),
        ],
      )),
    );
  }


  Widget _buildDropdownMenu() => DropdownButton(
        value: Mode.overlay,
        items: <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            child: Text("Overlay"),
            value: _mode,
          ),
          DropdownMenuItem<Mode>(
            child: Text("Fullscreen"),
            value: Mode.fullscreen,
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m;
          });
        },
      );

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
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
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}


  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }


}
