import 'package:flutter/material.dart';
import 'package:movie_catalog/genre/model/genre.dart';
import 'package:movie_catalog/genre/widget/genre_list_tile.dart';

class GenreListView extends StatelessWidget {
  final List<Genre> genres;
  final StateSetter innerSetState;
  final List<int> genreIndexes;
  const GenreListView(
      {super.key,
      required this.genres,
      required this.innerSetState,
      required this.genreIndexes});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (_, index) {
            return GenreListTile(
                index: index,
                innerSetState: innerSetState,
                genre: genres[index],
                genreIndexes: genreIndexes);
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: genres.length),
    );
  }
}
