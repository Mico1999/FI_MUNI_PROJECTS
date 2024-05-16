import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/common/service/common_service.dart';

class CelebrityService extends CommonService<Celebrity> {
  String _filteredName = "";

  CelebrityService() : super("Celebrities");

  Stream<List<Celebrity>> get celebrities => all.map((t) => t
      .where((celebrity) =>
          removeDiacritics(celebrity.lastName.toLowerCase())
              .contains(_filteredName) ||
          removeDiacritics(celebrity.firstName.toLowerCase())
              .contains(_filteredName) ||
          removeDiacritics(("${celebrity.firstName} ${celebrity.lastName}")
                  .toLowerCase())
              .contains(_filteredName) ||
          removeDiacritics(("${celebrity.lastName} ${celebrity.firstName}")
                  .toLowerCase())
              .contains(_filteredName))
      .toList());

  Stream<List<Celebrity>> get filteredCelebrities =>
      (_filteredName == "") ? Stream.value(List.empty()) : celebrities;

  Stream<List<Celebrity>> movieCelebrities(String movieId, {Role? role}) {
    return all.map((l) => l
        .where((c) => c.movieIdsWithRole!
            .where((e) => (role == null) ? true : role == e.values.first)
            .any((m) => m.keys.first == movieId))
        .toList());
  }

  // ! Is called by MovieService
  Future<void> addToMovie(String movieId, String celebrityId, Role role) {
    return collection.doc(celebrityId).update({
      "movieIdsWithRole": FieldValue.arrayUnion([
        <String, String>{movieId: role.name}
      ])
    });
  }

  // ! Is called by MovieService
  Future<void> removeFromMovie(
      String movieId, String celebrityId, Role role) async {
    collection.doc(celebrityId).update({
      "movieIdsWithRole": FieldValue.arrayRemove([
        {movieId: role.name}
      ])
    });
  }

  void addNameFilter(String name) {
    _filteredName = removeDiacritics(name.trim().toLowerCase());
  }

  Future<void> updateCelebrity(
      String celebrityId,
      String firstName,
      String lastName,
      String about,
      String avatar,
      DateTime birthDay,
      DateTime? died) async {
    await collection.doc(celebrityId).update({"firstName": firstName});
    await collection.doc(celebrityId).update({"lastName": lastName});
    await collection.doc(celebrityId).update({"about": about});
    await collection.doc(celebrityId).update({"avatar": avatar});
    await collection.doc(celebrityId).update({"birthDay": birthDay.toString()});
    await collection.doc(celebrityId).update({"died": died?.toString()});
  }
}
