import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/tabs/Movie.dart';
import 'package:flutter_app/tabs/Subject.dart';
class OnlineMovieList extends StatefulWidget {
  OnlineMovieList({Key key, this.city, this.query, this.changeData}):super(key: key);
  String city;
  String query;
  final Function() changeData;
  @override
  _OnlineMovieListState createState () {
    return new _OnlineMovieListState();
  }
}
class _OnlineMovieListState extends State<OnlineMovieList> {
  Movie moviePage;
  String city = '';
  String query  = '';

  @override
  void initState() {
    super.initState();
    city = widget.city;
    query = widget.query;
    print(widget.city);
    _getOnlineMovieList();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> listView = _getList();
    return new Center(
      child: new ListView(
        children: listView
      ),
    );
  }
  List<Widget> _getList () {
    List<Widget> list = [];
    Widget newItem = null;
    List<Subject> subjectList = moviePage.subjectList;
    for(var i = 0 ; i < subjectList.length ; i++) {
      Subject subject = subjectList[i];
      newItem = _getListItem(subject);
      list.add(newItem);
    }
    return list;
  }
  Padding _getMovieImg (subject) {
    return new Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: new Image.network(
            subject.images['medium'],
            fit: BoxFit.fill
        )
    );
  }
   _getOnlineMovieList () async {
    var http = new HttpClient();
    print('city ===============' + city);
    String url = 'https://api.douban.com/v2/movie/in_theaters?city='+ city +'&start=0&count=10';
    var request = await http.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok){
      var jsonData = await response.transform(utf8.decoder).join();
      setState(() {
        var m = Movie.getData(json.decode(jsonData));
        moviePage = m;
      });
    }
  }
  Stack _getTitleAndAverage (subject) {
    double average = subject.rating['average'];
    return Stack(
        children: <Widget>[
          Text(
            subject.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Align(
              alignment: FractionalOffset.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                    right: 10.0,
                    top: 5.0
                ),
                child: Text(
                    average.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: average >= 8 ? Colors.red : Colors.black
                    )
                ),
              )
          )
        ]
    );
  }
  Widget _getListItem (subject) {
    String typeStr = subject.genres.join('•');
    String directors = subject.directors.join('•');
    String casts = subject.casts.join('•');
    return Card(
      child: Row(
          children: <Widget>[
            Container( /// 此组件在主轴方向占据48.0逻辑像素
                width: 110.0,
                height: 150.0,
                child: _getMovieImg(subject),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: FractionalOffset.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _getTitleAndAverage(subject),
                        Text('年份：' + subject.year),
                        Text('类型：' + typeStr),
                        Text('导演：' + directors),
                        Text('主演：' + casts),
                      ],
                    ),
                  )
                ) /// 此组件会填满Row在主轴方向的剩余空间，撑开Row
            ),
//            Container( /// 此组件在主轴方向占据48.0逻辑像素
//              width: 100.0,
//              child: new Padding(
//                padding: EdgeInsets.only(
//                  right: 10.0,
//                ),
//                child: new Align(
//                  alignment: FractionalOffset.centerRight,
//                  child: OutlineButton(
//                      textTheme: ButtonTextTheme.primary,
//                      textColor: Colors.blue,//文字的颜色
//                      child: Text("购买")
//                  ),
//                ),
//              )
//            ),
          ]
      ),
    );
  }
}
