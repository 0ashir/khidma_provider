import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:fixit_provider/config.dart';
import '../../widgets/date_time_picker.dart';
import '../../widgets/year_dialog.dart';

class EarningHistoryProvider with ChangeNotifier {
  String? countryValue;

  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.month;
  int demoInt = 0;
  PageController pageController = PageController();
  dynamic chosenValue;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime currentDate = DateTime.now();
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  String showYear = 'Select Year';

  selectYear(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context3) {
          return YearAlertDialog(
              selectedDate: selectedYear,
              onChanged: (DateTime dateTime) {
                selectedYear = dateTime;
                showYear = "${dateTime.year}";
                focusedDay.value = DateTime.utc(selectedYear.year,
                    chosenValue["index"], focusedDay.value.day + 0);
                onDaySelected(focusedDay.value, focusedDay.value);
                notifyListeners();
                route.pop(context);
                log("YEAR CHANGE : ${focusedDay.value}");
              });
        });
  }

  onDropDownChange(choseVal) {
    notifyListeners();
    chosenValue = choseVal;

    notifyListeners();
    int index = choseVal['index'];
    focusedDay.value =
        DateTime.utc(focusedDay.value.year, index, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
  }

  onCalendarCreate(controller) {
    pageController = controller;
  }

  onRangeSelect(start, end, focusedDay, context) {
    selectedDay = null;
    currentDate = focusedDay;
    rangeStart = start;
    rangeEnd = end;
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    commissionHistory(context); // Adjust context as needed
    notifyListeners();
  }

  onChangeCountry(val) {
    countryValue = val;
    notifyListeners();
  }

  onTapCalender(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context3) {
          return const DateTimePicker();
        });
  }

  bool? isCommissionLoader = false;
// Update commissionHistory to include date range
  commissionHistory(BuildContext context) async {
    try {
      isCommissionLoader = true;
      notifyListeners();

      // Format dates for API query (YYYY-MM-DD)
      String apiUrl = "${api.commissionHistory}";
      if (rangeStart != null && rangeEnd != null) {
        String startDate = DateFormat('yyyy-MM-dd').format(rangeStart!);
        String endDate = DateFormat('yyyy-MM-dd').format(rangeEnd!);
        apiUrl += "?start_date=$startDate&end_date=$endDate";
      }

      await apiServices
          .getApi(apiUrl, [], isData: true, isToken: true)
          .then((value) async {
        if (value.isSuccess!) {
          commissionList = CommissionHistoryModel.fromJson(value.data);
          // Optional: Apply client-side filtering if API doesn't filter
          if (rangeStart != null && rangeEnd != null) {
            commissionList?.histories =
                filterHistoriesByDate(commissionList?.histories ?? []);
          }
          // Optional: Sort by createdAt
          sortHistoriesByDate(ascending: true);
          log("commissionList ${value.data}");
        }
        isCommissionLoader = false;
        notifyListeners();
      });
    } catch (e) {
      isCommissionLoader = false;
      log("EEEE commissionHistory :$e");
      notifyListeners();
    }
  }

  // Client-side filtering by date
  List<Histories> filterHistoriesByDate(List<Histories> histories) {
    if (rangeStart == null || rangeEnd == null) return histories;
    return histories.where((history) {
      if (history.createdAt == null) return false;
      return history.createdAt!
              .isAfter(rangeStart!.subtract(Duration(days: 1))) &&
          history.createdAt!.isBefore(rangeEnd!.add(Duration(days: 1)));
    }).toList();
  }

  // Sort histories by createdAt
  void sortHistoriesByDate({bool ascending = true}) {
    if (commissionList?.histories == null) return;
    commissionList!.histories!.sort((a, b) {
      if (a.createdAt == null || b.createdAt == null) return 0;
      return ascending
          ? a.createdAt!.compareTo(b.createdAt!)
          : b.createdAt!.compareTo(a.createdAt!);
    });
    notifyListeners();
  }

  onRightArrow() {
    pageController.nextPage(
        duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
    final newMonth = focusedDay.value.add(const Duration(days: 30));
    focusedDay.value = newMonth;
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == focusedDay.value.month);
    chosenValue = appArray.monthList[index];
    selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
        focusedDay.value.day + 0);
    notifyListeners();
  }

  onLeftArrow() {
    if (focusedDay.value.month != DateTime.january ||
        focusedDay.value.year != DateTime.now().year) {
      pageController.previousPage(
          duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
      final newMonth = focusedDay.value.subtract(const Duration(days: 30));
      focusedDay.value = newMonth;
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == focusedDay.value.month);
      chosenValue = appArray.monthList[index];
      selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
          focusedDay.value.day + 0);
    }
    notifyListeners();
  }

  void onDaySelected(DateTime selectDay, DateTime fDay) {
    notifyListeners();
    focusedDay.value = selectDay;
  }

  onPageCtrl(dayFocused) {
    focusedDay.value = dayFocused;
    demoInt = dayFocused.year;
    notifyListeners();
  }

  onInit() {
    focusedDay.value = DateTime.utc(focusedDay.value.year,
        focusedDay.value.month, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
    DateTime dateTime = DateTime.now();
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == dateTime.month);
    chosenValue = appArray.monthList[index];
    notifyListeners();
  }
}
