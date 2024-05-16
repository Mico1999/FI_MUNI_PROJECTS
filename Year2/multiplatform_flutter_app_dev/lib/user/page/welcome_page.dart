import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/user/authentication.dart';
import 'package:movie_catalog/user/model/app_user.dart';
import 'package:movie_catalog/user/model/role.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

const _PADDING = 16.0;

class WelcomePage extends StatelessWidget {
  final _appUserService = GetIt.I.get<AppUserService>();
  WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // in case user is cached after restart of app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, "/profile");
        }
      }
    });

    return PageTemplate(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _PADDING),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(_PADDING),
                child: Center(
                    child: Text(
                  "Movie Catalog",
                  style: TextStyle(fontSize: 40.0),
                )),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login", arguments: true);
                },
                child: const Padding(
                  padding: EdgeInsets.all(_PADDING),
                  child: Text("Log In"),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login", arguments: false);
                },
                child: const Padding(
                  padding: EdgeInsets.all(_PADDING),
                  child: Text("Sign Up"),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton.icon(
                icon: const Image(
                  image: AssetImage("assets/google.png"),
                  height: 35.0,
                ),
                onPressed: () async {
                  await Authentication.signInWithGoogle(context);

                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // create new app user only if not existent
                    final appUser =
                        await _appUserService.getByEmailFuture(user.email!);
                    if (appUser == null) {
                      await _appUserService.add(AppUser(
                        userEmail: user.email!,
                        role: Role.registered,
                        favoriteMovies: null,
                        favoriteCelebrities: null,
                        id: null,
                      ));
                    }
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, "/profile");
                    }
                  }
                },
                label: const Padding(
                  padding: EdgeInsets.all(_PADDING),
                  child: Text("Google"),
                ),
              )
            ]),
      ),
    );
  }
}
