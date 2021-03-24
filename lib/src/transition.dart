import 'package:flutter/widgets.dart';
import 'package:montage/montage.dart';

class MotionTransition<T> {
  const MotionTransition._({
    required this.begin,
    required this.end,
    required this.interval,
    required this.reference,
    required this.isReversed,
  });

  const MotionTransition({
    required this.begin,
    required this.end,
    this.interval = const Interval(
      0.0,
      1.0,
      curve: Curves.easeInOut,
    ),
  })  : this.isReversed = false,
        this.reference = null;

  const MotionTransition.reference(this.reference, [this.isReversed = false])
      : this.begin = null,
        this.end = null,
        this.interval = null;

  final MontageAnimation? reference;
  final T? begin;
  final T? end;
  final Interval? interval;
  final bool isReversed;

  MotionTransition<T> get reversed => MotionTransition._(
        begin: begin,
        end: end,
        interval: interval,
        isReversed: !isReversed,
        reference: reference,
      );
}
