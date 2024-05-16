import 'package:flutter/material.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/widget/movie_list_tile.dart';

class MovieStreamBuilder extends StatelessWidget {
  final Stream<List<Movie>> movies;

  const MovieStreamBuilder({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: movies,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return ListView.separated(
              itemBuilder: (_, index) {
                final movie = snapshot.data![index];
                return MovieListTile(movie: movie);
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: snapshot.data!.length);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
