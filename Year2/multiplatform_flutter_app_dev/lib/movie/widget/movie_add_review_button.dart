import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/util/shared_constants.dart';
import 'package:movie_catalog/common/widget/app_root.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/widget/movie_review_dialog.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/model/review_status.dart';
import 'package:movie_catalog/review/service/review_service.dart';
import 'package:tuple/tuple.dart';

class MovieAddReviewButton extends StatelessWidget {
  final _reviewService = GetIt.I.get<ReviewService>();
  final Movie movie;

  MovieAddReviewButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ElevatedButton(
        onPressed: () async {
          if (user != null) {
            final review =
                await showDialog<Tuple4<double, String, ReviewStatus, Review?>>(
                    context: context,
                    builder: (BuildContext context) {
                      return MovieReviewDialog(
                        movie: movie,
                      );
                    });
            if (review != null) {
              if (review.item3 == ReviewStatus.created) {
                await _createReview(user, review.item1, review.item2);
              } else if (review.item3 == ReviewStatus.updated) {
                await _updateReview(
                    review.item4!.id!, review.item1, review.item2);
              }
            }
          } else {
            if (context.mounted) {
              Navigator.pop(context);
              selectedIndexGlobal.value = PROFILE_PAGE_INDEX;
            }
          }
        },
        child: const Text("Your review"));
  }

  Future<void> _createReview(User user, double rating, String text) async {
    final date = DateTime.now();

    final review = Review(
        text: text,
        date: DateTime(date.year, date.month, date.day),
        rating: rating,
        movieId: movie.id!,
        userEmail: user.email!,
        id: null);

    await _reviewService.add(review);
  }

  Future<void> _updateReview(
      String reviewId, double rating, String text) async {
    await _reviewService.update(reviewId, rating, text);
  }
}
