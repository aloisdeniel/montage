import 'package:flutter/widgets.dart';
import 'package:montage/src/animation.dart';
import 'package:montage/src/transition.dart';

import 'motion_transition.dart';

class MotionPositioned extends StatelessWidget {
  const MotionPositioned({
    Key? key,
    required this.motion,
    required this.child,
    required this.fallback,
  }) : super(
          key: key,
        );

  final RelativeRect fallback;
  final Map<MontageAnimation, MotionTransition<RelativeRect>> motion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MotionTransitionBuilder(
      motion: motion,
      fallback: fallback,
      builder: (context, transition, value, child) {
        return Positioned.fromRelativeRect(
          rect: RelativeRectTween(
            begin: transition.begin,
            end: transition.end,
          ).transform(value),
          child: child!,
        );
      },
      child: child,
    );
  }
}
