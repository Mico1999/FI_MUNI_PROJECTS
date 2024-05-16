import 'package:flutter/material.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/widget/celebrity_tile.dart';
import 'package:movie_catalog/movie/widget/movie_list_tile.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class CombinedStreamBuilder extends StatelessWidget {
  final Stream<List<Movie>> movies;
  final Stream<List<Celebrity>> celebrities;
  final bool showCelebrities;
  final bool isSearch;
  const CombinedStreamBuilder(
      {super.key,
      required this.movies,
      required this.celebrities,
      required this.showCelebrities,
      required this.isSearch});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2<List<Movie>, List<Celebrity>>(
      streams: StreamTuple2(movies, celebrities),
      builder: (context, snapshots) {
        final moviesSnap = snapshots.snapshot1;
        final celebSnap = snapshots.snapshot2;
        if (moviesSnap.hasError || celebSnap.hasError) {
          return Text(moviesSnap.error.toString());
        }
        if (moviesSnap.hasData && celebSnap.hasData) {
          if (moviesSnap.data!.length +
                  ((showCelebrities) ? celebSnap.data!.length : 0) ==
              0) {
            return Center(
              child: Text(
                  (isSearch) ? "Nothing found :(" : "Type to search for..."),
            );
          }
          return ListView.separated(
            itemBuilder: (_, index) {
              if (index < moviesSnap.data!.length) {
                final movie = moviesSnap.data![index];
                return MovieListTile(movie: movie);
              } else {
                if (showCelebrities) {
                  final celebrity =
                      celebSnap.data![index - moviesSnap.data!.length];
                  return InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, '/celebrity_detail',
                          arguments: celebrity),
                      child: CelebrityTile(celebrity: celebrity));
                }
                return null;
              }
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: moviesSnap.data!.length +
                ((showCelebrities) ? celebSnap.data!.length : 0),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
