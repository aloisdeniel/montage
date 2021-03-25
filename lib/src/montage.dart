import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:montage/src/animation.dart';
import 'package:provider/provider.dart';

part 'controller.dart';

class Montage extends StatelessWidget {
  const Montage({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final MontageController controller;
  final Widget child;

  static MontageController controllerOf(BuildContext context) {
    return Provider.of<_Wrapper<MontageController>>(context).value;
  }

  static MontageAnimation? currentOf(BuildContext context) {
    return Provider.of<MontageAnimation?>(context);
  }

  static Future<void> play(
      BuildContext context, List<MontageAnimation> animations) {
    return controllerOf(context).play(animations);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _Wrapper(controller),
      child: ValueListenableProvider<MontageAnimation?>.value(
        value: controller.current,
        child: child,
      ),
    );
  }
}

class _Wrapper<T> extends Equatable {
  _Wrapper(this.value);
  final T value;

  @override
  List<Object?> get props => [value];
}
