// Define states for the BLoC
import 'package:iTunes/models/music_video.dart';

abstract class MusicVideoState {}

class MusicVideoInitial extends MusicVideoState {}

class MusicVideoLoading extends MusicVideoState {}

class MusicVideoError extends MusicVideoState {
  final String errorMessage;

  MusicVideoError(this.errorMessage);
}

class MusicVideoSearchLoaded extends MusicVideoState {
  final List<MusicVideo> filteredMusicVideos;

  MusicVideoSearchLoaded(this.filteredMusicVideos);

  List<Object?> get props => [filteredMusicVideos];
}
