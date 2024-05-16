import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';
import 'package:movie_catalog/common/service/common_service.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/service/review_service.dart';
import 'package:movie_catalog/user/model/app_user.dart';
import 'package:movie_catalog/user/model/role.dart';
import 'package:rxdart/rxdart.dart';

class AppUserService extends CommonService<AppUser> {
  final MovieService _movieService = GetIt.I.get<MovieService>();
  final CelebrityService _celebrityService = GetIt.I.get<CelebrityService>();
  final ReviewService _reviewService = GetIt.I.get<ReviewService>();

  AppUserService() : super('AppUsers');

  Stream<List<AppUser>> get appUsers => all;

  Future<void> addToFavoriteMovies(String userEmail, String movieId) async {
    final appUser = await getByEmailFuture(userEmail);
    final favoritesMovies =
        appUser!.favoriteMovies != null ? appUser.favoriteMovies : [];

    favoritesMovies!.add(movieId);

    await collection
        .doc(appUser.id)
        .update({"favoriteMovies": favoritesMovies});
  }

  Future<void> removeFromFavoriteMovies(
      String userEmail, String movieId) async {
    final appUser = await getByEmailFuture(userEmail);
    final favoriteMovies = appUser!.favoriteMovies;

    favoriteMovies!.remove(movieId);

    await collection.doc(appUser.id).update({"favoriteMovies": favoriteMovies});
  }

  Future<void> addToFavoriteCelebrities(
      String userEmail, String celebrityId) async {
    final appUser = await getByEmailFuture(userEmail);
    final favoriteCelebrities =
        appUser!.favoriteCelebrities != null ? appUser.favoriteCelebrities : [];

    favoriteCelebrities!.add(celebrityId);

    await collection
        .doc(appUser.id)
        .update({"favoriteCelebrities": favoriteCelebrities});
  }

  Future<void> removeFromFavoriteCelebrities(
      String userEmail, String celebrityId) async {
    final appUser = await getByEmailFuture(userEmail);
    final favoriteCelebrities = appUser!.favoriteCelebrities;

    favoriteCelebrities!.remove(celebrityId);

    await collection
        .doc(appUser.id)
        .update({"favoriteCelebrities": favoriteCelebrities});
  }

  Stream<AppUser?> getByEmail(String userEmail) {
    return all.map((l) => l.firstWhereOrNull((a) => a.userEmail == userEmail));
  }

  Future<AppUser?> getByEmailFuture(String userEmail) async {
    return await getByEmail(userEmail).firstWhere((e) => true);
  }

  Stream<List<Movie>> getFavoriteMovies(String userEmail) {
    return CombineLatestStream.combine2(
        _movieService.all,
        getByEmail(userEmail),
        (movies, user) => movies
            .where((m) => (user!.favoriteMovies != null)
                ? user.favoriteMovies!.contains(m.id)
                : false)
            .toList());
  }

  Stream<List<Celebrity>> getFavoriteCelebrities(String userEmail) {
    return CombineLatestStream.combine2(
        _celebrityService.all,
        getByEmail(userEmail),
        (celeb, user) => celeb
            .where((c) => (user!.favoriteCelebrities != null)
                ? user.favoriteCelebrities!.contains(c.id)
                : false)
            .toList());
  }

  Stream<List<Review>> getReviews(String userEmail) {
    return _reviewService.all
        .map((l) => l.where((r) => r.userEmail == userEmail).toList());
  }

  Stream<bool> isMovieFavorite(String userEmail, String movieId) {
    return getByEmail(userEmail).map((a) => (a!.favoriteMovies != null)
        ? a.favoriteMovies!.contains(movieId)
        : false);
  }

  Stream<bool> isCelebrityFavorite(String userEmail, String celebrityId) {
    return getByEmail(userEmail).map((a) => (a!.favoriteCelebrities != null)
        ? a.favoriteCelebrities!.contains(celebrityId)
        : false);
  }

  Stream<bool> isAdmin(String userEmail) {
    return getByEmail(userEmail).map((a) => a!.role == Role.admin);
  }
}
