import '../../../../config.dart';
import '../../../../providers/app_pages_provider/boost_provider.dart';
import '../../../../providers/app_pages_provider/offer_chat_provider.dart';

class OfferServiceSelectionLayout extends StatefulWidget {
  final bool isOffer;
  const OfferServiceSelectionLayout({super.key, this.isOffer = false});

  @override
  State<OfferServiceSelectionLayout> createState() =>
      _OfferServiceSelectionLayoutState();
}

class _OfferServiceSelectionLayoutState
    extends State<OfferServiceSelectionLayout> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BoostProvider>(builder: (context, offer, child) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s15, vertical: Sizes.s10),
        decoration: BoxDecoration(
          color: appColor(context).appTheme.whiteBg,
          border: Border.all(color: appColor(context).appTheme.stroke),
          borderRadius: BorderRadius.circular(Sizes.s8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(children: [
                SvgPicture.asset(eSvgAssets.categorySmall,
                        colorFilter: ColorFilter.mode(
                            offer.selectedServices.isNotEmpty
                                ? appColor(context).appTheme.darkText
                                : appColor(context).appTheme.lightText,
                            BlendMode.srcIn))
                    .padding(
                        left: Insets.i5,
                        right: rtl(context) ? Insets.i5 : 0,
                        top: Sizes.s5,
                        vertical: Sizes.s5),
                const HSpace(Sizes.s12),
                if (offer.selectedServices.isNotEmpty)
                  Expanded(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: offer.newServiceList
                          .asMap()
                          .entries
                          .map((e) => Container(
                              margin: EdgeInsets.only(
                                  bottom:
                                      offer.newServiceList.length - 1 != e.key
                                          ? Sizes.s8
                                          : 0,
                                  right: Sizes.s5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.s9, vertical: Sizes.s5),
                              decoration: ShapeDecoration(
                                  shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: 8, cornerSmoothing: 1),
                                  ),
                                  color:
                                      const Color.fromRGBO(84, 101, 255, 0.1)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    eSvgAssets.cross,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                        appColor(context).appTheme.primary,
                                        BlendMode.srcIn),
                                  ).inkWell(onTap: () {
                                    offer.onChangeService(
                                        e.value, true); // remove on tap
                                    setState(() {});
                                  }),
                                  const HSpace(Sizes.s3),
                                  Expanded(
                                    child: Text(e.value.title ?? '',
                                        style: appCss.dmDenseLight14.textColor(
                                            appColor(context)
                                                .appTheme
                                                .primary)),
                                  )
                                ],
                              )))
                          .toList(),
                    ),
                  ),
                if (offer.selectedServices.isEmpty)
                  Text(language(context, appFonts.services),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.lightText)),
              ]),
            ),
            SvgPicture.asset(eSvgAssets.dropDown,
                colorFilter: ColorFilter.mode(
                    offer.selectedServices.isNotEmpty
                        ? appColor(context).appTheme.darkText
                        : appColor(context).appTheme.lightText,
                    BlendMode.srcIn))
          ],
        ),
      ).inkWell(onTap: () => offer.onServiceBottomSheet(context));
    });
  }
}
