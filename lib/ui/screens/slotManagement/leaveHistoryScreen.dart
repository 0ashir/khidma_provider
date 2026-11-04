import 'package:flutter/material.dart';
import '../../../app/generalImports.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => FetchSlotConfigurationsCubit()),
          BlocProvider(create: (_) => ManageSlotConfigurationsCubit()),
        ],
        child: const LeaveHistoryScreen(),
      ),
    );
  }

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {
  final Map<String, List<ProviderLeave>> _leaves = {};
  final Map<String, DateTime> _parsedDates = {};
  List<ProviderShift> _shifts = [];
  String? _deletingDate;

  static const _weekDayKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  @override
  void initState() {
    super.initState();
    context.read<FetchSlotConfigurationsCubit>().fetchSlotConfigurations();
  }

  void _initFromData(SlotConfigurationData data) {
    _shifts = data.shifts;
    _leaves.clear();
    _parsedDates.clear();
    for (final l in data.leaves) {
      _leaves.putIfAbsent(l.leaveDate, () => []).add(l);
      final dt = _parseDate(l.leaveDate);
      if (dt != null) _parsedDates[l.leaveDate] = dt;
    }
  }

  DateTime? _parseDate(String s) {
    final p = s.split('-');
    if (p.length < 3) return null;
    try {
      return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    } catch (_) {
      return null;
    }
  }

  String _formatDateLabel(DateTime d) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return '${d.formatDate()} - ${days[d.weekday - 1].translate(context: context)}';
  }

  /// `HH:mm[:ss]` from the API in the country time format.
  String _trimTime(String t) => t.split(':').take(2).join(':').formatTime();

  String _shiftLabel(BuildContext context, ProviderLeave leave) {
    final time =
        (leave.openingTime?.isNotEmpty == true &&
            leave.closingTime?.isNotEmpty == true)
        ? ' · ${_trimTime(leave.openingTime!)} - ${_trimTime(leave.closingTime!)}'
        : '';
    return '${'shift'.translate(context: context)} ${leave.shiftNumber}$time';
  }

  void _deleteDate(BuildContext context, String dateStr) {
    setState(() => _deletingDate = dateStr);
    context.read<ManageSlotConfigurationsCubit>().deleteLeave(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    final sortedKeys = _leaves.keys.toList()..sort();

    return AnnotatedSafeArea(
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'leaveHistory'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
        ),
        backgroundColor: context.colorScheme.primaryColor,
        body:
            BlocListener<
              FetchSlotConfigurationsCubit,
              FetchSlotConfigurationsState
            >(
              listener: (context, state) {
                if (state is FetchSlotConfigurationsSuccess) {
                  setState(() => _initFromData(state.data));
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
                        if (_deletingDate != null) {
                          setState(() {
                            _leaves.remove(_deletingDate);
                            _parsedDates.remove(_deletingDate);
                            _deletingDate = null;
                          });
                        }
                        UiUtils.showMessage(
                          context,
                          state.message,
                          ToastificationType.success,
                        );
                      }
                      if (state is ManageSlotConfigurationsFailure) {
                        setState(() => _deletingDate = null);
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
                      final isLoading =
                          fetchState is FetchSlotConfigurationsInProgress;
                      final isDeleting =
                          manageState is ManageSlotConfigurationsInProgress;

                      if (isLoading) {
                        return const Center(
                          child: CustomCircularProgressIndicator(),
                        );
                      }

                      if (sortedKeys.isEmpty) {
                        return Center(
                          child: CustomText(
                            'noLeavesFound'.translate(context: context),
                            fontSize: 14,
                            color: context.colorScheme.lightGreyColor,
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: sortedKeys.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final dateStr = sortedKeys[index];
                          final date = _parsedDates[dateStr];
                          final leaveItems = (_leaves[dateStr] ?? [])
                            ..sort(
                              (a, b) => a.shiftNumber.compareTo(b.shiftNumber),
                            );
                          final isClosed =
                              date != null &&
                              _shifts
                                  .where(
                                    (s) =>
                                        s.day.toLowerCase() ==
                                        _weekDayKeys[date.weekday - 1],
                                  )
                                  .every((s) => s.isOpen == 0);

                          return CustomContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            borderRadius: UiUtils.borderRadiusOf10,
                            color: context.colorScheme.secondaryColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
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
                                        color: context.colorScheme.blackColor,
                                      ),
                                      const SizedBox(height: 8),
                                      if (isClosed)
                                        CustomText(
                                          'closed'.translate(context: context),
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: context
                                              .colorScheme
                                              .lightGreyColor,
                                        )
                                      else
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: leaveItems.map((leave) {
                                            return CustomContainer(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                              borderRadius:
                                                  UiUtils.borderRadiusOf8,
                                              color: context
                                                  .colorScheme
                                                  .accentColor
                                                  .withValues(alpha: 0.1),
                                              child: CustomText(
                                                _shiftLabel(context, leave),
                                                fontSize: 12,
                                                color: context
                                                    .colorScheme
                                                    .accentColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                isDeleting && _deletingDate == dateStr
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child:
                                            CustomCircularProgressIndicator(),
                                      )
                                    : CustomInkWellContainer(
                                        onTap: () =>
                                            _deleteDate(context, dateStr),
                                        borderRadius: BorderRadius.circular(6),
                                        child: CustomContainer(
                                          padding: const EdgeInsets.all(6),
                                          borderRadius: 6,
                                          color: AppColors.redColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            size: 18,
                                            color: AppColors.redColor,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
            ),
      ),
    );
  }
}
