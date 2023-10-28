import 'dart:io';

import 'package:story_app/repository/auth_repository.dart';
import 'package:story_app/models/story.dart';
import 'package:story_app/models/story_list_response.dart';
import 'package:story_app/services/story_service.dart';

class StoryRepository {
  final StoryService storyService = new StoryService();
  final AuthRepository authRepository = new AuthRepository();

  Future<StoryListResponse> getStories({int? page, int? size}) async {
    final token = await authRepository.getToken();
    return await storyService.getStories(token: token, page: page, size: size);
  }

  Future<bool> addStory(
      {required String description,
      required File photoPath,
      num? lat,
      num? lon}) async {
    final token = await authRepository.getToken();
    return await storyService.addStory(
        token: token,
        description: description,
        photoPath: photoPath,
        lat: lat,
        lon: lon);
  }

  Future<Story> getStory(String storyId) async {
    final token = await authRepository.getToken();
    return storyService.getStoryById(id: storyId, token: token);
  }
}
