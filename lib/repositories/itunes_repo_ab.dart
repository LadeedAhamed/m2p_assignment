import 'package:iTunes/models/music_video.dart';

abstract class ITunesServiceRepositoryAB {
  Future<MusicModel> searchMusicData(String query, String entities);
}
