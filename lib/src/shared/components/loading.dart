import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String textLoading;
  const Loading(this.textLoading);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.textLoading,
          style: TextStyle(fontSize: 30.0, color: Colors.black),
        ),
        CircularProgressIndicator(),
      ],
    ));
  }
}
