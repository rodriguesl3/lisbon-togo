import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';

class Stations extends StatefulWidget {
  Stations({Key key}) : super(key: key);

  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        /*TextField(
                        style: new TextStyle(
                          color: Colors.white,

                        ),
                        decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.search,color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)
                        ),
                      ), */
        title: Text("Stations", textAlign: TextAlign.center),
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
      ),
      
    );
    return scaffold;
  }
}
