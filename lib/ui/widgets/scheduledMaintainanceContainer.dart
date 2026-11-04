import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class ScheduledMaintenanceContainer extends StatefulWidget {
  final AppSetting appSettings;
  const ScheduledMaintenanceContainer({super.key, required this.appSettings});

  @override
  State<ScheduledMaintenanceContainer> createState() =>
      _ScheduledMaintenanceContainerState();
}

class _ScheduledMaintenanceContainerState
    extends State<ScheduledMaintenanceContainer> {
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _checkIfDismissed();
  }

  void _checkIfDismissed() {
    final lastDismissed =
        HiveRepository.getLastSkippedMaintenanceScheduleWarning;
    final startDateTime =
        widget.appSettings.providerAppMaintenanceModeStartDateTime;

    if (lastDismissed != null && startDateTime != null) {
      // Check if the dismissed warning is for the same maintenance schedule
      final dismissedDateTime = DateTime.tryParse(lastDismissed);
      if (dismissedDateTime != null &&
          dismissedDateTime.isAtSameMomentAs(startDateTime)) {
        setState(() {
          _isDismissed = true;
        });
      }
    }
  }

  void _dismissWarning() {
    final startDateTime =
        widget.appSettings.providerAppMaintenanceModeStartDateTime;
    if (startDateTime != null) {
      HiveRepository.setLastSkippedMaintenanceScheduleWarning = startDateTime
          .toIso8601String();
      setState(() {
        _isDismissed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final startDateTime =
        widget.appSettings.providerAppMaintenanceModeStartDateTime;
    final endDateTime =
        widget.appSettings.providerAppMaintenanceModeEndDateTime;

    if (startDateTime == null ||
        endDateTime == null ||
        widget.appSettings.providerAppScheduleMaintenanceMode == false) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: _isDismissed ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        onEnd: () {
          if (_isDismissed) {
            setState(() {});
          }
        },
        child: _isDismissed
            ? const SizedBox.shrink()
            : CustomContainer(
                color: AppColors.orangeColor.withValues(alpha: 0.15),
                margin: EdgeInsets.only(
                  bottom: 12.rh(context),
                ).add(EdgeInsets.symmetric(horizontal: 15.rw(context))),
                padding: const EdgeInsets.all(12),
                border: Border.all(
                  color: AppColors.orangeColor.withValues(alpha: 0.25),
                ),
                borderRadius: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.orangeColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'scheduledMaintenanceTitle'.translate(
                              context: context,
                            ),
                            fontSize: 14,
                            maxLines: 1,
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.blackColor,
                          ),
                          const SizedBox(height: 2),
                          Text.rich(
                            TextSpan(
                              text:
                                  '${'scheduledMaintenanceDescription'.translate(context: context)} ',
                              children: [
                                TextSpan(
                                  text: UiUtils.formatDateTime(
                                    startDateTime,
                                    convertToLocal: true,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' ${'to'.translate(context: context).toLowerCase()} ',
                                ),
                                TextSpan(
                                  text:
                                      '${UiUtils.formatDateTime(endDateTime, convertToLocal: true)}.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.colorScheme.blackColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _dismissWarning,
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
