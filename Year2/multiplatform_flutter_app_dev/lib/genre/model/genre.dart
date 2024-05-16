import 'package:json_annotation/json_annotation.dart';
import 'package:movie_catalog/common/model/serializable.dart';

part 'genre.g.dart';

@JsonSerializable()
class Genre extends Serializable {
  final String name;
  final String? id;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenreToJson(this);

  Genre({required this.name, required this.id});
}
