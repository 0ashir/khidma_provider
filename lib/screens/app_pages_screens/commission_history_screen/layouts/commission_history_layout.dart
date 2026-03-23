import 'package:intl/intl.dart';

import '../../../../config.dart';

class CommissionHistoryLayout extends StatelessWidget {
  final Histories? data;
  final GestureTapCallback? onTap;

  const CommissionHistoryLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(language(context, translations!.bookingId),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
            const VSpace(Sizes.s6),
            Text(
                DateFormat("dd MMM, yyyy hh:mm a").format(DateTime.parse(
                    language(context, data!.createdAt.toString()))),
                style: appCss.dmDenseRegular12
                    .textColor(appColor(context).appTheme.lightText))
          ]),
          BookingIdLayout(id: data!.booking?.bookingNumber)
        ]).paddingAll(Insets.i12).boxBorderExtension(context,
            bColor: appColor(context).appTheme.stroke,
            color: appColor(context).appTheme.fieldCardBg,
            radius: AppRadius.r10),
        const VSpace(Sizes.s15),
        if (isServiceman == false)
          CommissionRowLayout(
              data: data?.booking?.total ?? "0",
              title: translations!.servicePrice,
              style: appCss.dmDenseblack14
                  .textColor(appColor(context).appTheme.darkText)),
        if (isServiceman == false)
          CommissionRowLayout(
              title: translations!.adminCommission,
              data: data!.adminCommission!),
        /*  if (isServiceman == false) */
        if (isFreelancer == false)
          ...data!.servicemanCommissions!.map((charge) {
            return CommissionRowLayout(
                title: /* isServiceman
                  ? translations!.yourCommission
                  : */
                    translations!.servicemenCommission,
                data: charge.commission);
          }),
        /* CommissionRowLayout(
              title: /* isServiceman
                  ? translations!.yourCommission
                  : */
                  translations!.servicemenCommission,
              data: data!.servicemanCommissions?.first.commission), */
        CommissionRowLayout(
            title: translations!.platformFees,
            data: data?.booking?.platformFees ?? "0"),
        /*  if (isServiceman == false)
          CommissionRowLayout(
              title: translations!.yourCommission,
              color: appColor(context).appTheme.primary,
              data: data!.providerCommission!) */
      ]).padding(horizontal: Insets.i15, top: Insets.i15),
      const DividerCommon().paddingOnly(bottom: Insets.i15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, translations!.viewMore),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.primary)),
        SizedBox(
            height: Sizes.s18,
            width: Sizes.s18,
            child: SvgPicture.asset(eSvgAssets.anchorArrowRight,
                colorFilter: ColorFilter.mode(
                    appColor(context).appTheme.primary, BlendMode.srcIn)))
      ]).padding(horizontal: Insets.i15, bottom: Insets.i15)
    ])
        .boxBorderExtension(context, isShadow: true, radius: AppRadius.r12)
        .inkWell(onTap: onTap)
        .paddingOnly(bottom: Insets.i15);
  }
}
