import 'package:flutter_app/tabs/Subject.dart';
class Movie {
   int count;
   int start;
   int total;
   List<Subject> subjectList;

   static List<String> _getCastList (list) {
     List<String> castList = [];
     for(var j = 0 ; j < list.length ; j++) {
       castList.add(list[j]['name']);
     }
     return castList;
   }
   static Map<String, dynamic> _getRating (item){
     Map<String, dynamic> ratingMap = new Map();
     ratingMap['max'] = item['rating']['max'];
     ratingMap['average'] = item['rating']['average'];
     ratingMap['stars'] = item['rating']['stars'];
     ratingMap['min'] = item['rating']['min'];
     ratingMap['min'] = item['rating']['min'];
     ratingMap['min'] = item['rating']['min'];
     return ratingMap;
   }
   static List<String> _getDirectors (list) {
     List<String> directors = [];
     for(int i = 0 ; i < list.length ; i++){
       directors.add(list[i]['name']);
     }
     return directors;
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
      List<String> castList = _getCastList(item['casts']);
      Map<String, dynamic> ratingMap = _getRating(item);
      List<String> directors = _getDirectors(item['directors']);
      subject = new Subject(
          item['title'],
          ratingMap,
          item['genres'],
          castList,
          item['year'],
          item['images'],
          directors
      );
      subjectList.add(subject);
    }
    movie.subjectList = subjectList;
    return movie;
  }
}