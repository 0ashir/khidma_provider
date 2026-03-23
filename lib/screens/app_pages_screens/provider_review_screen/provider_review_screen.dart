import 'dart:developer';

import '../../../config.dart';

class ProviderReviewScreen extends StatelessWidget {
  const ProviderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServiceReviewProvider>(
        builder: (context, lang, value, child) {
      return Scaffold(
          appBar: AppBarCommon(title: translations!.review),
          body: SingleChildScrollView(
              child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              RatingLayout(
                  initialRating:
                      double.parse(value.services!.ratingCount.toString())),
              Row(children: [
                Text(language(context, translations!.averageRate),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.primary)),
                const HSpace(Sizes.s4),
                Text("${value.services!.ratingCount}/5",
                    style: appCss.dmDenseSemiBold12
                        .textColor(appColor(context).appTheme.primary))
              ])
            ])
                .paddingSymmetric(vertical: Insets.i12, horizontal: Insets.i15)
                .decorated(
                    color: appColor(context).appTheme.primary.withOpacity(0.2),
                    border:
                        Border.all(color: appColor(context).appTheme.primary),
                    borderRadius: BorderRadius.circular(AppRadius.r20))
                .paddingSymmetric(horizontal: Insets.i40),
            const VSpace(Sizes.s15),
            Column(
                    children: value.services!.reviewRatings!.reversed
                        .toList()
                        .asMap()
                        .entries
                        .map((e) => ProgressBarLayout(
                            data: e.value,
                            index: e.key,
                            list: appArray.reviewRating))
                        .toList())
                .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i20)
                .boxBorderExtension(context, isShadow: true),
            const VSpace(Sizes.s25),
            Row(children: [
              Expanded(
                  flex: 4,
                  child: Text(language(context, translations!.review),
                      style: appCss.dmDenseMedium16
                          .textColor(appColor(context).appTheme.darkText))),
              Expanded(
                  flex: 3,
                  child: DropDownLayout(
                      isField: true,
                      isIcon: false,
                      hintText: translations!.all,
                      val: value.settingExValue,
                      categoryList: appArray.reviewLowHighList,
                      onChanged: (val) => value.onSettingReview(val)))
            ]),
            const VSpace(Sizes.s15),
            /* ...appArray.reviewList
                .asMap()
                .entries
                .map((e) => ServiceReviewLayout(
                    isSetting: true,
                    data: e.value,
                    index: e.key,
                    list: appArray.reviewList))
                .toList()*/
          ]).paddingSymmetric(horizontal: Insets.i20)));
    });
  }
}
