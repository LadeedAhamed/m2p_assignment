import 'package:flutter/material.dart';
import 'package:iTunes/constants/app_constants.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/views/details_screen.dart';

class MusicVideoListView extends StatelessWidget {
  final List<MusicVideo> musicVideos;

  const MusicVideoListView({super.key, required this.musicVideos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: musicVideos.length,
      itemBuilder: (context, index) {
        MusicVideo musicVideo = musicVideos[index];
        return ListTile(
          leading: Image.network(
            musicVideo
                .artworkUrl30, // Example: Use appropriate image URL field from MusicVideo model
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          title: Text(
            musicVideo.trackName,
            style:
                ITunesAppConstants.subtitleStyle.copyWith(color: Colors.white),
          ),
          subtitle: Text(
            musicVideo.artistName,
            style: ITunesAppConstants.subtitleStyle,
          ),
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
      },
    );
  }
}
