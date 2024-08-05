import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_flutter_toast/src/flutter_toast.dart';

class NativeToast {
  final methodChannel = const MethodChannel('flutter_toast_plugin');

  Future<void> showToast({
    required String message,
    Color? textColor,
    double? fontSize,
    String? fontFamily,
    String? imageResourceName,
    Color? backgroundColor,
    String? imagePath,
    bool showImage = true,
    int maxLines = 2,
    ToastGravity gravity = ToastGravity.bottom,
    double? duration,
  }) async {
    /// If an image is provided, load it from assets and convert to base64.
    if (imagePath != null && imagePath.isNotEmpty) {
      try{
        final ByteData data = await rootBundle.load(imagePath);
        final Uint8List bytes = data.buffer.asUint8List();
        imagePath = base64Encode(bytes);
      }catch(e){
        log("Error to load image--->$imagePath");
      }
    }
    print(" backgroundColor?.value ${backgroundColor?.value}");
    final data = {
      'message': message,
      'textColor': textColor?.value,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'backgroundColor': backgroundColor?.value??Colors.white.value,
      'base64Image': imagePath,
      'showImage': showImage,
      'maxLines': maxLines,
      'gravity': gravity.index,
      /// On Android, if the duration is 0.0, the message will be displayed for a short duration otherwise it show message for long time.
      'duration': duration?.toInt() ?? (Platform.isAndroid ? 1 : 2),
      'imageResourceName': imageResourceName,
    };

    try {
      await methodChannel.invokeMethod<void>('showCustomToast', data);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to show toast: '${e.message}'.");
      }
    }
  }
}
