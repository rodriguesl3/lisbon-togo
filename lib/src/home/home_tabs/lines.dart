import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
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
            textAlign: TextAlign.center,
            autocorrect: true,
            decoration: InputDecoration(
              hintText: 'Buscar carreira',
              hintStyle: TextStyle(color: Colors.white)
            ),
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

                  return ListView(
                    children: buildListItems(context, lines),
                  );

                  // return CustomScrollView(
                  //   slivers: buildListItems(context, lines),
                  // );
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

      var listView = ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Colors.black,),
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(
          // leading: Image(
          //     image: NetworkImage(
          //         "https://www.transporlis.pt/${items[index].carrierImage}")),
          title: Text(items[index].lineName),
          subtitle: Text('Empresa: $elm'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapLineDetail(items[index])));
          },
        ),
      );

      var widgets = items.map((item) => Row(
            children: <Widget>[
              Text(item.lineName),
              SizedBox(
                height: 15.0,
              )
            ],
          ));

      widgetList.add(ExpansionTile(
        key: Key(elm),
        title: Text(elm),
        leading: Image(
          image: NetworkImage(
              "https://www.transporlis.pt/${items[0].carrierImage}"),
        ),
        children: <Widget>[
          Container(
              height: 520.0,
              width: 500.0,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    child: listView,
                  )
                ],
              ))
        ],
      ));
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
