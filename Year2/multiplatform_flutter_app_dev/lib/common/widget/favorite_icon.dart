import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  final Stream<bool> isFavorite;
  final Future<void> Function() addToFavorites;
  final Future<void> Function() removeFromFavorites;
  const FavoriteIcon(
      {super.key,
      required this.isFavorite,
      required this.addToFavorites,
      required this.removeFromFavorites});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isFavorite,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return IconButton(
            onPressed: () async {
              if (snapshot.data!) {
                removeFromFavorites();
              } else {
                addToFavorites();
              }
            },
            tooltip:
                snapshot.data! ? "Remove from favorites" : "Add to favorites",
            icon: Icon(
              Icons.favorite,
              size: 20.0,
              color: snapshot.data! ? Colors.red : Colors.grey,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
