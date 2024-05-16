// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      rating: (json['rating'] as num).toDouble(),
      movieId: json['movieId'] as String?,
      userEmail: json['userEmail'] as String,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'text': instance.text,
      'date': instance.date.toIso8601String(),
      'rating': instance.rating,
      'movieId': instance.movieId,
      'userEmail': instance.userEmail,
      'id': instance.id,
    };
