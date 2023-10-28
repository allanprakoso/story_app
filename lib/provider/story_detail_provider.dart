import 'package:flutter/material.dart';
import 'package:story_app/repository/story_repository.dart';
import 'package:story_app/models/story.dart';

class StoryDetailProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  StoryDetailProvider(this.storyRepository);
  Story? story;

  bool isLoadingDetail = false;
  bool isLoaded = false;
  Future<void> getStories(String storyId) async {
    isLoadingDetail = true;
    story = await storyRepository.getStory(storyId);
    isLoaded = true;
    isLoadingDetail = false;
    notifyListeners();
  }

  void resetValues() {
    isLoadingDetail = false;
    isLoaded = false;
  }
}
