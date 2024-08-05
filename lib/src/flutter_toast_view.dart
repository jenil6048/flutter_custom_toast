import 'package:flutter/material.dart';

/// A custom toast view widget for displaying a message with optional image and customizations.
class FlutterToastView extends StatefulWidget {
  /// The message to display in the toast.
  final String message;

  /// The color of the text.
  final Color textColor;

  /// that show duration of the toast
  final double duration;

  /// The font size of the text.
  final double fontSize;

  /// The font family of the text.
  final String fontFamily;

  /// The background color of the toast.
  final Color backgroundColor;

  /// The path to the optional image to display in the toast.
  final String? imagePath;

  /// An optional custom child widget to display in the toast.
  final Widget? child;

  /// Whether to show the image if imagePath is provided.
  final bool showImage;

  /// The maximum number of lines for the message text.
  final int maxLines;

  const FlutterToastView({
    super.key,
    required this.message,
    required this.textColor,
    required this.fontSize,
    required this.fontFamily,
    required this.backgroundColor,
    required this.duration,
    this.imagePath,
    this.child,
    this.showImage = true,
    this.maxLines = 2,
  });

  @override
  _FlutterToastViewState createState() => _FlutterToastViewState();
}

class _FlutterToastViewState extends State<FlutterToastView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Controller for the animations.
  late Animation<double> _scaleAnimation;

  /// Animation for scaling the toast.
  late Animation<double> _fadeAnimation;

  /// Animation for fading the toast.

  @override
  void initState() {
    super.initState();

    /// Initialize the animation controller with a duration of 300 milliseconds.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    /// Define the scale animation from 0.8 to 1.0 with ease in and out curve.
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    /// Define the fade animation from 0.0 to 1.0 with ease in curve.
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    /// Start the animations.
    _controller.forward();

    /// Automatically remove the toast after a delay of 2 seconds.
    Future.delayed(Duration(seconds: widget.duration.toInt()), () {
      if (mounted) {
        _controller.reverse().then((_) {
          /// Optionally perform some action after the reverse animation completes.
          /// For example, removing the widget or triggering a callback.
        });
      }
    });
  }

  @override
  void dispose() {
    /// Dispose the animation controller to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Fade transition for the opacity animation.
          FadeTransition(
            opacity: _fadeAnimation,

            /// Scale transition for the scaling animation.
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Colors.transparent,

                /// Make the material background transparent.
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,

                    /// Set the background color.
                    borderRadius: BorderRadius.circular(8.0),

                    /// Rounded corners.
                  ),
                  child: widget.child ??
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.showImage && widget.imagePath != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),

                                /// Rounded corners for the image.
                                child: Image.asset(
                                  widget.imagePath!,
                                  fit: BoxFit.cover,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          Flexible(
                            child: Text(
                              widget.message,

                              /// Display the message text.
                              style: TextStyle(
                                color: widget.textColor,

                                /// Set the text color.
                                fontSize: widget.fontSize,

                                /// Set the text font size.
                                fontFamily: widget.fontFamily,

                                /// Set the text font family.
                              ),
                              maxLines: widget.maxLines,

                              /// Set the maximum number of lines.
                              overflow: TextOverflow.ellipsis,

                              /// Truncate the text with ellipsis if it overflows.
                            ),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
