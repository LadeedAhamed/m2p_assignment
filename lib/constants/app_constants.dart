import 'package:flutter/material.dart';

class ITunesAppConstants {
  //Assets
  static const String splashIcon = 'assets/images/ITunes_logo.svg';
  static const String homeIcon = 'assets/images/apple-itunes.svg';

  // API Endpoints
  static const String baseUrl =
      "https://itunes.apple.com/search?term=jackjohnson&entity=musicVideo";

  // Colors
  static const Color primaryColor = Colors.black;

  // Dimensions
  static const double padding = 16.0;
  static const double imageSize = 200.0;

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.white54,
  );

  static const TextStyle headerStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  // Other constants
  static const Duration splashScreenDuration = Duration(seconds: 3);
}
