class ProviderShift {
  final String day;
  final int shiftNumber;
  final String openingTime;
  final String closingTime;
  final int isOpen;

  ProviderShift({
    required this.day,
    required this.shiftNumber,
    required this.openingTime,
    required this.closingTime,
    required this.isOpen,
  });

  factory ProviderShift.fromJson(Map<String, dynamic> json) {
    return ProviderShift(
      day: json['day']?.toString() ?? '',
      shiftNumber: int.tryParse(json['shift_number'].toString()) ?? 1,
      openingTime: json['opening_time']?.toString() ?? '09:00:00',
      closingTime: json['closing_time']?.toString() ?? '18:00:00',
      isOpen: int.tryParse(json['is_open'].toString()) ?? 0,
    );
  }
}

class SlotSettings {
  final int slotInterval;
  final int allowMultipleBookings;
  final int slotCapacity;
  final int minAdvanceBookingValue;
  final String minAdvanceBookingUnit;
  final int maxAdvanceBookingDays;
  final int sameDayBooking;
  final int bufferBefore;
  final int bufferAfter;

  SlotSettings({
    required this.slotInterval,
    required this.allowMultipleBookings,
    required this.slotCapacity,
    required this.minAdvanceBookingValue,
    required this.minAdvanceBookingUnit,
    required this.maxAdvanceBookingDays,
    required this.sameDayBooking,
    required this.bufferBefore,
    required this.bufferAfter,
  });

  factory SlotSettings.fromJson(Map<String, dynamic> json) {
    return SlotSettings(
      slotInterval: int.tryParse(json['slot_interval'].toString()) ?? 30,
      allowMultipleBookings:
          int.tryParse(json['allow_multiple_bookings'].toString()) ?? 0,
      slotCapacity: int.tryParse(json['slot_capacity'].toString()) ?? 1,
      minAdvanceBookingValue:
          int.tryParse(json['min_advance_booking_value'].toString()) ?? 1,
      minAdvanceBookingUnit:
          json['min_advance_booking_unit']?.toString() ?? 'hours',
      maxAdvanceBookingDays:
          int.tryParse(json['max_advance_booking_days'].toString()) ?? 10,
      sameDayBooking: int.tryParse(json['same_day_booking'].toString()) ?? 1,
      bufferBefore: int.tryParse(json['buffer_before'].toString()) ?? 0,
      bufferAfter: int.tryParse(json['buffer_after'].toString()) ?? 0,
    );
  }

  static SlotSettings defaults() => SlotSettings(
    slotInterval: 30,
    allowMultipleBookings: 0,
    slotCapacity: 1,
    minAdvanceBookingValue: 1,
    minAdvanceBookingUnit: 'hours',
    maxAdvanceBookingDays: 10,
    sameDayBooking: 1,
    bufferBefore: 0,
    bufferAfter: 0,
  );
}

class ProviderLeave {
  final String leaveDate;
  final int shiftNumber;
  final String? day;
  final String? openingTime;
  final String? closingTime;

  ProviderLeave({
    required this.leaveDate,
    required this.shiftNumber,
    this.day,
    this.openingTime,
    this.closingTime,
  });

  factory ProviderLeave.fromJson(Map<String, dynamic> json) {
    return ProviderLeave(
      leaveDate: json['leave_date']?.toString() ?? '',
      shiftNumber: int.tryParse(json['shift_number'].toString()) ?? 1,
      day: json['day']?.toString(),
      openingTime: json['opening_time']?.toString(),
      closingTime: json['closing_time']?.toString(),
    );
  }
}

class SlotConfigurationData {
  final List<ProviderShift> shifts;
  final SlotSettings slotSettings;
  final List<ProviderLeave> leaves;

  SlotConfigurationData({
    required this.shifts,
    required this.slotSettings,
    required this.leaves,
  });

  factory SlotConfigurationData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final shifts = (data['shifts'] as List? ?? [])
        .map((e) => ProviderShift.fromJson(e as Map<String, dynamic>))
        .toList();

    final settingsJson = data['slot_configurations'] as Map<String, dynamic>?;
    final slotSettings = settingsJson != null
        ? SlotSettings.fromJson(settingsJson)
        : SlotSettings.defaults();

    final leaves = (data['leaves'] as List? ?? [])
        .map((e) => ProviderLeave.fromJson(e as Map<String, dynamic>))
        .toList();

    return SlotConfigurationData(
      shifts: shifts,
      slotSettings: slotSettings,
      leaves: leaves,
    );
  }
}
