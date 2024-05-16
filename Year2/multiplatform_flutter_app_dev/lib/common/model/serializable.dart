import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/genre/model/genre.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/user/model/app_user.dart';

class Serializable {
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  static Serializable fromJson(Map<String, dynamic> json) {
    if (json.containsKey("title")) {
      return Movie.fromJson(json);
    } else if (json.containsKey("rating")) {
      return Review.fromJson(json);
    } else if (json.containsKey("avatar")) {
      return Celebrity.fromJson(json);
    } else if (json.containsKey("favoriteMovies")) {
      return AppUser.fromJson(json);
    } else {
      return Genre.fromJson(json);
    }
  }
}
