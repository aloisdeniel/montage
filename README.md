# montage

Organize your animations.

## Quickstart

![](montage_example.gif)

```dart
// 1. Define your animations
const entrance = MontageAnimation(
  key: 'entrance',
  duration: Duration(seconds: 2), 
);

const exit = MontageAnimation(
  key: 'exit',
  duration: Duration(seconds: 2),
);

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  MontageController? controller;

  @override
  void initState() {
    controller = MontageController(
      vsync: this,
      initialAnimation: entrance,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<MontageAnimation?>(
          valueListenable: controller!.current,
          builder: (context, current, child) => Text(current?.key ?? 'none'),
        ),
      ),
      // 2. Wrap your animated widget in a `Montage` with its controller.
      body: Montage( 
        controller: controller!,
        child: BasicScene(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /// Plays this sequence of animations
          controller!.play([
            entrance,
            exit,
          ]);
        },
        label: Text('Play'),
        icon: Icon(Icons.video_call),
      ),
    );
  }
}


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
        // 3. Use the motion widgets that defiens motions for each one of your animations
        Motion(
          motion: {
            // You can use the provider motions or custom ones
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
      ],
    );
  }
}
```

## Widgets

### Declaring animation references

You must start by declaring you scene's various animation sequences as `MontageAnimation` global objects.

```dart
const entrance = MontageAnimation(
  duration: Duration(seconds: 2),
);

const idle = MontageAnimation(
  duration: Duration(seconds: 3),
);

const exit = MontageAnimation(
  duration: Duration(seconds: 2),
);
```

### Montage

The montage serves as the root configuration for your motion widgets. It takes a dedicated controller that will allow to trigger animations.

```dart
class _HomeState extends State<Home> with TickerProviderStateMixin {
  MontageController? controller;

  @override
  void initState() {
    controller = MontageController(
      vsync: this,
      initialAnimation: entrance,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Montage(
        controller: controller!,
        child: Scene(),
      ),
      floatingActionButton: FloatingActionButton(
        icon: Icon(Icons.video_call),
        onPressed: () {
          /// Plays this sequence of animations
          controller!.play([
            entrance,
            exit,
            entrance,
            idle,
            exit,
          ]);
        },
      ),
    );
  }
}
```

### Motion

The core widget that can animate a child `widget` differently for each one of the played `MotionAnimation` from the root `Montage`'s controller.

```dart
Motion(
    motion: {
        entrance: Motions.fadeIn,
        exit: Motions.fadeOut,
    },
    child: FlutterLogo(
        size: 50,
    ),
)
```

### Staggered animation

If you want to animated a set of widgets progressively, you use the `Motion.staggered` helper method.

Two curves are provided with children animated in the original order as `forward`, or children animated in reverse order with `backwards`.

You can also configure `overlap` if you want that animation of each children starts before the end of the previous one.

```dart
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
```

## Motions

### Built-in

A set of motions is available [from the `motions.dart` file](lib/src/motions.dart).

### Custom

A motion is just a widget builder from the current `Animation<double>` and the child `Widget` that should be animated.

```dart
Widget fadeIn(
  BuildContext context,
  MontageAnimation current,
  Animation<double> animation,
  Widget? child,
) {
    return FadeTransition(
        opacity: animation,
        child: child,
    );
}
```