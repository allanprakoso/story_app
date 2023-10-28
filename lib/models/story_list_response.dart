import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/models/story.dart';

part 'story_list_response.g.dart';

@JsonSerializable()
class StoryListResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryListResponseFromJson(json);
}
