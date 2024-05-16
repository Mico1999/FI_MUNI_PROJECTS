import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';

const _POSTER_RATIO = 0.7;

class Poster extends StatelessWidget {
  final String posterUrl;
  final double height;
  final _storageService = GetIt.I.get<FireStorage>();

  Poster({super.key, required this.posterUrl, required this.height});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4.0),
      elevation: 2.0,
      child: _futureImage(),
    );
  }

  Widget _futureImage() {
    return FutureBuilder(
        future: _storageService.downloadImage(posterUrl),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: _POSTER_RATIO * height,
              height: height,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
