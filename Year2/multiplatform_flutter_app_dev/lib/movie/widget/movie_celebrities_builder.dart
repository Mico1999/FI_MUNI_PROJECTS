import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/movie/widget/celebrity_scroller.dart';

class MovieCelebritiesBuilder extends StatelessWidget {
  final Movie movie;
  final movieService = GetIt.I.get<MovieService>();

  MovieCelebritiesBuilder({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: movieService.movieCelebrities(movie.id!, role: Role.actor),
      builder: (BuildContext context, AsyncSnapshot<List<Celebrity>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return CelebrityScroller(
            celebrities: snapshot.data!,
            isInMovieDetail: true,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
