// ignore_for_file: unused_local_variable, deprecated_member_use, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import '../../../config.dart';

class TimeSlotScreen extends StatelessWidget {
  const TimeSlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, TimeSlotProvider>(
        builder: (context1, lang, value, child) {
      log("value.isSelectedDayUnavailable::${value.isMondayUnavailable}");
      final selectedDay =
          appArray.timeSlotList[value.selectedDayIndex].day ?? '';
      final isDayDisabled =
          appArray.timeSlotList[value.selectedDayIndex].status == 0;
      final index = appArray.timeSlotList.indexWhere(
          (slot) => slot.day?.toUpperCase() == selectedDay.toUpperCase());

      final isDayAvailable =
          index != -1 ? appArray.timeSlotList[index].status == 1 : false;
      return StatefulWrapper(
          onInit: () {
            if (value.timeList.isEmpty) {
              value.timeList = [
                for (int hour = 9; hour <= 24; hour++)
                  value.formatTime(hour >= 24 ? 0 : hour, value.is24HourFormat)
              ];
            }
            value.initSelectedSlots(value.timeList.length);
            value.loadSelectedSlotsFromPrefs();
            value.fetchTimeSlots();
          },
          child: Scaffold(
              appBar: AppBarCommon(
                title: translations!.timeSlots,
                onTap: () {
                  if (value.isEdit) {
                    value.edit(false);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              body: PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      if (value.isEdit) {
                        value.edit(false);
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: SingleChildScrollView(
                      child: Form(
                          key: value.formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(children: [
                                  Row(children: [
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${selectedDay.substring(0, 2).toUpperCase()} ${value.isSelectedDayUnavailable ? "Available" : "Unavailable"}",
                                            style: appCss.dmDenseMedium12
                                                .textColor(appColor(context)
                                                    .appTheme
                                                    .darkText)),
                                        FlutterSwitchCommon(
                                          value: value.isSelectedDayUnavailable,
                                          onToggle: (val) {
                                            log("Toggle value: $val");
                                            value.toggleDayAvailability(
                                                selectedDay, val);
                                          },
                                          // disabled: !isDayActive,
                                        ),
                                      ],
                                    )
                                            .padding(
                                                vertical: Sizes.s17,
                                                horizontal: Sizes.s10)
                                            .decorated(
                                                color: appColor(context)
                                                    .appTheme
                                                    .fieldCardBg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppRadius.r12))
                                            .paddingSymmetric(
                                                horizontal: Insets.i2)),
                                    const HSpace(Sizes.s10),
                                    Expanded(
                                        child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                          Text("24-hours",
                                              style: appCss.dmDenseMedium12
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText)),
                                          FlutterSwitchCommon(
                                              value: value.is24HourFormat,
                                              onToggle:
                                                  value.toggle24HourFormat)
                                        ])
                                            .padding(
                                                vertical: Sizes.s17,
                                                horizontal: Sizes.s10)
                                            .decorated(
                                              color: appColor(context)
                                                  .appTheme
                                                  .fieldCardBg,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppRadius.r12),
                                            )
                                            .paddingSymmetric(
                                                horizontal: Insets.i2))
                                  ]),
                                  const VSpace(Sizes.s17),
                                  Stack(
                                    children: [
                                      const FieldsBackground(),
                                      Column(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: appArray.timeSlotList
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (e) => Row(
                                                      children: [
                                                        Text(
                                                          e.value.day
                                                              .toString()
                                                              .substring(0, 2)
                                                              .toUpperCase(),
                                                          style: appCss
                                                              .dmDenseMedium12
                                                              .textColor(
                                                            value.selectedDayIndex ==
                                                                    e.key
                                                                ? appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .whiteColor
                                                                : appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .primary,
                                                          ),
                                                        )
                                                            .paddingAll(
                                                                Insets.i10)
                                                            .decorated(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: value.selectedDayIndex ==
                                                                      e.key
                                                                  ? appColor(
                                                                          context)
                                                                      .appTheme
                                                                      .primary
                                                                  : appColor(
                                                                          context)
                                                                      .appTheme
                                                                      .primary
                                                                      .withValues(
                                                                          alpha:
                                                                              0.1),
                                                            )
                                                            .inkWell(
                                                              onTap: () => value
                                                                  .selectDay(
                                                                      e.key),
                                                            ),
                                                        const HSpace(Sizes.s15),
                                                      ],
                                                    ),
                                                  )
                                                  .toList(),
                                            ).paddingSymmetric(
                                                horizontal: Insets.i15),
                                          ),
                                          const VSpace(Sizes.s15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${value.isEdit ? "Choose Time" : translations!.time}",
                                                style: appCss.dmDenseMedium12
                                                    .textColor(
                                                  appColor(context)
                                                      .appTheme
                                                      .darkText,
                                                ),
                                              ),
                                              value.isEdit
                                                  ? Text(
                                                      "Copy With",
                                                      style: appCss
                                                          .dmDenseMedium12
                                                          .textColor(
                                                        appColor(context)
                                                            .appTheme
                                                            .lightText,
                                                      ),
                                                    ).inkWell(
                                                      onTap: () => showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            CopyTimeSlotsDialog(
                                                          currentDayIndex: value
                                                              .selectedDayIndex,
                                                          provider: value,
                                                        ),
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      eSvgAssets.edit,
                                                      height: Sizes.s20,
                                                      width: Sizes.s20,
                                                      color: appColor(context)
                                                          .appTheme
                                                          .lightText,
                                                    ).inkWell(
                                                      onTap: () {
                                                        value.edit(true);
                                                        /* EditDaysDialog();*/
                                                      },
                                                    ),
                                            ],
                                          ).padding(
                                            horizontal: Sizes.s13,
                                            bottom: Sizes.s15,
                                            top: Sizes.s10,
                                          ),
                                          const VSpace(Sizes.s12),
                                          value.isLoading ||
                                                  value.selectedSlots.isEmpty ||
                                                  value
                                                      .selectedSlots[value
                                                          .selectedDayIndex]
                                                      .isEmpty
                                              ? Text("Loading slots...", style: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.lightText))
                                                  .padding(vertical: Sizes.s50)
                                              : value.isEdit
                                                  ? GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: value
                                                              .timeList.length,
                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 3,
                                                              mainAxisSpacing: 19,
                                                              crossAxisSpacing: 10,
                                                              childAspectRatio:
                                                                  2.5),
                                                          itemBuilder:
                                                              (context, index) {
                                                            final isSelected =
                                                                value.selectedSlots[
                                                                            value.selectedDayIndex]
                                                                        [
                                                                        index] ??
                                                                    false;
                                                            return GestureDetector(
                                                                onTap:
                                                                    isDayDisabled
                                                                        ? null
                                                                        : () {
                                                                            value.toggleTimeSlot(index);
                                                                            List<String>
                                                                                times =
                                                                                value.getSelectedTimesForDay(value.selectedDayIndex);
                                                                            log("Selected times for the day: $times");
                                                                          },
                                                                child: Container(
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(color: isSelected && !isDayDisabled ? appColor(context).appTheme.primary : appColor(context).appTheme.whiteColor, borderRadius: BorderRadius.circular(10), border: isDayDisabled ? Border.all(color: appColor(context).appTheme.lightText.withOpacity(0.5)) : null),
                                                                    child: Text(value.timeList[index],
                                                                        style: appCss.dmDenseMedium12.textColor(isSelected && !isDayDisabled
                                                                            ? appColor(context).appTheme.whiteColor
                                                                            : isDayDisabled
                                                                                ? appColor(context).appTheme.lightText.withOpacity(0.5)
                                                                                : isDark(context)
                                                                                    ? appColor(context).appTheme.whiteBg
                                                                                    : appColor(context).appTheme.darkText))));
                                                          })
                                                      .paddingSymmetric(
                                                          horizontal: Sizes.s13)
                                                  : value
                                                              .getSelectedTimesForDay(
                                                                  value
                                                                      .selectedDayIndex)
                                                              .isEmpty ||
                                                          isDayDisabled
                                                      ? Text("No Slots Available",
                                                              style: appCss
                                                                  .dmDenseMedium14
                                                                  .textColor(appColor(
                                                                          context)
                                                                      .appTheme
                                                                      .lightText))
                                                          .padding(
                                                              vertical:
                                                                  Sizes.s50)
                                                      : GridView.count(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          crossAxisCount: 3,
                                                          mainAxisSpacing: 15,
                                                          crossAxisSpacing: 8,
                                                          childAspectRatio: 2.5,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      Sizes
                                                                          .s13),
                                                          children: value
                                                              .getSelectedTimesForDay(
                                                                  value
                                                                      .selectedDayIndex)
                                                              .map(
                                                                (time) =>
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: appColor(
                                                                            context)
                                                                        .appTheme
                                                                        .primary
                                                                        .withValues(
                                                                            alpha:
                                                                                0.15),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Sizes.s8),
                                                                  ),
                                                                  child: Text(
                                                                    time,
                                                                    style: appCss
                                                                        .dmDenseMedium12
                                                                        .textColor(appColor(context)
                                                                            .appTheme
                                                                            .darkText),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                        ],
                                      ).paddingSymmetric(
                                        vertical: Insets.i20,
                                        horizontal: Sizes.s15,
                                      ),
                                    ],
                                  ),
                                  if (value.isEdit)
                                    ButtonCommon(
                                      title: translations!.updateHours,
                                      onTap: () {
                                        value.edit(false);
                                        value.onUpdateHour(context);
                                      },
                                    ).paddingOnly(
                                        top: Insets.i40, bottom: Insets.i30),
                                ]).padding(
                                    horizontal: Insets.i20, bottom: Insets.i20),
                              ]))))));
    });
  }
}

