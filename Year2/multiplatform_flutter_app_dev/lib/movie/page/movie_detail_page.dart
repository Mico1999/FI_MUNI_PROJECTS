import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/movie/widget/movie_add_review_button.dart';
import 'package:movie_catalog/movie/widget/movie_celebrities_builder.dart';
import 'package:movie_catalog/movie/widget/movie_detail_header.dart';
import 'package:movie_catalog/movie/widget/movie_favorite_icon.dart';
import 'package:movie_catalog/movie/widget/movie_rating_builder.dart';
import 'package:movie_catalog/movie/widget/movie_reviews_builder.dart';

import 'package:movie_catalog/movie/widget/movie_story_line.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class MovieDetailPage extends StatelessWidget {
  final appUserService = GetIt.I.get<AppUserService>();
  final Movie movie;
  MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: movie.title,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MovieDetailHeader(movie: movie),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: MovieRatingBuilder(
                        movie: movie,
                        withTextRating: true,
                      )),
                  const SizedBox(
                    width: 16.0,
                  ),
                  MovieAddReviewButton(
                    movie: movie,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  MovieFavoriteIcon(movie: movie)
                ],
              ),
              _buildEdit(),
              MovieStoryLine(
                storyLine: movie.storyLine,
              ),
              const SizedBox(
                height: 20.0,
              ),
              MovieCelebritiesBuilder(movie: movie),
              const SizedBox(
                height: 50.0,
              ),
              MovieReviewsBuilder(movie: movie),
              const SizedBox(
                height: 50.0,
              )
            ],
          ),
        ));
  }

  Widget _buildEdit() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container();
    }
    return StreamBuilder(
      stream: appUserService.isAdmin(user.email!),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data!) {
            // isAdmin
            return Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 15.0),
              child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/movie_edit',
                      arguments: movie),
                  icon: const Icon(
                    Icons.edit,
                    size: 35,
                  ),
                  label: const Text("Edit")),
            );
          } else {
            return Container();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
