import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/widget/movie_list_tile.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class FavoriteMoviesBuilder extends StatelessWidget {
  final _appUserService = GetIt.I.get<AppUserService>();
  FavoriteMoviesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: _appUserService.getFavoriteMovies(user.email!),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final favoriteMovies = snapshot.data!;
          if (favoriteMovies.isEmpty) {
            return const Card(
              elevation: 10,
              color: Colors.white70,
              child: Text("You have no favorite movies yet"),
            );
          } else {
            return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final movie = favoriteMovies[index];
                  return MovieListTile(movie: movie);
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: favoriteMovies.length);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
