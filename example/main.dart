import "package:flutter/material.dart";

import "package:video_controls/video_controls.dart";

const String url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

class HomePage extends StatefulWidget {
	@override
	HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
	final VideoController controller = VideoController.network(url);

	@override
	Widget build(BuildContext context) => Scaffold(
		body: VideoPlayer(controller)
	);

	@override
	void dispose() {
		controller.dispose();
		super.dispose();
	}
}

void main() => runApp(MaterialApp(home: HomePage()));