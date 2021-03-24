import 'package:flutter/widgets.dart';
import 'package:montage/src/animation.dart';
import 'package:montage/src/motions.dart';

import 'motion.dart';

class MotionText extends StatelessWidget {
  const MotionText.letters({
    Key? key,
    required this.rawCharacters,
    required this.motionCharacters,
    required this.motion,
  }) : super(
          key: key,
        );

  factory MotionText({
    Key? key,
    required String text,
    required TextStyle style,
    required Map<MontageAnimation, MotionWidgetBuilder> wordMotion,
    required Map<MontageAnimation, MotionWidgetBuilder> characterMotion,
    List<MontageAnimation> reversedCharacterAnimation =
        const <MontageAnimation>[],
    Curve characterCurve = Curves.easeInOut,
    double characterStartTime = 0.0,
    double characterEndTime = 1.0,
    double characterOverlapTime = 0.0,
  }) {
    assert(text.isNotEmpty);
    assert(characterStartTime >= 0.0);
    assert(characterEndTime <= 1.0);
    assert(characterEndTime > characterStartTime);
    assert(characterOverlapTime >= 0.0 && characterOverlapTime <= 1.0);
    final rawCharacters = <Text>[];
    for (var i = 0; i < text.length; i++) {
      final character = text[i];
      rawCharacters.add(
        Text(
          character,
          style: style,
        ),
      );
    }

    final motionCharacters = [
      ...Motion.staggered(
        children: <Widget>[...rawCharacters],
        motion: (child, i, forward, backward) {
          return characterMotion.map(
            (key, value) => MapEntry(
              key,
              Motions.curved(
                reversedCharacterAnimation.contains(key) ? backward : forward,
                value,
              ),
            ),
          );
        },
        overlap: characterOverlapTime,
        start: characterStartTime,
        end: characterEndTime,
      ),
    ];

    return MotionText.letters(
      key: key,
      rawCharacters: rawCharacters,
      motionCharacters: motionCharacters,
      motion: wordMotion,
    );
  }

  final List<Text> rawCharacters;
  final List<Widget> motionCharacters;
  final Map<MontageAnimation, MotionWidgetBuilder> motion;

  Iterable<Widget> _letters() sync* {
    final buffer = StringBuffer();

    for (var i = 0; i < rawCharacters.length; i++) {
      final raw = rawCharacters[i];
      final motion = motionCharacters[i];
      buffer.write(raw.data);
      yield Stack(
        children: [
          Opacity(
            key: Key('PlaceholderPositionning'),
            opacity: 0,
            child: Text(
              buffer.toString(),
              style: raw.style,
            ),
          ),
          Positioned(
            key: Key('Character'),
            right: 0,
            child: motion,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Motion(
      motion: motion,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [..._letters()],
      ),
    );
  }
}
