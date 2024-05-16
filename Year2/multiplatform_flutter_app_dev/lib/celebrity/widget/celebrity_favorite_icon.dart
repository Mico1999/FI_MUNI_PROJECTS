import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/common/widget/favorite_icon.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class CelebrityFavoriteIcon extends StatefulWidget {
  final Celebrity celebrity;
  final _appUserService = GetIt.I.get<AppUserService>();

  CelebrityFavoriteIcon({super.key, required this.celebrity});

  @override
  State<CelebrityFavoriteIcon> createState() => _CelebrityFavoriteIconState();
}

class _CelebrityFavoriteIconState extends State<CelebrityFavoriteIcon> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    } else {
      return FavoriteIcon(
          isFavorite: widget._appUserService
              .isCelebrityFavorite(user!.email!, widget.celebrity.id!),
          addToFavorites: _addToFavorites,
          removeFromFavorites: _removeFromFavorites);
    }
  }

  Future<void> _addToFavorites() async => await widget._appUserService
      .addToFavoriteCelebrities(user!.email!, widget.celebrity.id!);

  Future<void> _removeFromFavorites() async => await widget._appUserService
      .removeFromFavoriteCelebrities(user!.email!, widget.celebrity.id!);
}
