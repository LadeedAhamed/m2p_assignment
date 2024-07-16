import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class SecurityCheckScreen extends StatefulWidget {
  const SecurityCheckScreen({super.key});

  @override
  SecurityCheckScreenState createState() => SecurityCheckScreenState();
}

class SecurityCheckScreenState extends State<SecurityCheckScreen> {
  bool _isJailbroken = false;
  bool _isDeveloperMode = false;

  @override
  void initState() {
    super.initState();
    _checkRootStatus();
  }

  Future<void> _checkRootStatus() async {
    bool jailbroken = await FlutterJailbreakDetection.jailbroken;
    bool developerMode = await FlutterJailbreakDetection.developerMode;

    if (!mounted) return;

    setState(() {
      _isJailbroken = jailbroken;
      _isDeveloperMode = developerMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Jailbroken: $_isJailbroken'),
            Text('Developer Mode: $_isDeveloperMode'),
          ],
        ),
      ),
    );
  }
}
