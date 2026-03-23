import '../../../../config.dart';

class RecentBookingLayout extends StatelessWidget {
  final BookingModel? data;
  final GestureTapCallback? onTap;

  const RecentBookingLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<DashboardProvider>(context, listen: true);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(language(context, data!.service!.title),
              style: appCss.dmDenseMedium16
                  .textColor(appColor(context).appTheme.darkText)),
          Row(children: [
            Text(
                language(
                    context,
                    symbolPosition
                        ? "${getSymbol(context)}${currency(context).currencyVal * data!.total!}"
                        : "${currency(context).currencyVal * data!.total!}${getSymbol(context)}"),
                style: appCss.dmDenseBold18
                    .textColor(appColor(context).appTheme.primary)),
            const HSpace(Sizes.s8),
            if (data!.coupon != null)
              Text(language(context, "(${data!.coupon!.amount})"),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.red))
          ]),
          const VSpace(Sizes.s8),
          IntrinsicHeight(
            child: Row(children: [
              SvgPicture.asset(eSvgAssets.calender,
                  colorFilter: ColorFilter.mode(
                      appColor(context).appTheme.darkText, BlendMode.srcIn)),
              const HSpace(Sizes.s6),
              Text(language(context, data!.createdAt!),
                  style: appCss.dmDenseMedium13
                      .textColor(appColor(context).appTheme.darkText)),
              VerticalDivider(
                      width: 1,
                      color: appColor(context).appTheme.stroke,
                      thickness: 1,
                      indent: 3,
                      endIndent: 3)
                  .paddingSymmetric(horizontal: Insets.i8),
              SvgPicture.asset(eSvgAssets.clock,
                  colorFilter: ColorFilter.mode(
                      appColor(context).appTheme.darkText, BlendMode.srcIn)),
              const HSpace(Sizes.s6),
              Text(language(context, data!.createdAt!),
                  style: appCss.dmDenseMedium13
                      .textColor(appColor(context).appTheme.darkText))
            ]),
          ),
        ]),
        data!.service!.media != null && data!.service!.media!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: data!.service!.media![0].originalUrl!,
                imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s84,
                    width: Sizes.s84,
                    decoration: ShapeDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                        shape: const SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius.all(SmoothRadius(
                                cornerRadius: AppRadius.r10,
                                cornerSmoothing: 1))))),
                placeholder: (context, url) => CommonCachedImage(
                    image: eImageAssets.noImageFound1,
                    height: Sizes.s84,
                    width: Sizes.s84,
                    radius: AppRadius.r10),
                errorWidget: (context, url, error) => CommonCachedImage(
                    image: eImageAssets.noImageFound1,
                    height: Sizes.s84,
                    width: Sizes.s84,
                    radius: AppRadius.r10))
            : CommonCachedImage(
                image: eImageAssets.noImageFound1,
                height: Sizes.s84,
                width: Sizes.s84,
                radius: AppRadius.r10)
      ]),
      const VSpace(Sizes.s12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, translations!.requiredServiceman),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.darkText)),
        const HSpace(Sizes.s8),
        Text(
            language(context,
                "${data!.requiredServicemen!} ${translations!.serviceman}"),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.primary))
      ]),
      const DottedLines().paddingSymmetric(vertical: Insets.i12),
      Stack(alignment: Alignment.bottomCenter, children: [
        data!.servicemen!.isNotEmpty
            ? Column(children: [
                if (data!.servicemen!.isNotEmpty)
                  data!.isExpand == true
                      ? Column(
                          children: data!.servicemen!.asMap().entries.map((s) {
                          return ServiceProviderLayout(
                              title: capitalizeFirstLetter(
                                  language(context, translations!.serviceman)),
                              image: s.value.media != null
                                  ? s.value.media![0].originalUrl!
                                  : null,
                              name: s.value.name,
                              rate: s.value.reviewRatings ?? "0",
                              index: s.key,
                              list: data!.servicemen!);
                        }).toList())
                      : Column(
                          children: data!.servicemen!
                              .getRange(0, 1)
                              .toList()
                              .asMap()
                              .entries
                              .map((s) {
                          return ServiceProviderLayout(
                              expand: data!.isExpand,
                              title: translations!.serviceman,
                              image: s.value.media != null
                                  ? s.value.media![0].originalUrl!
                                  : null,
                              name: s.value.name,
                              rate: s.value.reviewRatings ?? "0",
                              index: s.key,
                              list: const []);
                        }).toList()),
              ])
                .paddingSymmetric(horizontal: Insets.i15)
                .boxShapeExtension(
                    color: appColor(context).appTheme.fieldCardBg,
                    radius: AppRadius.r12)
                .paddingOnly(
                    bottom: data!.servicemen!.length > 1 ? Insets.i20 : 0)
            : Text(
                    language(context,
                        "${translations!.note}${translations!.servicemanNotSelectedYet}"),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.lightText))
                .alignment(Alignment.centerLeft),
        if (data!.servicemen != null)
          if (data!.servicemen!.length > 1)
            CommonArrow(
                arrow: data!.isExpand == true
                    ? eSvgAssets.upDoubleArrow
                    : eSvgAssets.downDoubleArrow,
                isThirteen: true,
                onTap: () => value.onExpand(data),
                color: appColor(context).appTheme.whiteBg)
      ])
    ])
        .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i20)
        .boxBorderExtension(context, bColor: appColor(context).appTheme.stroke)
        .paddingOnly(bottom: Insets.i15)
        .inkWell(onTap: onTap);
  }
}
