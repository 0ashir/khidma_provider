import 'package:fixit_provider/screens/bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

import '../../../config.dart';

class ServiceReviewScreen extends StatelessWidget {
  const ServiceReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServiceReviewProvider>(
        builder: (context1, lang, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: PopScope(
              canPop: true,
              onPopInvoked: (bool? popInvoke) => value.onBack(context, false),
              child: Scaffold(
                  appBar: AppBarCommon(
                      title: translations!.review,
                      onTap: () => value.onBack(context, true)),
                  body: value.isreviewLoading == true
                      ? const BookingDetailShimmer()
                      : SingleChildScrollView(
                          child: Column(children: [
                          value.services == null
                              ? Container()
                              : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                      RatingLayout(
                                          initialRating:
                                              value.services!.ratingCount !=
                                                      null
                                                  ? double.parse(value
                                                      .services!.ratingCount
                                                      .toString())
                                                  : 0),
                                      Row(children: [
                                        Text(
                                            language(context,
                                                translations!.averageRate),
                                            style: appCss.dmDenseMedium12
                                                .textColor(appColor(context)
                                                    .appTheme
                                                    .primary)),
                                        const HSpace(Sizes.s4),
                                        Text(
                                            "${value.services!.ratingCount ?? 0}/5",
                                            style: appCss.dmDenseSemiBold12
                                                .textColor(appColor(context)
                                                    .appTheme
                                                    .primary))
                                      ])
                                    ])
                                  .paddingSymmetric(
                                      vertical: Insets.i12,
                                      horizontal: Insets.i15)
                                  .decorated(
                                      color: appColor(context)
                                          .appTheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      border: Border.all(
                                          color: appColor(context)
                                              .appTheme
                                              .primary),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.r20))
                                  .paddingSymmetric(horizontal: Insets.i40),
                          if (value.services != null) const VSpace(Sizes.s15),
                          value.services == null
                              ? Container()
                              : Column(
                                      children: value
                                          .services!.reviewRatings!.reversed
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((e) => ProgressBarLayout(
                                              data: e.value,
                                              index: e.key,
                                              list: value
                                                  .services!.reviewRatings!))
                                          .toList())
                                  .paddingSymmetric(
                                      vertical: Insets.i15,
                                      horizontal: Insets.i20)
                                  .boxBorderExtension(context, isShadow: true),
                          const VSpace(Sizes.s25),
                          Row(children: [
                            Expanded(
                                flex: 4,
                                child: Text(
                                    language(context, translations!.review),
                                    style: appCss.dmDenseMedium16.textColor(
                                        appColor(context).appTheme.darkText))),
                            Expanded(
                                flex: 3,
                                child: DarkDropDownLayout(
                                    svgColor:
                                        appColor(context).appTheme.lightText,
                                    border: CommonWidgetLayout().noneDecoration(
                                        radius: 0,
                                        color:
                                            appColor(context).appTheme.trans),
                                    isOnlyText: true,
                                    isField: true,
                                    isIcon: false,
                                    hintText: translations!.all,
                                    val: value.exValue,
                                    reviewLowHighList:
                                        appArray.reviewLowHighList,
                                    onChanged: (val) => value.onReview(val)))
                          ]),
                          const VSpace(Sizes.s15),
                          if (value.reviewList.isNotEmpty)
                            ...value.reviewList.asMap().entries.map((e) =>
                                ServiceReviewLayout(
                                        isSetting: value.isSetting,
                                        onTap: () =>
                                            value.onTap(context, e.value),
                                        data: e.value,
                                        index: e.key)
                                    .padding(bottom: Insets.i10)),
                          if (value.reviewList.isEmpty) CommonEmpty(),
                        ]).padding(
                              horizontal: Insets.i20, bottom: Insets.i20)))));
    });
  }
}
