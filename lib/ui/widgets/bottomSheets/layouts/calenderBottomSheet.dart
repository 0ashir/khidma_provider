import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../app/generalImports.dart';

class CalenderBottomSheet extends StatefulWidget {
  const CalenderBottomSheet({
    super.key,
    required this.advanceBookingDays,
    this.customJobRequestId,
  });

  final String advanceBookingDays;
  final String? customJobRequestId;

  @override
  State<CalenderBottomSheet> createState() => _CalenderBottomSheetState();
}

class _CalenderBottomSheetState extends State<CalenderBottomSheet>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  List<String> listOfDay = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  String? selectedMonth;
  String? selectedYear;
  late DateTime focusDate, selectedDate;
  String? selectedTime, message;

  int? selectedTimeSlotIndex;

  void fetchTimeSlots() {
    context.read<TimeSlotCubit>().getTimeslotDetails(
      selectedDate: selectedDate,
      customJobRequestId: widget.customJobRequestId,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    Future.delayed(Duration.zero).then((value) {
      fetchTimeSlots();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget verticalSpacing() {
    return const SizedBox(height: 10);
  }

  Widget _getSelectDateAndTimeHeading() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UiUtils.borderRadiusOf20),
          topRight: Radius.circular(UiUtils.borderRadiusOf20),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: CustomText(
        "selectDateAndTimeOfTheService".translate(context: context),
        color: Theme.of(context).colorScheme.blackColor,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontSize: 16,
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          Navigator.of(
            context,
          ).pop({'selectedDate': selectedDate, 'selectedTime': selectedTime});
        }
      },
      child: StatefulBuilder(
        builder: (final BuildContext context, final setStater) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Align(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getSelectDateAndTimeHeading(),
                  verticalSpacing(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomText(
                      "selectDate".translate(context: context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                  verticalSpacing(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: List.generate(
                        int.parse(widget.advanceBookingDays),
                        (index) {
                          final DateTime date = DateTime.now().add(
                            Duration(days: index),
                          );
                          final String day = listOfDay[date.weekday - 1]
                              .translate(context: context);
                          return CustomInkWellContainer(
                            onTap: () {
                              selectedDate = DateTime.parse(date.toString());
                              setStater(() {});
                              fetchTimeSlots();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                border:
                                    intl.DateFormat(
                                          "yyyy-MM-dd",
                                        ).format(selectedDate) ==
                                        intl.DateFormat(
                                          "yyyy-MM-dd",
                                        ).format(date)
                                    ? Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.accentColor,
                                      )
                                    : null,
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  CustomText(
                                    "${date.day} / ${date.month}",
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.blackColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomText(
                                    day.length > 3 ? day.substring(0, 3) : day,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.lightGreyColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  verticalSpacing(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomText(
                      "selectTimeOfTheService".translate(context: context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                  verticalSpacing(),
                  Expanded(
                    child: BlocConsumer<TimeSlotCubit, TimeSlotState>(
                      listener: (final context, final state) {
                        if (state is TimeSlotFetchSuccess) {
                          if (state.isError) {
                            UiUtils.showMessage(
                              context,
                              state.message,
                              ToastificationType.warning,
                            );
                          }
                        }
                      },
                      builder: (final context, final state) {
                        //timeslot background color
                        final Color disabledTimeSlotColor = Theme.of(
                          context,
                        ).colorScheme.lightGreyColor.withValues(alpha: 0.35);
                        final Color selectedTimeSlotColor = Theme.of(
                          context,
                        ).colorScheme.accentColor;
                        final Color defaultTimeSlotColor = Theme.of(
                          context,
                        ).colorScheme.primaryColor;

                        //timeslot border color
                        final Color disabledTimeSlotBorderColor = Theme.of(
                          context,
                        ).colorScheme.lightGreyColor.withValues(alpha: 0.35);
                        final Color selectedTimeSlotBorderColor = Theme.of(
                          context,
                        ).colorScheme.accentColor;
                        final Color defaultTimeSlotBorderColor = Theme.of(
                          context,
                        ).colorScheme.blackColor;

                        //timeslot text color
                        final Color disabledTimeSlotTextColor = Theme.of(
                          context,
                        ).colorScheme.blackColor;
                        final Color selectedTimeSlotTextColor =
                            AppColors.whiteColors;
                        final Color defaultTimeSlotTextColor = Theme.of(
                          context,
                        ).colorScheme.blackColor;

                        if (state is TimeSlotFetchSuccess) {
                          if (state.isError) {
                            return Center(child: CustomText(state.message));
                          }
                          if (state.slotsData.isEmpty &&
                              state.message.isNotEmpty) {
                            return Center(child: CustomText(state.message));
                          }
                          return GridView.count(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20,
                            childAspectRatio: 2.7,
                            children:
                                List<Widget>.generate(state.slotsData.length, (
                                  index,
                                ) {
                                  return CustomInkWellContainer(
                                    onTap: () {
                                      if (state.slotsData[index].isAvailable ==
                                          0) {
                                        return;
                                      }

                                      selectedTime =
                                          state.slotsData[index].time;
                                      message = state.slotsData[index].message;
                                      selectedTimeSlotIndex = index;
                                      setState(() {});
                                    },
                                    child: slotItemContainer(
                                      backgroundColor:
                                          state.slotsData[index].isAvailable ==
                                              0
                                          ? disabledTimeSlotColor
                                          : selectedTimeSlotIndex == index
                                          ? selectedTimeSlotColor
                                          : defaultTimeSlotColor,
                                      borderColor:
                                          state.slotsData[index].isAvailable ==
                                              0
                                          ? disabledTimeSlotBorderColor
                                          : selectedTimeSlotIndex == index
                                          ? selectedTimeSlotBorderColor
                                          : defaultTimeSlotBorderColor,
                                      titleColor:
                                          state.slotsData[index].isAvailable ==
                                              0
                                          ? disabledTimeSlotTextColor
                                          : selectedTimeSlotIndex == index
                                          ? selectedTimeSlotTextColor
                                          : defaultTimeSlotTextColor,
                                      title: state.slotsData[index].time
                                          .formatTime(),
                                    ),
                                  );
                                }) +
                                <Widget>[
                                  CustomInkWellContainer(
                                    onTap: () {
                                      displayTimePicker(context);
                                    },
                                    child: slotItemContainer(
                                      backgroundColor: Colors.transparent,
                                      titleColor: Theme.of(
                                        context,
                                      ).colorScheme.accentColor,
                                      borderColor: Theme.of(
                                        context,
                                      ).colorScheme.accentColor,
                                      title:
                                          selectedTime ??
                                          "addSlot".translate(context: context),
                                    ),
                                  ),
                                ],
                          );
                        }
                        if (state is TimeSlotFetchFailure) {
                          return ErrorContainer(
                            onTapRetry: () {
                              fetchTimeSlots();
                            },
                            errorMessage: state.errorMessage.translate(
                              context: context,
                            ),
                          );
                        }
                        return Center(
                          child: CustomText(
                            "loading".translate(context: context),
                          ),
                        );
                      },
                    ),
                  ),
                  _getCloseAndSelectNavigateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget slotItemContainer({
    required Color backgroundColor,
    required Color borderColor,
    required Color titleColor,
    required String title,
  }) {
    return CustomContainer(
      width: 150,
      height: 20,
      color: backgroundColor,
      borderRadius: UiUtils.borderRadiusOf20,
      border: Border.all(width: 0.5, color: borderColor),
      child: Center(
        child: Text(title, style: TextStyle(color: titleColor)),
      ),
    );
  }

  Future displayTimePicker(BuildContext context) async {
    // Get current locale using common method from LocaleUtils
    final Locale currentLocale = LocaleUtils.getCurrentLocale(context);

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        // Override locale to use app's selected language and the country
        // 12h/24h setting.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat:
                dateAndTimeSetting['use24HourFormat'] as bool,
          ),
          child: Localizations.override(
            context: context,
            locale: currentLocale,
            child: child,
          ),
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = '${time.hour}:${time.minute}:00';
        selectedTimeSlotIndex = null;
      });
    }
  }

  Widget _getCloseAndSelectNavigateButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomInkWellContainer(
              onTap: () {
                Navigator.pop(context);
              },
              child: CustomContainer(
                height: 44,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1c343f53),
                    offset: Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
                color: Theme.of(context).colorScheme.secondaryColor,
                child: Center(
                  child: Text(
                    'close'.translate(context: context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomInkWellContainer(
              onTap: () {
                Navigator.of(context).pop({
                  'selectedDate': selectedDate,
                  'selectedTime': selectedTime,
                });
              },
              child: CustomContainer(
                height: 44,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1c343f53),
                    offset: Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
                color: Theme.of(context).colorScheme.accentColor,
                child: // Apply Filter
                Center(
                  child: Text(
                    'select'.translate(context: context),
                    style: TextStyle(
                      color: AppColors.whiteColors,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
