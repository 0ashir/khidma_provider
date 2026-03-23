import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../config.dart';

class ServiceImageLayout extends StatelessWidget {
  final String? image, rating, title;
  final GestureTapCallback? editTap, deleteTap, onBack;
  final bool isActionShow;
  const ServiceImageLayout(
      {super.key,
      this.rating,
      this.image,
      this.deleteTap,
      this.editTap,
      this.onBack,
      this.isActionShow = true,
      this.title});

  @override
  Widget build(BuildContext context) {
    final sevrviceDetails =
        Provider.of<ServiceDetailsProvider>(context, listen: false);
    /*  final sevrviceDetails =
        Provider.of<ServiceDetailsProvider>(context, listen: false);
    sevrviceDetails
        .initializeVideoControllers(sevrviceDetails.services?.video ?? ""); */

    YoutubePlayerController? playerController = YoutubePlayerController(
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
        initialVideoId: YoutubePlayer.convertUrlToId(
                sevrviceDetails.services?.video ?? "") ??
            '');
    // Initialize controllers only once
    /*  if (sevrviceDetails.videoControllers.isEmpty) {
      sevrviceDetails.initializeVideoControllers(sevrviceDetails.videoUrls);
    } */
    return Consumer<ServiceDetailsProvider>(builder: (context, value, child) {
      return Stack(children: [
        value.isVideo == true
            ? SizedBox(
                height: Sizes.s230,
                child: GestureDetector(
                  onTap: () {
                    print("object=-=-=-=-=-=-=-=-=-");
                    if (playerController.value.isPlaying) {
                      playerController.play();
                    } else {
                      playerController.pause();
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: playerController.value.isPlaying,
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller:
                            playerController /* YoutubePlayerController(
                            flags: const YoutubePlayerFlags(
                              autoPlay: true,
                              mute: false,
                              disableDragSeek: true,
                            ),
                            initialVideoId: YoutubePlayer.convertUrlToId(
                                    value.services?.video ?? "") ??
                                '') */
                        ,
                        showVideoProgressIndicator: true,
                      ),
                      /*  YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: YoutubePlayer.convertUrlToId(
                                  value.services?.video ?? "") ??
                              '',
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                        // showVideoProgressIndicator: true,
                      ), */
                      builder: (context, player) {
                        return player;
                      },
                    ),
                  ),
                )).inkWell(onTap: () {
                print("object=-=-=-=-=-=-=-=-=-=-=-");
                if (playerController.value.isPlaying) {
                  playerController.play();
                } else {
                  playerController.pause();
                }
                /*  if (value.videoControllers!.value.isPlaying) {
                    value.videoControllers?.play();
                  } else {
                    value.videoControllers?.pause();
                  } */
              })
            : image != null
                ? CachedNetworkImage(
                    imageUrl: image!,
                    imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: Sizes.s230,
                        decoration: ShapeDecoration(
                            shadows: [
                              BoxShadow(
                                  color: appColor(context)
                                      .appTheme
                                      .darkText
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 3)
                            ],
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            shape: const SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.only(
                                    bottomRight: SmoothRadius(
                                        cornerRadius: AppRadius.r20,
                                        cornerSmoothing: 1),
                                    bottomLeft: SmoothRadius(
                                        cornerRadius: AppRadius.r20,
                                        cornerSmoothing: 1))))),
                    placeholder: (context, url) => CommonCachedImage(
                        isAllBorderRadius: false,
                        width: MediaQuery.of(context).size.width,
                        height: Sizes.s230,
                        image: eImageAssets.noImageFound2,
                        boxFit: BoxFit.cover),
                    errorWidget: (context, url, error) => CommonCachedImage(
                        isAllBorderRadius: false,
                        width: MediaQuery.of(context).size.width,
                        height: Sizes.s230,
                        image: eImageAssets.noImageFound2,
                        boxFit: BoxFit.cover),
                  )
                : CommonCachedImage(
                    isAllBorderRadius: false,
                    width: MediaQuery.of(context).size.width,
                    height: Sizes.s230,
                    image: eImageAssets.noImageFound2,
                    boxFit: BoxFit.cover,
                  ),
        if (value.isVideo != true)
          SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: Sizes.s230,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonArrow(
                                  arrow: rtl(context)
                                      ? eSvgAssets.arrowRight
                                      : eSvgAssets.arrowLeft,
                                  onTap: onBack),
                              if (isActionShow)
                                Row(children: [
                                  CommonArrow(
                                      arrow: eSvgAssets.edit,
                                      svgColor:
                                          appColor(context).appTheme.darkText,
                                      onTap: editTap),
                                  const HSpace(Sizes.s15),
                                  CommonArrow(
                                      arrow: eSvgAssets.delete,
                                      svgColor: appColor(context).appTheme.red,
                                      color: const Color(0xffFFEDED),
                                      onTap: deleteTap)
                                ])
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(title!,
                                    style: appCss.dmDenseSemiBold18.textColor(
                                        appColor(context).appTheme.whiteColor)),
                              ),
                              if (rating != null)
                                Row(children: [
                                  SvgPicture.asset(eSvgAssets.star),
                                  const HSpace(Sizes.s4),
                                  Text(rating!,
                                      style: appCss.dmDenseMedium13.textColor(
                                          appColor(context)
                                              .appTheme
                                              .whiteColor))
                                ])
                            ])
                      ]).padding(
                      horizontal: Insets.i20,
                      top: Insets.i30,
                      bottom: Insets.i20))
              .decorated(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.r20),
                      right: Radius.circular(AppRadius.r20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        appColor(context).appTheme.trans,
                        appColor(context).appTheme.darkText.withOpacity(0.3)
                      ]))
      ]);
    });
  }
}
