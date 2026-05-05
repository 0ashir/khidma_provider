import '../../../../config.dart';

class CustomerLayout extends StatelessWidget {
  final UserModel? data;
  final String? title;
  final bool isDetailShow;
  final GestureTapCallback? onTapChat, onTapPhone;
  const CustomerLayout(
      {super.key,
      this.data,
      this.title,
      this.isDetailShow = true,
      this.onTapChat,
      this.onTapPhone});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();
    return SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(language(context, title ?? ''),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText))
          .padding(horizontal: Insets.i15, top: Insets.i15),
      Divider(height: 1, color: appColor(context).appTheme.stroke)
          .paddingSymmetric(vertical: Insets.i15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          data!.media != null && data!.media!.isNotEmpty
              ? CommonImageLayout(
                  image: data!.media![0].originalUrl!,
                  assetImage: eImageAssets.noImageFound3,
                  height: Sizes.s40,
                  width: Sizes.s40,
                  isCircle: true)
              : CommonCachedImage(
                  image: eImageAssets.noImageFound3,
                  height: Sizes.s40,
                  width: Sizes.s40,
                  isCircle: true),
          const HSpace(Sizes.s12),
          Text(data!.name ?? '',
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText))
        ]),
        if (onTapChat != null || onTapPhone != null)
          Row(children: [
            if (onTapChat != null)
              SocialIconCommon(icon: eSvgAssets.chatOut, onTap: onTapChat),
            if (onTapChat != null && onTapPhone != null) const HSpace(Sizes.s12),
            if (onTapPhone != null)
              SocialIconCommon(icon: eSvgAssets.phone, onTap: onTapPhone)
          ])
      ]).padding(horizontal: Insets.i15),
      const VSpace(Sizes.s15),
      if (isDetailShow)
        Column(
          children: [
            if (data!.email != null)
              ContactDetailRowCommon(
                  image: eSvgAssets.email, title: data!.email),
            if (data!.phone != null)
              ContactDetailRowCommon(
                      code: "+${data?.code ?? ''}",
                      image: eSvgAssets.phone,
                      title: data!.phone != null
                          ? data!.phone.toString().replaceRange(
                              5, data!.phone.toString().length, "*****")
                          : "")
                  .paddingSymmetric(vertical: Insets.i15),
            if (data!.primaryAddress != null)
              ContactDetailRowCommon(
                  image: eSvgAssets.locationOut,
                  title:
                      "${data!.primaryAddress!.area != null ? "${data!.primaryAddress!.area}, " : ""}${data!.primaryAddress!.address}, ${data!.primaryAddress!.country!.name}, ${data!.primaryAddress!.state!.name}, ${data!.primaryAddress!.postalCode}"),
          ],
        )
            .paddingAll(Insets.i15)
            .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
            .padding(horizontal: Insets.i15, bottom: Insets.i15)
    ])).boxShapeExtension(color: appColor(context).appTheme.fieldCardBg);
  }
}
