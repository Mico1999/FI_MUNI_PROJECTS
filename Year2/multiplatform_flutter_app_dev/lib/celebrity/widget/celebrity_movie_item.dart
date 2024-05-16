import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/common/widget/poster.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/service/review_service.dart';

class CelebrityMovieItem extends StatelessWidget {
  CelebrityMovieItem({
    super.key,
    required this.movieRole,
  });
  final (Movie, Role) movieRole;
  final reviewService = GetIt.I.get<ReviewService>();

  @override
  Widget build(BuildContext context) {
    Movie movie = movieRole.$1;
    Role role = movieRole.$2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, '/movie_detail', arguments: movie),
        child: Row(
          children: [
            Poster(posterUrl: movie.bannerImage, height: 80),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(movie.title),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      StreamBuilder(
                        stream: reviewService.getMovieReviews(movie.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Review>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          if (snapshot.hasData) {
                            final reviews = snapshot.data!;
                            final movieRating = reviews.isNotEmpty
                                ? snapshot.data!
                                    .map((review) => review.rating)
                                    .average
                                : 0.0;

                            return Text(movieRating.toStringAsFixed(2));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child:
                            Text(role != Role.actor ? "as ${role.name}" : ""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
