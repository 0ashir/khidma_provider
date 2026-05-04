import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../config.dart';

class TopCategoriesLayout extends StatelessWidget {
  final data;
  final GestureTapCallback? onTap;
  final int? index, selectedIndex;
  final double? rPadding;
  final bool? isCategories;

  const TopCategoriesLayout(
      {super.key,
      this.onTap,
      this.data,
      this.index,
      this.selectedIndex,
      this.isCategories = false,
      this.rPadding});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: Sizes.s60,
          width: Sizes.s60,
          decoration: ShapeDecoration(
              color: selectedIndex == index
                  ? appColor(context).appTheme.primary.withOpacity(0.2)
                  : isCategories == true
                      ? appColor(context).appTheme.fieldCardBg
                      : appColor(context).appTheme.whiteBg,
              shape: SmoothRectangleBorder(
                  side: BorderSide(
                      color: selectedIndex == index
                          ? appColor(context).appTheme.primary
                          : appColor(context).appTheme.trans),
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: AppRadius.r10, cornerSmoothing: 1))),
          child: data!.media != null && data!.media!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: data!.media![0].originalUrl!,
                  imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        height: Sizes.s20,
                        width: Sizes.s20,
                      ).paddingAll(Insets.i18),
                  placeholder: (context, url) => Image.asset(data?.title == "All" ? eImageAssets.all : eImageAssets.noImageFound1,
                          color: selectedIndex == index
                              ? appColor(context).appTheme.primary
                              : appColor(context).appTheme.darkText,
                          fit: BoxFit.fill,
                          height: Sizes.s22,
                          width: Sizes.s22)
                      .paddingAll(Insets.i18),
                  errorWidget: (context, url, error) =>
                      Image.asset(data?.title == "All" ? eImageAssets.all : eImageAssets.noImageFound1,
                              color: selectedIndex == index
                                  ? appColor(context).appTheme.primary
                                  : appColor(context).appTheme.darkText,
                              fit: BoxFit.fill,
                              height: Sizes.s22,
                              width: Sizes.s22)
                          .paddingAll(Insets.i18))
              : selectedIndex == index
                  ? Image.asset(data?.title == "All" ? eImageAssets.all: eImageAssets.noImageFound1, color: appColor(context).appTheme.primary, fit: BoxFit.cover, height: Sizes.s22, width: Sizes.s22).paddingAll(Insets.i18)
                  : Image.asset(data?.title == "All" ? eImageAssets.all:eImageAssets.noImageFound1, fit: BoxFit.cover, height: Sizes.s22, width: Sizes.s22).paddingAll(Insets.i18)),
      const VSpace(Sizes.s8),
      Text(data!.title!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: appCss.dmDenseRegular13.textColor(selectedIndex == index
                  ? appColor(context).appTheme.primary
                  : appColor(context).appTheme.darkText))
          .width(Sizes.s66)
    ]).inkWell(onTap: onTap).paddingOnly(right: rPadding ?? 0);
  }
}
