import 'package:flutter/material.dart';
import 'package:story_app/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);
  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();
    await authRepository.login(email: email, password: password);
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> register(String name, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();
    final register = await authRepository.register(
      name: name,
      email: email,
      password: password,
    );
    isLoadingRegister = false;
    notifyListeners();
    return register;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    await authRepository.logout();
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }
}
