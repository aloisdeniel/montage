part of 'montage.dart';

class MontageController extends AnimationController {
  MontageController({
    required TickerProvider vsync,
    MontageAnimation? initialAnimation,
  })  : _current = ValueNotifier<MontageAnimation?>(initialAnimation),
        super(
          vsync: vsync,
        ) {
    duration = initialAnimation?.duration;
  }

  final ValueNotifier<MontageAnimation?> _current;

  /// Gets the current animation.
  ValueListenable<MontageAnimation?> get current => _current;

  set animation(MontageAnimation value) {
    if (current.value != value) {
      _current.value = value;
      duration = value.duration;
    }
  }

  Future<void> play(List<MontageAnimation> animations,
      {bool isReversed = false}) async {
    for (var animation in (isReversed ? animations.reversed : animations)) {
      reset();
      this.animation = animation;
      await (isReversed ? super.reverse() : super.forward());
    }
  }

  @override
  double get value => _current.value != null
      ? _current.value!.curve.transform(super.value)
      : super.value;

  @override
  void dispose() {
    _current.dispose();
    super.dispose();
  }
}
