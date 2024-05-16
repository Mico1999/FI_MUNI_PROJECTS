import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/util/shared_constants.dart';
import 'package:movie_catalog/common/widget/app_root.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/user/authentication.dart';
import 'package:movie_catalog/user/model/app_user.dart';
import 'package:movie_catalog/user/model/role.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';
import 'package:movie_catalog/user/text_field_decoration.dart';

class LoginPage extends StatelessWidget {
  final bool signIn;
  final _appUserService = GetIt.I.get<AppUserService>();
  LoginPage({super.key, required this.signIn});

  @override
  Widget build(BuildContext context) {
    var email = "";
    var password = "";
    return PageTemplate(
      title: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                  child: Text(
                signIn ? "Log In" : "Sign Up",
                style: const TextStyle(fontSize: 40.0),
              )),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: TextFieldDecoration.get(context).copyWith(
                  hintText: "Enter your email",
                )),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: TextFieldDecoration.get(context)
                    .copyWith(hintText: "Enter your password.")),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
                child: signIn ? const Text("Log In") : const Text("Sign Up"),
                onPressed: () async {
                  if (signIn) {
                    await Authentication.signInWithEmail(
                        context, email, password);
                  } else {
                    await Authentication.signUpWithEmail(
                        context, email, password);

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
                    }
                  }
                  if (FirebaseAuth.instance.currentUser != null) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, "/profile");
                      selectedIndexGlobal.value = HOME_PAGE_INDEX;
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
