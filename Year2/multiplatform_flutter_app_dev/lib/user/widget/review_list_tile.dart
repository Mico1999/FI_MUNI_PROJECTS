import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/movie/widget/movie_rating_bar.dart';
import 'package:movie_catalog/movie/widget/movie_review_dialog.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/model/review_status.dart';
import 'package:movie_catalog/review/service/review_service.dart';
import 'package:tuple/tuple.dart';

class ReviewListTile extends StatelessWidget {
  final _movieService = GetIt.I.get<MovieService>();
  final _reviewService = GetIt.I.get<ReviewService>();
  final Review review;

  ReviewListTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder(
        stream: _movieService.get(review.movieId!),
        builder: (BuildContext context, AsyncSnapshot<Movie?> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.94,
              child: InkWell(
                onTap: () async {
                  final response = await showDialog<
                          Tuple4<double, String, ReviewStatus, Review?>>(
                      context: context,
                      builder: (BuildContext context) {
                        return MovieReviewDialog(
                          movie: snapshot.data!,
                        );
                      });

                  if (response != null &&
                      response.item3 == ReviewStatus.updated) {
                    await _reviewService.update(
                        review.id!, response.item1, response.item2);
                  }
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    color: Colors.white70,
                    elevation: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.title,
                          style: textTheme.headlineSmall,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: MovieRatingBar(
                            rating: review.rating,
                            withTextRating: false,
                          ),
                        ),
                        ExpandableText(
                          review.text,
                          expandText: "show more",
                          collapseText: "show less",
                          maxLines: 3,
                          linkColor: Colors.deepOrange,
                        )
                      ],
                    )),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
