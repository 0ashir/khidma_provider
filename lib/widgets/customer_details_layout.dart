import '../config.dart';

class CustomerDetailsLayout extends StatelessWidget {
  final String? title;
  final dynamic data;
  final bool? isMore;
  final List? list;
  final int? index;
  final GestureTapCallback? onTapChat, onTapPhone, onTapMore;

  const CustomerDetailsLayout(
      {super.key,
      this.title,
      this.data,
      this.onTapChat,
      this.onTapPhone,
      this.isMore = false,
      this.list,
      this.index,
      this.onTapMore});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, title!),
            style: appCss.dmDenseRegular12
                .textColor(appColor(context).appTheme.lightText)),
        if (isMore == true)
          Row(children: [
            Text(language(context, translations!.view),
                style: appCss.dmDenseRegular12
                    .textColor(appColor(context).appTheme.primary)),
            const HSpace(Sizes.s5),
            const ArrowRightCommon()
          ]).inkWell(onTap: onTapMore)
      ]).paddingSymmetric(horizontal: Insets.i15),
      const DividerCommon().paddingSymmetric(vertical: Insets.i15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          data!.media != null && data!.media!.isNotEmpty
              ? CommonImageLayout(
                  image: data!.media![0].originalUrl!,
                  assetImage: eImageAssets.noImageFound3,
                  height: Sizes.s38,
                  width: Sizes.s38,
                  isCircle: true)
              : CommonCachedImage(
                  image: eImageAssets.noImageFound3,
                  height: Sizes.s38,
                  width: Sizes.s38,
                  isCircle: true),
          const HSpace(Sizes.s12),
          Text(data.name,
                  overflow: TextOverflow.ellipsis,
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText))
              .width(Sizes.s100)
        ]),
        if (data.id.toString() != userModel!.id.toString())
          Row(children: [
            SocialIconCommon(icon: eSvgAssets.chatOut, onTap: onTapChat),
            const HSpace(Sizes.s12),
            SocialIconCommon(icon: eSvgAssets.phone, onTap: onTapPhone)
          ])
      ]).paddingSymmetric(horizontal: Insets.i15)
    ])
        .paddingSymmetric(vertical: Insets.i15)
        .boxShapeExtension(
            color: appColor(context).appTheme.fieldCardBg,
            radius: AppRadius.r10)
        .paddingOnly(
            bottom: isMore == true
                ? index != list!.length - 1
                    ? Insets.i15
                    : 0
                : 0);
  }
}
