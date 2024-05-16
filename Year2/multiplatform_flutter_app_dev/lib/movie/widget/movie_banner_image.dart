import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';

class MovieBannerImage extends StatelessWidget {
  final String imageUrl;
  final _storageService = GetIt.I.get<FireStorage>();
  MovieBannerImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: ArcClipper(), child: _futureImage());
  }

  Widget _futureImage() {
    return FutureBuilder(
        future: _storageService.downloadImage(imageUrl),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: MediaQuery.of(context).size.width,
              height: 230.0,
              fit: BoxFit.cover,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
