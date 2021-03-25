import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:montage/montage.dart';

const entrance = MontageAnimation(
  key: 'entrance',
  duration: Duration(seconds: 2),
);

const idle = MontageAnimation(
  key: 'idle',
  duration: Duration(seconds: 3),
);

const exit = MontageAnimation(
  key: 'exit',
  duration: Duration(seconds: 2),
);

class ExampleScene extends StatelessWidget {
  const ExampleScene({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MotionPositioned(
          fallback: RelativeRect.fromLTRB(0, 200, 0, 0),
          motion: {
            entrance: MotionTransition(
              begin: RelativeRect.fromLTRB(0, 0, 0, 200),
              end: RelativeRect.fromLTRB(0, 200, 0, 0),
            ),
            exit: MotionTransition.reference(entrance, true),
          },
          child: Motion(
            motion: {
              entrance: Motions.curved(
                Curves.easeOut,
                Motions.fadeIn,
              ),
              exit: Motions.reverse(
                Motions.reference(entrance),
              ),
            },
            child: Opacity(
              opacity: 0.2,
              child: FlutterLogo(),
            ),
          ),
        ),
        Positioned.fill(
          child: MotionAlign(
            fallback: Alignment.center,
            motion: {
              entrance: MotionTransition(
                begin: Alignment.topLeft,
                end: Alignment.center,
              ),
              exit: MotionTransition(
                begin: Alignment.center,
                end: Alignment.bottomRight,
              ),
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MotionText(
                  text: 'Hello world',
                  style: TextStyle(
                    fontSize: 64,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  characterMotion: {
                    entrance: Motions.fadeFromTop(),
                    exit: Motions.fadeToTop(),
                  },
                  characterStartTime: 0.3,
                  characterEndTime: 1.0,
                  characterOverlapTime: 0.8,
                  reversedCharacterAnimation: [exit],
                  wordMotion: {
                    entrance: Motions.openBoxFromLeft(
                      decoration: BoxDecoration(color: Colors.red),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    idle: Motions.box(
                      decoration: BoxDecoration(color: Colors.red),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    exit: Motions.closeBoxFromRight(
                      decoration: BoxDecoration(color: Colors.red),
                      endDecoration: BoxDecoration(color: Colors.orange),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...Motion.staggered(
                      children: [
                        Text("FL"),
                        Text("UT"),
                        Text("TER"),
                      ],
                      motion: (child, i, forward, backward) {
                        return {
                          entrance: Motions.curved(
                            forward,
                            Motions.combine([
                              Motions.rotate(startTurns: -1, endTurns: 0),
                              Motions.fadeIn,
                              Motions.scale(begin: 3, end: 1)
                            ]),
                          ),
                          exit: Motions.curved(
                            backward,
                            Motions.combine([
                              Motions.rotate(startTurns: 0, endTurns: -1),
                              Motions.fadeOut,
                              Motions.scale(begin: 1, end: 3)
                            ]),
                          ),
                        };
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
