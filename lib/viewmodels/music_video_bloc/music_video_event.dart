part of 'music_video_bloc.dart';

abstract class MusicVideoEvent {}

class FetchMusicVideos extends MusicVideoEvent {}

class SearchMusicVideos extends MusicVideoEvent {
  final String query;

  SearchMusicVideos({required this.query});
}
