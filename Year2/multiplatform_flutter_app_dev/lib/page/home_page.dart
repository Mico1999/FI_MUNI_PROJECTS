import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/page/widget/movie_stream_builder.dart';

class HomePage extends StatelessWidget {
  final movieService = GetIt.I.get<MovieService>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // DON'T CALL FOR NOW
    // Seeder s = Seeder();
    // s.seed();
    // ImageSeeder i = ImageSeeder();
    // i.seed();
    return PageTemplate(
      title: "Movies Catalog",
      child: Column(
        children: [
          Expanded(child: MovieStreamBuilder(movies: movieService.movies)),
        ],
      ),
    );
  }
}
