import 'package:flutter/material.dart';
import 'package:montage/montage.dart';
import 'package:montage/src/widgets/motion.dart';

abstract class Motions {
  static MotionWidgetBuilder reference(MontageAnimation animation) =>
      ReferenceMotionWidgetBuilder(animation);

  static MotionWidgetBuilder combine(List<MotionWidgetBuilder> animators) => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        for (var animator in animators.reversed) {
          child = animator(context, current, animation, child);
        }
        return child!;
      };

  static MotionWidgetBuilder get none => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          child!;

  static MotionWidgetBuilder get cropped => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          ClipRect(
            child: child,
          );

  static MotionWidgetBuilder get fadeIn => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      };

  static MotionWidgetBuilder get fadeOut => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return FadeTransition(
          opacity: Tween(
            begin: 1.0,
            end: 0.0,
          ).animate(animation),
          child: child,
        );
      };

  static MotionWidgetBuilder slide({
    required Alignment start,
    required Alignment end,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return SlideTransition(
          position: Tween(
            begin: Offset(start.x * 2, start.y * 2),
            end: Offset(end.x * 2, end.y * 2),
          ).animate(animation),
          child: child,
        );
      };

  static MotionWidgetBuilder scale({
    required double begin,
    required double end,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return ScaleTransition(
          scale: Tween(
            begin: begin,
            end: end,
          ).animate(animation),
          child: child,
        );
      };

  static MotionWidgetBuilder fadeFromTop() => combine(
        [
          slide(
            start: Alignment.topCenter,
            end: Alignment.center,
          ),
          fadeIn,
        ],
      );

  static MotionWidgetBuilder fadeToTop() => combine(
        [
          slide(
            start: Alignment.center,
            end: Alignment.topCenter,
          ),
          fadeOut,
        ],
      );

  static MotionWidgetBuilder reverse(MotionWidgetBuilder animator) => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          animator(
            context,
            current,
            Tween(
              begin: 1.0,
              end: 0.0,
            ).animate(animation),
            child,
          );

  static MotionWidgetBuilder openBoxFromLeft({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(0, 1),
        endAmount: Offset(0, 0) & Size(1, 1),
        endDecoration: endDecoration,
        padding: padding,
      );

  static MotionWidgetBuilder closeBoxFromRight({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 1),
        endAmount: Offset(0, 0) & Size(0, 1),
        endDecoration: endDecoration,
        padding: padding,
      );

  static MotionWidgetBuilder clipBox({
    required BoxDecoration decoration,
    required Rect startAmount,
    required Rect endAmount,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      combine([
        clip(
          startAmount: startAmount,
          endAmount: endAmount,
        ),
        box(
          decoration: decoration,
          endDecoration: endDecoration,
          padding: padding,
        ),
      ]);

  static MotionWidgetBuilder clip({
    required Rect startAmount,
    required Rect endAmount,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => ClipPath(
            clipper: _OpeningBoxClip(
              animation,
              startAmount,
              endAmount,
            ),
            child: child,
          ),
        );
      };

  static MotionWidgetBuilder curved(
    Curve curve,
    MotionWidgetBuilder builder,
  ) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          builder(
            context,
            current,
            CurvedAnimation(parent: animation, curve: curve),
            child,
          );

  static MotionWidgetBuilder interval(
    MotionWidgetBuilder builder, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.linear,
  }) =>
      curved(Interval(begin, end, curve: curve), builder);

  static MotionWidgetBuilder rotate({
    double startTurns = 0,
    required double endTurns,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return RotationTransition(
          turns: Tween(
            begin: startTurns,
            end: endTurns,
          ).animate(animation),
          child: child,
        );
      };

  static MotionWidgetBuilder box({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => Container(
            decoration: BoxDecoration.lerp(
              decoration,
              endDecoration ?? decoration,
              animation.value,
            ),
            padding: padding,
            child: child,
          ),
        );
      };

  static MotionWidgetBuilder get appear => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => Opacity(
            opacity: animation.value.toInt().toDouble(),
            child: child,
          ),
        );
      };

  static MotionWidgetBuilder get disappear => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) => Opacity(
            opacity: 1 - animation.value.toInt().toDouble(),
            child: child,
          ),
        );
      };
}

class _OpeningBoxClip extends CustomClipper<Path> {
  const _OpeningBoxClip(this.animation, this.start, this.end);
  final Animation<double> animation;
  final Rect start;
  final Rect end;
  @override
  Path getClip(Size size) {
    final lerped = Rect.lerp(start, end, animation.value);
    var path = Path()
      ..addRect(
        Offset(
              size.width * lerped!.left,
              size.height * lerped.top,
            ) &
            Size(
              size.width * lerped.width,
              size.height * lerped.height,
            ),
      );
    return path;
  }

  @override
  bool shouldReclip(_OpeningBoxClip oldClipper) => true;
}
