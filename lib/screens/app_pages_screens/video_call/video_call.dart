// import 'package:fixit_provider/screens/app_pages_screens/video_call/video_call_class.dart';
//
// import '../../../config.dart';
// import '../../../providers/app_pages_provider/video_call_provider.dart';
//
// class VideoCall extends StatefulWidget {
//   const VideoCall({super.key});
//
//   @override
//   State<VideoCall> createState() => _VideoCallState();
// }
//
// class _VideoCallState extends State<VideoCall> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     final call = Provider.of<VideoCallProvider>(context, listen: false);
//     call.init(context);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<VideoCallProvider>(builder: (_, video, child) {
//       return Scaffold(
//         backgroundColor: appColor(context).appTheme.fieldCardBg,
//         body: video.call == null
//             ? const Center(child: CircularProgressIndicator())
//             : Stack(
//                 children: [
//                   video.isCameraShow
//                       ? VideoCallClass().buildNormalVideoUI(context)
//                       : Container(
//                           color: appColor(context).appTheme.fieldCardBg,
//                           height: MediaQuery.of(context).size.height,
//                           width: MediaQuery.of(context).size.height,
//                         ),
//                   Column(
//                     children: [
//                       const VSpace(Sizes.s50),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(eSvgAssets.arrowLeft),
//                           Expanded(
//                               child: Text(video.call!.receiverName!,
//                                   textAlign: TextAlign.center,
//                                   style: appCss.dmDenseMedium18.textColor(
//                                       appColor(context).appTheme.darkText)))
//                         ],
//                       ),
//                       Text(video.getFormattedTime(),
//                               style: appCss.dmDenseBold20.textColor(
//                                   appColor(context).appTheme.darkText))
//                           .alignment(Alignment.center),
//                     ],
//                   ).paddingSymmetric(horizontal: Sizes.s20),
//                   Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Stack(
//                         alignment: Alignment.bottomCenter,
//                         children: [
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Image.asset(eImageAssets.bottomSub,
//                                   fit: BoxFit.fill,
//                                   width: MediaQuery.sizeOf(context).width),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(children: [
//                                     SvgPicture.asset(
//                                             isDark(context)
//                                                 ? eSvgAssets.chatBold
//                                                 : eSvgAssets.chat1,
//                                             height: Sizes.s24,
//                                             colorFilter: ColorFilter.mode(
//                                                 appColor(context)
//                                                     .appTheme
//                                                     .primary,
//                                                 BlendMode.srcIn))
//                                         .inkWell(
//                                             onTap: () =>
//                                                 video.chatTap(context)),
//                                     const HSpace(Sizes.s47),
//                                     SvgPicture.asset(
//                                             isDark(context)
//                                                 ? eSvgAssets.volumeBold
//                                                 : eSvgAssets.volume,
//                                             height: Sizes.s24,
//                                             colorFilter: ColorFilter.mode(
//                                                 appColor(context)
//                                                     .appTheme
//                                                     .primary,
//                                                 BlendMode.srcIn))
//                                         .inkWell(
//                                             onTap: () =>
//                                                 video.onToggleSpeaker())
//                                   ]),
//                                   Row(
//                                     children: [
//                                       SvgPicture.asset(
//                                               isDark(context)
//                                                   ? eSvgAssets.microphoneBold
//                                                   : eSvgAssets.microphone1,
//                                               height: Sizes.s24,
//                                               colorFilter: ColorFilter.mode(
//                                                   appColor(context)
//                                                       .appTheme
//                                                       .primary,
//                                                   BlendMode.srcIn))
//                                           .inkWell(
//                                               onTap: () =>
//                                                   video.onToggleMute()),
//                                       const HSpace(Sizes.s47),
//                                       SvgPicture.asset(
//                                               video.call!.isVideoCall!
//                                                   ? eSvgAssets.video
//                                                   : isDark(context)
//                                                       ? eSvgAssets.videoHideBold
//                                                       : eSvgAssets.videoHide,
//                                               height: Sizes.s24,
//                                               colorFilter: ColorFilter.mode(
//                                                   appColor(context)
//                                                       .appTheme
//                                                       .primary,
//                                                   BlendMode.srcIn))
//                                           .inkWell(
//                                               onTap: () => video.videoTap())
//                                     ],
//                                   )
//                                 ],
//                               ).padding(horizontal: Sizes.s32, top: 10)
//                             ],
//                           ),
//                           Align(
//                             alignment: Alignment.topCenter,
//                             child: SizedBox(
//                               height: Sizes.s50,
//                               width: Sizes.s50,
//                               child: SvgPicture.asset(
//                                 eSvgAssets.call,
//                                 fit: BoxFit.scaleDown,
//                               ),
//                             )
//                                 .decorated(
//                                     shape: BoxShape.circle,
//                                     color: appColor(context).appTheme.red)
//                                 .paddingAll(3)
//                                 .decorated(
//                                     shape: BoxShape.circle,
//                                     color: appColor(context).appTheme.trans)
//                                 .inkWell(onTap: () => video.onEndCall(context)),
//                           )
//                         ],
//                       ).height(100))
//                 ],
//               ),
//       );
//     });
//   }
// }
