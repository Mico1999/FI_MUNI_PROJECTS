import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/genre/model/genre.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/common/widget/poster.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'movie_banner_image.dart';

class MovieDetailHeader extends StatelessWidget {
  final Movie movie;
  final _movieService = GetIt.I.get<MovieService>();
  MovieDetailHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(children: [
      MovieBannerImage(
        imageUrl: movie.bannerImage,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(children: [
          Poster(posterUrl: movie.posterImage, height: 230.0),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                StreamBuilder(
                    stream: _movieService.movieCelebrities(movie.id!),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Celebrity>> snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 14.0),
                              child: Row(children: [
                                const Icon(Icons.movie_creation_outlined),
                                Text(" ${movie.year.year}")
                              ]),
                            ),
                            Text(
                                "Director: ${_getStaff(Role.director, snapshot.data!)}"),
                            Text(
                                "Script: ${_getStaff(Role.scriptwriter, snapshot.data!)}"),
                            Text(
                                "Camera: ${_getStaff(Role.cameraman, snapshot.data!)}"),
                            Text(
                                "Music: ${_getStaff(Role.music, snapshot.data!)}"),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                const SizedBox(
                  height: 12.0,
                ),
                StreamBuilder(
                    stream: _movieService.movieGenres(movie.id!),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Genre>> snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return SizedBox.fromSize(
                          size: const Size.fromHeight(60.0),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return _buildGenreChip(snapshot.data![index]);
                              }),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
          )
        ]),
      ),
    ]);
  }

  String _getStaff(Role role, List<Celebrity> celebrities) {
    final staffMember = celebrities.firstWhereOrNull((celebrity) => celebrity
        .movieIdsWithRole!
        .where((element) => element.containsKey(movie.id))
        .where((element) => element.containsValue(role))
        .isNotEmpty);

    return staffMember != null
        ? "${staffMember.firstName} ${staffMember.lastName}"
        : "";
  }

  Widget _buildGenreChip(Genre genre) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Chip(
        label: Text(genre.name),
      ),
    );
  }
}
