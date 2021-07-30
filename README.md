# video_controls

A wrapper around `video_player ` to show customizable controls for Flutter videos.

Customization options are being implemented, but the package is in a working state. 

### Features

- Pause/Play button
- Full screen (only tested on Web)
- Slider for seeking and line to show the buffer
- Seeking without lag
- Mute button
- Controls that fade out when the mouse is still or not on the video
  - On mobile, tapping the video shows the controls for a few seconds

### Screenshots

| ![](https://github.com/Levi-Lesches/video_controls/blob/main/doc/demo4.gif) | ![](https://github.com/Levi-Lesches/video_controls/blob/main/doc/demo1.gif) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |



### Customization options 

Coming soon! But you can use regular ThemeData properties for now, since this package uses standard widgets. 

### Usage

```dart
import "package:flutter/material.dart";

import "package:video_controls/video_controls.dart";

const String url = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final VideoController controller = VideoController.network(url);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("video_controls Demo")),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Text(
              "My Video",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3
            ),
            const SizedBox(height: 30),
            VideoPlayer(controller),
          ]
        )
      )
    )
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: HomePage()));

```



