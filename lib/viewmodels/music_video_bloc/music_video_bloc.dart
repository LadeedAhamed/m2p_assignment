import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/repositories/itunes_repo.dart';

part 'music_video_event.dart';
part 'music_video_state.dart';

class MusicVideoBloc extends Bloc<MusicVideoEvent, MusicVideoState> {
  final ITunesServiceRepository repository;
  List<MusicVideo> allMusicVideos = []; // Store all music videos

  MusicVideoBloc({required this.repository}) : super(MusicVideoInitial()) {
    on<FetchMusicVideos>((event, emit) async {
      await _mapFetchMusicVideosToState(event, emit);
    });

    on<SearchMusicVideos>((event, emit) async {
      await _mapSearchMusicVideosToState(event.query, emit);
    });
  }

  Future<void> _mapFetchMusicVideosToState(
    FetchMusicVideos event,
    Emitter<MusicVideoState> emit,
  ) async {
    try {
      emit(MusicVideoLoading());
      MusicModel musicVideos = await repository.fetchMusicVideos();
      allMusicVideos =
          musicVideos.musics; // Update allMusicVideos with fetched data
      emit(MusicVideoLoaded(musicVideos));
    } catch (e) {
      emit(MusicVideoError('Failed to load music videos'));
    }
  }

  Future<void> _mapSearchMusicVideosToState(
    String query,
    Emitter<MusicVideoState> emit,
  ) async {
    try {
      if (query.isEmpty) {
        emit(MusicVideoLoaded(MusicModel(
            musics: allMusicVideos, resultCount: allMusicVideos.length)));
      } else {
        List<MusicVideo> filteredVideos = allMusicVideos
            .where((musicVideo) =>
                musicVideo.trackName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                musicVideo.artistName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        emit(MusicVideoSearchLoaded(filteredVideos));
      }
    } catch (e) {
      emit(MusicVideoError('Failed to search music videos'));
    }
  }
}
