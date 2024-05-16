import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';

class CelebrityScroller extends StatelessWidget {
  final List<Celebrity> celebrities;
  final bool isInMovieDetail;
  final String? movieIdInEditMode;
  // This param is dependent on movieIdInEditMode
  final Role? roleInEditMode;
  final storageService = GetIt.I.get<FireStorage>();
  final movieService = GetIt.I.get<MovieService>();

  CelebrityScroller(
      {super.key,
      required this.celebrities,
      required this.isInMovieDetail,
      this.movieIdInEditMode,
      this.roleInEditMode});

  Widget _buildActor(BuildContext ctx, int index) {
    final celebrity = celebrities[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () => (movieIdInEditMode != null && roleInEditMode != null)
            ? movieService.removeCelebrity(
                movieIdInEditMode!, celebrity.id!, roleInEditMode!)
            : Navigator.pushNamed(ctx, '/celebrity_detail',
                arguments: celebrity),
        child: Column(
          children: [
            _futureImage(celebrity.avatar),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("${celebrity.firstName} ${celebrity.lastName}"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _futureImage(String image) {
    return FutureBuilder(
        future: storageService.downloadImage(image),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            return CircleAvatar(
              backgroundImage: Image.memory(
                snapshot.data!,
              ).image,
              radius: 40.0,
              child: (movieIdInEditMode != null)
                  ? const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.cancel,
                        size: 17,
                      ),
                    )
                  : Container(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isInMovieDetail
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Cast',
                  style: textTheme.titleMedium,
                ),
              )
            : const SizedBox(
                height: 2.0,
              ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: celebrities.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildActor,
          ),
        ),
      ],
    );
  }
}
