import '../../../../config.dart';

class ServiceProviderLayout extends StatelessWidget {
  final List? list, list2;
  final int? index;
  final String? title, name, rate, image;
  final GestureTapCallback? onTap;
  final bool? expand;

  const ServiceProviderLayout(
      {super.key,
      this.list,
      this.index,
      this.title,
      this.rate,
      this.name,
      this.image,
      this.onTap,
      this.list2 = const [],
      this.expand = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: image == null
              ? CommonCachedImage(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  isCircle: true,
                  image: eImageAssets.noImageFound3)
              : CachedNetworkImage(
                  imageUrl: image!,
                  imageBuilder: (context, imageProvider) => Container(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover))),
                  placeholder: (context, url) => CommonCachedImage(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      isCircle: true,
                      image: eImageAssets.noImageFound3),
                  errorWidget: (context, url, error) => CommonCachedImage(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      isCircle: true,
                      image: eImageAssets.noImageFound3),
                ),
          title: Text(language(context, title!),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText)),
          subtitle: Text(language(context, name!),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
          trailing: language(context, title!) ==
                  language(context, translations!.customer)
              ? null
              : rate == null
                  ? null
                  : Row(mainAxisSize: MainAxisSize.min, children: [
                      SvgPicture.asset(eSvgAssets.star),
                      const HSpace(Sizes.s4),
                      Text(rate!,
                          style: appCss.dmDenseMedium13
                              .textColor(appColor(context).appTheme.darkText))
                    ])),
      if (list!.isNotEmpty)
        if (list!.length == 1 || index != list!.length - 1)
          const DividerCommon().paddingSymmetric(vertical: Insets.i10),
    ]);
  }
}
