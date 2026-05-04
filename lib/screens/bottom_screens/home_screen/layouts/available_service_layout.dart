import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../config.dart';

class AvailableServiceLayout extends StatelessWidget {
  final ServicemanModel? data;
  final GestureTapCallback? onTap;

  const AvailableServiceLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, value, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CachedNetworkImage(
          imageUrl: (data?.media?.isNotEmpty ?? false)
              ? data!.media!.first.originalUrl!
              : "", // Fallback to empty string if media is null or empty
          imageBuilder: (context, imageProvider) => Container(
              height: Sizes.s100,
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  shape: SmoothRectangleBorder(
                    borderRadius:
                        SmoothBorderRadius(cornerRadius: 6, cornerSmoothing: 1),
                  ))),
          placeholder: (context, url) => CommonCachedImage(
            height: Sizes.s100,
            width: MediaQuery.of(context).size.width,
            image: eImageAssets.noImageFound2,
            radius: 6,
            boxFit: BoxFit.fill,
          ),
          errorWidget: (context, url, error) => CommonCachedImage(
            height: Sizes.s100,
            width: MediaQuery.of(context).size.width,
            image: eImageAssets.noImageFound2,
            radius: 6,
            boxFit: BoxFit.fill,
          ),
        ),
        const VSpace(Sizes.s10),
        Text(data!.name!,overflow: TextOverflow.ellipsis,
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.darkText)),
        IntrinsicHeight(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (data!.expertise != null)
            Text(data?.expertise?.first.title ?? '',
                style: appCss.dmDenseRegular12
                    .textColor(appColor(context).appTheme.lightText)),
          if (data!.expertise != null)
            VerticalDivider(
                    width: 1,
                    color: appColor(context).appTheme.lightText,
                    thickness: 1,
                    indent: 3,
                    endIndent: 3)
                .paddingSymmetric(horizontal: Insets.i4),
          Expanded(
              child: Text(
                  "${language(context, translations!.since)} ${data!.createdAt == null ? "" : DateFormat("yyyy").format(DateTime.parse(data!.createdAt!))}",
                  overflow: TextOverflow.ellipsis,
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText)))
        ])),
        const VSpace(Sizes.s12),
        Expanded(
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: appArray.socialList
                        .asMap()
                        .entries
                        .map((e) => SocialLayout(
                            index: e.key,
                            data: e.value,
                            list: appArray.socialList,
                            onTap: () {
                              if (e.key == 0) {
                                route.pushNamed(context, routeName.chat, arg: {
                                  "image": data!.media != null &&
                                          data!.media!.isNotEmpty
                                      ? data!.media![0].originalUrl!
                                      : null,
                                  "name": data!.name,
                                  "role": "serviceman",
                                  "userId": data!.id.toString(),
                                  "token": data!.fcmToken,
                                  "phone": data!.phone.toString(),
                                  "code": data!.code.toString(),
                                  "chatId": null,  // New chat, no existing chatId
                                  "bookingId": null,  // Not a booking chat
                                  "bookingNumber": null
                                }).then((e) {
                                  final chat = Provider.of<ChatHistoryProvider>(
                                      context,
                                      listen: false);
                                  chat.onReady(context);
                                });
                              } else if (e.key == 1) {
                                if (data!.phone != null) {
                                  launchCall(context, data!.phone.toString());
                                }
                              } else if (e.key == 2) {
                                if (data!.email != null) {
                                  mailTap(context, data!.email!);
                                }
                              }
                            }))
                        .toList())
                .paddingSymmetric(horizontal: Insets.i10, vertical: Insets.i10)
                .boxShapeExtension(
                    color: appColor(context).appTheme.fieldCardBg))
      ])
          .paddingAll(Insets.i12)
          .boxBorderExtension(context, isShadow: true)
          .inkWell(onTap: onTap);
    });
  }
}
