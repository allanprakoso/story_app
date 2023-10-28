import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/models/story.dart';
import 'package:story_app/models/story_list_response.dart';

class StoryService {
  final String baseUrlString = 'https://story-api.dicoding.dev/v1';
  final String addStoryEndpoint = '/stories';

  Future<bool> addStory({
    required String token,
    required String description,
    required File photoPath,
    num? lat,
    num? lon,
  }) async {
    final url = Uri.parse('$baseUrlString$addStoryEndpoint');

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;

    // Tambahkan lat dan lon jika disediakan
    if (lat != null) {
      request.fields['lat'] = lat.toString();
    }
    if (lon != null) {
      request.fields['lon'] = lon.toString();
    }

    // Tambahkan foto ke request
    request.files.add(http.MultipartFile(
      'photo',
      photoPath.readAsBytes().asStream(),
      photoPath.lengthSync(),
      filename: photoPath.path.split('/').last,
    ));

    print(request.fields);
    // Kirim request dan tangani respons
    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);
      if (!responseData['error']) {
        return true;
      }
    }
    return false;
  }

  Future<Story> getStoryById(
      {required String id, required String token}) async {
    final endpoint = Uri.parse('$baseUrlString/stories/$id');

    final response = await http.get(
      endpoint,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Story.fromJson(responseData['story']);
    } else {
      throw Exception("Failed to load story detail");
    }
  }

  Future<StoryListResponse> getStories({
    int? page,
    int? size,
    int location = 1,
    required String token,
  }) async {
    final Uri baseUrl = Uri.parse(baseUrlString);
    final endpoint = Uri(
      scheme: baseUrl.scheme,
      host: baseUrl.host,
      path: '${baseUrl.path}/stories',
      queryParameters: {
        if (page != null) 'page': page.toString(),
        if (size != null) 'size': size.toString(),
        'location': location.toString(),
      },
    );

    final response = await http.get(
      endpoint,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StoryListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load stories");
    }
  }
}
