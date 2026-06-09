import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../config.dart';

class AvailableServiceLayout extends StatelessWidget {
  final ServicemanModel? data;
  final GestureTapCallback? onTap;
  final bool showAvailabilityToggle;
  final ValueChanged<bool>? onToggleAvailability;

  const AvailableServiceLayout(
      {super.key,
      this.data,
      this.onTap,
      this.showAvailabilityToggle = false,
      this.onToggleAvailability});

  @override
  Widget build(BuildContext context) {
    final bool isOnline = (data?.isOnline ?? 0) == 1;
    return Consumer<LanguageProvider>(builder: (context, value, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          CachedNetworkImage(
            imageUrl: (data?.media?.isNotEmpty ?? false)
                ? data!.media!.first.originalUrl!
                : "",
            imageBuilder: (context, imageProvider) => Container(
                height: Sizes.s100,
                width: MediaQuery.of(context).size.width,
                decoration: ShapeDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 6, cornerSmoothing: 1),
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
          // Online status dot (top-left)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF9E9E9E),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
          // Provider toggle (top-right) — only shown when provider is viewing
          if (showAvailabilityToggle)
            Positioned(
              top: 2,
              right: 2,
              child: Transform.scale(
                scale: 0.75,
                child: CupertinoSwitch(
                  value: isOnline,
                  onChanged: onToggleAvailability,
                  activeTrackColor: const Color(0xFF4CAF50),
                  inactiveTrackColor: appColor(context).appTheme.red,
                  thumbColor: Colors.white,
                ),
              ),
            ),
        ]),
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
