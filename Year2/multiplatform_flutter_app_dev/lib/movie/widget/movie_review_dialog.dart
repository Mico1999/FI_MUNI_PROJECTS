import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/review/model/review.dart';
import 'package:movie_catalog/review/model/review_status.dart';
import 'package:movie_catalog/review/service/review_service.dart';
import 'package:tuple/tuple.dart';

class MovieReviewDialog extends StatefulWidget {
  final _reviewService = GetIt.I.get<ReviewService>();
  final Movie movie;

  MovieReviewDialog({super.key, required this.movie});

  @override
  State<MovieReviewDialog> createState() => _MovieReviewDialog();
}

class _MovieReviewDialog extends State<MovieReviewDialog> {
  final _movieReviewController = TextEditingController();
  Review? _review;
  double _rating = 0.0;
  String _comment = "";

  @override
  void initState() {
    super.initState();
    _getUserReview(FirebaseAuth.instance.currentUser!);
  }

  Widget _buildStars() {
    final stars = <InkWell>[];

    for (var starIdx = 1; starIdx <= 5; starIdx++) {
      final star = Icon(
        Icons.star,
        color: _rating >= starIdx ? Colors.deepOrange : Colors.grey,
      );

      stars.add(InkWell(
        onTap: () {
          setState(() {
            if (starIdx == 1 && _rating == 1) {
              _rating = 0.0;
            } else {
              _rating = starIdx.toDouble();
            }
          });
        },
        child: star,
      ));
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Center(
        child: _review == null
            ? const Text('Add your review')
            : const Text('Update your review'),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              _buildStars(),
              const SizedBox(
                height: 50.0,
              ),
              Expanded(
                child: TextField(
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: "Your comments and feelings"),
                  controller: _movieReviewController,
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        _review != null
            ? ElevatedButton(
                onPressed: () async {
                  await _deleteUserReview(FirebaseAuth.instance.currentUser!);
                  if (context.mounted) {
                    Navigator.of(context).pop(Tuple4(
                        _rating, _comment, ReviewStatus.deleted, _review));
                  }
                },
                child: const Text('Delete'),
              )
            : const SizedBox(
                width: 0.2,
              ),
        ElevatedButton(
          onPressed: _comment.isNotEmpty
              ? () {
                  if (_review == null) {
                    Navigator.of(context).pop(Tuple4(
                        _rating, _comment, ReviewStatus.created, _review));
                  } else {
                    Navigator.of(context).pop(Tuple4(
                        _rating, _comment, ReviewStatus.updated, _review));
                  }
                }
              : null,
          child: const Text('Save'),
        )
      ],
    );
  }

  void _getUserReview(User user) {
    widget._reviewService
        .getUserReview(user.email!, widget.movie.id!)
        .then((value) {
      if (value != null) {
        setState(() {
          _rating = value.rating;
          _comment = value.text;
          _movieReviewController.text = value.text;
          _review = value;
        });
      }
    });
  }

  Future<void> _deleteUserReview(User user) async {
    await widget._reviewService.delete(_review!.id!);
  }
}
