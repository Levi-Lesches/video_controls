import "package:video_player/video_player.dart";

/// A wrapper around [VideoPlayerController]. 
/// 
/// This version maintains state about the full-screen mode. 
class VideoController extends VideoPlayerController {
	/// Plays a video from the network. 
	VideoController.network(String url) : super.network(url);

	/// Whether this video is being played in full screen.
	/// 
	/// Flutter takes care of the size of the video player. This value is just to
	/// set the full screen icon and callback correctly. 
	bool isFullScreen = false;
}
