import 'package:flutter/material.dart';
import 'package:lisbon_togo/src/pages/welcome.dart';
//import 'package:flutter/widgets.dart';

import './home_tabs/suggestions.dart' as suggestions;
import './home_tabs/routes.dart' as routes;
import './home_tabs/stations.dart' as stations;
import './home_tabs/lines.dart' as lines;

class HomePage extends StatefulWidget {
  HomePage({Key key, int position}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController tabController;
  int position=0;
 
 
  
  @override
  void initState() {
    tabController = TabController(vsync: this, length:4);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(
        isScrollable: false,
        //colors:[Color(0xFF673ab7),Color(0xFF3f51b5)]
        unselectedLabelColor: Colors.orangeAccent[400],
        labelColor: Color(0xFF140085),
        controller: tabController,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.star)),
          Tab(icon: Icon(Icons.location_on)),
          Tab(icon: Icon(Icons.train)),
          Tab(icon: Icon(Icons.score)),
        ],
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          WelcomePage(),
          stations.Stations(),
          lines.Lines(),
          suggestions.SugestionPage()
        ],
      ),
    );
  }
}
