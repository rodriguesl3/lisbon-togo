import 'dart:math';

import 'package:flutter/material.dart';

class Lines extends StatelessWidget {
  const Lines({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyleHeader = TextStyle(color: Colors.white, fontSize: 25.0);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            elevation: 0.0,
            pinned: true,
            floating: true,
            // title: Text('Lisbon Stations'),
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: Center(
                  child: TextField(
                autocorrect: true,
                //onChanged: () {},
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search a line...",
                    hintStyle: TextStyle(color: Colors.white)),
              )),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://www.incimages.com/uploaded_files/image/970x450/getty_874661962_200013331653767149166_347892.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(55.0)),
                  boxShadow: [new BoxShadow(blurRadius: 15.0)],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFff8400), Color(0xFF140085)])),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) {
              var carrisBusRow = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9n_c9xdmEhFTSCnPHH0x7WDH6FKNJXOMQ9jC3EuBYIa-rsO7F'),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    '754 - Alfragide',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 25.0,
                  ),
                  Icon(Icons.timer),
                  Text(
                      '${Random().nextInt(24).toString().padLeft(2, "0")}:${Random().nextInt(60).toString().padLeft(2, "0")}')
                ],
              );
              return Card(
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: carrisBusRow,
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
