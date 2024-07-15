import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iTunes/constants/app_constants.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/viewmodels/music_video_bloc/music_video_bloc.dart';
import 'package:iTunes/viewmodels/music_video_bloc/music_video_state.dart';
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
  String _selectedEntity = 'all';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {}

  void _onSearchSubmitted() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      if (_selectedEntity == 'all') {
        // Call API without specifying entity
        context.read<MusicVideoBloc>().add(SearchMusicVideos(query: query));
      } else {
        // Call API with entity
        context
            .read<MusicVideoBloc>()
            .add(SearchMusicVideos(query: query, entity: _selectedEntity));
      }
    }
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
          _buildEntitySelection(),
          _buildViewModeToggle(),
          Expanded(
            child: BlocBuilder<MusicVideoBloc, MusicVideoState>(
              builder: (context, state) {
                print('Current state: $state');
                if (state is MusicVideoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MusicVideoSearchLoaded) {
                  print(
                      'Filtered videos count: ${state.filteredMusicVideos.length}');
                  return _viewMode == ViewMode.grid
                      ? _buildGridView(state.filteredMusicVideos)
                      : _buildListView(state.filteredMusicVideos);
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
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: ITunesAppConstants.subtitleStyle,
                hintText: 'Search music...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchSubmitted,
          ),
        ],
      ),
    );
  }

  Widget _buildEntitySelection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEntityButton('all'),
            _buildEntityButton('musicVideo'),
            _buildEntityButton('song'),
            _buildEntityButton('album'),
            _buildEntityButton('movieArtist'),
            _buildEntityButton('ebook'),
            _buildEntityButton('podcast'),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityButton(String entity) {
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
        backgroundColor: WidgetStateProperty.all<Color>(
          _selectedEntity == entity ? Colors.white12 : Colors.transparent,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: _selectedEntity == entity
                  ? Colors.white12
                  : Colors.transparent,
            ),
          ),
        ),
      ),
      child: Text(
        entity,
        style: ITunesAppConstants.subtitleStyle.copyWith(
          color: _selectedEntity == entity ? Colors.green : Colors.grey,
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedEntity = entity;
        });
      },
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

  Widget _buildGridView(List<MusicVideo> musicVideos) {
    print('Building grid view with ${musicVideos.length} videos');
    Map<String, List<MusicVideo>> groupedVideos =
        _groupMusicVideosByKind(musicVideos);
    return ListView(
      children: groupedVideos.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.key.isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.amberAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Text(entry.key, style: ITunesAppConstants.titleStyle),
              ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entry.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                MusicVideo musicVideo = entry.value[index];
                return _buildMusicCard(musicVideo);
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildListView(List<MusicVideo> musicVideos) {
    print('Building list view with ${musicVideos.length} videos');
    Map<String, List<MusicVideo>> groupedVideos =
        _groupMusicVideosByKind(musicVideos);
    return ListView(
      children: groupedVideos.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.key.isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.amberAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Text(entry.key, style: ITunesAppConstants.titleStyle),
              ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entry.value.length,
              itemBuilder: (context, index) {
                MusicVideo musicVideo = entry.value[index];
                return _buildMusicListTile(musicVideo);
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, List<MusicVideo>> _groupMusicVideosByKind(
      List<MusicVideo> musicVideos) {
    Map<String, List<MusicVideo>> groupedVideos = {};
    for (var musicVideo in musicVideos) {
      if (!groupedVideos.containsKey(musicVideo.kind)) {
        groupedVideos[musicVideo.kind] = [];
      }
      groupedVideos[musicVideo.kind]!.add(musicVideo);
    }
    return groupedVideos;
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
        musicVideo.artworkUrl60,
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
