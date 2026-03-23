import 'package:intl/intl.dart';

import '../../../../config.dart';

class BookingServicemenListLayout extends StatelessWidget {
  final ServicemanModel? data;
  final List<ServicemanModel>? selList;
  final int? index, list, selectedIndex;
  final GestureTapCallback? onTap, onTapRadio;

  const BookingServicemenListLayout(
      {super.key,
      this.data,
      this.selList,
      this.index,
      this.onTap,
      this.list,
      this.selectedIndex,
      this.onTapRadio});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        data!.media != null && data!.media!.isNotEmpty
            ? CommonImageLayout(
                image: data!.media![0].originalUrl!,
                height: Sizes.s40,
                width: Sizes.s40,
                isCircle: true,
                assetImage: eImageAssets.noImageFound3)
            : CommonCachedImage(
                height: Sizes.s40,
                width: Sizes.s40,
                isCircle: true,
                image: eImageAssets.noImageFound3),
        const HSpace(Sizes.s12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IntrinsicHeight(
            child: Row(children: [
              Text(language(context, data!.name),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText)),
              if (data!.reviewRatings != null)
                VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: appColor(context).appTheme.stroke,
                        indent: 6,
                        endIndent: 6)
                    .paddingSymmetric(horizontal: Insets.i6),
              if (data!.reviewRatings != null)
                Row(children: [
                  SvgPicture.asset(eSvgAssets.star),
                  const HSpace(Sizes.s4),
                  Text(data!.reviewRatings ?? "0",
                      style: appCss.dmDenseMedium13
                          .textColor(appColor(context).appTheme.darkText))
                ])
            ]),
          ),
          const VSpace(Sizes.s4),
          Text(
              language(context,
                  "${language(context, translations!.memberSince)} ${data!.createdAt == null ? "" : DateFormat("yyyy").format(DateTime.parse(data!.createdAt!))}"),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText))
        ])
      ]),
      list == null
          ? Container()
          : list! <= 1
              ? CommonRadio(
                      selectedIndex: selectedIndex,
                      index: index,
                      onTap: onTapRadio)
                  .inkWell(onTap: onTap)
              : Container(
                      height: Sizes.s20,
                      width: Sizes.s20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selList!.contains(data)
                              ? appColor(context).appTheme.primary
                              : appColor(context).appTheme.whiteBg,
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                          border: Border.all(
                              color: selList!.contains(data)
                                  ? appColor(context).appTheme.trans
                                  : appColor(context).appTheme.stroke)),
                      child: selList!.contains(data)
                          ? Icon(Icons.check,
                              size: Sizes.s15,
                              color: appColor(context).appTheme.whiteBg)
                          : null)
                  .inkWell(onTap: onTap)
    ])
        .padding(horizontal: Insets.i15, vertical: Insets.i12)
        .boxBorderExtension(context,
            color: appColor(context).appTheme.whiteBg,
            isShadow: true,
            radius: AppRadius.r10)
        .paddingOnly(bottom: Insets.i15);
  }
}
