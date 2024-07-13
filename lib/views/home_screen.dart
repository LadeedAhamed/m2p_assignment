import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iTunes/constants/app_constants.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/viewmodels/music_video_bloc/music_video_bloc.dart';
import 'package:iTunes/views/components/music_video_listview.dart';
import 'package:iTunes/views/details_screen.dart';

enum ViewMode { grid, list }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  ViewMode _viewMode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    // Trigger FetchMusicVideos event
    context.read<MusicVideoBloc>().add(FetchMusicVideos());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<MusicVideo>> groupMusicVideosByArtist(
      List<MusicVideo> musicVideos) {
    Map<String, List<MusicVideo>> groupedMusicVideos = {};
    for (var musicVideo in musicVideos) {
      if (!groupedMusicVideos.containsKey(musicVideo.artistName)) {
        groupedMusicVideos[musicVideo.artistName] = [];
      }
      groupedMusicVideos[musicVideo.artistName]!.add(musicVideo);
    }
    return groupedMusicVideos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ITunesAppConstants.primaryColor,
      appBar: AppBar(
        title: const Text('iTunes', style: ITunesAppConstants.titleStyle),
        backgroundColor: ITunesAppConstants.primaryColor,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildViewModeToggle(),
          Expanded(
            child: BlocBuilder<MusicVideoBloc, MusicVideoState>(
              builder: (context, state) {
                if (state is MusicVideoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MusicVideoLoaded) {
                  var groupedMusicVideos =
                      groupMusicVideosByArtist(state.musicVideos.musics);
                  return ListView(
                    children: groupedMusicVideos.entries.map((entry) {
                      return _buildArtistSection(entry.key, entry.value);
                    }).toList(),
                  );
                } else if (state is MusicVideoSearchLoaded) {
                  return MusicVideoListView(
                      musicVideos: state.filteredMusicVideos);
                } else if (state is MusicVideoError) {
                  return Center(child: Text(state.errorMessage));
                } else {
                  return const Center(child: Text('No music videos loaded.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        onChanged: (query) {
          context
              .read<MusicVideoBloc>()
              .add(SearchMusicVideos(query: query)); // Trigger search event
        },
        decoration: InputDecoration(
          hintStyle: ITunesAppConstants.subtitleStyle,
          hintText: 'Search music...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeToggle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
              backgroundColor: WidgetStateProperty.all<Color>(
                _viewMode == ViewMode.grid
                    ? Colors.white12
                    : Colors.transparent,
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color:
                        _viewMode == ViewMode.grid ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            child: Text(
              'Grid Layout',
              style: ITunesAppConstants.subtitleStyle.copyWith(
                color: _viewMode == ViewMode.grid ? Colors.blue : Colors.grey,
              ),
            ),
            onPressed: () {
              setState(() {
                _viewMode = ViewMode.grid;
              });
            },
          ),
          const SizedBox(width: 16.0),
          TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
              backgroundColor: WidgetStateProperty.all<Color>(
                _viewMode == ViewMode.list
                    ? Colors.white12
                    : Colors.transparent,
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color:
                        _viewMode == ViewMode.list ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            child: Text(
              'List Layout',
              style: ITunesAppConstants.subtitleStyle.copyWith(
                color: _viewMode == ViewMode.list ? Colors.blue : Colors.grey,
              ),
            ),
            onPressed: () {
              setState(() {
                _viewMode = ViewMode.list;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArtistSection(String artistName, List<MusicVideo> musicVideos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            artistName,
            style: ITunesAppConstants.subtitleStyle
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _viewMode == ViewMode.grid
            ? GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: musicVideos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  MusicVideo musicVideo = musicVideos[index];
                  return _buildMusicCard(musicVideo);
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: musicVideos.length,
                itemBuilder: (context, index) {
                  MusicVideo musicVideo = musicVideos[index];
                  return _buildMusicListTile(musicVideo);
                },
              ),
      ],
    );
  }

  Widget _buildMusicCard(MusicVideo musicVideo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MusicVideoDetailsScreen(musicVideo: musicVideo),
          ),
        );
      },
      child: Card(
        color: ITunesAppConstants.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                musicVideo.artworkUrl60,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                musicVideo.trackName,
                style: ITunesAppConstants.subtitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                musicVideo.artistName,
                style: ITunesAppConstants.subtitleStyle.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicListTile(MusicVideo musicVideo) {
    return ListTile(
      leading: Image.network(
        musicVideo.artworkUrl30,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
      title: Text(
        musicVideo.trackName,
        style: ITunesAppConstants.subtitleStyle,
      ),
      subtitle: Text(musicVideo.artistName),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MusicVideoDetailsScreen(musicVideo: musicVideo),
          ),
        );
      },
    );
  }
}
