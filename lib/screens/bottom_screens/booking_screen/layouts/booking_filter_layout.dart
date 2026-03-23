import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';

class BookingFilterLayout extends StatelessWidget {
  const BookingFilterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<LanguageProvider, BookingProvider, CategoriesListProvider,
            UserDataApiProvider>(
        builder: (context, lang, value, cat, userApi, child) {
      return SafeArea(
        child: SizedBox(
                height: value.selectIndex == 1 ? 660 : Sizes.s600,
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
                      SingleChildScrollView(
                          child: Container(
                                  alignment: Alignment.center,
                                  height: Sizes.s50,
                                  decoration: BoxDecoration(
                                      color: appColor(context)
                                          .appTheme
                                          .fieldCardBg,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(AppRadius.r30))),
                                  child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: appArray.bookingFilterList
                                              .asMap()
                                              .entries
                                              .map((e) => CommonFilterLayout(
                                                  data: e.value,
                                                  index: e.key,
                                                  selectedIndex:
                                                      value.selectIndex,
                                                  onTap: () =>
                                                      value.onFilter(e.key)))
                                              .toList())
                                      .paddingAll(Insets.i5))
                              .paddingOnly(
                                  top: Insets.i25,
                                  bottom: Insets.i20,
                                  left: Insets.i20,
                                  right: Insets.i20)),
                      Text(
                              language(
                                  context,
                                  value.selectIndex == 0
                                      ? translations!.bookingStatus
                                      : value.selectIndex == 1
                                          ? translations!.selectDateOnly
                                          : translations!.categoryList),
                              style: appCss.dmDenseMedium14.textColor(
                                  appColor(context).appTheme.lightText))
                          .paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s15),
                      Expanded(
                          child: Column(children: [
                        value.selectIndex == 0
                            ? Expanded(
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                ...bookingStatusList.asMap().entries.map((e) =>
                                    BookingStatusFilterLayout(
                                        title:
                                            capitalizeFirstLetter(e.value.name),
                                        index: e.key,
                                        selectedIndex: value.statusIndex,
                                        onTap: () =>
                                            value.onStatus(e.key)).inkWell(
                                        onTap: () => value.onStatus(e.key)))
                              ]).paddingSymmetric(horizontal: Insets.i20)))
                            : value.selectIndex == 2
                                ? Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(children: [
                                    SearchTextFieldCommon(
                                        focusNode: value.categoriesFocus,
                                        controller: value.categoryCtrl,
                                        onChanged: (v) {
                                          /* log("value.categoryCtrl.text::${cat
                                                .searchCtrl.text}/// $v"); */
                                          if (v.isEmpty) {
                                            if (v.isEmpty) {
                                              cat.searchCategory(
                                                  context, cat.searchCtrl.text);
                                            }
                                            if (v.length > 2) {
                                              cat.searchCategory(
                                                  context, cat.searchCtrl.text);
                                            }
                                          }
                                        },
                                        onFieldSubmitted: (v) =>
                                            cat.searchCategory(
                                                context, v)).padding(
                                        bottom: Insets.i15,
                                        horizontal: Insets.i20),
                                    cat.searchCtrl.text.isNotEmpty
                                        ? Column(children: [
                                            ...cat.searchList
                                                .asMap()
                                                .entries
                                                .map((e) => ListTileLayout(
                                                    data: e.value,
                                                    isBooking: true,
                                                    isAddService: false,
                                                    selectedCategory: value
                                                        .selectedCategoryList,
                                                    index: e.key,
                                                    onTap: () =>
                                                        value.onCategoryChange(
                                                            context,
                                                            e.value.id)).inkWell(
                                                    onTap: () => value.onCategoryChange(
                                                        context, e.value.id)))
                                          ])
                                        : Column(children: [
                                            ...categoryList.asMap().entries.map(
                                                (e) => ListTileLayout(
                                                    data: e.value,
                                                    isBooking: true,
                                                    selectedCategory: value
                                                        .selectedCategoryList,
                                                    index: e.key,
                                                    onTap: () =>
                                                        value.onCategoryChange(
                                                            context,
                                                            e.value.id)).inkWell(
                                                    onTap: () =>
                                                        value.onCategoryChange(
                                                            context,
                                                            e.value.id)))
                                          ])
                                  ])))
                                : Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                        if (value.rangeEnd != null)
                                          Text("${value.rangeStart!.day} ${monthCondition(value.rangeStart!.month.toString())} TO ${value.rangeEnd!.day} ${monthCondition(value.rangeStart!.month.toString())} ${value.selectedYear.year}",
                                                  style: appCss.dmDenseMedium18
                                                      .textColor(
                                                          appColor(context)
                                                              .appTheme
                                                              .primary))
                                              .padding(
                                                  horizontal: Insets.i20,
                                                  bottom: Insets.i15),
                                        // Row(
                                        //     mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        //     children: [
                                        //       CommonArrow(
                                        //           arrow: eSvgAssets.arrowLeft,
                                        //           onTap: () =>
                                        //               value.onLeftArrow()),
                                        //       const HSpace(Sizes.s25),
                                        //       Container(
                                        //           height: Sizes.s34,
                                        //           alignment: Alignment.center,
                                        //           width: Sizes.s100,
                                        //           child: DropdownButton(
                                        //               underline: Container(),
                                        //               focusColor: Colors.white,
                                        //               value: value.chosenValue,
                                        //               // Ensure this stores the selected 'title'
                                        //               style: const TextStyle(
                                        //                   color: Colors.white),
                                        //               iconEnabledColor:
                                        //               appColor(context)
                                        //                   .appTheme
                                        //                   .darkText,
                                        //               items: appArray.monthList
                                        //                   .map<DropdownMenuItem>(
                                        //                       (monthValue) {
                                        //                     return DropdownMenuItem(
                                        //                         onTap: () =>
                                        //                             value
                                        //                                 .onTapMonth(
                                        //                                 monthValue[
                                        //                                 'title']),
                                        //                         value: monthValue,
                                        //                         child: Text(
                                        //                             monthValue[
                                        //                             'title'],
                                        //                             style: TextStyle(
                                        //                                 color: appColor(
                                        //                                     context)
                                        //                                     .appTheme
                                        //                                     .darkText)));
                                        //                   }).toList(),
                                        //               icon: SvgPicture.asset(
                                        //                   eSvgAssets.dropDown),
                                        //               onChanged: (choseVal) =>
                                        //                   value.onDropDownChange(
                                        //                       choseVal)))
                                        //           .boxShapeExtension(
                                        //           color: appColor(context)
                                        //               .appTheme
                                        //               .fieldCardBg,
                                        //           radius: AppRadius.r4),
                                        //       const HSpace(Sizes.s25),
                                        //       Container(
                                        //           alignment: Alignment.center,
                                        //           height: Sizes.s34,
                                        //           width: Sizes.s87,
                                        //           child: Row(
                                        //               mainAxisAlignment:
                                        //               MainAxisAlignment
                                        //                   .spaceAround,
                                        //               children: [
                                        //                 Text(
                                        //                     "${value.selectedYear
                                        //                         .year}"),
                                        //                 SvgPicture.asset(
                                        //                     eSvgAssets
                                        //                         .dropDown)
                                        //               ]))
                                        //           .boxShapeExtension(
                                        //           color: appColor(context)
                                        //               .appTheme
                                        //               .fieldCardBg,
                                        //           radius: AppRadius.r4)
                                        //           .inkWell(
                                        //           onTap: () =>
                                        //               value
                                        //                   .selectYear(context)),
                                        //       const HSpace(Sizes.s20),
                                        //       CommonArrow(
                                        //           arrow: eSvgAssets.arrowRight,
                                        //           onTap: () =>
                                        //               value.onRightArrow()),
                                        //     ]).paddingSymmetric(
                                        //     horizontal: Insets.i10),
                                        // const VSpace(Sizes.s15),
                                        TableCalendar(
                                                rowHeight: 40,
                                                headerVisible: false,
                                                daysOfWeekVisible: true,
                                                pageJumpingEnabled: true,
                                                pageAnimationEnabled: false,
                                                rangeSelectionMode:
                                                    RangeSelectionMode
                                                        .toggledOn,
                                                lastDay: DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month + 1,
                                                    DateTime.now().day),
                                                firstDay: DateTime.utc(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day),
                                                onDaySelected:
                                                    value.onDaySelected,
                                                focusedDay:
                                                    value.focusedDay.value,
                                                rangeStartDay: value.rangeStart,
                                                rangeEndDay: value.rangeEnd,
                                                availableGestures: AvailableGestures
                                                    .horizontalSwipe,
                                                calendarFormat:
                                                    value.calendarFormat,
                                                startingDayOfWeek:
                                                    StartingDayOfWeek.monday,
                                                onRangeSelected: (start, end,
                                                        focusedDay) =>
                                                    value.onRangeSelect(
                                                        start, end, focusedDay),
                                                headerStyle: const HeaderStyle(
                                                    leftChevronVisible: false,
                                                    formatButtonVisible: false,
                                                    rightChevronVisible: false),
                                                onPageChanged: (dayFocused) =>
                                                    value
                                                        .onPageCtrl(dayFocused),
                                                onCalendarCreated: (controller) =>
                                                    value.onCalendarCreate(controller),
                                                selectedDayPredicate: (day) {
                                                  return isSameDay(
                                                      value.focusedDay.value,
                                                      day);
                                                },
                                                daysOfWeekStyle: DaysOfWeekStyle(dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0], weekdayStyle: appCss.dmDenseBold14.textColor(appColor(context).appTheme.primary), weekendStyle: appCss.dmDenseBold14.textColor(appColor(context).appTheme.primary)),
                                                calendarStyle: CalendarStyle(rangeHighlightColor: appColor(context).appTheme.primary.withOpacity(0.10), rangeEndDecoration: BoxDecoration(color: appColor(context).appTheme.primary, shape: BoxShape.circle), defaultTextStyle: appCss.dmDenseLight14.textColor(appColor(context).appTheme.darkText), withinRangeTextStyle: appCss.dmDenseLight14.textColor(appColor(context).appTheme.primary), rangeStartTextStyle: appCss.dmDenseLight14.textColor(appColor(context).appTheme.whiteColor), rangeEndTextStyle: appCss.dmDenseLight14.textColor(appColor(context).appTheme.whiteColor), rangeStartDecoration: BoxDecoration(color: appColor(context).appTheme.primary, shape: BoxShape.circle), todayTextStyle: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.primary), selectedDecoration: BoxDecoration(color: appColor(context).appTheme.primary, shape: BoxShape.circle), todayDecoration: BoxDecoration(color: appColor(context).appTheme.primary.withValues(alpha: .10), shape: BoxShape.circle)))
                                            .paddingSymmetric(vertical: Insets.i20, horizontal: Insets.i15)
                                            .boxShapeExtension(color: appColor(context).appTheme.fieldCardBg)
                                            .paddingSymmetric(horizontal: Insets.i20)
                                      ])),
                        BottomSheetButtonCommon(
                                textOne: translations!.clearAll,
                                textTwo: translations!.apply,
                                applyTap: () {
                                  userApi.isLoadingForBookingHistory = true;
                                  userApi.getBookingHistory(context);
                                  route.pop(context);
                                },
                                clearTap: () => value.clearTap(context))
                            .paddingSymmetric(
                                horizontal: Insets.i20, vertical: Insets.i20)
                      ]))
                    ]).paddingOnly(top: Insets.i20))
            .bottomSheetExtension(context),
      );
    });
  }
}
