import 'dart:convert';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lisbon_togo/src/shared/components/google_map_line.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';

import '../../blocs/lines_bloc.dart';

class Lines extends StatelessWidget {
  const Lines({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.getBloc<LinesBloc>();
    var textStyleHeader = TextStyle(color: Colors.white, fontSize: 25.0);

    getLines(context).then((res) {
      bloc.setCarrierLines(lines: res);
    });

    var appBacrWithImage = AppBar(
      elevation: 0.0,
      flexibleSpace: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
        child: Center(
          child: TextField(
            autocorrect: true,
            onChanged: (data) {
              bloc.sinkSearchQuery.add(data);
              getLines(context).then((res) {
                bloc.setCarrierLines(lines: res);
              });
            },
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://www.incimages.com/uploaded_files/image/970x450/getty_874661962_200013331653767149166_347892.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(55.0)),
            boxShadow: [new BoxShadow(blurRadius: 15.0)],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFff8400), Color(0xFF140085)])),
      ),
    );

    return SafeArea(
        child: Scaffold(
            appBar: appBacrWithImage,
            body: StreamBuilder<CarrierLineModel>(
                stream: bloc.listLine,
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Text('Error');
                  else if (!snapshot.hasData) {
                    return Text('Loading....');
                  } else if (snapshot.data.data == null) {
                    return Text('Loading....');
                  }

                  var lines = snapshot.data.data;

                  return CustomScrollView(
                    slivers: buildListItems(context, lines),
                  );
                })));
  }

  List<Widget> buildListItems(BuildContext context, List<Data> lines) {
    final widgetList = List<Widget>();

    lines
        .where((elm) => elm.carrierUrl.contains("op="))
        .map((e) => e.carrierUrl.split("op=")[1])
        .toSet()
        .toList()
        .forEach((elm) {
      List<Data> items =
          lines.where((item) => item.carrierUrl.contains(elm)).toList();

      widgetList.add(
        SliverStickyHeaderBuilder(
          builder: (context, state) => Container(
            height: 60.0,
            color: (state.isPinned ? Colors.pink : Colors.lightBlue)
                .withOpacity(1.0 - state.scrollPercentage),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              elm,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ListTile(
                dense: true,
                leading: Image(
                    image: NetworkImage(
                        "https://www.transporlis.pt/${items[i].carrierImage}")),
                title: Text(items[i].lineName),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapLineDetail(items[i])));

                  print('${items[i].lineName} was pressed');
                },
              ),
              childCount: items.length,
            ),
          ),
        ),
      );
    });

    return widgetList;
  }

  Future<dynamic> getLines(BuildContext context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/lines.json");
    final jsonResult = json.decode(data);
    return jsonResult;
  }
}
