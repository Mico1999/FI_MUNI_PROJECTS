import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';
import 'package:movie_catalog/genre/service/genre_service.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/review/service/review_service.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class IoCContainer {
  static setup() {
    GetIt.instance.registerSingleton(CelebrityService());
    GetIt.instance.registerSingleton(ReviewService());
    GetIt.instance.registerSingleton(GenreService());
    GetIt.instance.registerSingleton(MovieService());
    GetIt.instance.registerSingleton(AppUserService());
    GetIt.instance.registerSingleton(FireStorage());
  }
}
