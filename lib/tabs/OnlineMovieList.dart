import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/tabs/Movie.dart';

class OnlineMovieList extends StatefulWidget {
  @override
  _OnlineMovieListState createState () {
    return new _OnlineMovieListState();
  }
}
class _OnlineMovieListState extends State<OnlineMovieList> {
  Movie movieList;

  @override
  void initState() {
    super.initState();
    _getOnlineMovieList();
  }
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new ListView(
        children: <Widget>[
          _getListItem(),
          _getListItem(),
        ],
      ),
    );
  }
  Padding _getMovieImg () {
    return new Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: new Image.network(
            'https://img.alicdn.com/bao/uploaded/i2/TB1plvqDSzqK1RjSZFjXXblCFXa_.jpg_300x300.jpg',
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
        movieList = Movie.getData(json.decode(jsonData));
      });
    }
  }
  Widget _getListItem () {
    return Card(
      child: Row(
          children: <Widget>[
            Container( /// 此组件在主轴方向占据48.0逻辑像素
                width: 110.0,
                height: 150.0,
                child: _getMovieImg(),
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
                          '驯龙高手3',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text('评分：'),
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
                      child: Text("购买1")
                  ),
                ),
              )
            ),
          ]
      ),
    );
  }
}
