import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/widget/favorite_icon.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class MovieFavoriteIcon extends StatefulWidget {
  final Movie movie;
  final _appUserService = GetIt.I.get<AppUserService>();
  MovieFavoriteIcon({super.key, required this.movie});

  @override
  State<MovieFavoriteIcon> createState() => _MovieFavoriteIconState();
}

class _MovieFavoriteIconState extends State<MovieFavoriteIcon> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    } else {
      return FavoriteIcon(
          isFavorite: widget._appUserService
              .isMovieFavorite(user!.email!, widget.movie.id!),
          addToFavorites: _addToFavorites,
          removeFromFavorites: _removeFromFavorites);
    }
  }

  Future<void> _addToFavorites() async => await widget._appUserService
      .addToFavoriteMovies(user!.email!, widget.movie.id!);

  Future<void> _removeFromFavorites() async => await widget._appUserService
      .removeFromFavoriteMovies(user!.email!, widget.movie.id!);
}
