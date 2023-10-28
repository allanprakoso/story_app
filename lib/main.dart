import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/map_provider.dart';
import 'package:story_app/repository/auth_repository.dart';
import 'package:story_app/repository/story_repository.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/page_manager.dart';
import 'package:story_app/routes/route_delegate.dart';

void main() {
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  late StoryListProvider storyListProvider;
  late AddStoryProvider addStoryProvider;
  late StoryDetailProvider storyDetailProvider;
  late MapProvider mapProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    final storyRepository = StoryRepository();

    authProvider = AuthProvider(authRepository);
    storyListProvider = StoryListProvider(storyRepository);
    addStoryProvider = AddStoryProvider(storyRepository);
    storyDetailProvider = StoryDetailProvider(storyRepository);
    mapProvider = MapProvider();

    myRouterDelegate = MyRouterDelegate(authRepository, storyRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PageManager>(
            create: (context) => PageManager(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => authProvider,
          ),
          ChangeNotifierProvider<StoryListProvider>(
            create: (context) => storyListProvider,
          ),
          ChangeNotifierProvider<AddStoryProvider>(
            create: (context) => addStoryProvider,
          ),
          ChangeNotifierProvider<StoryDetailProvider>(
            create: (context) => storyDetailProvider,
          ),
          ChangeNotifierProvider<MapProvider>(
            create: (context) => mapProvider,
          ),
        ],
        builder: (context, child) {
          return MaterialApp(
              title: 'Story App',
              home: Router(
                routerDelegate: myRouterDelegate,
                backButtonDispatcher: RootBackButtonDispatcher(),
              ));
        });
  }
}
