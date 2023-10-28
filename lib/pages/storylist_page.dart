import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/widget/story_card.dart';

class StoryListPage extends StatefulWidget {
  final VoidCallback onLogoutSuccess;
  final Function(String?) onStoryClicked;
  final VoidCallback onAddStoryClicked;
  final Function onLogin;
  const StoryListPage(
      {super.key,
      required this.onLogin,
      required this.onLogoutSuccess,
      required this.onStoryClicked,
      required this.onAddStoryClicked});

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storyListProvider = context.read<StoryListProvider>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyListProvider.page != null) {
          EasyDebounce.debounce(
              'my-debouncer',
              const Duration(milliseconds: 300),
              () => _getStoryList(isInitial: false));
        }
      }
    });
    Future.microtask(() async => _getStoryList(isInitial: true));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _getStoryList({bool? isInitial}) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<StoryListProvider>().getStories(isInitial: isInitial);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Story App"),
          actions: [
            IconButton(
              onPressed: () async {
                final result = await context.read<AuthProvider>().logout();
                if (result) {
                  widget.onLogoutSuccess();
                }
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onAddStoryClicked,
          child: const Icon(Icons.add),
        ),
        body: Consumer<StoryListProvider>(
          builder: (context, value, child) {
            if (value.isLoadingStories) {
              return const Center(child: CircularProgressIndicator());
            }
            if (value.isStoriesLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  _getStoryList(isInitial: true);
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: value.listStories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == value.listStories.length &&
                        value.page != null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final story = value.listStories[index];
                    return GestureDetector(
                      onTap: () {
                        widget.onStoryClicked(story.id);
                      },
                      child:
                          StoryCard(imageUrl: story.photoUrl, name: story.name),
                    );
                  },
                ),
              );
            }
            return Text("tidak dapat menampilkan data");
          },
        ));
  }
}
