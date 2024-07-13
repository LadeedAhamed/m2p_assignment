import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iTunes/constants/app_constants.dart';
import 'package:iTunes/models/music_video.dart';

class ITunesService {
  final Dio _dio = Dio();

  ITunesService() {
    // Initialize Dio instance
    _dio.interceptors.add(
        LogInterceptor(responseBody: true)); // Optional: For logging responses
  }

  Future<MusicModel> fetchMusicData() async {
    try {
      const String apiUrl = ITunesAppConstants.baseUrl;

      // Make GET request
      final response = await _dio.get(apiUrl);

      // Check if response is successful
      if (response.statusCode == 200) {
        // Decode JSON response
        final Map<String, dynamic> data = jsonDecode(response.data);
        return MusicModel.fromJson(data);
      } else {
        throw Exception('Failed to load music data');
      }
    } catch (e) {
      throw Exception('Failed to load music data: $e');
    }
  }
}
