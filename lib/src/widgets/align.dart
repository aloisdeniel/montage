import 'package:flutter/widgets.dart';
import 'package:montage/src/animation.dart';
import 'package:montage/src/transition.dart';

import 'motion_transition.dart';

class MotionAlign extends StatelessWidget {
  const MotionAlign({
    Key? key,
    required this.motion,
    required this.child,
    required this.fallback,
  }) : super(
          key: key,
        );

  final Alignment fallback;
  final Map<MontageAnimation, MotionTransition<Alignment>> motion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MotionTransitionBuilder(
      motion: motion,
      fallback: fallback,
      builder: (context, transition, value, child) {
        return Align(
          alignment: AlignmentTween(
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
