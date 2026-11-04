import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class HandymanCashCollectionFilterBottomSheet extends StatefulWidget {
  const HandymanCashCollectionFilterBottomSheet({
    super.key,
    this.initialType,
    this.initialDateFrom,
    this.initialDateTo,
  });

  final String? initialType;
  final DateTime? initialDateFrom;
  final DateTime? initialDateTo;

  @override
  State<HandymanCashCollectionFilterBottomSheet> createState() =>
      _HandymanCashCollectionFilterBottomSheetState();
}

class _HandymanCashCollectionFilterBottomSheetState
    extends State<HandymanCashCollectionFilterBottomSheet> {
  late String? _type = widget.initialType;
  late DateTime? _dateFrom = widget.initialDateFrom;
  late DateTime? _dateTo = widget.initialDateTo;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final accentColor = context.colorScheme.accentColor;
    final surfaceColor = context.colorScheme.secondaryColor;
    final onSurfaceColor = context.colorScheme.blackColor;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: (_dateFrom != null && _dateTo != null)
          ? DateTimeRange(start: _dateFrom!, end: _dateTo!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: Theme.of(
            context,
          ).dialogTheme.copyWith(backgroundColor: surfaceColor),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: accentColor,
            onPrimary: AppColors.whiteColors,
            secondaryContainer: accentColor.withValues(alpha: 0.15),
            onSecondaryContainer: accentColor,
            surface: surfaceColor,
            surfaceContainerHigh: surfaceColor,
            onSurface: onSurfaceColor,
            onSurfaceVariant: onSurfaceColor,
          ),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: onSurfaceColor,
            displayColor: onSurfaceColor,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: surfaceColor,
            headerBackgroundColor: accentColor,
            headerForegroundColor: AppColors.whiteColors,
            rangePickerBackgroundColor: surfaceColor,
            rangePickerHeaderBackgroundColor: accentColor,
            rangePickerHeaderForegroundColor: AppColors.whiteColors,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.whiteColors;
              }
              if (states.contains(WidgetState.disabled)) {
                return onSurfaceColor.withValues(alpha: 0.38);
              }
              return onSurfaceColor;
            }),
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _dateFrom = picked.start;
      _dateTo = picked.end;
    });
  }

  Widget _typeChip(String? value, String labelKey) {
    final selected = _type == value;
    final blackColor = Theme.of(context).colorScheme.blackColor;
    return Expanded(
      child: CustomInkWellContainer(
        onTap: () => setState(() => _type = value),
        child: CustomContainer(
          height: 40,
          color: selected
              ? context.colorScheme.accentColor
              : context.colorScheme.secondaryColor,
          border: selected
              ? null
              : Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.lightGreyColor.withValues(alpha: 0.4),
                ),
          borderRadius: UiUtils.borderRadiusOf10,
          child: Center(
            child: Text(
              labelKey.translate(context: context),
              style: TextStyle(
                color: selected ? AppColors.whiteColors : blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blackColor = Theme.of(context).colorScheme.blackColor;
    final hasDateRange = _dateFrom != null && _dateTo != null;

    return BottomSheetLayout(
      title: 'filter',
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'type'.translate(context: context),
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: blackColor,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _typeChip(null, 'all'),
                const SizedBox(width: 8),
                _typeChip('collection', 'collection'),
                const SizedBox(width: 8),
                _typeChip('settlement', 'settlement'),
              ],
            ),
            const SizedBox(height: 18),
            CustomText(
              'dateRange'.translate(context: context),
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: blackColor,
            ),
            const SizedBox(height: 8),
            CustomInkWellContainer(
              onTap: _pickDateRange,
              child: CustomContainer(
                height: 48,
                borderRadius: UiUtils.borderRadiusOf10,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.lightGreyColor.withValues(alpha: 0.4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 18,
                      color: context.colorScheme.accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomText(
                        hasDateRange
                            ? '${_dateFrom!.formatDate()} - ${_dateTo!.formatDate()}'
                            : 'selectDateRange'.translate(context: context),
                        fontSize: 13,
                        color: blackColor,
                      ),
                    ),
                    if (hasDateRange)
                      CustomInkWellContainer(
                        onTap: () => setState(() {
                          _dateFrom = null;
                          _dateTo = null;
                        }),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: Theme.of(context).colorScheme.lightGreyColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CloseAndConfirmButton(
              closeButtonName: 'clear'.translate(context: context),
              confirmButtonName: 'apply'.translate(context: context),
              closeButtonPressed: () {
                Navigator.pop(context, {
                  'type': null,
                  'dateFrom': null,
                  'dateTo': null,
                });
              },
              confirmButtonPressed: () {
                Navigator.pop(context, {
                  'type': _type,
                  'dateFrom': _dateFrom,
                  'dateTo': _dateTo,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
