import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/completed_booking_screen/layouts/completed_booking_payment_summary_layout.dart';
import 'package:fixit_provider/screens/app_pages_screens/completed_booking_screen/layouts/service_proof_list.dart';
import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

class CompletedBookingBodyLayout extends StatelessWidget {
  const CompletedBookingBodyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CompletedBookingProvider, AddServiceProofProvider>(
        builder: (context, value, s, child) {
      return Stack(alignment: Alignment.bottomCenter, children: [
        SingleChildScrollView(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StatusDetailLayout(
                data: value.bookingModel,
                onTapStatus: () =>
                    showBookingStatus(context, value.bookingModel)),
            Text(language(context, translations!.billSummary),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText))
                .paddingOnly(top: Insets.i25, bottom: Insets.i10),
            OngoingBillSummary(bookingModel: value.bookingModel),
            if (value.bookingModel!.advancePaymentEnable!)
              PaymentSummaryWidget(
                booking: value.bookingModel!,
              ),
            const VSpace(Sizes.s20),
            Text(language(context, translations!.paymentSummary),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
            const VSpace(Sizes.s10),
            CompletedBookingPaymentSummaryLayout(
                bookingModel: value.bookingModel),
            const VSpace(Sizes.s20),
            if (value.bookingModel!.serviceProofs!.isNotEmpty)
              Text(language(context, translations!.serviceProof),
                      overflow: TextOverflow.ellipsis,
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).appTheme.darkText))
                  .paddingOnly(bottom: Insets.i10),
            if (value.bookingModel!.serviceProofs != null &&
                value.bookingModel!.serviceProofs!.isNotEmpty)
              ServiceProofList(
                  bookingModel: value.bookingModel,
                  onTap: (val) => value.addProofTap(context, data: val)),
            if (value.bookingModel!.serviceProofs != null &&
                value.bookingModel!.serviceProofs!.isNotEmpty)
              const VSpace(Sizes.s20),
            if (value.bookingModel!.service!.reviews != null &&
                value.bookingModel!.service!.reviews!.isNotEmpty)
              Column(
                children: [
                  HeadingRowCommon(
                      isViewAllShow:
                          value.bookingModel!.service!.reviews!.length >= 10,
                      title: translations!.review,
                      onTap: () {
                        Provider.of<ServiceReviewProvider>(context,
                                listen: false)
                            .getMyReview(context);
                        route.pushNamed(context, routeName.serviceReview);
                      }).paddingOnly(bottom: Insets.i12),
                  ...value.bookingModel!.service!.reviews!.asMap().entries.map(
                      (e) => SizedBox(
                                  child:
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading:
                                      (/* data['consumer']['media'] is List && */
                                              e
                                                  .value
                                                  .consumer!
                                                  .media! /* ['consumer']['media'] */
                                                  .isNotEmpty)
                                          ? CachedNetworkImage(
                                              imageUrl: /* data['consumer']['media'][0]['original_url'] */
                                                  e.value.consumer!.media?.first
                                                          .originalUrl ??
                                                      "",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: Sizes.s40,
                                                width: Sizes.s40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CommonCachedImage(
                                                      height: Sizes.s40,
                                                      width: Sizes.s40,
                                                      isCircle: true,
                                                      image: eImageAssets
                                                          .noImageFound1),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CommonCachedImage(
                                                          height: Sizes.s40,
                                                          width: Sizes.s40,
                                                          isCircle: true,
                                                          image: eImageAssets
                                                              .noImageFound1),
                                            )
                                          : CommonCachedImage(
                                              height: Sizes.s40,
                                              width: Sizes.s40,
                                              isCircle: true,
                                              image:
                                                  eImageAssets.noImageFound1),
                                  title: Text(
                                    e.value.consumer
                                            ?.name /*  data['consumer']?['name'] */ ??
                                        '',
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).appTheme.darkText),
                                  ),
                                  subtitle: /* data['created_at'] */
                                      e.value.createdAt != null
                                          ? Text(
                                              getTime(DateTime.parse(e
                                                  .value.createdAt
                                                  .toString() /* data['created_at'] */)),
                                              style: appCss.dmDenseMedium12
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .lightText),
                                            )
                                          : Container(),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(eSvgAssets.star),
                                      const HSpace(Sizes.s4),
                                      Text(
                                        e.value.rating /*  data['rating'] */
                                            .toString(),
                                        style: appCss.dmDenseMedium12.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText),
                                      ),
                                    ],
                                  ),
                                ),
                                const VSpace(Sizes.s5),
                                Text(
                                        e.value.description /* .data!['description'] */ ??
                                            "",
                                        style: appCss.dmDenseRegular12
                                            .textColor(appColor(context)
                                                .appTheme
                                                .darkText))
                                    .paddingOnly(bottom: Insets.i15),
                              ]))
                              .paddingSymmetric(horizontal: Insets.i15)
                              .boxBorderExtension(context,
                                  bColor: appColor(context).appTheme.stroke))
                ],
              )
            /* ReviewListWithTitle(
                  reviews: value.bookingModel!.service!.reviews!) */
          ]).paddingAll(Insets.i20)
        ]).paddingOnly(bottom: Insets.i100)),
        if (isServiceman || isFreelancer)
          /*  value.bookingModel?.bookingStatus?.slug == 'completed'
              ? const SizedBox()
              :*/
          value.bookingModel?.service?.type != "remotely"
              ? Material(
                  elevation: 20,
                  child: value.bookingModel!.serviceProofs!.isNotEmpty
                      ? ButtonCommon(
                              onTap: () => value.addProofTap(context),
                              title: translations!.addServiceProof,
                              style: appCss.dmDenseRegular16.textColor(
                                  appColor(context).appTheme.primary),
                              color: appColor(context).appTheme.trans,
                              borderColor: appColor(context).appTheme.primary)
                          .paddingAll(Insets.i20)
                          .decorated(color: appColor(context).appTheme.whiteBg)
                      : ButtonCommon(
                              onTap: () => value.addProofTap(context),
                              title: translations!.addServiceProof)
                          .paddingAll(Insets.i20)
                          .decorated(color: appColor(context).appTheme.whiteBg))
              : Container()
      ]);
    });
  }
}
