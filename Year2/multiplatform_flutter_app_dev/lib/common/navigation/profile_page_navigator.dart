import 'package:flutter/material.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/page/celebrity_detail_page.dart';
import 'package:movie_catalog/celebrity/page/celebrity_edit_page.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/page/movie_detail_page.dart';
import 'package:movie_catalog/movie/page/movie_edit_page.dart';
import 'package:movie_catalog/user/page/auth_details_page.dart';
import 'package:movie_catalog/user/page/login_page.dart';
import 'package:movie_catalog/user/page/profile_page.dart';
import 'package:movie_catalog/common/widget/not_found_page.dart';
import 'package:movie_catalog/user/page/welcome_page.dart';

class ProfilePageNavigator extends StatelessWidget {
  const ProfilePageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return WelcomePage();
                case '/profile':
                  return ProfilePage();
                case '/login':
                  return LoginPage(signIn: settings.arguments as bool);
                case '/auth_details':
                  return const AuthDetailsPage();
                case '/movie_detail':
                  Movie movie = settings.arguments as Movie;
                  return MovieDetailPage(
                    movie: movie,
                  );
                case '/celebrity_detail':
                  Celebrity celebrity = settings.arguments as Celebrity;
                  return CelebrityDetailPage(
                    celebrity: celebrity,
                  );
                case '/movie_edit':
                  Movie? movie = settings.arguments as Movie?;
                  return MovieEditPage(
                    movie: movie,
                  );
                case '/celebrity_edit':
                  Celebrity? celebrity = settings.arguments as Celebrity?;
                  return CelebrityEditPage(
                    celebrity: celebrity,
                  );
                default:
                  return const NotFoundPage();
              }
            });
      },
    );
  }
}
