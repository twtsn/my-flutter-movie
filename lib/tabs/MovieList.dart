import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/tabs/Movie.dart';
import 'package:flutter_app/tabs/Subject.dart';
import 'package:flutter_app/common/MyEvent.dart';

class MovieList extends StatefulWidget {
  MovieList({Key key, this.url, this.city, this.query, this.changeData}):super(key: key);
  String url;
  String city;
  String query;
  final Function(int total) changeData;
  @override
  _MovieListState createState () {
    return new _MovieListState();
  }
}
class _MovieListState extends State<MovieList> {
  ScrollController _scrollController = new ScrollController();
  int start = 0;
  int count = 10;
  int totalSize = 0;
  String loadMoreText = '';
  List<Card> listCard = [];
  Future<Movie> future;
  @override
  void initState() {
    super.initState();
    future = _getOnlineMovieList();
    print('init change');
    eventBus.on<MyEvent>().listen((MyEvent data) =>
        _onDataChange(data)
    );
    _scrollEvent();
//    _scrollController.addListener((){
//      print(_scrollController.position.pixels);
//    });
  }
  void _scrollEvent() {
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixel = _scrollController.position.pixels;
      if (maxScroll == pixel && listCard.length < totalSize) {
        setState(() {
          loadMoreText = "正在加载中...";
        });
        _refresh();
      } else {
      }
    });
  }
  void _onDataChange (data) {
    setState((){
      widget.city = data.city;
      widget.query = data.query;
       future = _getOnlineMovieList(); //刷新数据,重新设置future就行了
    });
  }
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      body: new Center(
//        child: FutureBuilder(
//            builder: _buildFuture,
//            future: future
//        ),
//      ),
//    );
//  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: new ListView.builder(
            itemCount: listCard.length,
            itemBuilder: (context,i) {
              if(listCard.length == i + 1) {
                return _buildProgressMoreIndicator();
              }
              return listCard[i];
            },
            controller: _scrollController,
          )
//          FutureBuilder(
//              builder: _buildFuture,
//              future: future
//          ),
        )
      ),
    );
  }
  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText),
      ),
    );
  }
  Future<Null> _refresh() async {
    print('refresh');
    start += count;
    print('start====' + start.toString());
    _getOnlineMovieList();
    return;
  }
  //利用FutureBuilder来实现懒加载，并可以监听加载过程的状态
  Widget _buildFuture(BuildContext context, AsyncSnapshot<Movie> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        print('done');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _createListView(context, snapshot);
      default:
        return null;
    }
  }
  Widget _createListView(BuildContext context,  AsyncSnapshot<Movie> snapshot) {
//    print('list length' + listCard.length.toString());
//    return ListView(
//        children: listCard
//    );
  }
  _addMoreData(Movie movie) {
    listCard.addAll(_getList(movie));
    print('listCard' + listCard.length.toString());
  }
  List<Card> _getList (Movie moviePage) {
    List<Card> list = [];
    Card newItem = null;
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
   Future<Movie>_getOnlineMovieList () async {
     setState(() {
       loadMoreText = "正在加载数据...";
     });
    var http = new HttpClient();
    print('请求参数 url ===============' + widget.url);
    print('请求参数 city ===============' + widget.city);
    print('请求参数 start ===============' + start.toString());
    String url = widget.url + '?city='+ widget.city +'&start='+  start.toString() +'&count=' + count.toString();
    var request = await http.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok){
      var jsonData = await response.transform(utf8.decoder).join();
      Movie movie = Movie.getData(json.decode(jsonData));
      if(start == 0) {
        totalSize = movie.total;
        widget.changeData(movie.total);
      }
      _addMoreData(movie);

      var text = "点击加载更多";
      if (movie.total == listCard.length) {
        text = '无更多数据';
      }
      setState(() {
        loadMoreText = text;
      });
      return movie;
    } else {
      return null;
    }
  }
  Stack _getTitleAndAverage (Subject subject) {
    double average = double.parse(subject.rating['average'].toString());
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
  Card _getListItem (subject) {
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
