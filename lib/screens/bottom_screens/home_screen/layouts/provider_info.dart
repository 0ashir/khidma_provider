import '../../../../config.dart';

class ProviderInfo extends StatelessWidget {
  const ProviderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonApiProvider>(builder: (context, asdasd, child) {
      return Container(
              margin: const EdgeInsets.symmetric(horizontal: Insets.i20),
              padding: const EdgeInsets.all(Insets.i10),
              decoration: ShapeDecoration(
                  color: appColor(context).appTheme.fieldCardBg,
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 8, cornerSmoothing: 1))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      asdasd.providerData != null &&
                              asdasd.providerData!.media != null &&
                              asdasd.providerData!.media!.isNotEmpty
                          ? CommonImageLayout(
                              image:
                                  asdasd.providerData!.media![0].originalUrl!,
                              assetImage: eImageAssets.noImageFound3,
                              height: 38,
                              width: 38)
                          : CommonCachedImage(
                              height: 38,
                              width: 38,
                              image: eImageAssets.noImageFound3),
                      const HSpace(Sizes.s10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                language(
                                    context, translations!.yourProviderDetails),
                                style: appCss.dmDenseRegular12.textColor(
                                    appColor(context).appTheme.lightText)),
                            const VSpace(Sizes.s3),
                            Text(
                                asdasd.providerData != null
                                    ? asdasd.providerData!.name!
                                    : "",
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText))
                          ])
                    ]),
                    SvgPicture.asset(
                        rtl(context)
                            ? eSvgAssets.arrowLeft
                            : eSvgAssets.arrowRight,
                        colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.darkText,
                            BlendMode.srcIn))
                  ]))
          .marginOnly(bottom: Insets.i20)
          .inkWell(
              onTap: () => route.pushNamed(context, routeName.providerDetail));
    });
  }
}
