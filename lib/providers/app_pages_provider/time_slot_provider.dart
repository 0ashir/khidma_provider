import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart'; // Adjust based on your project structure

class TimeSlotProvider with ChangeNotifier {
  TextEditingController hourGap = TextEditingController();
  FocusNode hourGapFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CarouselSliderController hourCtrl = CarouselSliderController();
  CarouselSliderController mnCtrl = CarouselSliderController();
  CarouselSliderController amPmCtrl = CarouselSliderController();
  int scrollDayIndex = 0;
  int scrollMinIndex = 0;
  int scrollHourIndex = 0;
  bool isEdit = false;
  TimeSlotModel? timeSlot;
  int indexs = 0;
  FixedExtentScrollController? controller1, controller2, controller3;
  String? gapValue;
  bool isMondayUnavailable = false;
  bool is24HourFormat = true;
  int selectedDayIndex = 0;
  List<bool> editableDays = List.filled(24, false);
  List<List<bool>> selectedSlots = []; // Initialize to empty
  List<String> selectedTimeTexts = [];
  bool isLoading = false; // Start as false to avoid premature loading state

  // Constructor to initialize timeList and selectedSlots
  TimeSlotProvider() {
    // Populate timeList if empty
    if (timeList.isEmpty) {
      _initTimeList();
    }
    // Initialize selectedSlots
    initSelectedSlots(timeList.length);
  }

  // Initialize timeList with default values
  void _initTimeList() {
    timeList = [
      for (int hour = 9; hour <= 24; hour++)
        formatTime(hour >= 24 ? 0 : hour, is24HourFormat)
    ];
    log("Initialized timeList: $timeList");
  }

  // Initialize selectedSlots
  void initSelectedSlots(int totalSlots) {
    if (totalSlots > 0 && appArray.timeSlotList.isNotEmpty) {
      selectedSlots = List.generate(
        appArray.timeSlotList.length,
        (_) => List.filled(totalSlots, false),
      );
    } else {
      // Fallback for empty days
      selectedSlots = List.generate(
        7, // Default to 7 days
        (_) => [],
      );
    }
    log("Initialized selectedSlots: ${selectedSlots.length} days, ${selectedSlots.isNotEmpty ? selectedSlots[0].length : 0} slots");
    notifyListeners();
  }

  // Format time to 24-hour or 12-hour with AM/PM
  String formatTime(int hour, bool is24Hour) {
    if (is24Hour) {
      String formatted = '${hour.toString().padLeft(2, '0')}:00';
      return formatted;
    } else {
      String period = hour < 12 ? 'AM' : 'PM';
      int displayHour = hour == 0
          ? 12
          : hour > 12
              ? hour - 12
              : hour;
      String formatted = '$displayHour:00 $period';
      return formatted;
    }
  }

