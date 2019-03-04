import 'package:flutter_app/tabs/Cast.dart';
class Subject {
  final String title;
  Map rating = {
    "max": 0,
    "average": 0,
    "stars": 0,
    "min": 0
  };
  final List<String> genres;
  final List<Cast> casts;
  final int year;
  Map images = {
    "small": '',
    "large": '',
    "medium": ''
  };
  Subject(this.title, this.rating, this.genres, this.casts, this.year, this.images);
}