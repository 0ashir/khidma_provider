import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class PaymentHistoryLayout extends StatelessWidget {
  final PaymentHistoryModel? data;
  final GestureTapCallback? onTap;

  const PaymentHistoryLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    log("data!.createdAt! ${data!.createdAt!}");
    return data!.booking != null
        ? Column(children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data!.detail!,
                            style: appCss.dmDenseMedium14.textColor(
                                appColor(context).appTheme.darkText)),
                        const VSpace(Sizes.s5),
                        Text("\$${data!.amount}",
                            style: appCss.dmDenseBold18
                                .textColor(appColor(context).appTheme.darkText))
                      ]),
                  if (data!.bookingId != null)
                    BookingIdLayout(id: data!.booking!.bookingNumber)
                ]),
            const VSpace(Sizes.s12),
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(appColor(context).appTheme.isDark
                            ? eImageAssets.bookingDetailBg
                            : eImageAssets.commissionBg),
                        fit: BoxFit.fill)),
                child: Column(children: [
                  WalletRowLayout(
                      id: "#${data!.booking!.parentId}",
                      title: translations!.paymentId),
                  WalletRowLayout(
                      id: data!.booking!.paymentMethod,
                      title: translations!.methodType),
                  WalletRowLayout(
                      id: data!.booking!.paymentStatus,
                      title: translations!.status)
                ]).padding(horizontal: Insets.i15, top: Insets.i15)),
            const VSpace(Sizes.s10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(
                    height: Sizes.s36,
                    width: Sizes.s36,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data!
                                .booking!.consumer!.media![0].originalUrl!)))),
                const HSpace(Sizes.s12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(language(context, translations!.customer),
                      style: appCss.dmDenseRegular12
                          .textColor(appColor(context).appTheme.lightText)),
                  Text(data!.booking!.consumer!.name!,
                      style: appCss.dmDenseMedium13
                          .textColor(appColor(context).appTheme.darkText))
                ])
              ]),
              SvgPicture.asset(eSvgAssets.anchorArrowRight,
                      height: Sizes.s12,
                      width: Sizes.s12,
                      colorFilter: ColorFilter.mode(
                          appColor(context).appTheme.primary, BlendMode.srcIn))
                  .inkWell(onTap: onTap)
            ]).paddingAll(Insets.i12).boxBorderExtension(context,
                isShadow: true, bColor: appColor(context).appTheme.stroke)
          ])
            .paddingAll(Insets.i15)
            .boxBorderExtension(context,
                isShadow: true, bColor: appColor(context).appTheme.stroke)
            .paddingOnly(bottom: Insets.i25)
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.75,
                  child: Text(data!.detail!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appCss.dmDenseSemiBold14
                          .textColor(appColor(context).appTheme.darkText))),
              const VSpace(Sizes.s3),
              Text(
                  DateFormat("dd MMM, yyyy hh:mm a")
                      .format(DateTime.parse(data!.createdAt!)),
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText))
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                  symbolPosition
                      ? "${currency(context).priceSymbol}${(currency(context).currencyVal * data!.amount!).toStringAsFixed(2)}"
                      : "${(currency(context).currencyVal * data!.amount!).toStringAsFixed(2)}${currency(context).priceSymbol}",
                  style: appCss.dmDenseSemiBold14
                      .textColor(appColor(context).appTheme.darkText)),
              Text(capitalizeFirstLetter(data!.type!.toString()),
                  style: appCss.dmDenseMedium12.textColor(
                      data!.type! == "credit"
                          ? appColor(context).appTheme.online
                          : appColor(context).appTheme.red))
            ])
          ])
            .paddingAll(Insets.i15)
            .boxBorderExtension(context,
                isShadow: true, bColor: appColor(context).appTheme.stroke)
            .paddingOnly(bottom: Insets.i25);
  }
}
