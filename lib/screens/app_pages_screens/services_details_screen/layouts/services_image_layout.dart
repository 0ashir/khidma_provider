import 'dart:ui';

import '../../../../config.dart';

class ServicesImageLayout extends StatelessWidget {
  final dynamic data;
  final int? index, selectIndex;
  final GestureTapCallback? onTap;
  const ServicesImageLayout(
      {super.key, this.data, this.selectIndex, this.index, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Sizes.s60,
        width: Sizes.s60,
        decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
                side: BorderSide(
                    color: selectIndex == index
                        ? appColor(context).appTheme.primary
                        : appColor(context).appTheme.trans),
                borderRadius: SmoothBorderRadius(
                    cornerRadius: AppRadius.r8, cornerSmoothing: 1))),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r6),
            child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: selectIndex == index ? 0.1 : 1.0,
                    sigmaY: selectIndex == index ? 0.1 : 1.0),
                child: CachedNetworkImage(
                  imageUrl: "$data",
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    height: Sizes.s60,
                    width: Sizes.s60,
                  ),
                  placeholder: (context, url) => Image.asset(
                          eImageAssets.noImageFound1,
                          fit: BoxFit.fill,
                          height: Sizes.s60,
                          width: Sizes.s60)
                      .paddingAll(Insets.i18),
                  errorWidget: (context, url, error) => Image.asset(
                          eImageAssets.noImageFound1,
                          fit: BoxFit.fill,
                          height: Sizes.s60,
                          width: Sizes.s60)
                      .paddingAll(Insets.i18),
                )
                /* Image.network(data,
                        height: Sizes.s60,
                        width: Sizes.s60,
                        fit: BoxFit.cover) */
                ))).inkWell(onTap: onTap).paddingOnly(right: Insets.i15);
  }
}
