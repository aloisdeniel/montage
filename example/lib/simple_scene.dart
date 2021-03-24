import 'package:example/scene.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:montage/montage.dart';

class BasicScene extends StatelessWidget {
  const BasicScene({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MotionText(
          text: 'Hello world',
          style: TextStyle(
            fontSize: 64,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          characterMotion: {
            entrance: Motions.fadeFromTop(),
            exit: Motions.fadeToTop(),
          },
          reversedCharacterAnimation: [exit],
          wordMotion: {
            entrance: Motions.fadeIn,
            exit: Motions.fadeOut,
          },
        ),
        Motion(
          motion: {
            entrance: Motions.combine([
              Motions.rotate(startTurns: -1, endTurns: 0),
              Motions.fadeIn,
            ]),
            exit: Motions.combine([
              Motions.rotate(startTurns: 0, endTurns: 1),
              Motions.fadeOut,
            ]),
          },
          child: FlutterLogo(
            size: 50,
          ),
        ),
      ],
    );
  }
}
