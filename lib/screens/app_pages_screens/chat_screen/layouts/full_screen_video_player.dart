

import 'dart:developer';

import 'package:video_player/video_player.dart';

import '../../../../config.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;

  const FullScreenVideoPlayer({super.key, required this.videoController});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          route.pop(context);
          widget.videoController.value.isCompleted;
          widget.videoController.pause();
        },
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: VideoPlayer(widget.videoController),
              ),
            ),
            BackButton(
              color: appColor(context).appTheme.whiteColor,
              onPressed: () {
                route.pop(context);
                widget.videoController.value.isCompleted;
                widget.videoController.pause();
              },
            ).paddingDirectional(top: Sizes.s50),
            IconButton(
                icon: Icon(
                        widget.videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: appColor(context).appTheme.whiteColor)
                    .marginAll(Insets.i3)
                    .decorated(
                        color: appColor(context).appTheme.primary,
                        shape: BoxShape.circle),
                onPressed: () {
                  log("widget.videoController.value::${widget.videoController.value.isPlaying}");
                  if (widget.videoController.value.isPlaying) {
                    log("widget.videoController.value::${widget.videoController.value.isPlaying}");
                    widget.videoController.pause();
                  } else {
                    // If the video is paused, play it.
                    widget.videoController.play();
                  }
                  setState(() {});
                }).center()
          ],
        ),
      ),
    );
  }
}
