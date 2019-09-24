import 'package:flutter/material.dart';
import 'package:lisbon_togo/src/home/home_tabs/routes.dart';

class CustomFlatButton extends StatelessWidget {
  final Widget widget;
  final Function routeObject;

  const CustomFlatButton({this.widget, this.routeObject});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: this.routeObject,
        color: Colors.transparent,
        child: this.widget);
  }
}

class SuggestionDetails extends StatelessWidget {
  final String heroTag;
  final String descriptionPlace;
  final String imageUrl;
  final String title;
  final double latitude, longitude;

  const SuggestionDetails(this.heroTag, this.descriptionPlace, this.imageUrl,
      this.title, this.latitude, this.longitude);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CustomFlatButton(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.arrow_back),
                        Text('Voltar')
                      ],
                    ),
                    routeObject: () {
                      Navigator.pop(context);
                    }),
                CustomFlatButton(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Icon(Icons.directions), Text('Rota')],
                    ),
                    routeObject: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contenxt) => Routes(
                                    initialLatitude: this.latitude,
                                    initialLongitude: this.longitude,
                                    pointName: this.title,
                                  )));
                    }),
              ],
            ),
          ),
        ),
        body: Hero(
          tag: heroTag,
          child: Container(
              padding: EdgeInsets.only(bottom: 0),
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        this.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.grey,
                            fontFamily: 'MontSerrat'),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(this.descriptionPlace,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                                fontFamily: 'MontSerrat')),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
