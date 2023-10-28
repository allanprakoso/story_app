import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/repository/story_repository.dart';

class AddStoryProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  AddStoryProvider(this.storyRepository);

  bool isLoadingAdd = false;
  bool isAdded = false;

  Future<bool> addStory(
      {required String description,
      required File imagePath,
      num? lat,
      num? lon}) async {
    isLoadingAdd = true;
    notifyListeners();
    isAdded = await storyRepository.addStory(
      description: description,
      photoPath: imagePath,
      lat: lat,
      lon: lon,
    );
    isLoadingAdd = false;
    notifyListeners();
    return isAdded;
  }
}
