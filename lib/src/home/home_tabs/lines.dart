import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class Lines extends StatelessWidget {
  const Lines({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyleHeader = TextStyle(color: Colors.white, fontSize: 25.0);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(55.0)),
                boxShadow: [new BoxShadow(blurRadius: 15.0)],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFff8400), Color(0xFF140085)])),
          ),
        ),
        body: Container(child: Text('Lines available.'),)
      ),
    );
  }
}
