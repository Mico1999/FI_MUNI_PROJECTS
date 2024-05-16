import 'package:json_annotation/json_annotation.dart';
import 'package:movie_catalog/common/model/serializable.dart';

part 'review.g.dart';

@JsonSerializable()
class Review extends Serializable {
  final String text;
  final DateTime date;
  final double rating;
  final String? movieId;
  final String userEmail;
  final String? id;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  Review(
      {required this.text,
      required this.date,
      required this.rating,
      required this.movieId,
      required this.userEmail,
      required this.id});

  Review copyWith(
      {String? text,
      DateTime? date,
      double? rating,
      String? movieId,
      String? userEmail,
      String? id}) {
    return Review(
        text: text ?? this.text,
        date: date ?? this.date,
        rating: rating ?? this.rating,
        movieId: movieId ?? this.movieId,
        userEmail: userEmail ?? this.userEmail,
        id: id ?? this.id);
  }
}
