import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => FetchSlotConfigurationsCubit()),
          BlocProvider(create: (_) => ManageSlotConfigurationsCubit()),
        ],
        child: const LeaveScreen(),
      ),
    );
  }

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchSlotConfigurationsCubit>().fetchSlotConfigurations();
  }

  DateTime? _fromDate;
  DateTime? _toDate;

  List<ProviderShift> _shifts = [];

  // dateStr → set of shift_numbers on leave
  final Map<String, Set<int>> _managedDates = {};
  // dateStr → DateTime (for lookups)
  final Map<String, DateTime> _parsedDates = {};

  static const _weekDayKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  // ─── Helpers ──────────────────────────────────────────────────

  String _dayKey(DateTime d) => _weekDayKeys[d.weekday - 1];

  List<ProviderShift> _openShiftsForDate(DateTime date) {
    final day = _dayKey(date);
    return _shifts
        .where((s) => s.day.toLowerCase() == day && s.isOpen == 1)
        .toList()
      ..sort((a, b) => a.shiftNumber.compareTo(b.shiftNumber));
  }

  /// `HH:mm[:ss]` from the API in the country time format.
  String _trimTime(String t) => t.split(':').take(2).join(':').formatTime();

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatDateLabel(DateTime d) {
    return '${d.formatDate()} - ${_weekDayKeys[d.weekday - 1].translate(context: context)}';
  }

  // ─── Date picker ──────────────────────────────────────────────

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final accentColor = context.colorScheme.accentColor;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: (_fromDate != null && _toDate != null)
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: accentColor,
            onPrimary: AppColors.whiteColors,
            secondaryContainer: accentColor.withValues(alpha: 0.15),
            onSecondaryContainer: accentColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _fromDate = picked.start;
      _toDate = picked.end;
      _applyRange(_fromDate!, _toDate!);
    });
  }

  void _applyRange(DateTime from, DateTime to) {
    _managedDates.clear();
    _parsedDates.clear();
    DateTime current = from;
    while (!current.isAfter(to)) {
      final key = _dateKey(current);
      _parsedDates[key] = current;
      final shiftNums = _openShiftsForDate(
        current,
      ).map((s) => s.shiftNumber).toSet();
      _managedDates[key] = shiftNums.isEmpty ? {1} : shiftNums;
      current = current.add(const Duration(days: 1));
    }
  }

  // ─── Save ─────────────────────────────────────────────────────

  void _save(BuildContext context) {
    final entries = <Map<String, dynamic>>[];
    for (final e in _managedDates.entries) {
      for (final shiftNum in e.value) {
        entries.add({'leave_date': e.key, 'shift_number': shiftNum});
      }
    }
    context.read<ManageSlotConfigurationsCubit>().manageLeaves(entries);
  }

  bool get _canSave => _managedDates.values.any((s) => s.isNotEmpty);

  // ─── Conflict dialog ──────────────────────────────────────────

  void _showConflictDialog(
    BuildContext context,
    String message,
    List<Map<String, dynamic>> bookings,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colorScheme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
        title: CustomText(
          'bookingConflict'.translate(context: context),
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.redColor,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              message,
              fontSize: 13,
              color: context.colorScheme.lightGreyColor,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: bookings.map((b) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryColor,
                        borderRadius: BorderRadius.circular(
                          UiUtils.borderRadiusOf8,
                        ),
                        border: Border(
                          left: BorderSide(
                            color: context.colorScheme.accentColor,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  '${'orderID'.translate(context: context)}: ',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: context.colorScheme.blackColor,
                                ),
                                Expanded(
                                  child: CustomText(
                                    '#${b['order_id'] ?? ''}',
                                    fontSize: 12,
                                    color: context.colorScheme.lightGreyColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context).pushNamed(
                                      Routes.bookingDetails,
                                      arguments: {
                                        'bookingId': b['order_id']?.toString(),
                                      },
                                    );
                                  },
                                  child: CustomText(
                                    'view'.translate(context: context),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.accentColor,
                                    showUnderline: true,
                                    underlineOrLineColor:
                                        context.colorScheme.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _conflictRow(
                            'date'.translate(context: context),
                            b['date']?.toString().formatDate() ?? '',
                          ),
                          _conflictRow(
                            'startTime'.translate(context: context),
                            _trimTime(b['starting_time']?.toString() ?? ''),
                          ),
                          _conflictRow(
                            'customer'.translate(context: context),
                            b['customer_name']?.toString() ?? '',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: CustomText(
              'okay'.translate(context: context),
              fontWeight: FontWeight.w600,
              color: context.colorScheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _conflictRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            '$label: ',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.colorScheme.blackColor,
          ),
          Expanded(
            child: CustomText(
              value,
              fontSize: 12,
              color: context.colorScheme.lightGreyColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final sortedKeys = _managedDates.keys.toList()..sort();

    return AnnotatedSafeArea(
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'setLeave'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.leaveHistoryScreen),
              child: Text(
                'leaveHistory'.translate(context: context),
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
        body: BlocListener<FetchSlotConfigurationsCubit, FetchSlotConfigurationsState>(
          listener: (context, state) {
            if (state is FetchSlotConfigurationsSuccess) {
              setState(() => _shifts = state.data.shifts);
            }
            if (state is FetchSlotConfigurationsFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
          },
          child: BlocConsumer<ManageSlotConfigurationsCubit, ManageSlotConfigurationsState>(
            listener: (context, state) {
              if (state is ManageSlotConfigurationsSuccess) {
                UiUtils.showMessage(
                  context,
                  state.message,
                  ToastificationType.success,
                );
                setState(() {
                  _managedDates.clear();
                  _parsedDates.clear();
                  _fromDate = null;
                  _toDate = null;
                });
              }
              if (state is ManageSlotConfigurationsFailure) {
                UiUtils.showMessage(
                  context,
                  state.errorMessage,
                  ToastificationType.error,
                );
              }
              if (state is ManageSlotConfigurationsBookingConflict) {
                _showConflictDialog(context, state.message, state.bookings);
              }
            },
            builder: (context, manageState) {
              final isSaving =
                  manageState is ManageSlotConfigurationsInProgress;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date range picker
                          CustomContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: UiUtils.borderRadiusOf10,
                            color: context.colorScheme.secondaryColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _DateField(
                                  label: 'fromDate'.translate(context: context),
                                  value: _fromDate != null
                                      ? _fromDate!.formatDate()
                                      : '',
                                  placeholder: 'selectFromDate'.translate(
                                    context: context,
                                  ),
                                  onTap: () => _pickDateRange(),
                                ),
                                const SizedBox(height: 16),
                                _DateField(
                                  label: 'toDate'.translate(context: context),
                                  value: _toDate != null
                                      ? _toDate!.formatDate()
                                      : '',
                                  placeholder: 'selectToDate'.translate(
                                    context: context,
                                  ),
                                  onTap: () => _pickDateRange(),
                                ),
                              ],
                            ),
                          ),
                          // Managed dates list
                          if (sortedKeys.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              borderRadius: UiUtils.borderRadiusOf10,
                              color: context.colorScheme.secondaryColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: sortedKeys.map((dateStr) {
                                  final date = _parsedDates[dateStr];
                                  final selected = _managedDates[dateStr] ?? {};
                                  final dayShifts = date != null
                                      ? _openShiftsForDate(date)
                                      : <ProviderShift>[];
                                  final allSelected =
                                      dayShifts.isNotEmpty &&
                                      dayShifts.every(
                                        (s) => selected.contains(s.shiftNumber),
                                      );
                                  final isLast = dateStr == sortedKeys.last;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              date != null
                                                  ? _formatDateLabel(date)
                                                  : dateStr,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: context
                                                  .colorScheme
                                                  .blackColor,
                                            ),
                                            const SizedBox(height: 10),
                                            if (dayShifts.isEmpty)
                                              CustomContainer(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10,
                                                    ),
                                                borderRadius:
                                                    UiUtils.borderRadiusOf8,
                                                border: Border.all(
                                                  color: context
                                                      .colorScheme
                                                      .lightGreyColor,
                                                  width: 1,
                                                ),
                                                child: CustomText(
                                                  'closed'.translate(
                                                    context: context,
                                                  ),
                                                  fontSize: 13,
                                                  fontStyle: FontStyle.italic,
                                                  color: context
                                                      .colorScheme
                                                      .lightGreyColor,
                                                ),
                                              )
                                            else
                                              LayoutBuilder(
                                                builder: (context, constraints) {
                                                  const spacing = 8.0;
                                                  final itemWidth =
                                                      (constraints.maxWidth -
                                                          spacing * 2) /
                                                      3;
                                                  final allItems = <Widget>[
                                                    SizedBox(
                                                      width: itemWidth,
                                                      child: CustomCheckIconTextButton(
                                                        title: 'fullDay',
                                                        subtitle:
                                                            '${_trimTime(dayShifts.first.openingTime)} - ${_trimTime(dayShifts.last.closingTime)}',
                                                        isSelected: allSelected,
                                                        onTap: () => setState(() {
                                                          if (allSelected) {
                                                            _managedDates[dateStr]
                                                                ?.clear();
                                                          } else {
                                                            _managedDates[dateStr] =
                                                                dayShifts
                                                                    .map(
                                                                      (s) => s
                                                                          .shiftNumber,
                                                                    )
                                                                    .toSet();
                                                          }
                                                        }),
                                                      ),
                                                    ),
                                                    if (dayShifts.length > 1)
                                                      for (final shift
                                                          in dayShifts)
                                                        SizedBox(
                                                          width: itemWidth,
                                                          child: CustomCheckIconTextButton(
                                                            title:
                                                                '${'shift'.translate(context: context)} ${shift.shiftNumber}',
                                                            subtitle:
                                                                '${_trimTime(shift.openingTime)} - ${_trimTime(shift.closingTime)}',
                                                            isSelected: selected
                                                                .contains(
                                                                  shift
                                                                      .shiftNumber,
                                                                ),
                                                            onTap: () => setState(() {
                                                              final s =
                                                                  _managedDates[dateStr] ??=
                                                                      {};
                                                              if (s.contains(
                                                                shift
                                                                    .shiftNumber,
                                                              )) {
                                                                s.remove(
                                                                  shift
                                                                      .shiftNumber,
                                                                );
                                                              } else {
                                                                s.add(
                                                                  shift
                                                                      .shiftNumber,
                                                                );
                                                              }
                                                            }),
                                                          ),
                                                        ),
                                                  ];
                                                  return Wrap(
                                                    spacing: spacing,
                                                    runSpacing: spacing,
                                                    children: allItems,
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (!isLast)
                                        Divider(
                                          height: 1,
                                          thickness: 0.5,
                                          color: context
                                              .colorScheme
                                              .lightGreyColor
                                              .withValues(alpha: 0.4),
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
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
                      onTap: (!_canSave || isSaving)
                          ? null
                          : () => _save(context),
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
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.placeholder = '',
  });

  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.blackColor,
                ),
              ),
              const TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 13, color: AppColors.redColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: CustomContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            borderRadius: UiUtils.borderRadiusOf8,
            border: Border.all(
              color: context.colorScheme.lightGreyColor,
              width: 0.5,
            ),
            color: context.colorScheme.primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    value.isEmpty ? placeholder : value,
                    fontSize: 14,
                    color: value.isEmpty
                        ? context.colorScheme.lightGreyColor
                        : context.colorScheme.blackColor,
                  ),
                ),
                CustomSvgPicture(
                  svgImage: AppAssets.bCalender,
                  color: context.colorScheme.lightGreyColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
