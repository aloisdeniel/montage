import 'package:flutter/widgets.dart';
import 'package:montage/montage.dart';
import 'package:montage/src/animation.dart';
import 'package:montage/src/montage.dart';
import 'package:provider/provider.dart';

typedef Widget MotionWidgetBuilder(
  BuildContext context,
  MontageAnimation current,
  Animation<double> animation,
  Widget? child,
);

class ReferenceMotionWidgetBuilder {
  ReferenceMotionWidgetBuilder(this.reference);

  final MontageAnimation reference;

  Widget call(
    BuildContext context,
    MontageAnimation current,
    Animation<double> animation,
    Widget? child,
  ) {
    final builders =
        Provider.of<Map<MontageAnimation, MotionWidgetBuilder>>(context);
    final builder = builders[reference];
    if (builder == null) throw Exception('Reference to an undefined motion');
    return builder(context, current, animation, child);
  }
}

class Motion extends StatelessWidget {
  const Motion({
    Key? key,
    required this.motion,
    this.fallback = defaultMotionFallbackBuilder,
    this.child,
  }) : super(
          key: key,
        );

  final Widget? child;
  final MotionWidgetBuilder fallback;
  final Map<MontageAnimation, MotionWidgetBuilder> motion;

  static List<Widget> staggered({
    required List<Widget> children,
    required Map<MontageAnimation, MotionWidgetBuilder> motion(
      Widget widget,
      int i,
      Curve forward,
      Curve backward,
    ),
    MotionWidgetBuilder? fallback,
    double overlap = 0,
    double start = 0.0,
    double end = 1.0,
  }) {
    final result = <Widget>[];

    final baseCurve = Interval(
      start,
      end,
    );

    final totalDuration =
        children.length.toDouble() - (children.length - 1) * overlap;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final childStart = (i - i * overlap) / totalDuration;
      final childEnd = (i - (i * overlap) + 1) / totalDuration;

      final interval = Interval(
        childStart,
        childEnd,
        curve: baseCurve,
      );
      final childMotion = motion(
        child,
        i,
        interval,
        interval.flipped,
      );

      result.add(
        Motion(
          fallback: fallback ?? defaultMotionFallbackBuilder,
          motion: childMotion,
          child: child,
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final current = Montage.currentOf(context);

    final animation = Montage.controllerOf(context);
    if (current == null) {
      return fallback(context, MontageAnimation.none, animation, child);
    }
    var builder = motion[current] ?? fallback;
    return builder(context, current, animation, child);
  }
}

Widget defaultMotionFallbackBuilder(
  BuildContext context,
  MontageAnimation current,
  Animation<double> animation,
  Widget? child,
) =>
    child ?? SizedBox();
