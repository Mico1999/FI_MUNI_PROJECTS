import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_catalog/movie/widget/movie_rating_bar.dart';
import 'package:movie_catalog/review/model/review.dart';

class MovieReviews extends StatelessWidget {
  final List<Review> reviews;

  const MovieReviews({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Reviews",
              style: textTheme.titleMedium,
            )),
        SizedBox.fromSize(
            size: const Size.fromHeight(200.0),
            child: ListView.separated(
              itemCount: reviews.length,
              itemBuilder: _buildReview,
              separatorBuilder: (_, __) => const Divider(),
              padding:
                  const EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
            )),
      ],
    );
  }

  Widget _buildReview(BuildContext ctx, int index) {
    final textTheme = Theme.of(ctx).textTheme;
    var review = reviews[index];

    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.userEmail,
            style: textTheme.titleSmall,
          ),
          const SizedBox(
            height: 15.0,
          ),
          MovieRatingBar(rating: review.rating, withTextRating: false),
          const SizedBox(
            height: 15.0,
          ),
          ExpandableText(
            review.text,
            expandText: "show more",
            collapseText: "show less",
            maxLines: 3,
            linkColor: Colors.deepOrange,
          ),
        ],
      ),
    );
  }
}
