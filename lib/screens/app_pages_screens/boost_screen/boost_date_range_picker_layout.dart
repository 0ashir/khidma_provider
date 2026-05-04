import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';
import '../../../providers/app_pages_provider/boost_provider.dart';
import 'custom_table_date_range.dart';

class BoostDateRangePickerLayout extends StatelessWidget {
  const BoostDateRangePickerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, BoostProvider>(
        builder: (context1, lang, value, child) {
      final now = DateTime.now();
      final lastDayOfNextMonth = DateTime(now.year, now.month + 2, 0);
      return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(language(context, translations!.selectDate),
                style: appCss.dmDenseMedium18
                    .textColor(appColor(context).appTheme.darkText)),
            const Icon(CupertinoIcons.multiply)
                .inkWell(onTap: () => route.pop(context))
          ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i15),
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   CommonArrow(
          //       arrow: eSvgAssets.arrowLeft, onTap: () => value.onLeftArrow()),
          //   const HSpace(Sizes.s20),
          //   Container(
          //           height: Sizes.s34,
          //           alignment: Alignment.center,
          //           width: Sizes.s100,
          //           child: DropdownButton<String>(
          //             underline: Container(),
          //             focusColor: Colors.white,
          //             value: value.chosenValue,
          //             style: const TextStyle(color: Colors.white),
          //             iconEnabledColor: appColor(context).appTheme.darkText,
          //             items: appArray.monthList
          //                 .map<DropdownMenuItem<String>>((monthValue) {
          //               final String monthTitle = monthValue['title'];
          //               return DropdownMenuItem<String>(
          //                 value: monthTitle,
          //                 child: Text(
          //                   monthTitle,
          //                   style: TextStyle(
          //                       color: appColor(context).appTheme.darkText),
          //                 ),
          //               );
          //             }).toList(),
          //             icon: SvgPicture.asset(eSvgAssets.dropDown),
          //             onChanged: (choseVal) => value.onDropDownChange(choseVal),
          //           ))
          //       .boxShapeExtension(
          //           color: appColor(context).appTheme.fieldCardBg,
          //           radius: AppRadius.r4),
          //   const HSpace(Sizes.s20),
          //   Container(
          //           alignment: Alignment.center,
          //           height: Sizes.s34,
          //           width: Sizes.s87,
          //           child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: [
          //                 Text("${value.selectedYear.year}"),
          //                 SvgPicture.asset(eSvgAssets.dropDown)
          //               ]))
          //       .boxShapeExtension(
          //           color: appColor(context).appTheme.fieldCardBg,
          //           radius: AppRadius.r4)
          //       .inkWell(onTap: () => value.selectYear(context)),
          //   const HSpace(Sizes.s20),
          //   CommonArrow(
          //       arrow: eSvgAssets.arrowRight,
          //       onTap: () => value.onRightArrow()),
          // ]).paddingSymmetric(horizontal: Insets.i10),
          // if (value.startDateCtrl.text == '')
          Text("${DateFormat.MMMM().format(lastDayOfNextMonth)} ${lastDayOfNextMonth.year}",
                  style: appCss.dmDenseBold18
                      .textColor(appColor(context).appTheme.darkText))
              .padding(horizontal: Sizes.s20, bottom: Sizes.s10),

          Text(" ${value.startDateCtrl.text}  ${value.endDateCtrl.text}",
                  style: appCss.dmDenseLight14
                      .textColor(appColor(context).appTheme.darkText))
              .padding(horizontal: Sizes.s20),
          const VSpace(Sizes.s15),
          const BoostCustomTableDateRange(),
          const VSpace(Sizes.s15),
          ButtonCommon(
                  title: translations!.selectDate,
                  onTap: () => value.onSelect(context))
              .paddingDirectional(horizontal: Insets.i20, bottom: Sizes.s30)
        ]),
      );
    });
  }
}
