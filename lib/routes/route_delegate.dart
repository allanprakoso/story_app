import 'package:flutter/material.dart';
import 'package:story_app/repository/auth_repository.dart';
import 'package:story_app/repository/story_repository.dart';
import 'package:story_app/pages/add_story_page.dart';
import 'package:story_app/pages/login_page.dart';
import 'package:story_app/pages/register_page.dart';
import 'package:story_app/pages/splash_page.dart';
import 'package:story_app/pages/story_detail_page.dart';
import 'package:story_app/pages/storylist_page.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  final StoryRepository storyRepository;

  MyRouterDelegate(this.authRepository, this.storyRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  String? storyId;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddStory = false;

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashPage(),
        ),
      ];
  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginPage(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterPage(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];
  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: StoryListPage(
            onLogin: () {
              isLoggedIn = false;
              notifyListeners();
            },
            onLogoutSuccess: () {
              isLoggedIn = false;
              notifyListeners();
            },
            onAddStoryClicked: () {
              isAddStory = true;
              notifyListeners();
            },
            onStoryClicked: (id) {
              storyId = id;
              notifyListeners();
            },
          ),
        ),
        if (isAddStory)
          MaterialPage(
            key: ValueKey("AddStoryPage"),
            child: AddStoryPage(
              onSuccessAddStory: () {
                isAddStory = false;
                notifyListeners();
              },
            ),
          ),
        if (storyId != null)
          MaterialPage(
            key: ValueKey(storyId),
            child: StoryDetailsPage(
              storyId: storyId!,
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        isRegister = false;
        isAddStory = false;
        storyId = null;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
