import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:iTunes/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isJailbroken = await FlutterJailbreakDetection.jailbroken;
  if (isJailbroken) {
    runApp(const RootDetectedApp());
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ITunes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class RootDetectedApp extends StatelessWidget {
  const RootDetectedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Security Alert',
      home: Scaffold(
        appBar: AppBar(title: const Text('Security Alert')),
        body: const Center(
          child: Text(
              'This device is rooted/jailbroken. The app cannot run on this device.'),
        ),
      ),
    );
  }
}