  // Convert time to 24-hour format
  String to24HourFormat(String time) {
    if (!time.contains('AM') && !time.contains('PM')) {
      return time; // Already in 24-hour format
    }
    try {
      final parts = time.trim().split(' ');
      if (parts.length != 2) {
        log("Invalid time format: $time");
        return time;
      }
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      String minutes = timeParts[1];
      String period = parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }
      String formatted = '${hour.toString().padLeft(2, '0')}:$minutes';
      return formatted;
    } catch (e) {
      log("Error converting time $time: $e");
      return time;
    }
  }

  // Convert time to 12-hour format
  String to12HourFormat(String time) {
    try {
      final timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      String minutes = timeParts[1];
      String period = hour < 12 ? 'AM' : 'PM';
      int displayHour = hour == 0
          ? 12
          : hour > 12
              ? hour - 12
              : hour;
      String formatted = '$displayHour:$minutes $period';
      return formatted;
    } catch (e) {
      log("Error converting time $time: $e");
      return time;
    }
  }

  // Time list getter
  List<String> timeList = [];

  // Toggle 24-hour format
  void toggle24HourFormat(bool value) {
    final oldTimeList = timeList;
    is24HourFormat = value;
    _initTimeList(); // Regenerate timeList
    final newTimeList = timeList;

    // Map existing selections
    List<List<bool>> newSelectedSlots = List.generate(
      appArray.timeSlotList.length,
      (_) => List.filled(newTimeList.length, false),
    );
    List<String> newSelectedTimeTexts = [];

    for (int dayIndex = 0; dayIndex < selectedSlots.length; dayIndex++) {
      for (int i = 0; i < selectedSlots[dayIndex].length; i++) {
        if (selectedSlots[dayIndex][i]) {
          String oldTime = oldTimeList[i];
          String mappedTime = is24HourFormat
              ? to24HourFormat(oldTime)
              : to12HourFormat(oldTime);
          int newIndex = newTimeList.indexOf(mappedTime);
          if (newIndex != -1 && newIndex < newSelectedSlots[dayIndex].length) {
            newSelectedSlots[dayIndex][newIndex] = true;
            if (!newSelectedTimeTexts.contains(mappedTime)) {
              newSelectedTimeTexts.add(mappedTime);
            }
          }
        }
      }
    }

    selectedSlots = newSelectedSlots;
    selectedTimeTexts = newSelectedTimeTexts;
    saveSelectedSlotsToPrefs();
    notifyListeners();
  }

  // Toggle day availability
  void toggleDayAvailability(String day, bool isAvailable) {
    final index = appArray.timeSlotList.indexWhere(
      (slot) => slot.day!.toUpperCase() == day.toUpperCase(),
    );
    if (index != -1) {
      appArray.timeSlotList[index].status = isAvailable ? 1 : 0;
      if (!isAvailable &&
          selectedSlots.isNotEmpty &&
          selectedSlots[index].isNotEmpty) {
        selectedSlots[index] = List.filled(timeList.length, false);
        appArray.timeSlotList[index].slots = [];
        selectedTimeTexts.removeWhere(
            (time) => getSelectedTimesForDay(index).contains(time));
      }
      saveSelectedSlotsToPrefs();
      notifyListeners();
    }
  }

  // Select day
  void selectDay(int index) {
    selectedDayIndex = index;
    notifyListeners();
  }

  // Toggle time slot
  void toggleTimeSlot(int index) {
    if (selectedSlots.isNotEmpty &&
        selectedDayIndex < selectedSlots.length &&
        index < selectedSlots[selectedDayIndex].length) {
      selectedSlots[selectedDayIndex][index] =
          !selectedSlots[selectedDayIndex][index];
      final time = timeList[index];
      if (selectedSlots[selectedDayIndex][index]) {
        if (!selectedTimeTexts.contains(time)) {
          selectedTimeTexts.add(time);
        }
      } else {
        selectedTimeTexts.remove(time);
      }
      appArray.timeSlotList[selectedDayIndex].slots =
          getSelectedTimesForDay(selectedDayIndex);
      saveSelectedSlotsToPrefs();
      notifyListeners();
    }
  }

  // Toggle time slot for specific day (for EditDaysDialog)
  void toggleTimeSlotForDay(int dayIndex, int slotIndex) {
    if (selectedSlots.isNotEmpty &&
        dayIndex < selectedSlots.length &&
        slotIndex < selectedSlots[dayIndex].length) {
      selectedSlots[dayIndex][slotIndex] = !selectedSlots[dayIndex][slotIndex];
      appArray.timeSlotList[dayIndex].slots = getSelectedTimesForDay(dayIndex);
      final time = timeList[slotIndex];
      if (selectedSlots[dayIndex][slotIndex]) {
        if (!selectedTimeTexts.contains(time)) {
          selectedTimeTexts.add(time);
        }
      } else {
        selectedTimeTexts.remove(time);
      }
      saveSelectedSlotsToPrefs();
      notifyListeners();
    }
  }

  // Save to SharedPreferences
  Future<void> saveSelectedSlotsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final slotData = {
        'selectedSlots': selectedSlots,
        'selectedTimeTexts': selectedTimeTexts,
        'is24HourFormat': is24HourFormat,
      };
      await prefs.setString('time_slot_data', jsonEncode(slotData));
      log("Saved selected slots to preferences");
    } catch (e) {
      log("Error saving selected slots: $e");
    }
  }

  // Load from SharedPreferences
  Future<void> loadSelectedSlotsFromPrefs() async {
    try {
      isLoading = true;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('time_slot_data');
      if (data != null) {
        final decoded = jsonDecode(data);
        is24HourFormat = decoded['is24HourFormat'] ?? true;
        final rawSlots =
            List<List<dynamic>>.from(decoded['selectedSlots'] ?? []);
        if (rawSlots.isNotEmpty &&
            rawSlots.length == appArray.timeSlotList.length &&
            rawSlots[0].length == timeList.length) {
          selectedSlots =
              rawSlots.map((list) => List<bool>.from(list)).toList();
          selectedTimeTexts =
              List<String>.from(decoded['selectedTimeTexts'] ?? []);
          log("Loaded selected slots: ${selectedSlots.length} days, ${selectedSlots[0].length} slots");
        } else {
          log("Invalid saved slots data, reinitializing");
          initSelectedSlots(timeList.length);
        }
      } else {
        log("No saved slots data, initializing");
        initSelectedSlots(timeList.length);
      }
    } catch (e) {
      log("Error loading selected slots: $e");
      initSelectedSlots(timeList.length);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Get selected times for a day
  List<String> getSelectedTimesForDay(int dayIndex) {
    if (dayIndex >= selectedSlots.length || selectedSlots[dayIndex].isEmpty) {
      return [];
    }
    List<String> selectedTimes = [];
    for (int i = 0;
        i < selectedSlots[dayIndex].length && i < timeList.length;
        i++) {
      if (selectedSlots[dayIndex][i]) {
        selectedTimes.add(timeList[i]);
      }
    }
    return selectedTimes;
  }

  // Check if selected day is unavailable
  bool get isSelectedDayUnavailable {
    final day = appArray.timeSlotList[selectedDayIndex].day;
    final slot = appArray.timeSlotList.firstWhereOrNull(
      (e) => e.day?.toUpperCase() == day?.toUpperCase(),
    );
    return slot?.status == 1;
  }

  // Toggle availability status
  void onToggle(int index, bool val) {
    appArray.timeSlotList[index].status = val ? 1 : 0;
    if (!val && selectedSlots.isNotEmpty && selectedSlots[index].isNotEmpty) {
      selectedSlots[index] = List.filled(timeList.length, false);
      appArray.timeSlotList[index].slots = [];
    }
    notifyListeners();
  }

  // Update hours
  void onUpdateHour(BuildContext context) {
    if (formKey.currentState!.validate()) {
      timeSlotAddApi(context);
    }
  }

  // Toggle edit mode
  void edit(bool value) {
    isEdit = value;
    notifyListeners();
  }

  // API call to add/update time slots
  // Updated timeSlotAddApi
  Future<void> timeSlotAddApi(BuildContext context) async {
    try {
      showLoading(context);
      isLoading = true;
      notifyListeners();

      // Fetch latest server state to ensure accuracy
      await fetchTimeSlots();
      List timeSlotList = [];
      for (var d in appArray.timeSlotList) {
        timeSlotList.add(d.toJson());
        notifyListeners();
      }
      log("getSelectedTimesForDay(selectedDayIndex)L::${getSelectedTimesForDay(selectedDayIndex)}");
      List<Map<String, dynamic>> timeSlots = [];

      for (int i = 0; i < appArray.timeSlotList.length; i++) {
        final day = appArray.timeSlotList[i].day.toString(); // e.g. "MONDAY"
        final slots = getSelectedTimesForDay(i); // List<String>
        final isActive = slots.isNotEmpty ? "1" : "0"; // active if slots exist

        timeSlots.add({
          "day": day,
          "slots": slots,
          "is_active": isActive,
        });
      }

      var body = {
        "time_slots": timeSlots,
      };

      log("TIME SLOT BODY => $body");

      // Call POST API for creating slots
      if (getSelectedTimesForDay(selectedDayIndex).isNotEmpty) {
        final response = await apiServices.postApi(
          api.providerTimeSlot,
          body,
          isToken: true,
        );
        log("POST API Response: ${response.message}");
        if (response.isSuccess!) {
          snackBarMessengers(
            isDuration: true,
            context,
            message: "Slots created successfully.",
            color: appColor(context).appTheme.primary,
          );
        } else {
          snackBarMessengers(
            isDuration: true,
            context,
            message: response.message ?? "Failed to create slots.",
            color: Colors.red,
          );
          hideLoading(context);
          return; // Stop if POST fails
        }
      }

      // Call PUT API for updating slots
      if (getSelectedTimesForDay(selectedDayIndex).isNotEmpty) {
        final response = await apiServices.putApi(
          api.updateProviderTimeSlot,
          body,
          isToken: true,
        );
        log("PUT API Response: ${response.message}");
        if (response.isSuccess!) {
          snackBarMessengers(
            isDuration: true,
            context,
            message: "Slots updated successfully.",
            color: appColor(context).appTheme.primary,
          );
        } else {
          snackBarMessengers(
            isDuration: true,
            context,
            message: response.message ?? "Failed to update slots.",
            color: Colors.red,
          );
          hideLoading(context);
          return; // Stop if PUT fails
        }
      }
    } catch (e,s) {
      log("EEEE::$e ==---=---= $s");
    }
  }

  // Fetch time slots from API (if implemented)
  Future<void> fetchTimeSlots() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await apiServices.getApi(
          "${api.providerTimeSlot}/${userModel!.id}", [],
          isToken: true);
      log("GET API Response: ${response}");

      /*  if (response.isSuccess!) { */
      final timeSlots = response.data['time_slots'] as List<dynamic>;
      for (var slot in timeSlots) {
        final day = slot['day'].toString().toUpperCase();
        final slots = List<String>.from(slot['slots'] ?? []);
        final isActive = slot['is_active'] == 1 ? 1 : 0;

        final dayIndex = appArray.timeSlotList.indexWhere(
          (d) => d.day?.toUpperCase() == day,
        );
        if (dayIndex != -1) {
          appArray.timeSlotList[dayIndex].slots = slots;
          appArray.timeSlotList[dayIndex].status = isActive;

          if (selectedSlots.isNotEmpty && timeList.isNotEmpty) {
            selectedSlots[dayIndex] = List.generate(
              timeList.length,
              (i) => slots.contains(to24HourFormat(timeList[i])),
            );
          }
        }
      }
      /*  } else {
        log("GET API failed: ${response.message}");
      } */
    } catch (e, s) {
      log("Fetch time slots error: $e\n$s");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

/*
import 'dart:developer';

import 'package:collection/collection.dart';

import '../../config.dart';

class TimeSlotProvider with ChangeNotifier {
  TextEditingController hourGap = TextEditingController();
  FocusNode hourGapFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CarouselSliderController hourCtrl = CarouselSliderController();
  CarouselSliderController mnCtrl = CarouselSliderController();
  CarouselSliderController amPmCtrl = CarouselSliderController();
  int scrollDayIndex = 0;
  int scrollMinIndex = 0;
  int scrollHourIndex = 0;

  TimeSlotModel? timeSlot;
  int indexs = 0;
  FixedExtentScrollController? controller1, controller2, controller3;

  String? gapValue;

  // timeslot availability status change
  onToggle(index, val) {
    appArray.timeSlotList[index].status = val == true ? 1 : 0;
    notifyListeners();
  }

  // fetch time slot from api
  onUpdateHour(context) {
    if (formKey.currentState!.validate()) {
      timeSlotAddApi(context);
    }
  }

 */
/* timeSlotAddApi(context) async {
    try {
      showLoading(context);
      notifyListeners();

      List<Map<String, dynamic>> timeSlotsPayload = [];
      bool isAnySlotPresent = false; // Track if any slot exists
      List<Map<String, dynamic>> createSlotsPayload = [];
      List<Map<String, dynamic>> updateSlotsPayload = [];

      // Iterate through each day to check for slots
      for (int dayIndex = 0; dayIndex < appArray.timeSlotList.length; dayIndex++) {
        final slot = appArray.timeSlotList[dayIndex];
        final selectedTimes = getSelectedTimesForDay(dayIndex);

        // Safely handle null or missing data for slot.day
        String dayString = (slot.day?.toString().toUpperCase()) ?? 'UNKNOWN';
        int statusString = slot.status ?? 1;
        log("statusString::$statusString");

        // Safely handle null or empty data for slot.slots
        List<String> existingSlots = slot.slots ?? [];

        // Skip if no slots are selected and status is off (0)
        if (selectedTimes.isEmpty && statusString == 0) continue;

        // Check if any slots are selected or status is active for the current day
        if (selectedTimes.isNotEmpty || statusString == 1) {
          isAnySlotPresent = true;
        }

        // Compare existing status with new status
        int existingStatus = slot.status ?? 1; // Assume active if null

        // Determine whether to create or update the slots for this day
        if (selectedTimes.isNotEmpty || statusString != existingStatus) {
          if (existingSlots.isEmpty && selectedTimes.isNotEmpty) {
            // If no slots are present, this is a creation (POST)
            createSlotsPayload.add({
              "day": dayString,
              "slots": selectedTimes,
              "is_active": statusString,
            });
          } else if (existingSlots != selectedTimes || existingStatus != statusString) {
            // If slots or status are different, this is an update (PUT)
            updateSlotsPayload.add({
              "day": dayString,
              "slots": selectedTimes,
              "is_active": statusString,
            });
          }
        }
      }

      // Combine the payloads for both create and update slots
      timeSlotsPayload.addAll(createSlotsPayload);
      timeSlotsPayload.addAll(updateSlotsPayload);

      final body = {
        "time_slots": timeSlotsPayload,
      };

      log("TIME SLOT BODY => $timeSlotsPayload");

      if (!isAnySlotPresent) {
        hideLoading(context);
        snackBarMessengers(
          context,
          message: "Please select at least one slot before saving.",
          color: Colors.red,
        );
        return;
      }

      if (timeSlotsPayload.isNotEmpty) {
        // Use PUT for updates or POST for creations
        final response = await apiServices.putApi(
          api.updateProviderTimeSlot,
          body,
          isToken: true,
        );
        log("API Response Message: ${response.message}");
        snackBarMessengers(
          isDuration: true,
          context,
          message: response.message ?? "Slots updated.",
          color: appColor(context).appTheme.primary,
        );
      }else{

      }

      hideLoading(context);
      notifyListeners();

      // Show success dialog
      snackBarMessengers(
        context,
        message: "Slots updated successfully!",
        color: appColor(context).appTheme.primary,
      );
    } catch (e, s) {
      log("Time slot error::$e\n$s");
      hideLoading(context);
      notifyListeners();
    }
  }*/ /*

  timeSlotAddApi(context) async {
    try {
      showLoading(context);
      notifyListeners();

      List<Map<String, dynamic>> timeSlotsPayload = [];
      bool isAnySlotPresent = false; // Track if any slot exists
      List<Map<String, dynamic>> createSlotsPayload = [];
      List<Map<String, dynamic>> updateSlotsPayload = [];

      // Iterate through each day to check for slots
      for (int dayIndex = 0; dayIndex < appArray.timeSlotList.length; dayIndex++) {
        final slot = appArray.timeSlotList[dayIndex];
        final selectedTimes = getSelectedTimesForDay(dayIndex);

        // Safely handle null or missing data for slot.day
        String dayString = (slot.day?.toString().toUpperCase()) ?? 'UNKNOWN';
        int statusString = slot.status ?? 1;
        log("statusString::$statusString");

        // Safely handle null or empty data for slot.slots
        List<String> existingSlots = slot.slots ?? [];

        // If status is 0, clear selected times and skip adding to payload
        if (statusString == 0) {
          if (selectedTimes.isNotEmpty || existingSlots.isNotEmpty) {
            // Update payload to clear slots if they exist
            updateSlotsPayload.add({
              "day": dayString,
              "slots": [], // Explicitly send empty slots
              "is_active": 0,
            });
          }
          continue; // Skip further processing for this day
        }

        // Check if any slots are selected for the current day
        if (selectedTimes.isNotEmpty) {
          isAnySlotPresent = true;
        }

        // Determine whether to create or update the slots for this day
        if (selectedTimes.isNotEmpty) {
          if (existingSlots.isEmpty) {
            // If no slots are present, this is a creation (POST)
            createSlotsPayload.add({
              "day": dayString,
              "slots": selectedTimes,
              "is_active": statusString,
            });
          } else if (existingSlots != selectedTimes) {
            // If slots are different, this is an update (PUT)
            updateSlotsPayload.add({
              "day": dayString,
              "slots": selectedTimes,
              "is_active": statusString,
            });
          }
        }
      }

      // Combine the payloads for both create and update slots
      timeSlotsPayload.addAll(createSlotsPayload);
      timeSlotsPayload.addAll(updateSlotsPayload);

      final body = {
        "time_slots": timeSlotsPayload,
      };

      log("TIME SLOT BODY => $body");

      if (!isAnySlotPresent && timeSlotsPayload.isEmpty) {
        hideLoading(context);
        snackBarMessengers(
          context,
          message: "Please select at least one slot before saving.",
          color: Colors.red,
        );
        return;
      }

      if (timeSlotsPayload.isNotEmpty) {
        // Use PUT for updates or POST for creations
        final response = await apiServices.putApi(
          api.updateProviderTimeSlot,
          body,
          isToken: true,
        );
        log("API Response Message: ${response.message}");
        snackBarMessengers(
          isDuration: true,
          context,
          message: response.message ?? "Slots updated.",
          color: appColor(context).appTheme.primary,
        );
      } else {
        hideLoading(context);
        snackBarMessengers(
          context,
          message: "No changes to save.",
          color: appColor(context).appTheme.lightText,
        );
        notifyListeners();
        return;
      }

      hideLoading(context);
      notifyListeners();

      // Show success dialog
      snackBarMessengers(
        context,
        message: "Slots updated successfully!",
        color: appColor(context).appTheme.primary,
      );
    } catch (e, s) {
      log("Time slot error::$e\n$s");
      hideLoading(context);
      notifyListeners();
    }
  }

  List<String> get timeList {
    List<String> times = [];

    // 09:00 to 23:00
    for (int i = 9; i < 24; i++) {
      times.add('${i.toString().padLeft(2, '0')}:00');
    }

    // 00:00 (midnight)
    times.add('00:00');

    return times;
  }

  bool isMondayUnavailable = false;
  bool is24HourFormat = true;
  int selectedDayIndex = 0;
  List<bool> editableDays = List.filled(24, false);
  late List<List<bool>> selectedSlots;
  // Initialize selectedSlots
  void initSelectedSlots(int timeListLength) {
    selectedSlots = List.generate(
      24,  // For each day of the week (24 hours for each day)
          (_) => List.generate(timeListLength, (_) => false),  // For each time slot of the day
    );
  }
  bool get isSelectedDayUnavailable {
    final day = appArray.timeSlotList[selectedDayIndex].day;

    // Safely search for the day in the list
    final slot = appArray.timeSlotList.firstWhereOrNull(
            (e) => e.day?.toUpperCase() == day?.toUpperCase()
    );

    // If slot is null, return false (or another default behavior if needed)
    return slot?.status == 1; // If status is 1, return true, else false
  }

  void toggleDayAvailability(String day, bool isUnavailable) {
    final index = appArray.timeSlotList.indexWhere(
          (slot) => slot.day!.toUpperCase() == day.toUpperCase(),
    );

    if (index != -1) {
      appArray.timeSlotList[index].status = isUnavailable ? 1 : 0;

      // If status is turned off (0), unselect all time slots for this day
      if (!isUnavailable) {
        // Clear selected slots for the day
        for (int i = 0; i < selectedSlots[index].length; i++) {
          selectedSlots[index][i] = false;
        }

        // Remove all times for this day from selectedTimeTexts
        final timesForDay = getSelectedTimesForDay(index);
        selectedTimeTexts.removeWhere((time) => timesForDay.contains(time));
      }

      notifyListeners();
    }
  }

  void toggle24HourFormat(bool value) {
    is24HourFormat = value;
    notifyListeners();
  }

  void selectDay(int index) {
    selectedDayIndex = index;
    notifyListeners();
  }

  List<String> selectedTimeTexts = [];

  void toggleTimeSlot(int index) {
    final dayIndex = selectedDayIndex;
    selectedSlots[dayIndex][index] = !selectedSlots[dayIndex][index];

    final time = timeList[index];

    if (selectedSlots[dayIndex][index]) {
      // Add time to list if selected
      if (!selectedTimeTexts.contains(time)) {
        selectedTimeTexts.add(time);
      }
    } else {
      // Remove time from list if deselected
      selectedTimeTexts.remove(time);
    }

    notifyListeners();
  }

  List<String> getSelectedTimesForDay(int dayIndex) {
    List<String> selectedTimes = [];

    for (int i = 0; i < selectedSlots[dayIndex].length; i++) {
      if (selectedSlots[dayIndex][i]) {
        final time = (i < timeList.length) ? timeList[i] : null;
        if (time != null && time.isNotEmpty) {
          selectedTimes.add(time);
        } else {
          log("Warning: timeList[$i] is null or empty");
        }
      }
    }

    return selectedTimes;
  }
}
*/
