import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/widget/movie_rating_bar.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/service/review_service.dart';

class MovieRatingBuilder extends StatelessWidget {
  final Movie movie;
  final bool withTextRating;
  final reviewService = GetIt.I.get<ReviewService>();

  MovieRatingBuilder(
      {super.key, required this.movie, required this.withTextRating});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: reviewService.getMovieReviews(movie.id!),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final reviews = snapshot.data!;
          final movieRating = reviews.isNotEmpty
              ? snapshot.data!.map((review) => review.rating).average
              : 0.0;

          return MovieRatingBar(
              rating: movieRating, withTextRating: withTextRating);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
