import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iTunes/constants/app_constants.dart';
import 'package:iTunes/repositories/itunes_repo.dart';
import 'package:iTunes/services/itunes_services.dart';
import 'package:iTunes/viewmodels/music_video_bloc/music_video_bloc.dart';
import 'package:iTunes/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Simulate some initialization tasks
    await Future.delayed(ITunesAppConstants.splashScreenDuration, () {});

    // Navigate to the HomeScreen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => MusicVideoBloc(
                      repository:
                          ITunesServiceRepository(service: ITunesService())),
                  child: const HomeScreen(),
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ITunesAppConstants.primaryColor,
      body: Center(
        child: SvgPicture.asset(
          height: ITunesAppConstants.imageSize,
          width: ITunesAppConstants.imageSize,
          ITunesAppConstants.splashIcon,
        ),
      ),
    );
  }
}
