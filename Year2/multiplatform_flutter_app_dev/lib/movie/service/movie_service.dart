import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';
import 'package:movie_catalog/common/service/common_service.dart';
import 'package:movie_catalog/genre/model/genre.dart';
import 'package:movie_catalog/genre/service/genre_service.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:rxdart/rxdart.dart';

class MovieService extends CommonService<Movie> {
  final CelebrityService _celebrityService = GetIt.I.get<CelebrityService>();
  final GenreService _genreService = GetIt.I.get<GenreService>();
  final List<String> _filteredGenres = [];
  String _filteredTitle = "";
  MovieService() : super('Movies');

  Stream<List<Movie>> get movies => all.map((t) => t
      .where((movie) =>
          removeDiacritics(movie.title.toLowerCase()).contains(_filteredTitle))
      .where((movie) => (_filteredGenres.isNotEmpty)
          ? movie.genreIds!.any((g) => _filteredGenres.contains(g))
          : true)
      .toList());

  Stream<List<Movie>> get filteredMovies =>
      (_filteredTitle == "" && _filteredGenres.isEmpty)
          ? Stream.value(List.empty())
          : movies;

  Stream<List<(Movie, Role)>> celebrityMovies(String celebrityId) {
    return all.map((l) => l
        .expand((m) => m.celebrityIdsWithRole!
            .where((e) => e.keys.first == celebrityId)
            .map((ee) => (m, ee.values.first)))
        .toList());
  }

  Stream<List<Celebrity>> movieCelebrities(String movieId, {Role? role}) {
    return _celebrityService.movieCelebrities(movieId, role: role);
  }

  Stream<List<Genre>> movieGenres(String movieId) {
    return CombineLatestStream.combine2(all, _genreService.all,
        (movies, genres) {
      final movie = movies.where((m) => m.id == movieId).first;
      return genres.where((g) => movie.genreIds!.contains(g.id)).toList();
    });
  }

  Future<void> addCelebrity(String movieId, String celebrityId,
      {Role role = Role.actor}) async {
    await _celebrityService.addToMovie(movieId, celebrityId, role);
    return collection.doc(movieId).update({
      "celebrityIdsWithRole": FieldValue.arrayUnion([
        <String, String>{celebrityId: role.name}
      ])
    });
  }

  Future<void> updateCelebrity(String movieId, String? oldCelebrityId,
      String celebrityId, Role role) async {
    if (oldCelebrityId != null) {
      await removeCelebrity(movieId, oldCelebrityId, role);
    }
    await addCelebrity(movieId, celebrityId, role: role);
  }

  Future<void> removeCelebrity(
      String movieId, String celebrityId, Role role) async {
    await _celebrityService.removeFromMovie(movieId, celebrityId, role);
    collection.doc(movieId).update({
      "celebrityIdsWithRole": FieldValue.arrayRemove([
        {celebrityId: role.name}
      ])
    });
  }

  Future<void> addGenreTags(String movieId, List<String> genreIds) async {
    return collection.doc(movieId).update({"genreIds": genreIds});
  }

  void addTitleFilter(String title) {
    _filteredTitle = removeDiacritics(title.toLowerCase());
  }

  void addGenreFilter(List<String> genreIds) {
    _filteredGenres.clear();
    _filteredGenres.addAll(genreIds);
  }

  Future<void> updateStringFields(String movieId, String title, String preview,
      String storyline, String bannerImage, String posterImage) async {
    await collection.doc(movieId).update({"title": title});
    await collection.doc(movieId).update({"preview": preview});
    await collection.doc(movieId).update({"storyLine": storyline});
    await collection.doc(movieId).update({"bannerImage": bannerImage});
    await collection.doc(movieId).update({"posterImage": posterImage});
  }

  Future<void> updateGenres(String movieId, List<String> genreIds) async {
    await collection.doc(movieId).update({"genreIds": genreIds});
  }

  Future<void> updateYear(String movieId, DateTime year) async {
    await collection.doc(movieId).update({"year": year.toString()});
  }
}
