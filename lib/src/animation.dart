import 'package:flutter/animation.dart';

class MontageAnimation {
  const MontageAnimation({
    required this.duration,
    this.key,
    this.curve = Curves.easeInOut,
  });
  final String? key;
  final Duration duration;
  final Curve curve;

  static const none = MontageAnimation(duration: Duration());
}
