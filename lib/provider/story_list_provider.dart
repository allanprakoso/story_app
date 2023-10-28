import 'package:flutter/widgets.dart';
import 'package:story_app/repository/story_repository.dart';
import 'package:story_app/models/story.dart';

class StoryListProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  StoryListProvider(this.storyRepository);

  bool isLoadingStories = false;
  bool isStoriesLoaded = false;
  List<Story> listStories = [];
  int? page = 1;
  int size = 10;

  Future<bool> getStories({bool? isInitial}) async {
    if (isInitial != null && isInitial) {
      isLoadingStories = true;
      page = 1;
      listStories = [];
      notifyListeners();
    }

    final stories = await storyRepository.getStories(page: page, size: size);

    isLoadingStories = false;
    isStoriesLoaded = true;

    if (!stories.error) {
      listStories.addAll(stories.listStory);
      if (stories.listStory.length < size) {
        page = null;
      } else {
        page = page! + 1;
      }
      print("listStories: ${listStories.length} , page: " + page.toString());
      notifyListeners();
      return true;
    }
    return false;
  }
}
