import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/common/widget/poster.dart';
import 'package:movie_catalog/movie/widget/movie_rating_builder.dart';

class MovieListTile extends StatelessWidget {
  final Movie movie;
  const MovieListTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.94,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/movie_detail', arguments: movie);
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          color: Colors.white70,
          elevation: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.28,
                    maxHeight: MediaQuery.of(context).size.height * 0.28,
                  ),
                  child: Poster(
                    posterUrl: movie.posterImage,
                    height: 200.0,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    MovieRatingBuilder(movie: movie, withTextRating: false),
                    const SizedBox(
                      height: 15.0,
                    ),
                    ExpandableText(
                      movie.preview,
                      expandText: "show more",
                      collapseText: "show less",
                      maxLines: 3,
                      linkColor: Colors.deepOrange,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
