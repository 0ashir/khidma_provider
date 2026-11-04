import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/generalImports.dart';

class Form5WorkingDays extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<bool> isChecked;
  final List<TimeOfDay> selectedStartTime;
  final List<TimeOfDay> selectedEndTime;
  final List<String> daysOfWeek;
  final Function(TimeOfDay, int, bool) onTimeSelected;
  final Function(int, bool) onDayToggled;

  const Form5WorkingDays({
    Key? key,
    required this.formKey,
    required this.isChecked,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.daysOfWeek,
    required this.onTimeSelected,
    required this.onDayToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                mainAxisExtent: 80,
              ),
              padding: EdgeInsets.zero,
              itemCount: daysOfWeek.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return CustomCheckIconTextButton(
                  startDate: DateFormat.jm().format(
                    DateTime.parse(
                      "2020-07-20T${selectedStartTime[index].hour.toString().padLeft(2, "0")}:${selectedStartTime[index].minute.toString().padLeft(2, "0")}:00",
                    ),
                  ),
                  onStartDateTap: () {
                    _selectTime(
                      context,
                      selectedTime: selectedStartTime[index],
                      indexVal: index,
                      isTimePickerForStarTime: true,
                    );
                  },
                  endDate:
                      "${DateFormat.jm().format(DateTime.parse("2020-07-20T${selectedEndTime[index].hour.toString().padLeft(2, "0")}:${selectedEndTime[index].minute.toString().padLeft(2, "0")}:00"))} ",
                  onEndDateTap: () {
                    _selectTime(
                      context,
                      selectedTime: selectedEndTime[index],
                      indexVal: index,
                      isTimePickerForStarTime: false,
                    );
                  },
                  title: daysOfWeek[index],
                  isSelected: isChecked[index],
                  onTap: () {
                    onDayToggled(index, !isChecked[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime(
    BuildContext context, {
    required TimeOfDay selectedTime,
    required int indexVal,
    required bool isTimePickerForStarTime,
  }) {
    onTimeSelected(selectedTime, indexVal, isTimePickerForStarTime);
  }
}
