import 'package:json_annotation/json_annotation.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/common/model/serializable.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends Serializable {
  final String title;
  final DateTime year;
  final String preview;
  final String storyLine;
  final List<String>? genreIds;
  final String bannerImage;
  final String posterImage;
  final List<Map<String, Role>>? celebrityIdsWithRole;
  final String? id;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieToJson(this);
  Movie({
    required this.title,
    required this.year,
    required this.preview,
    required this.storyLine,
    required this.genreIds,
    required this.bannerImage,
    required this.posterImage,
    required this.celebrityIdsWithRole,
    required this.id,
  });
}
