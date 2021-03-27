import 'package:flutter/material.dart';
import 'package:montage/montage.dart';
import 'package:montage/src/widgets/motion.dart';

abstract class Motions {
  /// No motion.
  static MotionWidgetBuilder get none => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          child!;

  /// Use the motion of an other [animation].
  static MotionWidgetBuilder reference(MontageAnimation animation) =>
      ReferenceMotionWidgetBuilder(animation);

  /// Reverses the given [motion].
  static MotionWidgetBuilder reverse(MotionWidgetBuilder motion) => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          motion(
            context,
            current,
            Tween(
              begin: 1.0,
              end: 0.0,
            ).animate(animation),
            child,
          );

  /// Apply the given [motion] into the given interval.
  static MotionWidgetBuilder interval(
    MotionWidgetBuilder motion, {
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.linear,
  }) =>
      curved(Interval(begin, end, curve: curve), motion);

  /// Apply a [curve] onto the given [motion].
  static MotionWidgetBuilder curved(
    Curve curve,
    MotionWidgetBuilder motion,
  ) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) =>
          motion(
            context,
            current,
            CurvedAnimation(parent: animation, curve: curve),
            child,
          );

  /// Appears instantly.
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

  /// Disappears instantly.
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

  /// Combine multiple [motions] and apply them recursively in order from first to last.
  static MotionWidgetBuilder combine(List<MotionWidgetBuilder> motions) => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        for (var motion in motions.reversed) {
          child = motion(context, current, animation, child);
        }
        return child!;
      };

  /// Fades from [begin] opacity to [end] opacity.
  static MotionWidgetBuilder fade(double begin, double end) => (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return FadeTransition(
          opacity: Tween(
            begin: begin,
            end: end,
          ).animate(animation),
          child: child,
        );
      };

  /// Fade in (from `0` opacity to `1`).
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

  /// Fade in (from `1` opacity to `0`).
  static MotionWidgetBuilder get fadeOut => fade(1, 0);

  /// Animates the position relative to its normal position.
  ///
  /// The translation is expressed as an [Alignment] scaled to the child's size multiplied
  /// by the given [factor]. For example, an [Alignment] with a `dx` of 0.25 and a factor of `2` will result
  /// in a horizontal translation of one half (two quarters) the width of the child.
  static MotionWidgetBuilder slide({
    required Alignment begin,
    required Alignment end,
    double factor = 1.0,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return SlideTransition(
          position: Tween(
            begin: Offset(begin.x * 2 * factor, begin.y * 2 * factor),
            end: Offset(end.x * 2 * factor, end.y * 2 * factor),
          ).animate(animation),
          child: child,
        );
      };

  /// Animates the position from center to [end].
  static MotionWidgetBuilder slideTo(
    Alignment end, {
    double factor = 1.0,
  }) =>
      slide(
        begin: Alignment.center,
        end: end,
        factor: factor,
      );

  /// Animates the position from center to top.
  static MotionWidgetBuilder slideToTop({
    double factor = 1.0,
  }) =>
      slideTo(
        Alignment.topCenter,
        factor: factor,
      );

  /// Animates the position from center to bottom.
  static MotionWidgetBuilder slideToBottom({
    double factor = 1.0,
  }) =>
      slideTo(
        Alignment.bottomCenter,
        factor: factor,
      );

  /// Animates the position from center to left.
  static MotionWidgetBuilder slideToLeft({
    double factor = 1.0,
  }) =>
      slideTo(
        Alignment.centerLeft,
        factor: factor,
      );

  /// Animates the position from center to right.
  static MotionWidgetBuilder slideToRight({
    double factor = 1.0,
  }) =>
      slideTo(
        Alignment.centerRight,
        factor: factor,
      );

  /// Animates the position from [begin] to center.
  static MotionWidgetBuilder slideFrom(
    Alignment begin, {
    double factor = 1.0,
  }) =>
      slide(
        begin: begin,
        end: Alignment.center,
        factor: factor,
      );

  /// Animates the position from top to center.
  static MotionWidgetBuilder slideFromTop({
    double factor = 1.0,
  }) =>
      slideFrom(
        Alignment.topCenter,
        factor: factor,
      );

  /// Animates the position from bottom to center.
  static MotionWidgetBuilder slideFromBottom({
    double factor = 1.0,
  }) =>
      slideFrom(
        Alignment.bottomCenter,
        factor: factor,
      );

  /// Animates the position from left to center.
  static MotionWidgetBuilder slideFromLeft({
    double factor = 1.0,
  }) =>
      slideFrom(
        Alignment.centerLeft,
        factor: factor,
      );

  /// Animates the position from right to center.
  static MotionWidgetBuilder slideFromRight({
    double factor = 1.0,
  }) =>
      slideFrom(
        Alignment.centerLeft,
        factor: factor,
      );

  /// Animates the scale from [begin] to [end].
  static MotionWidgetBuilder scale({
    required double begin,
    required double end,
    Alignment alignment = Alignment.center,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        return ScaleTransition(
          alignment: alignment,
          scale: Tween(
            begin: begin,
            end: end,
          ).animate(animation),
          child: child,
        );
      };

  /// Animates the transformation from [begin] to [end].
  static MotionWidgetBuilder transform({
    required Matrix4 begin,
    required Matrix4 end,
    Offset? origin,
  }) =>
      (
        BuildContext context,
        MontageAnimation current,
        Animation<double> animation,
        Widget? child,
      ) {
        final transformAnimation = Matrix4Tween(
          begin: begin,
          end: end,
        ).animate(animation);
        return AnimatedBuilder(
          animation: transformAnimation,
          child: child,
          builder: (context, child) => Transform(
            origin: origin,
            transform: transformAnimation.value,
            child: child,
          ),
        );
      };

  /// Combination of [slideFromTop] and [fadeIn].
  static MotionWidgetBuilder fadeFromTop([double factor = 1.0]) => combine(
        [
          slideFromTop(factor: factor),
          fadeIn,
        ],
      );

  /// Combination of [slideFromTop] and [fadeOut].
  static MotionWidgetBuilder fadeToTop([double factor = 1.0]) => combine(
        [
          slideToTop(factor: factor),
          fadeOut,
        ],
      );

  /// Combination of [slideFromBottom] and [fadeIn].
  static MotionWidgetBuilder fadeFromBottom([double factor = 1.0]) => combine(
        [
          slideFromBottom(factor: factor),
          fadeIn,
        ],
      );

  /// Combination of [slideToBottom] and [fadeOut].
  static MotionWidgetBuilder fadeToBottom([double factor = 1.0]) => combine(
        [
          slideToBottom(factor: factor),
          fadeOut,
        ],
      );

  /// Combination of [slideFromLeft] and [fadeIn].
  static MotionWidgetBuilder fadeFromLeft([double factor = 1.0]) => combine(
        [
          slideFromLeft(factor: factor),
          fadeIn,
        ],
      );

  /// Combination of [slideToLeft] and [fadeOut].
  static MotionWidgetBuilder fadeToLeft([double factor = 1.0]) => combine(
        [
          slideToLeft(factor: factor),
          fadeOut,
        ],
      );

  /// Combination of [slideFromRight] and [fadeIn].
  static MotionWidgetBuilder fadeFromRight([double factor = 1.0]) => combine(
        [
          slideFromRight(factor: factor),
          fadeIn,
        ],
      );

  /// Combination of [slideToRight] and [fadeOut].
  static MotionWidgetBuilder fadeToRight([double factor = 1.0]) => combine(
        [
          slideToRight(factor: factor),
          fadeOut,
        ],
      );

  /// Rotates from [startTurns] to [endTurns].
  static MotionWidgetBuilder rotate({
    required double startTurns,
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

  /// A combination of [clip] and [box].
  static MotionWidgetBuilder clipBox({
    required BoxDecoration decoration,
    required Rect startAmount,
    required Rect endAmount,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
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
          endPadding: endPadding,
        ),
      ]);

  /// Clips from the [startAmount] to [endAmount].
  ///
  /// Amount offsets are from `0` to `1` from left to right, or top to bottom.
  /// Amount sizes are from `0` to `1` for width and height.
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

  /// Decorates with the [decoration] as a `Container`.
  ///
  /// If `endDecoration` is provided, animates decoration to it.
  ///
  /// A [padding]  can also be provided.
  static MotionWidgetBuilder box({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
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
            padding: EdgeInsets.lerp(
              padding,
              endPadding ?? padding,
              animation.value,
            ),
            child: child,
          ),
        );
      };

  /// A [clipBox] that opens from left.
  static MotionWidgetBuilder openBoxFromLeft({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(0, 1),
        endAmount: Offset(0, 0) & Size(1, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that opens from right.
  static MotionWidgetBuilder openBoxFromRight({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(1, 0) & Size(0, 1),
        endAmount: Offset(0, 0) & Size(1, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that opens from top.
  static MotionWidgetBuilder openBoxFromTop({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 0),
        endAmount: Offset(0, 0) & Size(1, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that opens from bottom.
  static MotionWidgetBuilder openBoxFromBottom({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 1) & Size(1, 0),
        endAmount: Offset(0, 0) & Size(1, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that opens from center.
  static MotionWidgetBuilder openBoxFromCenter({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0.5, 0.5) & Size(0, 0),
        endAmount: Offset(0, 0) & Size(1, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that closes from right.
  static MotionWidgetBuilder closeBoxFromRight({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 1),
        endAmount: Offset(0, 0) & Size(0, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that closes from left.
  static MotionWidgetBuilder closeBoxFromLeft({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 1),
        endAmount: Offset(1, 0) & Size(0, 1),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that closes from top.
  static MotionWidgetBuilder closeBoxFromTop({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 1),
        endAmount: Offset(0, 0) & Size(1, 0),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that closes from top.
  static MotionWidgetBuilder closeBoxFromBottom({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 1),
        endAmount: Offset(0, 1) & Size(1, 0),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );

  /// A [clipBox] that closes from all sides to center.
  static MotionWidgetBuilder closeBoxFromAllSides({
    required BoxDecoration decoration,
    BoxDecoration? endDecoration,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets? endPadding,
  }) =>
      clipBox(
        decoration: decoration,
        startAmount: Offset(0, 0) & Size(1, 1),
        endAmount: Offset(0.5, 0.5) & Size(0, 0),
        endDecoration: endDecoration,
        padding: padding,
        endPadding: endPadding,
      );
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
