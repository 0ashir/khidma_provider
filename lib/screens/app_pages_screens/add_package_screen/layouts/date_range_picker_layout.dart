import 'package:flutter/cupertino.dart';
import '../../../../config.dart';
import '../../../../providers/app_pages_provider/offer_chat_provider.dart';

class DateRangePickerLayout extends StatelessWidget {
  final bool isOffer ;
  const DateRangePickerLayout({super.key,this.isOffer=false});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddPackageProvider,OfferChatProvider>(builder: (context1, value,offer, child) {
      return AnimatedSize(
          duration: const Duration(microseconds: 300),
          child: SingleChildScrollView(
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.selectDate),
                    style: appCss.dmDenseMedium18
                        .textColor(appColor(context).appTheme.darkText)),
                const Icon(CupertinoIcons.multiply)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i15),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CommonArrow(
                    arrow: eSvgAssets.arrowLeft,
                    onTap: () => value.onLeftArrow()),
                const HSpace(Sizes.s20),
           /*     Container(
                    height: Sizes.s34,
                    alignment: Alignment.center,
                    width: Sizes.s100,
                    child: DropdownButton(
                        underline: Container(),
                        focusColor: Colors.white,
                        value: isOffer?offer.chosenValue: value.chosenValue,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: appColor(context).appTheme.darkText,
                        items: appArray.monthList
                            .map<DropdownMenuItem>((monthValue) {
                          return DropdownMenuItem(
                              onTap: () =>
                              isOffer?offer.onTapMonth(monthValue['title']):   value.onTapMonth(monthValue['title']),
                              value: monthValue,
                              child: Text(monthValue['title'],
                                  style: TextStyle(
                                      color: appColor(context)
                                          .appTheme
                                          .darkText)));
                        }).toList(),
                        icon: SvgPicture.asset(eSvgAssets.dropDown),
                        onChanged: (choseVal) => isOffer?offer
                            .onDropDownChange(choseVal): value
                            .onDropDownChange(choseVal))).boxShapeExtension(
                    color: appColor(context).appTheme.fieldCardBg,
                    radius: AppRadius.r4),*/
                const HSpace(Sizes.s20),
                Container(
                    alignment: Alignment.center,
                    height: Sizes.s34,
                    width: Sizes.s87,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("${ isOffer? offer.selectedYear.year: value.selectedYear.year}"),
                          SvgPicture.asset(eSvgAssets.dropDown)
                        ]))
                    .boxShapeExtension(
                    color: appColor(context).appTheme.fieldCardBg,
                    radius: AppRadius.r4)
                    .inkWell(onTap: () => isOffer? offer.selectYear(context): value.selectYear(context)),
                const HSpace(Sizes.s20),
                CommonArrow(
                    arrow: eSvgAssets.arrowRight,
                    onTap: () =>isOffer? offer.onRightArrow(): value.onRightArrow()),
              ]).paddingSymmetric(horizontal: Insets.i10),
              const VSpace(Sizes.s15),
              CustomTableDateRange(isOffer: isOffer),
              const VSpace(Sizes.s15),
              ButtonCommon(
                  title: appFonts.selectDate,
                  onTap: () =>isOffer? offer.onSelect(context): value.onSelect(context))
                  .paddingDirectional(horizontal: Insets.i20, bottom: Sizes.s20)
            ]),
          ));
    });
  }
}
