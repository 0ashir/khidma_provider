/*
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class SelectTimeSheet extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? type;

  const SelectTimeSheet({super.key, this.onTap, this.type});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer<TimeSlotProvider>(builder: (context, value, child) {
        return StatefulWrapper(
          onInit: () =>
              Future.delayed(Durations.short3).then((_) {} */
/*value.fetchData()*//*
),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.58,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, translations!.selectTime),
                          style: appCss.dmDenseblack18
                              .textColor(appColor(context).appTheme.darkText)),
                      const Icon(CupertinoIcons.multiply)
                          .inkWell(onTap: () => route.pop(context))
                    ]).paddingAll(Insets.i20),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectTimeWheelLayout(
                          childCount: 13,
                          controller: value.controller1,
                          scrollHourIndex: value.scrollHourIndex,
                          */
/*onSelectedItemChanged: (val) =>
                              value.onHourChange(val),*//*

                          builder: (context, index) {
                            return HourLayout(
                                hours: index,
                                index: index,
                                selectIndex: value.scrollHourIndex);
                          }),
                      const HSpace(Sizes.s12),
                      SelectTimeWheelLayout(
                          childCount: 60,
                          controller: value.controller2,
                          scrollHourIndex: value.scrollMinIndex,
                     */
/*     onSelectedItemChanged: (val) =>
                              value.onMinChange(val),*//*

                          builder: (context, index) {
                            return MyMinutes(
                                index: index,
                                selectIndex: value.scrollMinIndex,
                                min: index);
                          }),
                      const HSpace(Sizes.s12),
                      SelectTimeWheelLayout(
                          childCount: 2,
                          controller: value.controller3,
                          scrollHourIndex: value.scrollDayIndex,
                      */
/*    onSelectedItemChanged: (val) =>
                              value.onAmPmChange(val),*//*

                          builder: (context, index) {
                            if (index == 0) {
                              return AmPmLayout(
                                  index: index,
                                  selectIndex: value.scrollDayIndex,
                                  isItAm: true);
                            } else {
                              return AmPmLayout(
                                  index: index,
                                  selectIndex: value.scrollDayIndex,
                                  isItAm: false);
                            }
                          })
                    ]).paddingSymmetric(horizontal: Insets.i20),
                ButtonCommon(title: translations!.addTime, onTap: onTap)
                    .paddingSymmetric(horizontal: Insets.i20)
              ]))).bottomSheetExtension(context),
        );
      });
    });
  }
}
*/
