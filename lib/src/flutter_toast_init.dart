import 'package:flutter/cupertino.dart';

/// A function to create a [TransitionBuilder] for displaying custom toasts.
///
/// This builder wraps the child widget in a [_FlutterToastHolder].
TransitionBuilder flutterToastBuilder() {
  return (context, child) {
    return _FlutterToastHolder(
      child: child!,
    );
  };
}

/// A widget that holds an [Overlay] to display custom toasts.
class _FlutterToastHolder extends StatelessWidget {
  /// The child widget to be wrapped by the overlay.
  final Widget child;

  const _FlutterToastHolder({required this.child});

  @override
  Widget build(BuildContext context) {
    /// Create an overlay with the initial entries containing the child widget.
    final Overlay overlay = Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return child;
          },
        ),
      ],
    );

    /// Return the overlay wrapped in a [Directionality] widget to handle text direction.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: overlay,
    );
  }
}
