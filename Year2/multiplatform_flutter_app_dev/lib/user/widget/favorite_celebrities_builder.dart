import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/movie/widget/celebrity_scroller.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class FavoriteCelebritiesBuilder extends StatelessWidget {
  final _appUserService = GetIt.I.get<AppUserService>();
  FavoriteCelebritiesBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: _appUserService.getFavoriteCelebrities(user.email!),
      builder: (BuildContext context, AsyncSnapshot<List<Celebrity>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final favoriteCelebrities = snapshot.data!;
          if (favoriteCelebrities.isEmpty) {
            return const Card(
              elevation: 10,
              color: Colors.white70,
              child: Text("You have no favorite celebrities yet"),
            );
          } else {
            return CelebrityScroller(
              celebrities: favoriteCelebrities,
              isInMovieDetail: false,
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
