import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => FetchSlotConfigurationsCubit()),
          BlocProvider(create: (_) => ManageSlotConfigurationsCubit()),
        ],
        child: const WorkingHoursScreen(),
      ),
    );
  }

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

typedef _TimeRange = ({TimeOfDay start, TimeOfDay end});

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  static const List<String> _dayKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  late List<bool> _isOpen;
  late List<List<_TimeRange>> _slots;
  bool _initialized = false;
  int _slotInterval = 30;

  @override
  void initState() {
    super.initState();
    _isOpen = List.filled(7, true);
    _slots = List.generate(
      7,
      (_) => [
        (
          start: const TimeOfDay(hour: 9, minute: 0),
          end: const TimeOfDay(hour: 18, minute: 0),
        ),
      ],
    );
    context.read<FetchSlotConfigurationsCubit>().fetchSlotConfigurations();
  }

  void _initFromShifts(List<ProviderShift> shifts) {
    _isOpen = List.filled(7, false);
    _slots = List.generate(7, (_) => []);

    // Group shifts by day
    for (int i = 0; i < _dayKeys.length; i++) {
      final dayShifts =
          shifts.where((s) => s.day.toLowerCase() == _dayKeys[i]).toList()
            ..sort((a, b) => a.shiftNumber.compareTo(b.shiftNumber));

      if (dayShifts.isEmpty) {
        _isOpen[i] = true;
        _slots[i] = [
          (
            start: const TimeOfDay(hour: 9, minute: 0),
            end: const TimeOfDay(hour: 18, minute: 0),
          ),
        ];
      } else {
        final anyOpen = dayShifts.any((s) => s.isOpen == 1);
        _isOpen[i] = anyOpen;
        _slots[i] = dayShifts.map((s) {
          return (
            start: _parseTime(s.openingTime),
            end: _parseTime(s.closingTime),
          );
        }).toList();
        if (_slots[i].isEmpty) {
          _slots[i] = [
            (
              start: const TimeOfDay(hour: 9, minute: 0),
              end: const TimeOfDay(hour: 18, minute: 0),
            ),
          ];
        }
      }
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  /// Label in the country time format; [_formatTime] is the API format.
  String _displayTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}'
          .formatTime();

  Future<void> _pickTime(int dayIdx, int slotIdx, bool isStart) async {
    final current = isStart
        ? _slots[dayIdx][slotIdx].start
        : _slots[dayIdx][slotIdx].end;
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: dateAndTimeSetting['use24HourFormat'] as bool,
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        final slot = _slots[dayIdx][slotIdx];
        _slots[dayIdx][slotIdx] = isStart
            ? (start: picked, end: slot.end)
            : (start: slot.start, end: picked);
      });
    }
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  // Returns null if valid, or ({errorKey, slotIndex}) of first bad slot.
  ({String key, int slotIndex})? _validateDaySlots(List<_TimeRange> slots) {
    for (int s = 0; s < slots.length; s++) {
      if (_toMinutes(slots[s].start) >= _toMinutes(slots[s].end)) {
        return (key: 'startTimeMustBeBeforeEndTime', slotIndex: s);
      }
      if (s > 0 && _toMinutes(slots[s].start) < _toMinutes(slots[s - 1].end)) {
        return (key: 'slotsOverlapError', slotIndex: s);
      }
    }
    return null;
  }

  String _buildSlotErrorMessage(
    BuildContext context,
    int dayIdx,
    ({String key, int slotIndex}) error,
  ) {
    final dayName = _dayKeys[dayIdx].translate(context: context);
    final slotNum = error.slotIndex + 1;
    final base = error.key.translate(context: context);
    final slotLabel = 'slot'.translate(context: context);
    return '$dayName – $slotLabel $slotNum: $base';
  }

  TimeOfDay _addMinutes(TimeOfDay t, int minutes) {
    final total = t.hour * 60 + t.minute + minutes;
    return TimeOfDay(hour: (total ~/ 60) % 24, minute: total % 60);
  }

  void _addSlot(int dayIdx) {
    final lastEnd = _slots[dayIdx].last.end;
    final newEnd = _addMinutes(lastEnd, _slotInterval);
    setState(() {
      _slots[dayIdx].add((start: lastEnd, end: newEnd));
    });
  }

  void _removeSlot(int dayIdx, int slotIdx) {
    setState(() => _slots[dayIdx].removeAt(slotIdx));
  }

  void _applyToAll() {
    final firstEnabledIdx = _isOpen.indexWhere((open) => open);
    if (firstEnabledIdx == -1) return;
    final sourceError = _validateDaySlots(_slots[firstEnabledIdx]);
    if (sourceError != null) {
      UiUtils.showMessage(
        context,
        _buildSlotErrorMessage(context, firstEnabledIdx, sourceError),
        ToastificationType.error,
      );
      return;
    }
    final sourceSlots = List<_TimeRange>.from(_slots[firstEnabledIdx]);
    setState(() {
      for (int i = 0; i < 7; i++) {
        _isOpen[i] = true;
        _slots[i] = List<_TimeRange>.from(sourceSlots);
      }
    });
  }

  void _save(BuildContext context) {
    for (int i = 0; i < 7; i++) {
      if (!_isOpen[i]) continue;
      final error = _validateDaySlots(_slots[i]);
      if (error != null) {
        UiUtils.showMessage(
          context,
          _buildSlotErrorMessage(context, i, error),
          ToastificationType.error,
        );
        return;
      }
    }
    final shifts = <Map<String, dynamic>>[];
    for (int i = 0; i < _dayKeys.length; i++) {
      for (int s = 0; s < _slots[i].length; s++) {
        shifts.add({
          'day': _dayKeys[i],
          'shift_number': s + 1,
          'opening_time': _formatTime(_slots[i][s].start),
          'closing_time': _formatTime(_slots[i][s].end),
          'is_open': _isOpen[i] ? 1 : 0,
        });
      }
    }
    context.read<ManageSlotConfigurationsCubit>().manageShifts(shifts);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'workingHours'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
          actions: [
            TextButton(
              onPressed: _applyToAll,
              child: Text(
                'applyToAll'.translate(context: context),
                style: TextStyle(
                  color: context.colorScheme.accentColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: context.colorScheme.primaryColor,
        body:
            BlocListener<
              FetchSlotConfigurationsCubit,
              FetchSlotConfigurationsState
            >(
              listener: (context, state) {
                if (state is FetchSlotConfigurationsSuccess && !_initialized) {
                  setState(() {
                    _slotInterval = state.data.slotSettings.slotInterval;
                    _initFromShifts(state.data.shifts);
                    _initialized = true;
                  });
                }
                if (state is FetchSlotConfigurationsFailure) {
                  UiUtils.showMessage(
                    context,
                    state.errorMessage,
                    ToastificationType.error,
                  );
                }
              },
              child:
                  BlocConsumer<
                    ManageSlotConfigurationsCubit,
                    ManageSlotConfigurationsState
                  >(
                    listener: (context, state) {
                      if (state is ManageSlotConfigurationsSuccess) {
                        UiUtils.showMessage(
                          context,
                          state.message,
                          ToastificationType.success,
                        );
                      }
                      if (state is ManageSlotConfigurationsFailure) {
                        UiUtils.showMessage(
                          context,
                          state.errorMessage,
                          ToastificationType.error,
                        );
                      }
                    },
                    builder: (context, manageState) {
                      final fetchState = context
                          .watch<FetchSlotConfigurationsCubit>()
                          .state;
                      final isLoadingData =
                          fetchState is FetchSlotConfigurationsInProgress;
                      final isSaving =
                          manageState is ManageSlotConfigurationsInProgress;

                      if (isLoadingData) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: CustomContainer(
                                padding: const EdgeInsets.all(16),
                                borderRadius: UiUtils.borderRadiusOf10,
                                color: context.colorScheme.secondaryColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'workingSchedule'.translate(
                                        context: context,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      'configureWhenServicesAvailable'
                                          .translate(context: context),
                                      fontSize: 13,
                                      color: context.colorScheme.lightGreyColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        CustomSvgPicture(
                                          svgImage: AppAssets.bClock,
                                          height: 14,
                                          width: 14,
                                          color:
                                              context.colorScheme.accentColor,
                                        ),
                                        const SizedBox(width: 6),
                                        CustomText(
                                          '${'slotInterval'.translate(context: context)}: $_slotInterval ${'mins'.translate(context: context)}',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              context.colorScheme.accentColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ...List.generate(7, _buildDayRow),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: CustomRoundedButton(
                              showBorder: false,
                              widthPercentage: 1,
                              backgroundColor: context.colorScheme.accentColor,
                              titleColor: AppColors.whiteColors,
                              buttonTitleWidget: isSaving
                                  ? CustomCircularProgressIndicator(
                                      color: AppColors.whiteColors,
                                    )
                                  : null,
                              buttonTitle: isSaving
                                  ? null
                                  : 'saveBtn'.translate(context: context),
                              onTap: isSaving ? null : () => _save(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            ),
      ),
    );
  }

  Widget _buildDayRow(int i) {
    final isOpen = _isOpen[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        borderRadius: UiUtils.borderRadiusOf8,
        border: Border.all(
          color: isOpen
              ? context.colorScheme.accentColor
              : context.colorScheme.lightGreyColor,
          width: 0.8,
        ),
        color: isOpen
            ? context.colorScheme.accentColor.withValues(alpha: 0.04)
            : context.colorScheme.primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isOpen[i] = !_isOpen[i]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSvgPicture(
                    svgImage: AppAssets.checkCircle,
                    height: 20,
                    width: 20,
                    color: isOpen
                        ? context.colorScheme.accentColor
                        : context.colorScheme.lightGreyColor,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    _dayKeys[i].translate(context: context),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isOpen
                        ? context.colorScheme.blackColor
                        : context.colorScheme.lightGreyColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: isOpen
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          _slots[i].length,
                          (s) => _buildSlotRow(i, s),
                        ),
                      )
                    : CustomText(
                        'closed'.translate(context: context),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: context.colorScheme.lightGreyColor,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotRow(int dayIdx, int slotIdx) {
    final slot = _slots[dayIdx][slotIdx];
    final isLast = slotIdx == _slots[dayIdx].length - 1;

    return Padding(
      padding: EdgeInsets.only(
        bottom: slotIdx < _slots[dayIdx].length - 1 ? 6 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeButton(
            _displayTime(slot.start),
            () => _pickTime(dayIdx, slotIdx, true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: CustomText(
              '—',
              color: context.colorScheme.lightGreyColor,
              fontSize: 10,
            ),
          ),
          _buildTimeButton(
            _displayTime(slot.end),
            () => _pickTime(dayIdx, slotIdx, false),
          ),
          const SizedBox(width: 4),
          if (isLast)
            CustomInkWellContainer(
              onTap: () => _addSlot(dayIdx),
              borderRadius: BorderRadius.circular(4),
              child: CustomContainer(
                padding: const EdgeInsets.all(4),
                borderRadius: 4,
                color: context.colorScheme.accentColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.add,
                  size: 16,
                  color: context.colorScheme.accentColor,
                ),
              ),
            )
          else
            CustomInkWellContainer(
              onTap: () => _removeSlot(dayIdx, slotIdx),
              borderRadius: BorderRadius.circular(4),
              child: CustomContainer(
                padding: const EdgeInsets.all(4),
                borderRadius: 4,
                color: AppColors.redColor.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: AppColors.redColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String time, VoidCallback onTap) {
    return CustomInkWellContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        borderRadius: 6,
        color: context.colorScheme.accentColor.withValues(alpha: 0.1),
        child: CustomText(
          time,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: context.colorScheme.accentColor,
        ),
      ),
    );
  }
}
