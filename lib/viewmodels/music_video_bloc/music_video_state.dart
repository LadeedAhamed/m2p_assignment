part of 'music_video_bloc.dart';

// Define states for the BLoC
abstract class MusicVideoState {}

class MusicVideoInitial extends MusicVideoState {}

class MusicVideoLoading extends MusicVideoState {}

class MusicVideoLoaded extends MusicVideoState {
  final MusicModel musicVideos;

  // Optionally define filteredMusicVideos property here
  List<MusicVideo> get filteredMusicVideos => musicVideos.musics;

  MusicVideoLoaded(this.musicVideos);
}

class MusicVideoError extends MusicVideoState {
  final String errorMessage;

  MusicVideoError(this.errorMessage);
}

class MusicVideoSearchLoaded extends MusicVideoState {
  final List<MusicVideo> filteredMusicVideos;

  MusicVideoSearchLoaded(this.filteredMusicVideos);

  List<Object?> get props => [filteredMusicVideos];
}
