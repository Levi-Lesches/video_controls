import "package:flutter/material.dart";
import "package:video_player/video_player.dart";
import "controller.dart";

extension on Duration {
  String get timestamp => "${inMinutes.toString().padLeft(2, '0')}:"
    "${(inSeconds % 60).toString().padLeft(2, '0')}";
}

/// A widget that shows controls for a video. 
/// 
/// This widget provides interactivity for videos backed by 
/// `package:video_player`. It should be overlaid on top of [VideoPlayer], and 
/// is backed by a [VideoController], which must be initialized before 
/// this widget is created. 
class VideoControls extends StatefulWidget {
  /// The `video_player` plugin's [VideoController].
  final VideoController controller;

  /// The callbacks used to open and close full screen mode. 
  /// 
  /// Because full-screen mode depends on the Widget tree, that is left to the 
  /// widget on top of this one. 
  final VoidCallback openFullScreen, closeFullScreen;

  /// Creates a widget to show video controls.
  /// 
  /// [controller] must be initialized before creating this widget 
  const VideoControls(
    this.controller, 
    {
      required this.openFullScreen,
      required this.closeFullScreen,
    }
  );

  @override
  VideoControlsState createState() => VideoControlsState();
}

/// The state for the video controls. 
/// 
/// This state uses [controller] from `package:video_player` to read and control
/// the state of the video, which can be accessed through [video].
class VideoControlsState extends State<VideoControls> {
  /// The `video_player` plugin's [VideoController].
  VideoController get controller => widget.controller;

  /// The current state of the video.
  VideoPlayerValue get video => controller.value;

  /// The position the user is trying to seek to. 
  /// 
  /// This allows the UI to move the slider while still playing the video, and 
  /// only actually loading the selected position when the user releases. 
  /// 
  /// Null when the user is not moving the slider. 
  double? seekValue;

  /// The current position of the buffer. 
  Duration get bufferedPosition => video.buffered.isEmpty
    ? Duration.zero : video.buffered.last.end;

  /// Whether the video is currently muted. 
  bool get isMuted => video.volume == 0;

  /// The timestamp in `current` / `end` form. 
  /// 
  /// If the user is moving the slider (when [seekValue] is non-null), the
  /// `current` time shows the position of the slider. 
  String get timestamp {
    final Duration currentPosition = seekValue == null 
      ? video.position : doubleToDuration(seekValue!);
    return "${currentPosition.timestamp} / ${video.duration.timestamp}";
  }

  /// Updates the value of [video] whenever the controller updates.
  void listener() => setState(() {});

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  /// Converts a [Duration] object to a double. 
  /// 
  /// Used to allow a [Duration] object to be used with a [Slider].
  double durationToDouble(Duration duration) => 
    duration.inSeconds.toDouble();

  /// Converts a double to a [Duration] object.
  /// 
  /// This allows a [Slider] to output [Duration] values. 
  Duration doubleToDuration(double position) => 
    Duration(minutes: position ~/ 60, seconds: (position % 60).truncate());

  @override
  Widget build(BuildContext context) => IconTheme(
    data: const IconThemeData(color: Colors.white),
    child: Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              SliderTheme(
                data: SliderThemeData(thumbShape: SliderComponentShape.noThumb),
                child: Slider(
                  max: durationToDouble(video.duration),
                  value: durationToDouble(bufferedPosition),   
                  onChanged: null,         
                )
              ),
              Slider(
                max: durationToDouble(video.duration),
                value: seekValue ?? durationToDouble(video.position),
                onChanged: (double value) => setState(() => seekValue = value),
                onChangeEnd: (double value) {
                  setState(() => seekValue = null);
                  controller.seekTo(doubleToDuration(value));
                },
              ),
            ]
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(video.isPlaying ? Icons.pause : Icons.play_arrow ),
                onPressed: video.isPlaying ? controller.pause : controller.play,
              ),
              IconButton(
                icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: () => widget.controller.setVolume(isMuted ? 1 : 0),
              ),
              Text(
                timestamp,
                style: Theme.of(context).textTheme.caption
                  ?.copyWith(color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  controller.isFullScreen 
                    ? Icons.fullscreen_exit : Icons.fullscreen
                ),
                onPressed: controller.isFullScreen
                  ? widget.closeFullScreen: widget.openFullScreen,
              )
            ],
          )
        ]
      )
    )
  );
}
