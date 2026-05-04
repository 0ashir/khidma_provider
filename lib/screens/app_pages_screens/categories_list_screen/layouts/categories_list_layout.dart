import '../../../../config.dart';

class CategoriesListLayout extends StatelessWidget {
  final CategoryModel? data;
  final GestureTapCallback? onTap;
  final bool? isCommission;

  const CategoriesListLayout(
      {super.key, this.data, this.onTap, this.isCommission = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        CachedNetworkImage(
            imageUrl: data!.media!.isNotEmpty
                ? data!.media!.first.originalUrl.toString()
                : '',
            imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                fit: BoxFit.cover,
                height: Sizes.s20,
                width: Sizes.s20),
            errorWidget: (context, url, error) => Image.asset(
                eImageAssets.noImageFound1,
                fit: BoxFit.fill,
                height: Sizes.s22,
                width: Sizes.s22)),
        const HSpace(Sizes.s15),
        Row(children: [
          Text(language(context, data!.title),
              style: appCss.dmDenseRegular14
                  .textColor(appColor(context).appTheme.darkText)),
          if (isCommission == true)
            Text(language(context, " - ${data?.commission ?? "0"}%"),
                style: appCss.dmDenseRegular14
                    .textColor(appColor(context).appTheme.darkText))
        ])
      ]),
      if (data!.hasSubCategories != null && data!.hasSubCategories!.isNotEmpty)
        SvgPicture.asset(
            rtl(context) ? eSvgAssets.arrowLeft : eSvgAssets.arrowRight,
            colorFilter: ColorFilter.mode(
                appColor(context).appTheme.lightText, BlendMode.srcIn))
    ])
        .paddingAll(Insets.i15)
        .boxBorderExtension(context, isShadow: true)
        .inkWell(onTap: onTap)
        .paddingOnly(bottom: Insets.i12);
  }
}
