import 'package:flutter/material.dart';
import 'package:iTunes/constants/app_constants.dart';
import 'package:iTunes/models/music_video.dart';
import 'package:iTunes/views/components/music_videoplay_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicVideoDetailsScreen extends StatelessWidget {
  final MusicVideo musicVideo;

  const MusicVideoDetailsScreen({required this.musicVideo, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ITunesAppConstants.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
        title: const Text('Description', style: ITunesAppConstants.titleStyle),
        backgroundColor: ITunesAppConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    height: 200,
                    width: 150,
                    musicVideo.artworkUrl60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          musicVideo.trackName,
                          style: ITunesAppConstants.subtitleStyle
                              .copyWith(fontSize: 16.0, color: Colors.white),
                        ),
                        const SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse(musicVideo.artistViewUrl));
                          },
                          child: Text(
                            'Artist: ${musicVideo.artistName}',
                            style: ITunesAppConstants.subtitleStyle
                                .copyWith(fontSize: 18.0, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        if (musicVideo.collectionName.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              launchUrl(
                                  Uri.parse(musicVideo.collectionViewUrl));
                            },
                            child: Text(
                              'Collection: ${musicVideo.collectionName}',
                              style: ITunesAppConstants.subtitleStyle
                                  .copyWith(fontSize: 18.0, color: Colors.blue),
                              maxLines:
                                  null, // Allow the text to wrap to the next line if needed
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Genre: ${musicVideo.primaryGenreName}',
                          style: ITunesAppConstants.subtitleStyle
                              .copyWith(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Text(
                'Preview',
                style:
                    ITunesAppConstants.subtitleStyle.copyWith(fontSize: 16.0),
              ),
              const SizedBox(height: 18.0),
              VideoPlayerScreen(
                videoUrl: musicVideo.previewUrl,
              ),
              const SizedBox(height: 18.0),
              if (musicVideo.longDescription.isNotEmpty)
                Text(
                  'Description: ${musicVideo.longDescription}',
                  style:
                      ITunesAppConstants.subtitleStyle.copyWith(fontSize: 14.0),
                ),
              const SizedBox(height: 18.0),
              Text(
                'Release Date: ${musicVideo.releaseDate}',
                style:
                    ITunesAppConstants.subtitleStyle.copyWith(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
