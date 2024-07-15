import 'dart:convert';

import 'package:iTunes/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:iTunes/models/music_video.dart';

class ITunesService {
  final Dio _dio = Dio();

  ITunesService() {
    // Initialize Dio instance
    _dio.interceptors.add(
        LogInterceptor(responseBody: true)); // Optional: For logging responses
  }

  Future<MusicModel> searchMusicData(String query, String? entity) async {
    try {
      String apiUrl = "${ITunesAppConstants.baseUrl}?term=$query";
      if (entity != null && entity.isNotEmpty) {
        apiUrl += "&entity=$entity";
      }

      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.data);
        return MusicModel.fromJson(data);
      } else {
        throw Exception('Failed to load music data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search music data: $e');
    }
  }
}
