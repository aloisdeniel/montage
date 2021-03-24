import 'package:flutter/widgets.dart';
import 'package:montage/src/animation.dart';
import 'package:montage/src/transition.dart';
import 'package:montage/src/widgets/motion.dart';

typedef Widget MotionTransitionWidgetBuilder<T>(
  BuildContext context,
  MotionTransition<T> transition,
  double value,
  Widget? child,
);

class MotionTransitionBuilder<T> extends StatelessWidget {
  const MotionTransitionBuilder({
    Key? key,
    required this.motion,
    required this.builder,
    required this.fallback,
    this.child,
  }) : super(
          key: key,
        );

  final MotionTransitionWidgetBuilder builder;
  final T fallback;
  final Map<MontageAnimation, MotionTransition<T>> motion;
  final Widget? child;

  Widget _transitionBuilder(
    BuildContext context,
    MontageAnimation current,
    Animation<double> animation,
    Widget? child,
  ) {
    final fallbackTransition = MotionTransition(
      begin: fallback,
      end: fallback,
    );
    var transition = motion[current] ?? fallbackTransition;
    while (transition.reference != null) {
      final isReversed = transition.isReversed;
      transition = motion[transition.reference] ?? fallbackTransition;
      if (isReversed) transition = transition.reversed;
    }

    final interval = transition.interval;

    if (interval != null) {
      animation = CurvedAnimation(
        parent: animation,
        curve: interval,
      );
    }

    if (transition.isReversed) {
      animation = Tween(begin: 1.0, end: 0.0).animate(animation);
    }
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return builder(context, transition, animation.value, child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Motion(
      fallback: _transitionBuilder,
      motion: motion.map((key, value) => MapEntry(key, _transitionBuilder)),
      child: child,
    );
  }
}
