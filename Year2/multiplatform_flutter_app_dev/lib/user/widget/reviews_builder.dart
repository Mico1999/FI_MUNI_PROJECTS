import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';
import 'package:movie_catalog/user/widget/review_list_tile.dart';

class ReviewsBuilder extends StatelessWidget {
  final _appUserService = GetIt.I.get<AppUserService>();
  ReviewsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: _appUserService.getReviews(user.email!),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final reviews = snapshot.data!;
          if (reviews.isEmpty) {
            return const Card(
              elevation: 10,
              color: Colors.white70,
              child: Text("You have no reviews yet"),
            );
          } else {
            return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final review = reviews[index];
                  return ReviewListTile(review: review);
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: reviews.length);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
