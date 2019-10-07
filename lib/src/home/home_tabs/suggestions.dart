import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lisbon_togo/src/home/details/suggestion_details.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:lisbon_togo/src/blocs/suggestion_bloc.dart';
import 'package:lisbon_togo/src/shared/model/suggestion.dart';

class SugestionPage extends StatefulWidget {
  SugestionPage({Key key}) : super(key: key);

  _SugestionPageState createState() => _SugestionPageState();
}

class _SugestionPageState extends State<SugestionPage> {
  void buildStaggeredGridView(List<SuggestionModel> suggestionsList) {}

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<SuggestionBLoc>();

    timeDilation = 2.0;
    var cardHorizontalList = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                var cardImage = Image(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  height: 150.0,
                  image: NetworkImage('https://placeimg.com/470/280/any'),
                );
                var cardContainer = Card(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
                    elevation: 20.0,
                    child: Column(
                      children: <Widget>[
                        cardImage,
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                          child: Text(
                            'Nice place to visit. Make sure that you not going to wrong place. :)',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ));
                var btnRouteChange = RaisedButton(
                    child: Text(
                      "Read More",
                      style: TextStyle(color: Colors.white),
                    ),
                    elevation: 0.8,
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)));

                return Container(
                  width: 260.0,
                  height: 300.0,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        height: 270.0,
                        width: 250.0,
                        child: cardContainer,
                      ),
                      Positioned(
                          top: 240.0,
                          left: MediaQuery.of(context).size.width / 5,
                          width: 120.0,
                          child: btnRouteChange)
                    ],
                  ),
                );
              }),
        ),
      ],
    );

    var staggeredGridView = StreamBuilder<List<SuggestionModel>>(
      stream: bloc.listOut,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<SuggestionModel> suggestions = snapshot.data;

        return StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) => Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(0.0),
              child: Hero(
                tag: 'suggestion${index}',
                child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuggestionDetails(
                                  'suggestion${index}',
                                  suggestions[index].descriptionPlace,
                                  suggestions[index].imageUrl,
                                  suggestions[index].title,
                                  suggestions[index].latitude,
                                  suggestions[index].longitude)));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Image(
                          image: NetworkImage(suggestions[index].imageUrl),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 200.0,
                        ),
                        Positioned(
                          //top: 120.0,
                          child: Text(
                            suggestions[index].title,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              wordSpacing: 12.0,
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )),
              )),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
                  alignment: Alignment.center,
                  child: Text(
                    'We have some suggestion',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  )),
              Container(height: 300.0, child: cardHorizontalList),
              SizedBox(
                height: 90.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Most Visited in Lisbon.',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
                  ),
                  Icon(
                    Icons.monochrome_photos,
                    size: 30.0,
                  ),
                ],
              ),
              Container(
                  height: 500.0,
                  width: 300.0,
                  margin: EdgeInsets.all(20.0),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Expanded(
                        child: staggeredGridView,
                      )
                    ],
                  )),
              SizedBox(
                height: 20.0,
              ),
              Text('Did you like?'),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
