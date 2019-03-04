import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/OnlineMovieList.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}
class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState () {
    return new _MyHomeState();
  }
}
class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  String dropdownValue = '杭州';
  DropdownButton getDropdownButton () {
   return new DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['杭州', '上海', '北京']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()
       );
  }
  Stack getTitleStack () {
    return new Stack(
        children: <Widget>[
          new Align(
            alignment: FractionalOffset.centerLeft,
            child: getDropdownButton()
          ),
          new Align(
            alignment: FractionalOffset.center,
            child: new Text('电影'),
          ),
          new Align(
            alignment:Alignment(0.75, 0),
            child:  new Icon(
              Icons.center_focus_weak ,
              size: 28,
              color: Colors.black,
            ),
          ),
          new Align(
            alignment: FractionalOffset.centerRight,
            child:  new Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
        ]
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: getTitleStack(),
        bottom: new TabBar(
          tabs: <Widget>[
            new Tab(
                text: '正在热映(55)'
            ),
            new Tab(
                text: '即将上映(111)'
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new OnlineMovieList(),
          new Center(child: new Text('船')),
        ],
      ),
    );
  }
}