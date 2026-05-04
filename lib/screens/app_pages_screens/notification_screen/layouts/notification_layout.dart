import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class NotificationLayout extends StatelessWidget {
  final NotificationModel? data;
  final GestureTapCallback? onTap;

  const NotificationLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                data!.data!.thumbnail != null
                    ? /*Image.network(
                        data!.data!.thumbnail!,
                        height: Sizes.s18,
                      ).paddingAll(Insets.i7).decorated(
                        color: data!.readAt != null
                            ? appColor(context).appTheme.fieldCardBg
                            : appColor(context).appTheme.whiteBg,
                        shape: BoxShape.circle)*/
                    CachedNetworkImage(
                        imageUrl: data?.data?.thumbnail ?? "",
                        imageBuilder: (context, imageProvider) => Image(
                              image: imageProvider,
                              fit: BoxFit.fill,
                              height: Sizes.s18,
                            ).paddingAll(Insets.i7).decorated(
                                color: data!.readAt != null
                                    ? appColor(context).appTheme.whiteBg
                                    : appColor(context).appTheme.fieldCardBg,
                                shape: BoxShape.circle),
                        errorWidget: (context, url, error) => Image.asset(
                              eImageAssets.noImageFound1,
                              height: Sizes.s18,
                            ).paddingAll(Insets.i7).decorated(
                                color: data!.readAt != null
                                    ? appColor(context).appTheme.whiteBg
                                    : appColor(context).appTheme.fieldCardBg,
                                shape: BoxShape.circle))
                    : Image.asset(
                        eImageAssets.noImageFound1,
                        height: Sizes.s18,
                      ).paddingAll(Insets.i7).decorated(
                        color: data!.readAt != null
                            ? appColor(context).appTheme.whiteBg
                            : appColor(context).appTheme.fieldCardBg,
                        shape: BoxShape.circle),
                const HSpace(Sizes.s12),
                Flexible(
                  child: Text(data?.data?.title ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: appCss.dmDenseMedium14.textColor(
                          data!.readAt != null
                              ? appColor(context).appTheme.lightText
                              : appColor(context).appTheme.darkText)),
                ),
              ]).expanded(),
              Text(checkCurrentDateShowMin(data!.createdAt!).toString(),
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText))
            ]),
        Text(data!.data!.message ?? "",
                style: appCss.dmDenseRegular12.textColor(data!.readAt != null
                    ? appColor(context).appTheme.lightText
                    : appColor(context).appTheme.darkText))
            .paddingOnly(
                left: rtl(context) ? 0 : Insets.i42,
                right: rtl(context) ? Insets.i42 : 0),
        if (data!.data!.image != null)
          Image.network(data!.data!.image!, height: Sizes.s53)
              .paddingOnly(top: Insets.i10)
              .decorated(borderRadius: BorderRadius.circular(AppRadius.r4))
              .paddingOnly(
                  left: rtl(context) ? 0 : Insets.i42,
                  right: rtl(context) ? Insets.i42 : 0)
      ],
    )
        .paddingAll(Insets.i12)
        .boxBorderExtension(context,
            bColor: appColor(context).appTheme.fieldCardBg,
            color: data!.readAt != null
                ? appColor(context).appTheme.whiteBg
                : appColor(context).appTheme.fieldCardBg,
            isShadow: data!.readAt != null ? true : false,
            radius: AppRadius.r12)
        .paddingOnly(bottom: Insets.i15)
        .inkWell(onTap: onTap);
  }
}

checkCurrentDateShowMin(date) {
  DateTime now = DateTime.now();
  if (DateFormat("dd/MM/yyyy").format(now) ==
      DateFormat("dd/MM/yyyy").format(DateTime.parse(date))) {
    if (DateTime.now().difference(DateTime.parse(date)).inMinutes < 1) {
      return "seconds ago";
    } else if (DateTime.now().difference(DateTime.parse(date)).inMinutes < 60) {
      return "${DateTime.now().difference(DateTime.parse(date)).inMinutes} minutes";
    } else if (DateTime.now().difference(DateTime.parse(date)).inMinutes <
        1440) {
      return "${DateTime.now().difference(DateTime.parse(date)).inHours} hours";
    }
  } else {
    if (DateTime.now().difference(DateTime.parse(date)).inMinutes > 1440 &&
        DateTime.now().difference(DateTime.parse(date)).inMinutes <= 2880) {
      return "${DateTime.now().difference(DateTime.parse(date)).inDays} days";
    } else {
      return DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
    }
  }
}
