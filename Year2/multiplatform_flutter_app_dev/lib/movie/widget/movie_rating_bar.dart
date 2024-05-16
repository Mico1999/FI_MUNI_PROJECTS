import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:movie_catalog/movie/service/movie_service.dart';

class MovieRatingBar extends StatelessWidget {
  final double rating;
  final bool withTextRating;
  final movieService = GetIt.I.get<MovieService>();

  MovieRatingBar(
      {super.key, required this.rating, required this.withTextRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRatingStars(),
        const SizedBox(height: 4.0),
        withTextRating
            ? Text(
                rating.toStringAsFixed(2),
                style: const TextStyle(color: Colors.deepOrange),
              )
            : Container()
      ],
    );
  }

  Widget _buildRatingStars() {
    final stars = <Icon>[];

    for (var i = 1; i <= 5; i++) {
      final color = i <= rating ? Colors.deepOrange : Colors.black12;
      final star = Icon(
        Icons.star,
        color: color,
      );

      stars.add(star);
    }

    return Row(children: stars);
  }
}
