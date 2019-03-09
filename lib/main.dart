import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/MovieList.dart';
import 'package:flutter_app/common/MyEvent.dart';

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
  int onlineTotal = 0;
  int comingTotal = 0;
  String onlineMovieUrl = 'https://api.douban.com/v2/movie/in_theaters';
  String comingSoonMovieUrl = 'https://api.douban.com/v2/movie/coming_soon';
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }
  void changeDataForOnline (int total) {
    setState((){
      this.onlineTotal = total;
    });
  }
  void changeDataForComing (total) {
    setState((){
      this.comingTotal = total;
    });
  }
  String city = '杭州';
  DropdownButton getDropdownButton () {
   return new DropdownButton<String>(
          value: city,
          onChanged: (String newValue) {
            setState(() {
              city = newValue;
              print('切换城市 ===============' + city);
              eventBus.fire(new MyEvent(city, ''));
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
            child: new Text('老徐电影'),
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
  String _getTotalStr (int total) {
    String totalStr = '';
    if (total != null && total > 0) {
      totalStr = '('+  total.toString() +')';
    }
    return totalStr;
  }
  @override
  Widget build(BuildContext context) {
    String onlineTotal = this._getTotalStr(this.onlineTotal);
    String comingTotal = this._getTotalStr(this.comingTotal);
    return new Scaffold(
      appBar: new AppBar(
        title: getTitleStack(),
        bottom: new TabBar(
          tabs: <Widget>[
            new Tab(
                text: '正在热映' + onlineTotal
            ),
            new Tab(
                text: '即将上映' + comingTotal
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new MovieList(url: this.onlineMovieUrl, city: city, query: '', changeData: changeDataForOnline),
          new MovieList(url: this.comingSoonMovieUrl, city: city, query: '', changeData: changeDataForComing),
        ],
      ),
    );
  }
}