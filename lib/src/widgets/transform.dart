import 'package:flutter/widgets.dart';
import 'package:montage/src/animation.dart';
import 'package:montage/src/transition.dart';

import 'motion_transition.dart';

class MotionTransform extends StatelessWidget {
  const MotionTransform({
    Key? key,
    required this.motion,
    required this.child,
    required this.fallback,
    this.origin,
  }) : super(
          key: key,
        );

  final Matrix4 fallback;
  final Offset? origin;
  final Map<MontageAnimation, MotionTransition<Matrix4>> motion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MotionTransitionBuilder(
      motion: motion,
      fallback: fallback,
      builder: (context, transition, value, child) {
        return Transform(
          origin: origin,
          transform: Matrix4Tween(
            begin: transition.begin,
            end: transition.end,
          ).transform(value),
          child: child,
        );
      },
      child: child,
    );
  }
}
