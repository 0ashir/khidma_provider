// import 'dart:developer';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
//
// import '../../../../config.dart';
// import '../../../providers/app_pages_provider/video_call_provider.dart';
//
// class VideoCallClass {
//   //build video call view
//
//   Widget buildNormalVideoUI(context) {
//     return Consumer<VideoCallProvider>(builder: (_,videoCtrl,c) {
//
//       return SizedBox(height: MediaQuery.sizeOf(context).height, child: buildJoinUserUI(videoCtrl,context),);
//     });
//   }
//
//   //join user
//   Widget buildJoinUserUI(VideoCallProvider? videoCtrl,context) {
//     final views = _getRenderViews(videoCtrl);
//     log("views : ${views.length}");
//     switch (views.length) {
//       case 1:
//         return Column(
//           children: <Widget>[_videoView(views[0])],
//         );
//       case 2:
//         return Consumer<VideoCallProvider>(builder: (_,videoCtrl,c) {
//           return SizedBox(
//               width: MediaQuery.sizeOf(context).width,
//               height: MediaQuery.sizeOf(context).height,
//               child: Stack(children: <Widget>[
//                 Align(
//                     alignment: Alignment.topLeft,
//                     child: Column(children: <Widget>[
//                       _expandedVideoRow([views[1]])
//                     ])),
//                 Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: Sizes.s8, color: Colors.white38),
//                             borderRadius: BorderRadius.circular(Insets.i10)),
//                         margin: const EdgeInsets.fromLTRB(
//                             Insets.i15, Insets.i40, Insets.i10, Insets.i15),
//                         width: Sizes.s110,
//                         height: Sizes.s140,
//                         child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               _expandedVideoRow([views[0]])
//                             ])))
//               ]));
//         });
//       case 3:
//         return Column(children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 2)),
//           _expandedVideoRow(views.sublist(2, 3))
//         ]);
//       case 4:
//         return Column(children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 2)),
//           _expandedVideoRow(views.sublist(2, 4))
//         ]);
//       default:
//     }
//     return Container();
//   }
//
//   //user view
//   List<Widget> _getRenderViews(VideoCallProvider? videoCallCtrl) {
//     final List<AgoraVideoView> list = [
//       AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: videoCallCtrl!.engine,
//           canvas: const VideoCanvas(uid: 0),
//         ),
//       )
//     ];
//     videoCallCtrl.users
//         .asMap()
//         .entries
//         .forEach((uid) => list.add(AgoraVideoView(
//               controller: VideoViewController(
//                 rtcEngine: videoCallCtrl.engine!,
//                 canvas: VideoCanvas(uid: uid.value),
//               ),
//             )));
//
//     log("AGORA : $list");
//     return list;
//   }
//
//   //video view
//   Widget _videoView(view) {
//     return Consumer<VideoCallProvider>(builder: (_,videoCtrl,c) {
//       return Expanded(child: Container(child: view));
//     });
//   }
//
//   //multiple user add view
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Consumer<VideoCallProvider>(builder: (_,videoCtrl,c) {
//       return Expanded(child: Row(children: wrappedViews));
//     });
//   }
// }
