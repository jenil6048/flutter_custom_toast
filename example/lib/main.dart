import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:custom_flutter_toast/export.dart';
import 'package:flutter/services.dart';

/// The navigator key to be used throughout the app.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: flutterToastBuilder(), // Use the custom toast builder
      navigatorKey: navigatorKey, // Set the navigator key
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nativeToastPlugin = NativeToast();
  final _flutterToast = FlutterToast();

  @override
  void initState() {
    super.initState();
    // Initialize platform state if needed.
    // Uncomment if using _untitled7Plugin to show toast
    // initPlatformState();
  }

  Future<void> showToastMessage(String message,
      {bool useNativeToast = false, bool withImage = false}) async {
    try {
      if (useNativeToast) {
        await _nativeToastPlugin.showToast(
          message: message,
          backgroundColor: Colors.red,
          maxLines: 6,
          gravity: ToastGravity.bottom,
          textColor: Colors.white,
          fontSize: 16,
          showImage: withImage,
          imagePath: "assets/car_image.jpeg",
        );
      } else {
        _flutterToast.showCustomToast(
          message,
          navigatorKey: navigatorKey,
          maxLines: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          imagePath: "assets/car_image.jpeg",
          showImage: withImage,
        );
      }
    } on PlatformException {
      // Handle platform exception if toast display fails
      if (kDebugMode) {
        print('Failed to show toast.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showToastMessage("Hello from Flutter Toast",
                    useNativeToast: false, withImage: true);
              },
              child: const Text('Show Flutter Toast With Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showToastMessage("Hello from Native Toast",
                    useNativeToast: true, withImage: true);
              },
              child: const Text('Show Native Toast With Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showToastMessage("Another message from Flutter Toast",
                    useNativeToast: false);
              },
              child: const Text('Show Another Flutter Toast'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showToastMessage("Another message from Native Toast",
                    useNativeToast: true);
              },
              child: const Text('Show Another Native Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
