import 'package:flutter/material.dart';
import 'package:movie_catalog/genre/model/genre.dart';

class GenreListTile extends StatelessWidget {
  final int index;
  final StateSetter innerSetState;
  final Genre genre;
  final List<int> genreIndexes;
  const GenreListTile(
      {super.key,
      required this.index,
      required this.innerSetState,
      required this.genre,
      required this.genreIndexes});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: [
          Text(genre.name),
          const Expanded(child: SizedBox()),
          (genreIndexes != [])
              ? (genreIndexes.contains(index))
                  ? const Icon(
                      Icons.check,
                      size: 30,
                    )
                  : Container()
              : Container(),
        ],
      ),
      selectedColor: Colors.purple,
      onTap: () {
        if (genreIndexes.contains(index)) {
          genreIndexes.remove(index);
        } else {
          genreIndexes.add(index);
        }

        innerSetState(() {});
      },
      selected: (genreIndexes != []) ? (genreIndexes.contains(index)) : false,
    );
  }
}
