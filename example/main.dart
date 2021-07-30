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
    appBar: AppBar(title: const Text("video_controls Demo")),
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