class EditDaysDialog extends StatelessWidget {
  const EditDaysDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeSlotProvider>(builder: (context, value, child) {
      final selectedDay =
          appArray.timeSlotList[value.selectedDayIndex].day ?? '';
      final isDayDisabled =
          appArray.timeSlotList[value.selectedDayIndex].status == 0;
      return Column(
        children: [
          value.timeList.isEmpty
              ? Text(
                  "No Slots Available",
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.lightText),
                ).padding(vertical: Sizes.s50)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.timeList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 19,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected =
                        value.selectedSlots[value.selectedDayIndex][index];
                    return GestureDetector(
                      onTap: isDayDisabled
                          ? null
                          : () {
                              value.toggleTimeSlot(index);
                              List<String> times = value.getSelectedTimesForDay(
                                  value.selectedDayIndex);
                              log("Selected times for the day: $times");
                            },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected && !isDayDisabled
                              ? appColor(context).appTheme.primary
                              : appColor(context).appTheme.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: isDayDisabled
                              ? Border.all(
                                  color: appColor(context)
                                      .appTheme
                                      .lightText
                                      .withOpacity(0.5))
                              : null,
                        ),
                        child: Text(
                          value.timeList[index],
                          style: appCss.dmDenseMedium12.textColor(
                              isSelected && !isDayDisabled
                                  ? appColor(context).appTheme.whiteColor
                                  : isDayDisabled
                                      ? appColor(context)
                                          .appTheme
                                          .lightText
                                          .withOpacity(0.5)
                                      : appColor(context).appTheme.darkText),
                        ),
                      ),
                    );
                  },
                ).paddingSymmetric(horizontal: Sizes.s13),
        ],
      );
    });
  }
}

