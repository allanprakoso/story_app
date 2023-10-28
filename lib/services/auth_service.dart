import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_app/models/user.dart';

class AuthService {
  final String baseUrl =
      'https://story-api.dicoding.dev/v1'; // gantilah dengan domain dari API Anda

  // Fungsi untuk mendaftar
  Future<bool> register(
      {required String name,
      required String email,
      required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (!responseData['error']) {
      return true;
    }
    return false;
  }

  // Fungsi untuk login
  Future<User?> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (!responseData['error']) {
        return User.fromJson(responseData['loginResult']);
      }
    }

    return null;
  }
}
