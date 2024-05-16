import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/user/authentication.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';
import 'package:movie_catalog/user/widget/favorite_celebrities_builder.dart';
import 'package:movie_catalog/user/widget/favorite_movies_builder.dart';
import 'package:movie_catalog/user/widget/reviews_builder.dart';

class ProfilePage extends StatelessWidget {
  final appUserService = GetIt.I.get<AppUserService>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final textTheme = Theme.of(context).textTheme;

    return PageTemplate(
      title: (user.displayName == null) ? "Profile Page" : user.displayName!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async => {
                            await Authentication.signOut(context),
                            if (context.mounted)
                              {Navigator.pushReplacementNamed(context, "/")}
                          },
                      child: const Text("Sign Out")),
                  const SizedBox(
                    width: 8.0,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/auth_details',
                        arguments: user),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xffE6E6E6),
                      foregroundImage: user.photoURL != null
                          ? Image.network(user.photoURL!).image
                          : null,
                      radius: 30.0,
                      child: const Icon(
                        Icons.person,
                        color: Color(0xffCCCCCC),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildCreateButtons(context, user),
            _pageSubTitleSection("Favorite movies", textTheme),
            _pageContainerSection(
                FavoriteMoviesBuilder(),
                MediaQuery.of(context).size.width * 0.95,
                MediaQuery.of(context).size.height * 0.4),
            _pageSubTitleSection("Favorite celebrities", textTheme),
            _pageContainerSection(
                FavoriteCelebritiesBuilder(),
                MediaQuery.of(context).size.width * 0.95,
                MediaQuery.of(context).size.height * 0.2),
            _pageSubTitleSection("Reviews", textTheme),
            _pageContainerSection(
                ReviewsBuilder(),
                MediaQuery.of(context).size.width * 0.95,
                MediaQuery.of(context).size.height * 0.35),
            const SizedBox(
              height: 50.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButtons(BuildContext context, User user) {
    return StreamBuilder(
        stream: appUserService.isAdmin(user.email!),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (snapshot.data! == true) {
              return Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                            context, '/movie_edit',
                            arguments: null),
                        icon: const Icon(Icons.movie_creation),
                        label: const Text("Create Movie")),
                    const SizedBox(
                      width: 12.0,
                    ),
                    ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                            context, '/celebrity_edit',
                            arguments: null),
                        icon: const Icon(Icons.add_circle_rounded),
                        label: const Text("Create Celebrity")),
                  ],
                ),
              );
            } else {
              return Container();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _pageSubTitleSection(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 35.0, bottom: 35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _pageContainerSection(Widget widget, double width, double height) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      child: widget,
    );
  }
}