class CopyTimeSlotsDialog extends StatefulWidget {
  final int currentDayIndex; // day whose slots are being copied
  final TimeSlotProvider provider;

  const CopyTimeSlotsDialog({
    required this.currentDayIndex,
    required this.provider,
    super.key,
  });

  @override
  State<CopyTimeSlotsDialog> createState() => _CopyTimeSlotsDialogState();
}

class _CopyTimeSlotsDialogState extends State<CopyTimeSlotsDialog> {
  late List<bool> selectedDays;
  bool isSelectAll = false;

  @override
  void initState() {
    super.initState();
    // Init with all false except current day
    selectedDays = List.generate(7, (index) => index != widget.currentDayIndex);
  }

  void toggleSelectAll(bool value) {
    setState(() {
      isSelectAll = value;
      for (int i = 0; i < selectedDays.length; i++) {
        if (i != widget.currentDayIndex) {
          selectedDays[i] = value;
        }
      }
    });
  }

  void onSave() {
    final sourceSlots = widget.provider.selectedSlots[widget.currentDayIndex];

    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        widget.provider.selectedSlots[i] = List<bool>.from(sourceSlots);
      }
    }

    widget.provider.saveSelectedSlotsToPrefs(); // persist changes
    widget.provider.notifyListeners(); // update UI
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
// or however you're passing it

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  translations!.selectTime!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                const Text("Select All")
                    .paddingDirectional(
                        vertical: Sizes.s5, horizontal: Sizes.s3)
                    .inkWell(
                      onTap: () => toggleSelectAll(!isSelectAll),
                    ),
              ],
            ),
            const SizedBox(height: 16),
            ...appArray.timeSlotList.asMap().entries.map((entry) {
              int index = entry.key;
              String dayLabel =
                  entry.value.day.toString().substring(0, 3).toUpperCase();

              if (index == widget.currentDayIndex)
                return const SizedBox.shrink();

              return Row(
                children: [
                  Text(dayLabel),
                  const Spacer(),
                  CheckBoxCommon(
                      isCheck: selectedDays[index],
                      onTap: () {
                        setState(() {
                          selectedDays[index] = !selectedDays[index];
                          isSelectAll = selectedDays
                              .asMap()
                              .entries
                              .where((e) => e.key != widget.currentDayIndex)
                              .every((e) => e.value);
                        });
                      })
                ],
              ).padding(bottom: Sizes.s10);
            }),
            const SizedBox(height: 12),
            ButtonCommon(
              title: translations!.save,
              onTap: onSave,
            )
          ],
        ),
      ),
    );
  }
}
