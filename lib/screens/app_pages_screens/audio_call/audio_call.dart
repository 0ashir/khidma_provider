// import '../../../config.dart';
// import '../../../providers/app_pages_provider/audio_call_provider.dart';
//
// class AudioCall extends StatefulWidget {
//   const AudioCall({super.key});
//
//   @override
//   State<AudioCall> createState() => _AudioCallState();
// }
//
// class _AudioCallState extends State<AudioCall> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     final call = Provider.of<AudioCallProvider>(context, listen: false);
//     call.init(context);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AudioCallProvider>(builder: (_, audio, child) {
//       return Scaffold(
//         backgroundColor: appColor(context).appTheme.fieldCardBg,
//         body: audio.call == null
//             ? Center(child: CircularProgressIndicator())
//             : Stack(
//                 children: [
//                   Column(
//                     children: [
//                       const VSpace(Sizes.s50),
//                       Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(eSvgAssets.arrowLeft),
//                             Expanded(
//                                 child: Text(audio.call!.receiverName!,
//                                     textAlign: TextAlign.center,
//                                     style: appCss.dmDenseMedium18.textColor(
//                                         appColor(context).appTheme.darkText)))
//                           ]),
//                       Text(audio.getFormattedTime(),
//                               style: appCss.dmDenseBold20.textColor(
//                                   appColor(context).appTheme.darkText))
//                           .alignment(Alignment.center),
//                     ],
//                   ).paddingSymmetric(horizontal: Sizes.s20),
//                   Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                               height: Sizes.s140,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image:
//                                           NetworkImage(audio.call!.callerPic!)),
//                                   shape: BoxShape.circle))
//                           .paddingAll(5.11)
//                           .decorated(
//                               color: appColor(context).appTheme.whiteBg,
//                               shape: BoxShape.circle)),
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
//                                                 audio.chatTap(context)),
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
//                                                 audio.onToggleSpeaker())
//                                   ]),
//                                   Row(children: [
//                                     SvgPicture.asset(
//                                             isDark(context)
//                                                 ? eSvgAssets.microphoneBold
//                                                 : eSvgAssets.microphone1,
//                                             height: Sizes.s24,
//                                             colorFilter: ColorFilter.mode(
//                                                 appColor(context)
//                                                     .appTheme
//                                                     .primary,
//                                                 BlendMode.srcIn))
//                                         .inkWell(
//                                             onTap: () => audio.onToggleMute()),
//                                     const HSpace(Sizes.s47),
//                                     SvgPicture.asset(
//                                             audio.call!.isVideoCall!
//                                                 ? eSvgAssets.video
//                                                 : isDark(context)
//                                                     ? eSvgAssets.videoHideBold
//                                                     : eSvgAssets.videoHide,
//                                             height: Sizes.s24,
//                                             colorFilter: ColorFilter.mode(
//                                                 appColor(context)
//                                                     .appTheme
//                                                     .primary,
//                                                 BlendMode.srcIn))
//                                         .inkWell(onTap: () => audio.videoTap())
//                                   ])
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
//                                 .inkWell(onTap: () => audio.onCallEnd(context)),
//                           )
//                         ],
//                       ).height(100))
//                 ],
//               ),
//       );
//     });
//   }
// }
