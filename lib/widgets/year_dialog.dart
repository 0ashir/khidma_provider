import '../../../../config.dart';

class YearAlertDialog extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  const YearAlertDialog(
      {super.key, this.selectedDate, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
              width: 300,
              height: 300,
              child: Theme(
                  data: ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme.light(
                          primary: appColor(context).appTheme.primary,
                          onSurface: appColor(context).appTheme.darkText)),
                  child: YearPicker(
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 1)),
                      lastDate: DateTime(2040),
                      selectedDate: selectedDate /*dateTimePvr.selectedYear*/,
                      onChanged:
                          onChanged /*(DateTime dateTime) {
                        dateTimePvr.selectedYear = dateTime;
                        dateTimePvr.showYear = "${dateTime.year}";
                        dateTimePvr.focusedDay.value = DateTime.utc(
                            dateTimePvr.selectedYear.year,
                            dateTimePvr.chosenValue["index"],
                            dateTimePvr.focusedDay.value.day + 0);
                        dateTimePvr.onDaySelected(
                            dateTimePvr.focusedDay.value,
                            dateTimePvr.focusedDay.value);
                        route.pop(context);
                        log("YEAR CHANGE : ${dateTimePvr.focusedDay.value}");
                      }*/
                      ))));
    });
  }
}
