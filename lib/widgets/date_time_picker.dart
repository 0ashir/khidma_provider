import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../config.dart';

class DateTimePicker extends StatefulWidget {
  final bool? isWeek;

  const DateTimePicker({super.key, this.isWeek = false});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime dateTime = DateTime.now();
  ScrollController hourController = ScrollController();
  ScrollController minuteController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, EarningHistoryProvider>(
        builder: (context1, lang, value, child) {
          return StatefulWrapper(
              onInit: () =>
                  Future.delayed(DurationsDelay.ms150)
                      .then((val) => value.onInit()),
              child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.5,
                  decoration: ShapeDecoration(
                      color: appColor(context).appTheme.whiteBg,
                      shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.only(
                              topLeft: SmoothRadius(
                                  cornerRadius: 10, cornerSmoothing: 1),
                              topRight: SmoothRadius(
                                  cornerRadius: 10, cornerSmoothing: 1)))),
                  child: SingleChildScrollView(
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language(context, translations!.selectDate),
                                  style: appCss.dmDenseBold18
                                      .textColor(appColor(context).appTheme
                                      .darkText)),
                              const Icon(CupertinoIcons.multiply)
                                  .inkWell(onTap: () => route.pop(context))
                            ]).paddingSymmetric(
                            horizontal: Insets.i20, vertical: Insets.i20),
                        if (value.rangeEnd != null)
                          Text("${value.rangeStart!.day} ${monthCondition(value
                              .rangeStart!.month.toString())} TO ${value
                              .rangeEnd!.day} ${monthCondition(value.rangeStart!
                              .month.toString())} ${value.selectedYear.year}",
                              style: appCss.dmDenseMedium18
                                  .textColor(appColor(context).appTheme
                                  .primary))
                              .padding(
                              horizontal: Insets.i20, bottom: Insets.i15)
                              .alignment(Alignment.centerLeft),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonArrow(
                                  arrow: eSvgAssets.arrowLeft,
                                  onTap: () => value.onLeftArrow()),
                              const HSpace(Sizes.s20),
                              Container(
                                  height: Sizes.s34,
                                  alignment: Alignment.center,
                                  width: Sizes.s100,
                                  child: DropdownButton(
                                      underline: Container(),
                                      focusColor: Colors.white,
                                      value: value.chosenValue,
                                      style: const TextStyle(
                                          color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      items: appArray.monthList
                                          .map<DropdownMenuItem>((monthValue) {
                                        return DropdownMenuItem(
                                            value: monthValue,
                                            child: Text(monthValue['title'],
                                                style:
                                                const TextStyle(
                                                    color: Colors.black)));
                                      }).toList(),
                                      icon: SvgPicture.asset(
                                          eSvgAssets.dropDown),
                                      onChanged: (choseVal) =>
                                          value
                                              .onDropDownChange(choseVal)))
                                  .boxShapeExtension(
                                  color: appColor(context).appTheme.fieldCardBg,
                                  radius: AppRadius.r4),
                              const HSpace(Sizes.s20),
                              Container(
                                  alignment: Alignment.center,
                                  height: Sizes.s34,
                                  width: Sizes.s87,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        Text("${value.selectedYear.year}"),
                                        SvgPicture.asset(eSvgAssets.dropDown)
                                      ]))
                                  .boxShapeExtension(
                                  color: appColor(context).appTheme.fieldCardBg,
                                  radius: AppRadius.r4)
                                  .inkWell(onTap: () =>
                                  value.selectYear(context)),
                              const HSpace(Sizes.s20),
                              CommonArrow(
                                  arrow: eSvgAssets.arrowRight,
                                  onTap: () => value.onRightArrow()),
                            ]).paddingSymmetric(horizontal: Insets.i10),
                        const VSpace(Sizes.s15),
                        TableCalendar(
                            rowHeight: 40,
                            headerVisible: false,
                            daysOfWeekVisible: true,
                            pageJumpingEnabled: true,
                            pageAnimationEnabled: false,
                            rangeSelectionMode: RangeSelectionMode.toggledOn,
                            lastDay: DateTime(
                                DateTime
                                    .now()
                                    .year,
                                DateTime
                                    .now()
                                    .month + 1,
                                DateTime
                                    .now()
                                    .day
                            ),
                            firstDay: DateTime.utc(DateTime
                                .now()
                                .year,
                                DateTime.january, DateTime
                                    .now()
                                    .day),
                            onDaySelected: value.onDaySelected,
                            focusedDay: value.focusedDay.value,
                            rangeStartDay: value.rangeStart,
                            rangeEndDay: value.rangeEnd,
                            availableGestures: AvailableGestures.none,
                            calendarFormat: value.calendarFormat,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            onRangeSelected: (start, end, focusedDay) =>
                                value.onRangeSelect(start, end, focusedDay,context),
                            headerStyle: const HeaderStyle(
                                leftChevronVisible: false,
                                formatButtonVisible: false,
                                rightChevronVisible: false),
                            onPageChanged: (dayFocused) =>
                                value.onPageCtrl(dayFocused),
                            onCalendarCreated: (controller) =>
                                value.onCalendarCreate(controller),
                            selectedDayPredicate: (day) {
                              return isSameDay(value.focusedDay.value, day);
                            },
                            daysOfWeekStyle: DaysOfWeekStyle(
                                dowTextFormatter: (date, locale) =>
                                DateFormat.E(locale).format(date)[0],
                                weekdayStyle: appCss.dmDenseBold14
                                    .textColor(
                                    appColor(context).appTheme.primary),
                                weekendStyle: appCss.dmDenseBold14
                                    .textColor(
                                    appColor(context).appTheme.primary)),
                            calendarStyle: CalendarStyle(
                                rangeHighlightColor: appColor(context)
                                    .appTheme
                                    .primary
                                    .withOpacity(0.10),
                                rangeEndDecoration: BoxDecoration(
                                    color: appColor(context).appTheme.primary,
                                    shape: BoxShape.circle),
                                defaultTextStyle: appCss.dmDenseLight14
                                    .textColor(
                                    appColor(context).appTheme.darkText),
                                withinRangeTextStyle: appCss.dmDenseLight14
                                    .textColor(
                                    appColor(context).appTheme.primary),
                                rangeStartTextStyle: appCss.dmDenseLight14
                                    .textColor(
                                    appColor(context).appTheme.whiteColor),
                                rangeEndTextStyle: appCss.dmDenseLight14
                                    .textColor(
                                    appColor(context).appTheme.whiteColor),
                                rangeStartDecoration: BoxDecoration(
                                    color: appColor(context).appTheme.primary,
                                    shape: BoxShape.circle),
                                todayTextStyle: appCss.dmDenseMedium14
                                    .textColor(
                                    appColor(context).appTheme.primary),
                                todayDecoration: BoxDecoration(
                                    color: appColor(context).appTheme.primary
                                        .withOpacity(.10),
                                    shape: BoxShape.circle)))
                            .paddingAll(Insets.i20)
                            .boxShapeExtension(
                            color: appColor(context).appTheme.fieldCardBg)
                            .paddingSymmetric(horizontal: Insets.i20),
                        BottomSheetButtonCommon(
                            textOne: translations!.clearFilter,
                            textTwo: translations!.apply,
                            applyTap: () {
                              Provider.of<EarningHistoryProvider>(
                                  context, listen: false)
                                  .commissionHistory(context);
                              route.pop(context);
                            },
                            clearTap: () {
                              value.rangeStart=null;
                              value.rangeEnd=null;
                              Provider.of<EarningHistoryProvider>(
                                  context, listen: false)
                                  .commissionHistory(context);
                              route.pop(context);
                            })
                            .paddingSymmetric(
                            horizontal: Insets.i20, vertical: Insets.i20)
                      ]))));
        });
  }
}
