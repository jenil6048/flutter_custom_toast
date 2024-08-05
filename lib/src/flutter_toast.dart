import 'package:flutter/material.dart';

import 'flutter_toast_view.dart';

/// A service to manage navigation with a global navigator key.
class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

/// A class for displaying custom toasts in a Flutter application.
class FlutterToast {
  BuildContext? context;
  static final FlutterToast _instance = FlutterToast._internal();

  /// Factory constructor to return the singleton instance of FlutterToast.
  factory FlutterToast() {
    return _instance;
  }

  /// Initializes the FlutterToast with the provided [context].
  FlutterToast init(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  FlutterToast._internal();

  ///------------------------------------- Note -------------------------------------
  ///
  /// You need to add the `builder` inside the `MaterialApp` and also add the `navigatorKey` like this:
  ///
  /// ```dart
  /// return MaterialApp(
  ///   builder: flutterToastBuilder(),
  ///   navigatorKey: navigatorKey,
  ///   title: 'Flutter Custom Toast Example',
  ///   home: const MyHomePage(),
  /// );
  /// ```
  ///
  /// To create the `navigatorKey`:
  ///
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ```

  /// Displays a custom toast with various customization options.
  ///
  /// [message] is the text to display in the toast.
  /// [textColor] is the color of the text. Default is black.
  /// [navigatorKey] is the global key for the navigator.
  /// [fontSize] is the font size of the text. Default is 16.0.
  /// [fontFamily] is the font family of the text. Default is 'Roboto'.
  /// [backgroundColor] is the background color of the toast. Default is white.
  /// [imagePath] is the optional image to display in the toast.
  /// [child] is an optional custom widget to display in the toast.
  /// [showImage] determines whether to show the image if [imagePath] is provided. Default is true.
  /// [maxLines] is the maximum number of lines for the text. Default is 2.
  /// [gravity] determines the position of the toast on the screen. Default is bottom.
  /// [duration] is the duration for which the toast is displayed in seconds. Default is 2.0.
  void showCustomToast(
      String message, {
        Color textColor = Colors.black,
        required GlobalKey<NavigatorState> navigatorKey,
        double fontSize = 16.0,
        String fontFamily = 'Roboto',
        Color backgroundColor = Colors.white,
        String? imagePath,
        Widget? child,
        bool showImage = true,
        int maxLines = 2,
        ToastGravity gravity = ToastGravity.bottom,
        double duration = 2.0,
      }) {
    if (context == null) {
      FlutterToast().init(navigatorKey.currentContext!);
      if (context == null) return;
    }

    /// Create an OverlayEntry to display the custom toast.
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: gravity == ToastGravity.top || gravity == ToastGravity.center ? 0 : null,
        bottom: gravity == ToastGravity.bottom || gravity == ToastGravity.center ? 0 : null,
        left: 24.0,
        right: 24.0,
        child: FlutterToastView(
          message: message,
          duration: duration,
          textColor: textColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          backgroundColor: backgroundColor,
          imagePath: imagePath,
          showImage: showImage,
          maxLines: maxLines,
          child: child,
        ),
      ),
    );

    /// Insert the overlay entry into the overlay.
    Overlay.of(context!).insert(overlayEntry);

    /// Remove the overlay entry after the specified duration.
    Future.delayed(Duration(seconds: duration.toInt()), () {
      overlayEntry.remove();
    });
  }
}

/// Enum to define the possible positions of the toast on the screen.
enum ToastGravity {
  top,
  center,
  bottom,
}
