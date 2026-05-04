import 'dart:developer';

import 'package:video_player/video_player.dart';

import '../../../../../config.dart';
import 'full_screen_video_player.dart';

class ChatVideo extends StatefulWidget {
  final dynamic snapshot;

  const ChatVideo({super.key, this.snapshot});

  @override
  State<ChatVideo> createState() => _ChatVideoState();
}

class _ChatVideoState extends State<ChatVideo> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.snapshot));
    initializeVideoPlayerFuture = videoController!.initialize();
    setState(() {});
    log("videoController :$videoController");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        route.pop(context);
        videoController!.value.isCompleted;
        videoController!.pause();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
                  child: AspectRatio(
                          aspectRatio: videoController!.value.aspectRatio,
                          // Use the VideoPlayer widget to display the video.
                          child: VideoPlayer(videoController!))
                      .height(220)
                      .width(Sizes.s200))
              .inkWell(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenVideoPlayer(
                                videoController: videoController!)),
                      )),
          IconButton(
              icon: Icon(
                      videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: appColor(context).appTheme.whiteColor)
                  .marginAll(Insets.i3)
                  .decorated(
                      color: appColor(context).appTheme.primary,
                      shape: BoxShape.circle),
              onPressed: () {
                log("videoController!.value::${videoController!.value.isPlaying}");
                if (videoController!.value.isPlaying) {
                  log("videoController!.value::${videoController!.value.isPlaying}");
                  videoController!.pause();
                } else {
                  // If the video is paused, play it.
                  videoController!.play();
                }
                setState(() {});
              }).center()
        ],
      ),
    );
  }
}
