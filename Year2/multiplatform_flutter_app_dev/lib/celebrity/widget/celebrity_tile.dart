import 'package:flutter/material.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/widget/celebrity_favorite_icon.dart';
import 'package:movie_catalog/common/widget/poster.dart';

class CelebrityTile extends StatelessWidget {
  const CelebrityTile({
    super.key,
    required this.celebrity,
  });

  final Celebrity celebrity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Poster(
              posterUrl: celebrity.avatar,
              height: 200.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                        style: const TextStyle(color: Colors.deepPurple),
                        "${celebrity.firstName} ${celebrity.lastName}"),
                  ),
                  CelebrityFavoriteIcon(celebrity: celebrity)
                ],
              ),
              const SizedBox(height: 20),
              Text(
                  "Born: ${celebrity.birthDay.day}.${celebrity.birthDay.month}.${celebrity.birthDay.year}"),
              (celebrity.died != null)
                  ? SizedBox(
                      width: 100,
                      child: Text(
                        "Died ${celebrity.died!.day}.${celebrity.died!.month}.${celebrity.died!.year} (Age: ${celebrity.died!.year - celebrity.birthDay.year} )",
                      ),
                    )
                  : Text(
                      "Age: ${DateTime.now().year - celebrity.birthDay.year}"),
            ],
          ),
        ],
      ),
    );
  }
}
