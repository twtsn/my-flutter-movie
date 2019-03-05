import 'package:flutter_app/tabs/Subject.dart';
import 'package:flutter_app/tabs/Cast.dart';
class Movie {
   int count;
   int start;
   int total;
   List<Subject> subjectList;

   static List<Cast> _getCastList (list) {
     List<Cast> castList = new List<Cast>();
     Map item = null;
     for(var j = 0 ; j < list.length ; j++) {
       item = list[j];
       castList.add(new Cast (
           item['alt'],
           item['avatars'],
           item['name'],
           item['id']
       ));
     }
     return castList;
   }
  static Movie getData (Map jsonData) {
    Movie movie = new Movie();
    movie.count = jsonData['count'];
    movie.start = jsonData['start'];
    movie.total = jsonData['total'];
    List<Subject> subjectList = [];
    List list = jsonData['subjects'];
    Subject subject = null;
    Map item = null;
    for(var i = 0 ; i < list.length ; i++) {
      item = list[i];
      List<Cast> castList = _getCastList(item['casts']);
      Map<String, dynamic> ratingMap = new Map();
      ratingMap['max'] = item['rating']['max'];
      ratingMap['average'] = item['rating']['max'];
      ratingMap['stars'] = item['rating']['max'];
      ratingMap['min'] = item['rating']['max'];
      subject = new Subject(
          item['title'],
          ratingMap,
          item['genres'],
          castList,
          item['year'],
          item['images']);
      subjectList.add(subject);
    }
    movie.subjectList = subjectList;
    return movie;
  }
}