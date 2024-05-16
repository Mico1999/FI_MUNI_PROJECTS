import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/widget/movie_reviews.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/service/review_service.dart';

class MovieReviewsBuilder extends StatelessWidget {
  final Movie movie;
  final reviewService = GetIt.I.get<ReviewService>();

  MovieReviewsBuilder({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: reviewService.getMovieReviews(movie.id!),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return MovieReviews(
            reviews: snapshot.data!,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
