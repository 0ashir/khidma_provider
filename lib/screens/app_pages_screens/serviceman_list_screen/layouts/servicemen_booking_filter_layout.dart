import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class ServicemenBookingFilterLayout extends StatelessWidget {
  const ServicemenBookingFilterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider,ServicemanListProvider>(builder: (context, lang,value, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: SizedBox(
                    height: Sizes.s600,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(language(context, translations!.filterBy),
                                    style: appCss.dmDenseMedium18.textColor(
                                        appColor(context).appTheme.darkText)),
                                const Icon(CupertinoIcons.multiply)
                                    .inkWell(onTap: () => route.pop(context))
                              ]).paddingSymmetric(horizontal: Insets.i20),
                          Expanded(
                              child: Column(children: [
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                  SingleChildScrollView(
                                      child: Container(
                                              alignment: Alignment.center,
                                              height: Sizes.s50,
                                              decoration: BoxDecoration(
                                                  color: appColor(context)
                                                      .appTheme
                                                      .fieldCardBg,
                                                  borderRadius: const BorderRadius.all(Radius.circular(
                                                      AppRadius.r30))),
                                              child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: appArray.servicemanFilterList
                                                          .asMap()
                                                          .entries
                                                          .map((e) => FilterTapLayout(
                                                              data: e.value,
                                                              index: e.key,
                                                              selectedIndex: value.selectIndex,
                                                              onTap: () => value.onFilter(e.key)))
                                                          .toList())
                                                  .paddingAll(Insets.i5))
                                          .paddingOnly(top: Insets.i25, bottom: Insets.i20, left: Insets.i20, right: Insets.i20)),
                                  Text(
                                          language(
                                              context,
                                              value.selectIndex == 0
                                                  ? translations!.categoryList
                                                  : translations!
                                                      .showMemberSince),
                                          style: appCss.dmDenseMedium14
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .lightText))
                                      .paddingSymmetric(horizontal: Insets.i20),
                                  const VSpace(Sizes.s15),
                                  value.selectIndex == 0
                                      ? Column(children: [
                                          SearchTextFieldCommon(
                                            controller: value.categoryCtrl,
                                            focusNode: value.categoryFocus,
                                          ).padding(
                                              bottom: Insets.i15,
                                              horizontal: Insets.i20),
                                          ...categoryList.asMap().entries.map(
                                              (e) => ListTileLayout(
                                                  booking: e.value,
                                                  isBooking: true,
                                                  selectedCategory:
                                                      value.statusList,
                                                  index: e.key,
                                                  onTap: () =>
                                                      value.onCategoryChange(
                                                          context, e.key)))
                                        ])
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                  Text(
                                                      language(context,
                                                          translations!.year),
                                                      style: appCss
                                                          .dmDenseMedium14
                                                          .textColor(
                                                              appColor(context)
                                                                  .appTheme
                                                                  .darkText)),
                                                  const VSpace(Sizes.s6),
                                                  DropDownLayout(
                                                      icon: eSvgAssets.calender,
                                                      val: value.yearValue,
                                                      hintText: translations!
                                                          .selectYear,
                                                      isIcon: true,
                                                      categoryList: appArray
                                                          .jobExperienceList,
                                                      onChanged: (val) =>
                                                          value.onTapYear(val))
                                                ])
                                                .paddingAll(AppRadius.r15)
                                                .boxShapeExtension(
                                                    color: appColor(context)
                                                        .appTheme
                                                        .fieldCardBg)
                                                .paddingSymmetric(
                                                    horizontal: Insets.i20),
                                          ],
                                        )
                                ]))),
                            /* Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(language(context, translations!.showMemberSince),
                                  style: appCss.dmDenseMedium14
                                      .textColor(appColor(context).appTheme.lightText)).padding(horizontal: Insets.i20,top: Insets.i10,bottom: Insets.i15),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(language(context, translations!.year),
                                    style: appCss.dmDenseMedium14
                                        .textColor(appColor(context).appTheme.darkText)),
                                const VSpace(Sizes.s6),
                                DropDownLayout(
                                    icon: eSvgAssets.calender,
                                    val: value.yearValue,
                                    isIcon: true,
                                    categoryList: appArray.jobExperienceList,
                                    onChanged: (val) => value.onTapYear(val))

                              ]).paddingAll(AppRadius.r15).boxShapeExtension(
                                  color: appColor(context).appTheme.fieldCardBg).paddingSymmetric(horizontal: Insets.i20),
                            ],)),*/
                            BottomSheetButtonCommon(
                                    textOne: translations!.clearAll,
                                    textTwo: translations!.apply,
                                    applyTap: () {},
                                    clearTap: () {})
                                .padding(
                                    horizontal: Insets.i20, bottom: Insets.i10)
                          ]))
                        ]).paddingOnly(top: Insets.i20))
                .bottomSheetExtension(context),
          ),
        ],
      );
    });
  }
}
