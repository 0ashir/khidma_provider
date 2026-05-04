import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../config.dart';
import '../../../model/advertisement_model.dart';
import '../../../providers/app_pages_provider/boost_provider.dart';

class CommonAdsListLayout extends StatelessWidget {
  final AdvertisementModel? data;
  final GestureTapCallback? onTap;

  const CommonAdsListLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      return DateFormat('dd MMM, yyyy').format(date); // Adjust format as needed
    }

    YoutubePlayerController? playerController = YoutubePlayerController(
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
        initialVideoId:
            YoutubePlayer.convertUrlToId(data?.videoLink ?? "") ?? '');
    log("dataAAAAAA::${data!.status}");

    return Consumer<BoostProvider>(builder: (context, value, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Advertising Type
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(language(context, "Advertisement Type"),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.lightText)),
              ),
              Text(language(context, data!.type),
                      textAlign: TextAlign.end,
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.primary))
                  .paddingDirectional(vertical: Sizes.s5, horizontal: Sizes.s12)
                  .decorated(
                      borderRadius: BorderRadius.circular(Sizes.s4),
                      color: appColor(context)
                          .appTheme
                          .primary
                          .withValues(alpha: 0.2))
            ]).paddingDirectional(bottom: Sizes.s15),
        if (data?.bannerType == "image" || data!.type == 'service')
          SizedBox(
            height: Sizes.s130,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: data!.type == 'banner'
                  ? (data!.media.isNotEmpty
                      ? data!.media.first.originalUrl ?? ''
                      : '')
                  : data!.type == 'service'
                      ? (data!.services.isNotEmpty &&
                              data!.services.first.media.isNotEmpty
                          ? data!.services.first.media.first.originalUrl ?? ''
                          : '')
                      : '',
              placeholder: (context, url) => CommonCachedImage(
                image: eImageAssets.noImageFound2,
                height: Sizes.s84,
                width: Sizes.s84,
                radius: AppRadius.r10,
              ),
              errorWidget: (context, url, error) => CommonCachedImage(
                image: eImageAssets.noImageFound2,
                height: Sizes.s84,
                width: Sizes.s84,
                radius: AppRadius.r10,
              ),
              fit: BoxFit.cover,
            ),
          ),
        if (data?.bannerType == "video")
          SizedBox(
              height: Sizes.s130,
              child: AbsorbPointer(
                absorbing: playerController.value.isPlaying,
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: playerController,
                    showVideoProgressIndicator: true,
                  ),
                  builder: (context, player) {
                    return player;
                  },
                ),
              )),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(capitalizeFirstLetter(language(context, "Status")),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText)),
            Text(
                    capitalizeFirstLetter(
                        language(context, capitalizeFirstLetter(data!.status))),
                    style: appCss.dmDenseSemiBold12
                        .textColor(appColor(context).appTheme.whiteColor))
                .paddingDirectional(horizontal: Sizes.s12, vertical: Sizes.s4)
                .decorated(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Sizes.s30)),
                    color: data!.status == appFonts.pending
                        ? appColor(context).appTheme.pending
                        : data!.status == appFonts.reject
                            ? appColor(context).appTheme.red
                            : data!.status == 'approved'
                                ? appColor(context).appTheme.lightText
                                : appColor(context).appTheme.online),
          ],
        ).paddingDirectional(top: Sizes.s14, bottom: Sizes.s12),
        Image.asset(eImageAssets.bulletDotted),
        VSpace(Sizes.s11),
        buildRow(context, "App Screen", capitalizeFirstLetter(data!.screen)),
        buildRow(context, "Duration",
            "${formatDate(data!.startDate!)} - ${formatDate(data!.endDate!)}"),
        buildRow(context, "Zone", "${data!.zone}"),
      ])
          .paddingDirectional(all: Sizes.s15)
          .decorated(
              color: appColor(context).appTheme.whiteBg,
              border: Border.all(color: appColor(context).appTheme.stroke),
              borderRadius: SmoothBorderRadius(
                  cornerRadius: AppRadius.r10, cornerSmoothing: 1))
          .paddingDirectional(
              horizontal: Sizes.s20, bottom: Sizes.s10, top: Sizes.s5)
          .inkWell(onTap: onTap);
    });
  }

// Helper function to build rows
}

Widget buildRow(context, String label, String value, {Color? valueColor}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(language(context, label),
                  style: appCss.dmDenseMedium12.textColor(
                      valueColor ?? appColor(context).appTheme.lightText)),
            ),
            Text(language(context, value),
                textAlign: TextAlign.end,
                style: appCss.dmDenseSemiBold12.textColor(
                    valueColor ?? appColor(context).appTheme.darkText))
          ]));
}
