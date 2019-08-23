import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lisbon_togo/src/shared/model/carrier_line.dart';

import 'blocs/lines_bloc.dart';

class Lines extends StatelessWidget {
  const Lines({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.getBloc<LinesBloc>();
    var textStyleHeader = TextStyle(color: Colors.white, fontSize: 25.0);

    var appBacrWithImage = AppBar(
      elevation: 0.0,
      flexibleSpace: Container(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
        child: Center(
          child: TextField(
            autocorrect: true,
            //onChanged: () {},
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
                  }

                  var lines = snapshot.data.data;

                  var foo = lines.map((e)=>e.carrierUrl.split("op=")[1]).toSet().toList();
                  


                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverStickyHeaderBuilder(
                        builder: (context, state) => new Container(
                          height: 60.0,
                          color:
                              (state.isPinned ? Colors.pink : Colors.lightBlue)
                                  .withOpacity(1.0 - state.scrollPercentage),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            'Header #1',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        sliver: new SliverList(
                          delegate: new SliverChildBuilderDelegate(
                            (context, i) => new ListTile(
                              leading: new CircleAvatar(
                                child: new Text('0'),
                              ),
                              title: new Text('List tile #$i'),
                            ),
                            childCount: 12,
                          ),
                        ),
                      ),
                      SliverStickyHeaderBuilder(
                        builder: (context, state) => new Container(
                          height: 60.0,
                          color:
                              (state.isPinned ? Colors.pink : Colors.lightBlue)
                                  .withOpacity(1.0 - state.scrollPercentage),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            'Header #2',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        sliver: new SliverList(
                          delegate: new SliverChildBuilderDelegate(
                            (context, i) => new ListTile(
                              leading: new CircleAvatar(
                                child: new Text('0'),
                              ),
                              title: new Text('List tile #$i'),
                            ),
                            childCount: 12,
                          ),
                        ),
                      ),
                      SliverStickyHeaderBuilder(
                        builder: (context, state) => new Container(
                          height: 60.0,
                          color:
                              (state.isPinned ? Colors.pink : Colors.lightBlue)
                                  .withOpacity(1.0 - state.scrollPercentage),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            'Header #2',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        sliver: new SliverList(
                          delegate: new SliverChildBuilderDelegate(
                            (context, i) => new ListTile(
                              leading: new CircleAvatar(
                                child: new Text('0'),
                              ),
                              title: new Text('List tile #$i'),
                            ),
                            childCount: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                })));
  }
}
