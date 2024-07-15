import 'package:flutter/foundation.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/repositories/itunes_repo_ab.dart';
import 'package:iTunes/services/itunes_services.dart';

class ITunesServiceRepository implements ITunesServiceRepositoryAB {
  final ITunesService service;

  ITunesServiceRepository({required this.service});

  @override
  Future<MusicModel> searchMusicData(String query, String? entity) async {
    try {
      // Fetch data from service
      MusicModel responseData = await service.searchMusicData(query, entity);
      return responseData;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching music videos: $e');
      }
      // Handle exceptions or errors
      rethrow; // Optionally handle error logging or rethrow for UI to handle
    }
  }
}
