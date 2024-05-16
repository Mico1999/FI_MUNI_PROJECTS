import 'package:movie_catalog/common/service/common_service.dart';
import 'package:movie_catalog/genre/model/genre.dart';

class GenreService extends CommonService<Genre> {
  GenreService() : super('Genres');

  Stream<List<Genre>> get genres => all;

  Future<void> update(String id, String name) async =>
      await collection.doc(id).update({"name": name});
}
