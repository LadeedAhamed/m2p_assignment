import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/repositories/itunes_repo.dart';

import 'music_video_state.dart';
part 'music_video_event.dart';

class MusicVideoBloc extends Bloc<MusicVideoEvent, MusicVideoState> {
  final ITunesServiceRepository repository;
  List<MusicVideo> allMusicVideos = []; // Store all music videos

  MusicVideoBloc({required this.repository}) : super(MusicVideoInitial()) {
    on<SearchMusicVideos>((event, emit) async {
      await _mapSearchMusicVideosToState(event, emit);
    });
  }

  Future<void> _mapSearchMusicVideosToState(
    SearchMusicVideos event,
    Emitter<MusicVideoState> emit,
  ) async {
    try {
      emit(MusicVideoLoading());

      // Fetch music videos from the repository
      MusicModel musicVideos =
          await repository.searchMusicData(event.query, event.entity);

      // Log the received music videos count
      if (kDebugMode) {
        print('Received music videos: ${musicVideos.musics.length}');
      }

      // Directly assign musicVideos.musics to filteredVideos
      List<MusicVideo> filteredVideos = musicVideos.musics;

      // Emit the state with filtered videos
      emit(MusicVideoSearchLoaded(filteredVideos));
    } catch (e) {
      // Handle any errors
      emit(MusicVideoError('Failed to search music videos: $e'));
    }
  }
}
