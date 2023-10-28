import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final num? lat;
  final num? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(json) => _$StoryFromJson(json);
}
