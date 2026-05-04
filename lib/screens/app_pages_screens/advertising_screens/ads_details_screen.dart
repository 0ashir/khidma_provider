// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../config.dart';
import '../../../providers/app_pages_provider/ads_detail_provider.dart';

class AdsDetailsScreen extends StatelessWidget {
  const AdsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sevrviceDetails =
        Provider.of<AdsDetailProvider>(context, listen: false);

    YoutubePlayerController? playerController = YoutubePlayerController(
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
        initialVideoId: YoutubePlayer.convertUrlToId(
                sevrviceDetails.advertisingModel?.videoLink ?? "") ??
            '');
    return Consumer<AdsDetailProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(const Duration(milliseconds: 150))
            .then((_) => value.onReady(context, value.advertisingModel?.id)),
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            value.onBack(context);
            if (didPop) return;
          },
          child: Scaffold(
              body: value.advertisingModel == null
                  ? Container()
                  : RefreshIndicator(
                      onRefresh: () => value.getAdvertisementList(
                          context, value.advertisingModel?.id),
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  if (value.advertisingModel!.bannerType ==
                                      "video")
                                    SizedBox(
                                        height: Sizes.s230,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (playerController
                                                .value.isPlaying) {
                                              playerController.play();
                                            } else {
                                              playerController.pause();
                                            }
                                          },
                                          child: AbsorbPointer(
                                            absorbing: playerController
                                                .value.isPlaying,
                                            child: YoutubePlayerBuilder(
                                              player: YoutubePlayer(
                                                controller: playerController,
                                                showVideoProgressIndicator:
                                                    true,
                                              ),
                                              builder: (context, player) {
                                                return player;
                                              },
                                            ),
                                          ),
                                        )).inkWell(onTap: () {
                                      if (playerController.value.isPlaying) {
                                        playerController.play();
                                      } else {
                                        playerController.pause();
                                      }
                                    }),
                                  value.advertisingModel!.bannerType != "image"
                                      ? const SizedBox.shrink()
                                      : CachedNetworkImage(
                                          imageUrl: value.selectedImage ?? "",
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                  height: Sizes.s230,
                                                  decoration: ShapeDecoration(
                                                      shadows: [
                                                        BoxShadow(
                                                            color: appColor(
                                                                    context)
                                                                .appTheme
                                                                .darkText
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 8,
                                                            spreadRadius: 3)
                                                      ],
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill),
                                                      shape: const SmoothRectangleBorder(
                                                          borderRadius: SmoothBorderRadius.only(
                                                              bottomRight: SmoothRadius(
                                                                  cornerRadius:
                                                                      AppRadius
                                                                          .r20,
                                                                  cornerSmoothing:
                                                                      1),
                                                              bottomLeft: SmoothRadius(
                                                                  cornerRadius:
                                                                      AppRadius
                                                                          .r20,
                                                                  cornerSmoothing:
                                                                      1))))),
                                          placeholder: (context, url) =>
                                              CommonCachedImage(
                                                  isAllBorderRadius: false,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: Sizes.s230,
                                                  image: eImageAssets
                                                      .noImageFound2,
                                                  boxFit: BoxFit.cover),
                                          errorWidget: (context, url, error) =>
                                              CommonCachedImage(
                                                  isAllBorderRadius: false,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: Sizes.s230,
                                                  image: eImageAssets
                                                      .noImageFound2,
                                                  boxFit: BoxFit.cover),
                                        ),
                                  SizedBox(
                                    height: Sizes.s130,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: Sizes.s30,
                                          width: Sizes.s30,
                                          child: SvgPicture.asset(
                                            eSvgAssets.arrowLeft,
                                            color: appColor(context)
                                                .appTheme
                                                .darkText,
                                          ).paddingAll(Sizes.s8),
                                        )
                                            .decorated(
                                                shape: BoxShape.circle,
                                                color: appColor(context)
                                                    .appTheme
                                                    .fieldCardBg)
                                            .inkWell(
                                                onTap: () =>
                                                    route.pop(context)),
                                      ],
                                    ),
                                  ).padding(
                                      top: Sizes.s30, horizontal: Sizes.s20),
                                ],
                              ),
                              const VSpace(Sizes.s12),
                              if (value.advertisingModel?.media != [])
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: value
                                              .advertisingModel!.media!
                                              .asMap()
                                              .entries
                                              .map((e) => Container(
                                                    height: Sizes.s60,
                                                    width: Sizes.s60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: Insets.i5),
                                                    child: Image.network(
                                                        e.value.originalUrl ??
                                                            "",
                                                        height: Sizes.s60,
                                                        width: Sizes.s60,
                                                        fit: BoxFit.cover),
                                                  ).inkWell(onTap: () {
                                                    value.onHomeImageChange(
                                                        e.key,
                                                        e.value.originalUrl);
                                                  }))
                                              .toList())
                                    ])),
                              Stack(alignment: Alignment.center, children: [
                                Image.asset(eImageAssets.servicesBg,
                                    width: MediaQuery.of(context).size.width),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          language(
                                              context, translations!.amount),
                                          style: appCss.dmDenseMedium12
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .primary)),
                                      // Text(
                                      //     "${getSymbol(context)}${currency(context).currencyVal * (value.advertisingModel?.price ?? 0)}",
                                      //     style: appCss.dmDenseBold18.textColor(
                                      //         appColor(context)
                                      //             .appTheme
                                      //             .primary))
                                    ]).paddingSymmetric(horizontal: Insets.i20)
                              ]).paddingSymmetric(
                                  vertical: Insets.i15, horizontal: Insets.i20),
                              Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                    const VSpace(Sizes.s10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: DescriptionLayoutCommon(
                                                  icon: eSvgAssets.status,
                                                  title: language(
                                                      context,
                                                      translations!
                                                          .status) /* translations!.duration */,
                                                  subtitle: value
                                                          .advertisingModel
                                                          ?.status ??
                                                      "")
                                              .paddingSymmetric(
                                                  horizontal: Insets.i25),
                                        ),
                                        Container(
                                            height: Sizes.s38,
                                            width: 1,
                                            color: appColor(context)
                                                .appTheme
                                                .stroke),
                                        Expanded(
                                          child: DescriptionLayoutCommon(
                                                  icon: eSvgAssets.appScreen,
                                                  title: language(
                                                      context,
                                                      translations!
                                                          .screen /* "Screen" */) /* translations!.duration */,
                                                  subtitle: value
                                                          .advertisingModel
                                                          ?.screen ??
                                                      "")
                                              .paddingSymmetric(
                                                  horizontal: Insets.i25),
                                        ),
                                      ],
                                    ),
                                    const VSpace(Sizes.s20),
                                    DescriptionLayoutCommon(
                                            icon: eSvgAssets.clock,
                                            title: translations!.duration,
                                            subtitle:
                                                "${value.advertisingModel!.startDate}  - ${value.advertisingModel?.endDate}")
                                        .paddingSymmetric(
                                            horizontal: Insets.i25),
                                    const VSpace(Sizes.s20),
                                    DescriptionLayoutCommon(
                                            icon: eSvgAssets.adsType,
                                            title: language(
                                                context, "Advertisement Type"),
                                            subtitle:
                                                value.advertisingModel?.type ??
                                                    "")
                                        .paddingSymmetric(
                                            horizontal: Insets.i25),
                                    const VSpace(Sizes.s20),
                                  ])
                                  .decorated(
                                      color: appColor(context).appTheme.whiteBg,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 3,
                                            spreadRadius: 2,
                                            color: appColor(context)
                                                .appTheme
                                                .darkText
                                                .withOpacity(0.06))
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.r10))
                                  .padding(
                                      horizontal: Sizes.s20, top: Sizes.s10)
                            ],
                          ),
                        ),
                      ),
                    )),
        ),
      );
    });
  }
}
