import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/services/auth_service.dart';

class AuthRepository {
  final String tokenKey = "authToken";

  final AuthService authService = new AuthService();

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final token = preferences.getString(tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<bool> login({required String email, required String password}) async {
    final preferences = await SharedPreferences.getInstance();
    final user = await authService.login(email: email, password: password);
    if (user != null) {
      return preferences.setString(tokenKey, user.token);
    } else {
      return false;
    }
  }

  Future<bool> register(
      {required String name,
      required String email,
      required String password}) async {
    return await authService.register(
        name: name, email: email, password: password);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(tokenKey);
  }

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) ?? "";
  }
}
