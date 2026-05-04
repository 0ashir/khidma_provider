import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class DocumentLayout extends StatelessWidget {
  final ProviderDocumentModel? data;
  final List? list;
  final int? index;

  const DocumentLayout({super.key, this.data, this.index, this.list});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      data!.media != null &&
              data!.media!.isNotEmpty &&
              data!.media![0].originalUrl!.contains("http")
          ? CachedNetworkImage(
              imageUrl: data!.media!.first.originalUrl!,
              imageBuilder: (context, imageProvider) => Container(
                  height: Sizes.s160,
                  width: MediaQuery.of(context).size.width,
                  decoration: ShapeDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill),
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 8, cornerSmoothing: 1)))),
              errorWidget: (context, url, error) => CommonCachedImage(
                  height: Sizes.s160,
                  width: MediaQuery.of(context).size.width,
                  radius: 8,
                  image: eImageAssets.noImageFound2),
              placeholder: (context, url) => CommonCachedImage(
                  image: eImageAssets.noImageFound2,
                  height: Sizes.s160,
                  width: MediaQuery.of(context).size.width))
          : Container(
              height: Sizes.s160,
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                  image: DecorationImage(
                      image: AssetImage(eImageAssets.noImageFound2),
                      fit: BoxFit.fill),
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 8, cornerSmoothing: 1)))),
      const VSpace(Sizes.s12),
      Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(language(context, translations!.identityNo)),
            Text(data!.identityNo ?? "")
          ],
        ),
        const VSpace(Sizes.s12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            if (language(context, data!.status) ==
                language(context, translations!.requestForUpdate))
              Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: appColor(context).appTheme.online, size: Sizes.s18),
            if (language(context, data!.status) ==
                language(context, translations!.requestForUpdate))
              const HSpace(Sizes.s5),
            Text(language(context, data!.document),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
          ]).expanded(),
          language(context, data!.status) !=
                  language(context, translations!.pending)
              ? Row(children: [
                  Text(language(context, "${data!.status}"),
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.primary)),
                  const HSpace(Sizes.s5)
                ])
              : Text(
                  language(
                      context, "\u2022 ${language(context, data!.status)}"),
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).appTheme.red))
        ])
      ]).paddingAll(Insets.i15).boxBorderExtension(context,
          radius: AppRadius.r10, bColor: appColor(context).appTheme.stroke),
    ])
        .paddingAll(Insets.i12)
        .boxShapeExtension(
            color: appColor(context).appTheme.fieldCardBg,
            radius: AppRadius.r10)
        .paddingOnly(bottom: index != list!.length - 1 ? Insets.i15 : 0);
  }
}
