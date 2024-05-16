import 'package:collection/collection.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/celebrity/widget/celebrity_movie_item.dart';
import 'package:movie_catalog/celebrity/widget/celebrity_tile.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class CelebrityDetailPage extends StatelessWidget {
  final Celebrity celebrity;
  final movieService = GetIt.I.get<MovieService>();
  final appUserService = GetIt.I.get<AppUserService>();

  CelebrityDetailPage({super.key, required this.celebrity});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "${celebrity.firstName} ${celebrity.lastName}",
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CelebrityTile(celebrity: celebrity),
            _buildEditButton(),
            const Text(
                style: TextStyle(
                    height: 2, color: Colors.deepPurple, fontSize: 20),
                "About"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ExpandableText(
                celebrity.about,
                expandText: "show more",
                collapseText: "show less",
                maxLines: 8,
                linkColor: Colors.deepOrange,
              ),
            ),
            const Text(
                style: TextStyle(
                    height: 2, color: Colors.deepPurple, fontSize: 20),
                "Movies"),
            StreamBuilder(
              stream: movieService.celebrityMovies(celebrity.id!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<(Movie, Role)>> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 12.0, left: 20.0),
                    itemBuilder: (context, index) => CelebrityMovieItem(
                        movieRole: snapshot.data!.sorted((a, b) => b.$1.title
                            .toLowerCase()
                            .compareTo(a.$1.title.toLowerCase()))[index]),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
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
                  onPressed: () => Navigator.pushNamed(
                      context, '/celebrity_edit',
                      arguments: celebrity),
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
