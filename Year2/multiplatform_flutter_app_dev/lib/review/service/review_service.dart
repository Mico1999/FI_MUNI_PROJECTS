import 'package:movie_catalog/common/service/common_service.dart';
import 'package:movie_catalog/review/model/review.dart';

class ReviewService extends CommonService<Review> {
  ReviewService() : super("Reviews");

  Stream<List<Review>> get reviews => all;
  Future<void> update(String id, double rating, String text) async =>
      await collection.doc(id).update({"rating": rating, "text": text});

  Stream<List<Review>> getMovieReviews(String movieId) {
    return all.map((l) => l.where((r) => r.movieId == movieId).toList());
  }

  // Stream<List<Review>> getUserReview(String userEmail, String movieId) {
  //   return all.map((l) =>
  //       l.where((r) => r.movieId == movieId).where((r) => r.userEmail ==
  //           userEmail).toList());
  // }
  Future<Review?> getUserReview(String userEmail, String movieId) async {
    final userReviews = await collection
        .where("userEmail", isEqualTo: userEmail)
        .get()
        .then((value) => value.docs.toList());

    for (var element in userReviews) {
      if (element.data().movieId == movieId) {
        return element.data();
      }
    }
    return null;
  }
}
