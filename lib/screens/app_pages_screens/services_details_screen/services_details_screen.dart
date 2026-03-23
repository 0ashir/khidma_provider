// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/services_details_screen/service_detail_shimmer/services_details_shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../config.dart';

class ServicesDetailsScreen extends StatefulWidget {
  const ServicesDetailsScreen({super.key});

  @override
  State<ServicesDetailsScreen> createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ServiceDetailsProvider, LocationProvider,
            AddNewServiceProvider>(
        builder: (context1, value, val, addService, child) {
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: Container(
              color: appColor(context).appTheme.whiteBg,
              child: SafeArea(
                  child: StatefulWrapper(
                      onInit:
                          () => /* value.onReady(
                          context) */
                              Future.delayed(DurationsDelay.ms150)
                                  .then((_) => value.onReady(context)),
                      child: RefreshIndicator(
                          onRefresh: () {
                            return value.onRefresh(context);
                          },
                          child: Scaffold(
                              body: (value.serviceLoader == true)
                                  ? const ServiceDetailShimmer()
                                  : value.services != null
                                      ? SingleChildScrollView(
                                          child: Column(children: [
                                          ServiceImageLayout(
                                            onBack: () =>
                                                value.onBack(context, true),
                                            editTap: () {
                                              /*  addService.isEdit = true; */
                                              addService
                                                  .getServiceDetails(context);
                                              addService
                                                  .getServiceDetails(context);
                                              // log("value.services::${value.services!.addressId}");
                                              log("value.services::${value.services!.toJson()}");
                                              route.pushNamed(context,
                                                      routeName.addNewService,
                                                      arg: {
                                                    "isEdit": true,
                                                    "service": value.services!
                                                        .toJson(),
                                                    "serviceFaq":
                                                        value.serviceFaq,
                                                  }) /* .then((e) =>
                                                  /* addService.getServiceDetails(
                                                      context)  */
                                                  value.getServiceId(context)) */
                                                  ;
                                            },
                                            deleteTap: () => value
                                                .onServiceDelete(context, this),
                                            title: /* value.isImage
                                                  .toString() */
                                                value.services!.title!,
                                            image: value
                                                    .services!.media!.isNotEmpty
                                                ? value
                                                    .services!
                                                    .media![value.selectedIndex]
                                                    .originalUrl!
                                                : "",
                                            /*  rating: value.services!
                                                          .ratingCount !=
                                                      null
                                                  ? value.services!.ratingCount!
                                                      .toString()
                                                  : "0"*/
                                          ),
                                          if (value.services!.media != null &&
                                              value.services!.media!.length > 1)
                                            const VSpace(Sizes.s12),
                                          // if (value.services!.media != null ||
                                          //     value.services!.media!.length > 1)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                const HSpace(Sizes.s25),
                                                /* Text(
                                                      "${value.services}"), */
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: value
                                                        .services!.media!
                                                        .asMap()
                                                        .entries
                                                        .map<Widget>((e) =>
                                                            ServicesImageLayout(
                                                              data: e.value
                                                                  .originalUrl,
                                                              index: e.key,
                                                              selectIndex: value
                                                                  .selectedIndex,
                                                              onTap: () => value
                                                                  .onImageChange(
                                                                      e.key,
                                                                      e.value
                                                                          .originalUrl!),
                                                            ))
                                                        .toList()),
                                                /*    Text(value.services?.video ??
                                                    "ftgv"), */
                                                if (value.services?.video !=
                                                        null &&
                                                    value.services?.video != "")
                                                  SizedBox(
                                                    height: Sizes.s60,
                                                    width: Sizes.s60,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        print(
                                                            "object=-=-=-${value.services?.video}");
                                                        /*  value.onVideo(); */
                                                      },
                                                      child: AbsorbPointer(
                                                        child:
                                                            YoutubePlayerBuilder(
                                                          player: YoutubePlayer(
                                                            controller:
                                                                YoutubePlayerController(
                                                              initialVideoId:
                                                                  YoutubePlayer.convertUrlToId(value
                                                                              .services
                                                                              ?.video ??
                                                                          "") ??
                                                                      '',
                                                              flags:
                                                                  const YoutubePlayerFlags(
                                                                autoPlay: false,
                                                                mute: false,
                                                              ),
                                                            ),
                                                            /*  showVideoProgressIndicator:
                                                                false, */
                                                          ),
                                                          builder: (context,
                                                              player) {
                                                            return player;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ).padding(right: Sizes.s10)
                                              ],
                                            ),
                                          ),
                                          Column(children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                      eImageAssets.servicesBg,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            language(
                                                                context,
                                                                translations!
                                                                    .amount),
                                                            style: appCss
                                                                .dmDenseMedium12
                                                                .textColor(appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .primary)),
                                                        Text(
                                                            symbolPosition
                                                                ? "${getSymbol(context)}${(currency(context).currencyVal * (value.services!.price!)).toStringAsFixed(2)}"
                                                                : "${(currency(context).currencyVal * (value.services!.price!)).toStringAsFixed(2)}${getSymbol(context)}",
                                                            style: appCss
                                                                .dmDenseBold18
                                                                .textColor(appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .primary))
                                                      ]).paddingSymmetric(
                                                      horizontal: Insets.i20)
                                                ]).paddingSymmetric(
                                                vertical: Insets.i15),
                                            ServiceDescription(
                                                services: value.services),
                                            if (value.serviceFaq.isNotEmpty)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const VSpace(Sizes.s10),
                                                  Text(
                                                      language(context,
                                                          translations!.faq),
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: appCss
                                                          .dmDenseBold16
                                                          .textColor(
                                                              appColor(context)
                                                                  .appTheme
                                                                  .darkText)),
                                                  const VSpace(Sizes.s10),
                                                  ...value.serviceFaq
                                                      .asMap()
                                                      .entries
                                                      .map((e) => Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        Sizes
                                                                            .s8),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        Sizes
                                                                            .s20),
                                                            decoration: ShapeDecoration(
                                                                shadows: [
                                                                  BoxShadow(
                                                                      blurRadius:
                                                                          2,
                                                                      spreadRadius:
                                                                          2,
                                                                      color: appColor(
                                                                              context)
                                                                          .appTheme
                                                                          .darkText
                                                                          .withOpacity(
                                                                              0.06))
                                                                ],
                                                                color: appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .whiteBg,
                                                                shape: SmoothRectangleBorder(
                                                                    borderRadius: SmoothBorderRadius(
                                                                        cornerRadius:
                                                                            8,
                                                                        cornerSmoothing:
                                                                            1))),
                                                            child: ExpansionTile(
                                                                expansionAnimationStyle: AnimationStyle(
                                                                    curve: Curves
                                                                        .fastOutSlowIn),
                                                                key: Key(value.selected
                                                                    .toString()),
                                                                initiallyExpanded: e.key ==
                                                                    value
                                                                        .selected,
                                                                onExpansionChanged: (newState) =>
                                                                    value.onExpansionChange(
                                                                        newState,
                                                                        e.key),
                                                                tilePadding: EdgeInsets
                                                                    .zero,
                                                                collapsedIconColor:
                                                                    appColor(context)
                                                                        .appTheme
                                                                        .darkText,
                                                                dense: true,
                                                                iconColor: appColor(context)
                                                                    .appTheme
                                                                    .darkText,
                                                                title: Text(
                                                                    e.value.question ?? "",
                                                                    style: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.darkText)),
                                                                children: <Widget>[
                                                                  Divider(
                                                                      color: appColor(
                                                                              context)
                                                                          .appTheme
                                                                          .stroke,
                                                                      height:
                                                                          .5,
                                                                      thickness:
                                                                          0),
                                                                  ListTile(
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal: Sizes
                                                                              .s5),
                                                                      title: Text(
                                                                          e.value.answer ??
                                                                              "",
                                                                          style: appCss.dmDenseLight14.textColor(appColor(context)
                                                                              .appTheme
                                                                              .darkText
                                                                              .withOpacity(.8))))
                                                                ]),
                                                          )),
                                                  if (value.services!.reviews !=
                                                          null &&
                                                      value.services!.reviews!
                                                          .isEmpty)
                                                    const SizedBox(
                                                        height: Sizes.s20)
                                                ],
                                              ).marginOnly(top: Sizes.s10),
                                          ]).paddingSymmetric(
                                              horizontal: Insets.i20),

                                          /*  if (value.services!.reviews != null &&
                                              value.services!.reviews!
                                                  .isNotEmpty)
                                            Column(children: [
                                              if (value.services!.reviews != null &&
                                                  value.services!.reviews!
                                                      .isNotEmpty)
                                                HeadingRowCommon(
                                                    isViewAllShow: value
                                                            .services!
                                                            .reviews!
                                                            .length >=
                                                        10,
                                                    title: translations!.review,
                                                    onTap: () => route.pushNamed(
                                                            context,
                                                            routeName.serviceReview,
                                                            arg: {
                                                              "service":
                                                                  value.services
                                                            })).paddingOnly(
                                                    bottom: Insets.i12),
                                              ...value.services!.reviews!
                                                  .asMap()
                                                  .entries
                                                  .map((e) =>
                                                      ServiceReviewLayout(
                                                          data: e.value,
                                                          index: e.key,
                                                          list: value.services!
                                                              .reviews!))
                                            ]).paddingDirectional(
                                                all: Insets.i20,
                                                bottom: Sizes.s30) */
                                          if (value.services!.reviews != null &&
                                              value.services!.reviews!
                                                  .isNotEmpty)
                                            Column(
                                              children: [
                                                HeadingRowCommon(
                                                        isViewAllShow: value
                                                                .services!
                                                                .reviews!
                                                                .length >=
                                                            10,
                                                        title: translations!.review,
                                                        onTap: () {
                                                          Provider.of<ServiceReviewProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getMyReview(
                                                                  context);
                                                          route.pushNamed(
                                                              context,
                                                              routeName
                                                                  .serviceReview);
                                                        })
                                                    .paddingOnly(
                                                        bottom: Insets.i12),
                                                ...value.services!.reviews!
                                                    .asMap()
                                                    .entries
                                                    .map((e) => SizedBox(
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                              ListTile(
                                                                dense: true,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                leading: (e.value['consumer']?['media'] != null &&
                                                                        e.value['consumer']['media']
                                                                            is List &&
                                                                        e
                                                                            .value['consumer'][
                                                                                'media']
                                                                            .isNotEmpty)
                                                                    ? CachedNetworkImage(
                                                                        imageUrl:
                                                                            e.value['consumer']['media'][0]['original_url'] ??
                                                                                "",
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                Container(
                                                                          height:
                                                                              Sizes.s40,
                                                                          width:
                                                                              Sizes.s40,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            image:
                                                                                DecorationImage(image: imageProvider),
                                                                          ),
                                                                        ),
                                                                        placeholder: (context, url) => CommonCachedImage(
                                                                            height: Sizes
                                                                                .s40,
                                                                            width: Sizes
                                                                                .s40,
                                                                            isCircle:
                                                                                true,
                                                                            image:
                                                                                eImageAssets.noImageFound1),
                                                                        errorWidget: (context, url, error) => CommonCachedImage(
                                                                            height: Sizes
                                                                                .s40,
                                                                            width: Sizes
                                                                                .s40,
                                                                            isCircle:
                                                                                true,
                                                                            image:
                                                                                eImageAssets.noImageFound1),
                                                                      )
                                                                    : CommonCachedImage(
                                                                        height: Sizes
                                                                            .s40,
                                                                        width: Sizes
                                                                            .s40,
                                                                        isCircle:
                                                                            true,
                                                                        image: eImageAssets
                                                                            .noImageFound1),
                                                                title: Text(
                                                                  e.value['consumer']
                                                                          ?[
                                                                          'name'] ??
                                                                      "",
                                                                  style: appCss
                                                                      .dmDenseMedium14
                                                                      .textColor(appColor(
                                                                              context)
                                                                          .appTheme
                                                                          .darkText),
                                                                ),
                                                                subtitle: e.value[
                                                                            'created_at'] !=
                                                                        null
                                                                    ? Text(
                                                                        getTime(
                                                                            DateTime.parse(e.value['created_at'])),
                                                                        style: appCss
                                                                            .dmDenseMedium12
                                                                            .textColor(appColor(context).appTheme.lightText),
                                                                      )
                                                                    : Container(),
                                                                trailing: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                        eSvgAssets
                                                                            .star),
                                                                    const HSpace(
                                                                        Sizes
                                                                            .s4),
                                                                    Text(
                                                                      e.value['rating']
                                                                          .toString(),
                                                                      style: appCss
                                                                          .dmDenseMedium12
                                                                          .textColor(appColor(context)
                                                                              .appTheme
                                                                              .darkText),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const VSpace(
                                                                  Sizes.s5),
                                                              Text(
                                                                e.value['description'] ??
                                                                    "",
                                                                style: appCss
                                                                    .dmDenseRegular12
                                                                    .textColor(appColor(
                                                                            context)
                                                                        .appTheme
                                                                        .darkText),
                                                              ).paddingOnly(
                                                                  bottom: Insets
                                                                      .i15),
                                                            ]))
                                                            .paddingSymmetric(
                                                                horizontal:
                                                                    Insets.i15)
                                                            .boxBorderExtension(
                                                                context,
                                                                bColor: appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .stroke))
                                              ],
                                            ).paddingDirectional(
                                                all: Insets.i20,
                                                bottom: Sizes.s30)
                                        ]))
                                      : null))))));
    });
  }
}
