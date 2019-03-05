import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/tabs/Movie.dart';
import 'package:flutter_app/tabs/Subject.dart';
class OnlineMovieList extends StatefulWidget {
  @override
  _OnlineMovieListState createState () {
    return new _OnlineMovieListState();
  }
}
class _OnlineMovieListState extends State<OnlineMovieList> {
  Movie moviePage;

  @override
  void initState() {
    super.initState();
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
    const url = 'https://api.douban.com/v2/movie/in_theaters?city=杭州&start=0&count=10';
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
  Widget _getListItem (subject) {
    String average = subject.rating['average'].toString();
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
                        Text(
                          subject.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text('评分：' + average),
                        Text('类型：'),
                        Text('导演：'),
                        Text('主演：')
                      ],
                    ),
                  )
                ) /// 此组件会填满Row在主轴方向的剩余空间，撑开Row
            ),
            Container( /// 此组件在主轴方向占据48.0逻辑像素
              width: 100.0,
              child: new Padding(
                padding: EdgeInsets.only(
                  right: 10.0,
                ),
                child: new Align(
                  alignment: FractionalOffset.centerRight,
                  child: OutlineButton(
                      textTheme: ButtonTextTheme.primary,
                      textColor: Colors.blue,//文字的颜色
                      child: Text("购买")
                  ),
                ),
              )
            ),
          ]
      ),
    );
  }
}
