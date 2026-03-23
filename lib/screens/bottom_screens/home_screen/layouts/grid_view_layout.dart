// ignore_for_file: unused_local_variable

import '../../../../config.dart';

class GridViewLayout extends StatelessWidget {
  final Animation? animation;
  final dynamic data;
  final int? index;
  final GestureTapCallback? onTap;
  final bool isHeight;

  const GridViewLayout(
      {super.key,
      this.animation,
      this.data,
      this.index,
      this.onTap,
      this.isHeight = true});

  @override
  Widget build(BuildContext context) {
    //log("Data::${data['price']}");
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    return Container(
            height: isHeight ? Sizes.s130 : Sizes.s110,
            decoration: ShapeDecoration(
                color: appColor(context).appTheme.fieldCardBg,
                image: DecorationImage(
                    image: AssetImage(eImageAssets.even1), fit: BoxFit.cover),
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 1))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(data["image"]),
                  const VSpace(Sizes.s12),
                  Text(language(context, data["title"]),
                      overflow: TextOverflow.clip,
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.lightText)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            symbolPosition
                                ? "${data["title"] == translations!.totalEarning ? "${getSymbol(context)}" : ""}${data["price"]}"
                                : "${data["price"]}${data["title"] == translations!.totalEarning ? "${getSymbol(context)}" : ""}",
                            style: appCss.dmDenseBold16
                                .textColor(appColor(context).appTheme.primary)),
                        SvgPicture.asset(eSvgAssets.anchorArrowRight,
                            colorFilter: ColorFilter.mode(
                                appColor(context).appTheme.lightText,
                                BlendMode.srcIn))
                      ])
                ]).paddingAll(Insets.i15))
        .inkWell(onTap: onTap);
  }
}
