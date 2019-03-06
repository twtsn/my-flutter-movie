class Subject {
  final String title;
  Map<String, dynamic> rating = {
    "max": 0,
    "average": 0,
    "stars": "0",
    "min": 0
  };
  final List<dynamic> genres;
  final List<String> casts;
  final String year;
  Map images = {
    "small": '',
    "large": '',
    "medium": ''
  };
  final List<String> directors;
  Subject(this.title, this.rating, this.genres, this.casts, this.year, this.images, this.directors);
}