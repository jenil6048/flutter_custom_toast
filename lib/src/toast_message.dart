import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_toast.dart';

/// A class to interact with native platform code to show custom toasts.
class NativeToast {
  /// A [MethodChannel] for communicating with the native platform.
  static const platform = MethodChannel('com.example.toast');

  /// Shows a custom toast using native platform capabilities.
  ///
  /// The [message] is the text to display in the toast. Optionally, you can
  /// specify [textColor], [fontSize], [fontFamily], [backgroundColor], [image],
  /// whether to [showImage], the maximum number of [maxLines], the [gravity]
  /// (position of the toast), and the [duration] of the toast.
  static Future<void> showToast({
    required String message,
    Color? textColor,
    double? fontSize,
    String? fontFamily,

    ///Give native asset image name like :-imageResourceName "ic_launcher"
    String? imageResourceName,
    Color? backgroundColor,
    String? image,
    bool showImage = true,
    int maxLines = 2,
    ToastGravity gravity = ToastGravity.bottom,
    double duration = 2.0,
  }) async {
    try {
      /// If an image is provided, load it from assets and convert to base64.
      if (image != null && image.isNotEmpty) {
        final ByteData data = await rootBundle.load(image);
        final Uint8List bytes = data.buffer.asUint8List();
        image = base64Encode(bytes);
      }

      /// Invoke the 'showToast' method on the platform with the provided parameters.
      await platform.invokeMethod('showToast', {
        'message': message,
        'textColor': textColor?.value,
        'fontSize': fontSize,
        'fontFamily': fontFamily ?? 'Roboto',
        'backgroundColor': backgroundColor?.value,
        'base64Image': image,
        'showImage': showImage,
        'maxLines': maxLines,
        'gravity': gravity.index,
        'duration': duration,
        "imageResourceName": imageResourceName,
      });
    } on PlatformException catch (e) {
      /// Log an error message if showing the toast fails.
      if (kDebugMode) {
        log("Failed to show toast: '${e.message}'.");
      }
    }
  }
}
