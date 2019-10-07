import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lisbon_togo/src/blocs/directions_map_bloc.dart';
import 'package:lisbon_togo/src/blocs/lines_detail_bloc.dart';
import 'package:lisbon_togo/src/blocs/welcome_bloc.dart';
import 'package:lisbon_togo/src/home/home_page.dart';
import 'package:lisbon_togo/src/blocs/lines_bloc.dart';
import 'package:lisbon_togo/src/blocs/station_bloc.dart';
import 'package:lisbon_togo/src/blocs/suggestion_bloc.dart';
import 'package:lisbon_togo/src/repositories/direction_repository.dart';
import 'package:lisbon_togo/src/repositories/lines_repository.dart';
import 'package:lisbon_togo/src/repositories/next_bus_repository.dart';
import 'package:lisbon_togo/src/repositories/request_client_http.dart';
import 'package:lisbon_togo/src/repositories/route_repository.dart';
import 'package:lisbon_togo/src/repositories/stations_repository.dart';
import 'package:lisbon_togo/src/repositories/suggestions_repository.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:lisbon_togo/src/shared/database/database_creator.dart';
import 'package:lisbon_togo/src/shared/global_position.dart';

import 'src/blocs/routes_bloc.dart';

void main() async {
  await DatabaseCreator().initDatabase();

  runApp(BlocProvider(
    child: LisbonApp(),
    dependencies: [
      Dependency((i) => GlobalPosition()),
      Dependency((i) => RequestClient()),
      Dependency((i) => RequestDirection()),
      Dependency(
          (i) => SuggestionsRepository(i.get<RequestClient>().requestHttp())),
      Dependency((i) => RouteRepository(i.get<RequestClient>().requestHttp())),
      Dependency(
          (i) => StationsRepository(i.get<RequestClient>().requestHttp())),
      Dependency(
          (i) => DirectionRepository(i.get<RequestDirection>().requestHttp())),
      Dependency((i) => LinesRepository(i.get<RequestClient>().requestHttp())),
      Dependency(
          (i) => LineDetailRepository(i.get<RequestClient>().requestHttp())),
      Dependency((i) => NextBusRepository(i.get<RequestClient>().requestHttp()))
    ],
    blocs: [
      Bloc((i) => SuggestionBLoc(i.get<SuggestionsRepository>())),
      Bloc((i) => RoutesBloc(i.get<RouteRepository>())),
      Bloc((i) => StationsBloc(
          i.get<StationsRepository>(), i.get<DirectionRepository>())),
      Bloc((i) => DirectionsMapBloc()),
      Bloc((i) => LinesBloc(i.get<LinesRepository>())),
      Bloc((i) => LinesDetailBloc(i.get<LineDetailRepository>())),
      Bloc((i) => WelcomeBloc(i.get<NextBusRepository>()))
    ],
  ));
}

class LisbonApp extends StatelessWidget {
  const LisbonApp({Key key}) : super(key: key);

  @override
Widget build(BuildContext context) {
    GlobalPosition().getCurrentPosition();

    return MaterialApp(
      title: "Lisbon Transport",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.amber[50],
          appBarTheme: AppBarTheme(
            color: Colors.indigo[900],
            elevation: 12.0,
          ),
          pageTransitionsTheme: PageTransitionsTheme(),
          
          primaryColor: Colors.indigo,
          accentColor: Colors.red[700],
          buttonColor: Color(0xab000d),
          textSelectionColor: Colors.indigo[600],
          
          errorColor: Colors.redAccent[700],
          backgroundColor: Colors.white60,
          // cardColor: Color(0xebebd3),

          fontFamily: 'Montserrat'),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      //routes: ,
    );
  }
}
