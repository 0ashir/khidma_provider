import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../../config.dart';

class StatusDetailLayout extends StatelessWidget {
  final BookingModel? data;
  final GestureTapCallback? onPhone, onTapStatus;

  const StatusDetailLayout({
    super.key,
    this.data,
    this.onTapStatus,
    this.onPhone,
  });

  @override
  Widget build(BuildContext context) {
    log("data!.consumer!.fcmToken::${data!.consumer!.fcmToken}");
    return SingleChildScrollView(
      child: data != null && data!.service != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data!.service!.media != null &&
                            data!.service!.media!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                data?.service?.media?.first.originalUrl ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              height: Sizes.s140,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: AppRadius.r10,
                                      cornerSmoothing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => CommonCachedImage(
                              height: Sizes.s140,
                              image: eImageAssets.noImageFound1,
                              radius: AppRadius.r10,
                            ),
                            errorWidget: (context, url, error) =>
                                CommonCachedImage(
                              height: Sizes.s140,
                              image: eImageAssets.noImageFound1,
                              radius: AppRadius.r10,
                            ),
                          )
                        : CommonCachedImage(
                            height: Sizes.s140,
                            image: eImageAssets.noImageFound1,
                            radius: AppRadius.r10,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              data?.bookingNumber ?? "",
                              style: appCss.dmDenseMedium16.textColor(
                                appColor(context).appTheme.primary,
                              ),
                            ),
                            if (data!.servicePackageId != null)
                              ButtonCommon(
                                title: translations!.package,
                                width: Sizes.s68,
                                height: Sizes.s22,
                                color: appColor(context).appTheme.whiteBg,
                                radius: AppRadius.r12,
                                borderColor: appColor(
                                  context,
                                ).appTheme.online,
                                style: appCss.dmDenseMedium11.textColor(
                                  appColor(context).appTheme.online,
                                ),
                              ).paddingSymmetric(horizontal: Insets.i8),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              language(
                                context,
                                translations!.viewStatus,
                              ),
                              style: appCss.dmDenseMedium12.textColor(
                                appColor(context).appTheme.primary,
                              ),
                            ),
                            const HSpace(Sizes.s5),
                            SvgPicture.asset(
                              eSvgAssets.anchorArrowRight,
                              colorFilter: ColorFilter.mode(
                                appColor(context).appTheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        )
                            .paddingSymmetric(
                              horizontal: Insets.i12,
                              vertical: Insets.i8,
                            )
                            .boxShapeExtension(
                              radius: AppRadius.r4,
                              color: appColor(
                                context,
                              ).appTheme.primary.withOpacity(0.1),
                            )
                            .inkWell(onTap: onTapStatus),
                      ],
                    ).paddingSymmetric(vertical: Insets.i15),
                    Text(
                      data?.service?.title ?? "",
                      style: appCss.dmDenseMedium16.textColor(
                        appColor(context).appTheme.darkText,
                      ),
                    ),
                    const VSpace(Sizes.s15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DescriptionLayout(
                                icon: eSvgAssets.calender,
                                title: data?.dateTime == null
                                    ? ""
                                    : DateFormat("dd MMM, yyyy").format(
                                        DateTime.parse(data!.dateTime!),
                                      ),
                                subTitle: translations!.date,
                                padding: 0,
                              ),
                            ),
                            Container(
                              height: Sizes.s78,
                              width: 2,
                              color: appColor(context).appTheme.stroke,
                            ).paddingSymmetric(horizontal: Insets.i20),
                            Expanded(
                              child: DescriptionLayout(
                                icon: eSvgAssets.clock,
                                title: data?.dateTime == null
                                    ? ""
                                    : DateFormat("hh:mm aa").format(
                                        DateTime.parse(data!.dateTime!),
                                      ),
                                subTitle: translations!.time,
                                padding: 0,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: Insets.i10),
                        if (data!.address != null) const DottedLines(),
                        if (data!.address != null) const VSpace(Sizes.s17),
                        if (data!.address != null)
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  eSvgAssets.locationOut,
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                    appColor(context).appTheme.darkText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                VerticalDivider(
                                  thickness: 1,
                                  indent: 2,
                                  endIndent: 20,
                                  width: 1,
                                  color: appColor(context).appTheme.stroke,
                                ).paddingSymmetric(horizontal: Insets.i9),
                                // if(data!.address != null)
                                Expanded(
                                  child: Text(
                                    data!.address != null
                                        ? "${data!.address!.area != null ? "${data!.address!.area}, " : ""}${data!.address!.address},${data!.address?.country?.name == null ? "" : " ${data!.address?.country?.name},"}${data!.address?.state?.name == null ? "" : " ${data!.address?.state?.name},"}${data!.address!.postalCode}"
                                        : "",
                                    overflow: TextOverflow.fade,
                                    style: appCss.dmDenseRegular12.textColor(
                                      appColor(
                                        context,
                                      ).appTheme.darkText,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  eSvgAssets.copy,
                                  height: Sizes.s18,
                                  colorFilter: ColorFilter.mode(
                                    appColor(context).appTheme.darkText,
                                    BlendMode.srcIn,
                                  ),
                                ).inkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: "Copied");
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            "${data!.address!.area != null ? "${data!.address!.area}, " : ""}${data!.address!.address},${data!.address?.country?.name == null ? "" : " ${data!.address?.country?.name},"}${data!.address?.state?.name == null ? "" : " ${data!.address?.state?.name},"}${data!.address!.postalCode}",
                                      ),
                                    );
                                    /* Tooltip(
                                      message: "Copied",
                                      child: SvgPicture.asset(
                                        eSvgAssets.copy,
                                        height: Sizes.s18,
                                        colorFilter: ColorFilter.mode(
                                          appColor(
                                            context,
                                          ).appTheme.darkText,
                                          BlendMode.srcIn, 
                                        ),
                                      ),
                                    ); */
                                  },
                                ),
                                /*  SvgPicture.asset(eSvgAssets.copy,
                                    fit: BoxFit.scaleDown,
                                    colorFilter: ColorFilter.mode(
                                        appColor(context).appTheme.darkText,
                                        BlendMode.srcIn)) */
                              ],
                            ),
                          ).padding(
                            horizontal: Insets.i10,
                            bottom: Insets.i15,
                          ),
                        // if (data!.bookingStatus != null &&
                        //     data!.address != null)
                        //   if (data!.bookingStatus!.slug != "cancel")
                        //     ViewLocationCommon(address: data!.address!)
                      ],
                    ).boxBorderExtension(
                      context,
                      bColor: appColor(context).appTheme.stroke,
                    ),
                    data!.bookingStatus != null &&
                            (data!.bookingStatus!.slug == "completed" ||
                                data!.bookingStatus!.slug == "cancelled" ||
                                data!.bookingStatus!.slug == "cancel")
                        ? CustomerLayout(
                            isDetailShow: false,
                            title: translations!.customerDetails,
                            data: data!.consumer,
                            onTapChat: () =>
                                route.pushNamed(context, routeName.chat, arg: {
                              "image": data!.consumer!.media != null &&
                                      data!.consumer!.media!.isNotEmpty
                                  ? data!.consumer!.media![0].originalUrl!
                                  : "",
                              "name": data!.consumer!.name,
                              "role": "user",
                              "userId": data!.consumer!.id.toString(),
                              "token": data!.consumer!.fcmToken,
                              "phone": data!.consumer!.phone.toString(),
                              "code": data!.consumer!.code.toString(),
                              "chatId": Provider.of<ChatProvider>(context,
                                      listen: false)
                                  .buildChatId(
                                      bookingId: data!.id.toString(),
                                      partnerId: data!.consumer!.id.toString()),
                              "bookingId": data!.id.toString(),
                              "bookingNumber": data!.bookingNumber
                            }).then((e) {
                              final chat = Provider.of<ChatHistoryProvider>(
                                  context,
                                  listen: false);
                              chat.onReady(context);
                            }),
                            // onTapPhone: () => onPhone(),
                          ).paddingDirectional(top: Sizes.s20)
                        : CustomerServiceLayout(
                            id: data!.consumer?.id,
                            role: "user",
                            bookingId: data!.id.toString(),
                            token: data!.consumer!.fcmToken,
                            phone:
                                data!.consumer!.phone?.toString().replaceRange(
                                      0,
                                      data!.consumer!.phone.toString().length,
                                      "*",
                                    ),
                            code: data!.consumer!.code,
                            title: translations!.customerDetails,
                            image: data!.consumer!.media != null &&
                                    data!.consumer!.media!.isNotEmpty
                                ? data!.consumer!.media![0].originalUrl!
                                : null,
                            name: data!.consumer!.name,
                            status: data!.bookingStatus != null
                                ? data!.bookingStatus!.slug
                                : "",
                            phoneTap: onPhone,
                            bookingNumber: data?.bookingNumber,
                          ).paddingDirectional(top: Sizes.s20),
                    if (isFreelancer != true) const VSpace(Sizes.s15),
                    if (isFreelancer != true)
                      if (!isServiceman)
                        data!.servicemen!.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const DottedLines(),
                                  const VSpace(Sizes.s10),
                                  RichText(
                                    text: TextSpan(
                                      style: appCss.dmDenseMedium12.textColor(
                                        data!.bookingStatus!.slug ==
                                                    "assigned" ||
                                                data!.bookingStatus!.slug ==
                                                    translations!.ongoing ||
                                                data!.bookingStatus!.slug ==
                                                    "cancelled" ||
                                                (data!.bookingStatus!.slug ==
                                                        "accepted" &&
                                                    data!.providerId
                                                            .toString() !=
                                                        userModel!.id
                                                            .toString())
                                            ? appColor(context).appTheme.red
                                            : appColor(
                                                context,
                                              ).appTheme.darkText,
                                      ),
                                      text: language(
                                        context,
                                        translations!.note,
                                      ),
                                      children: [
                                        TextSpan(
                                          style:
                                              appCss.dmDenseRegular12.textColor(
                                            data!.bookingStatus!.slug ==
                                                        "assigned" ||
                                                    data!.bookingStatus!.slug ==
                                                        translations!.ongoing ||
                                                    data!.bookingStatus!.slug ==
                                                        translations!.cancel ||
                                                    (data!.bookingStatus!
                                                                .slug ==
                                                            translations!
                                                                .accepted &&
                                                        data!.providerId !=
                                                            userModel!.id
                                                                .toString())
                                                ? appColor(
                                                    context,
                                                  ).appTheme.red
                                                : appColor(
                                                    context,
                                                  ).appTheme.darkText,
                                          ),
                                          text: language(
                                            context,
                                            data!.bookingStatus!.slug ==
                                                        translations!
                                                            .assigned ||
                                                    data!.bookingStatus!.slug ==
                                                        translations!.ongoing ||
                                                    data!.bookingStatus!.slug ==
                                                        translations!.cancel ||
                                                    (data!.bookingStatus!
                                                                .slug ==
                                                            translations!
                                                                .accepted &&
                                                        data!.providerId !=
                                                            userModel!.id
                                                                .toString())
                                                ? translations!
                                                    .youAssignedService
                                                : translations!
                                                    .servicemenIsNotSelected,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : data!.servicemen!
                                    .where(
                                      (element) =>
                                          element.id.toString() ==
                                          userModel!.id.toString(),
                                    )
                                    .isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const DottedLines(),
                                      const VSpace(Sizes.s10),
                                      RichText(
                                        text: TextSpan(
                                          style:
                                              appCss.dmDenseMedium12.textColor(
                                            appColor(context).appTheme.red,
                                          ),
                                          text: language(
                                            context,
                                            translations!.note,
                                          ),
                                          children: [
                                            TextSpan(
                                              style: appCss.dmDenseRegular12
                                                  .textColor(
                                                appColor(
                                                  context,
                                                ).appTheme.red,
                                              ),
                                              text: language(
                                                context,
                                                translations!
                                                    .youAssignedService,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: data!.servicemen!
                                        .asMap()
                                        .entries
                                        .map((s) {
                                      log("data!.servicemen::${data!.consumer!.fcmToken}");
                                      return CustomerServiceLayout(
                                        id: s.value.id,
                                        bookingId: data!.id.toString(),
                                        title: translations!.servicemanDetail,
                                        phone: s.value.phone.toString(),
                                        code: s.value.code,
                                        token: s.value.fcmToken,
                                        name: s.value.name,
                                        role: "serviceman",
                                        rate: s.value.reviewRatings != null
                                            ? double.parse(
                                                s.value.reviewRatings!,
                                              )
                                            : 0.0,
                                        moreTap: () => route.pushNamed(
                                          context,
                                          routeName.servicemanDetail,
                                          arg: {
                                            "isShow": false,
                                            "detail": s.value.id,
                                          },
                                        ),
                                        image: s.value.media != null &&
                                                s.value.media!.isNotEmpty
                                            ? s.value.media![0].originalUrl
                                            : null,
                                        status: data!.bookingStatus != null
                                            ? data!.bookingStatus!.slug
                                            : "",
                                        bookingNumber: data?.bookingNumber,
                                      ).paddingOnly(
                                        bottom: s.key !=
                                                data!.servicemen!.length - 1
                                            ? Insets.i15
                                            : 0,
                                      );
                                    }).toList(),
                                  ),
                  ],
                ).paddingAll(Insets.i15).boxBorderExtension(
                      context,
                      bColor: appColor(context).appTheme.stroke,
                      color: appColor(context).appTheme.whiteBg,
                      isShadow: true,
                    ),
              ],
            )
          : Container(),
    );
  }
}
