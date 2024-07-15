part of 'music_video_bloc.dart';

abstract class MusicVideoEvent {}

class SearchMusicVideos extends MusicVideoEvent {
  final String query;
  final String? entity;

  SearchMusicVideos({required this.query, this.entity});
}
