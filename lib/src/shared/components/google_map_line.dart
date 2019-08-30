import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_togo/src/blocs/lines_detail_bloc.dart';
import 'package:lisbon_togo/src/shared/components/loading.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';
import 'package:lisbon_togo/src/shared/model/line_detail.dart';
import 'package:uuid/uuid.dart';

class MapLineDetail extends StatelessWidget {
  final Data lineInformation;

  const MapLineDetail(this.lineInformation);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<LinesDetailBloc>();

    bloc.sinkInformation.add(lineInformation);

    return Scaffold(
      appBar: AppBar(title: Text('Line R')),
      endDrawer: Drawer(
        child: Container(
            color: Color(0xFF673ab7),
            child: StreamBuilder<List<LineRouteDetailModel>>(
              stream: bloc.listLineDetail,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Loading('Problema para encontrar detalhes');
                }
                if (!snapshot.hasData || snapshot.data[0] == null) {
                  return Loading('Carregando informações');
                }

                final stepsList = List<Step>();

                stepsList.addAll(snapshot.data.map((elm) => Step(
                      title: Text(
                        "Nome: ${elm.stopName.replaceAll("-", "\n").replaceAll("/", "\n/").replaceAll("(", "\n(")}",
                        softWrap: true,
                        style: TextStyle(color: Colors.white),
                      ),
                      isActive: true,
                      content: Text(
                        "Código: ${elm.stopCode}",
                        style: TextStyle(color: Colors.white),
                      ),
                    )));

                return Stepper(
                    type: StepperType.vertical,
                    steps: stepsList,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Row(
                        children: <Widget>[
                          Container(
                            child: null,
                          ),
                          Container(
                            child: null,
                          ),
                        ],
                      );
                    });
              },
            )),
      ),
      body: StreamBuilder<List<Object>>(
          stream: bloc.readySubmit,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Loading('Problema para encontrar detalhes');
            }
            if (!snapshot.hasData || snapshot.data[0] == null) {
              return Loading('Carregando informações');
            }

            var lines = snapshot.data[0] as List<LineRouteDetailModel>;
            var mapPolyline = snapshot.data[2] as Set<Polyline>;

            return GoogleMap(
              markers: snapshot.data[1],
              polylines: mapPolyline,
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(lines[0].stopLatitude),
                      double.parse(lines[0].stopLongitude)),
                  zoom: 14.4766),
              onMapCreated: (GoogleMapController controller) {},
              indoorViewEnabled: true,
            );
          }),
    );
  }
}
