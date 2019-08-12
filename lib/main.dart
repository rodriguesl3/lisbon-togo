import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lisbon_togo/src/home/home_page.dart';
import 'package:lisbon_togo/src/home/home_tabs/blocs/station_bloc.dart';
import 'package:lisbon_togo/src/home/home_tabs/blocs/suggestion_bloc.dart';
import 'package:lisbon_togo/src/repositories/direction_repository.dart';
import 'package:lisbon_togo/src/repositories/request_client_http.dart';
import 'package:lisbon_togo/src/repositories/route_repository.dart';
import 'package:lisbon_togo/src/repositories/stations_repository.dart';
import 'package:lisbon_togo/src/repositories/suggestions_repository.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import 'src/home/home_tabs/blocs/routes_bloc.dart';

void main() => runApp(BlocProvider(
      child: LisbonApp(),
      dependencies: [
        Dependency((i) => RequestClient()),
        Dependency((i)=> RequestDirection()),
        Dependency(
            (i) => SuggestionsRepository(i.get<RequestClient>().requestHttp())),
        Dependency(
            (i) => RouteRepository(i.get<RequestClient>().requestHttp())),
        Dependency(
            (i) => StationsRepository(i.get<RequestClient>().requestHttp())),
        Dependency(
            (i) => DirectionRepository(i.get<RequestDirection>().requestHttp()))
      ],
      blocs: [
        Bloc((i) => SuggestionBLoc(i.get<SuggestionsRepository>())),
        Bloc((i) => RoutesBloc(i.get<RouteRepository>())),
        Bloc((i) => StationsBloc(
            i.get<StationsRepository>(), i.get<DirectionRepository>()))
      ],
    ));

class LisbonApp extends StatelessWidget {
  const LisbonApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lisbon Transport",
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Color(0xFF673ab7),
          buttonColor: Color(0xFFff8400),
          fontFamily: 'Montserrat'),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      //routes: ,
    );
  }
}
