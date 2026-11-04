import 'package:edemand_partner/app/generalImports.dart';
import 'package:edemand_partner/cubits/notification/removeNotificationsCubit.dart';
import 'package:edemand_partner/ui/screens/notifications/widgets/notificationItemContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
    builder: (final _) => BlocProvider(
      create: (BuildContext context) => NotificationsCubit(),
      child: const NotificationsScreen(),
    ),
  );

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _processingNotificationId;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchNotifications() {
    context.read<NotificationsCubit>().fetchNotifications();
  }

  void _onScroll() {
    if (!context.read<NotificationsCubit>().hasMoreNotification()) {
      return;
    }
    // Trigger fetch when 70% scrolled
    final nextPageTrigger = 0.7 * _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels > nextPageTrigger) {
      context.read<NotificationsCubit>().fetchMoreNotifications();
    }
  }

  /// Returns the date group key for grouping notifications
  String _getDateGroupKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notificationDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(notificationDate).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else {
      return '${date.day}_${date.month}_${date.year}';
    }
  }

  /// Returns the translated title for a date group
  String _getGroupTitle(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notificationDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(notificationDate).inDays;

    if (difference == 0) {
      return 'today'.translate(context: context);
    } else if (difference == 1) {
      return 'yesterday'.translate(context: context);
    } else {
      final languageCode =
          HiveRepository.getCurrentLanguage()?.languageCode ?? 'en';
      return DateFormat('d MMMM, y', languageCode).format(date);
    }
  }

  /// Determines the location of the notification item within its group
  NotificationItemLocation _getItemLocation(
    List<NotificationDataModel> notifications,
    int index,
  ) {
    final currentKey = _getDateGroupKey(notifications[index].dateSent);

    final bool hasPreviousInGroup =
        index > 0 &&
        _getDateGroupKey(notifications[index - 1].dateSent) == currentKey;

    final bool hasNextInGroup =
        index < notifications.length - 1 &&
        _getDateGroupKey(notifications[index + 1].dateSent) == currentKey;

    if (!hasPreviousInGroup && !hasNextInGroup) {
      return NotificationItemLocation.onlyOne;
    } else if (!hasPreviousInGroup && hasNextInGroup) {
      return NotificationItemLocation.first;
    } else if (hasPreviousInGroup && !hasNextInGroup) {
      return NotificationItemLocation.last;
    } else {
      return NotificationItemLocation.middle;
    }
  }

  /// Handles notification tap - redirects based on notification type
  Future<void> _onNotificationTap(NotificationDataModel notification) async {
    // Prevent multi-taps
    if (_processingNotificationId != null) return;

    setState(() {
      _processingNotificationId = notification.id;
    });

    try {
      await NotificationService.handleNotificationRedirection(
        notification.toRedirectionData(),
      );
    } on NotificationTapError catch (e) {
      UiUtils.showMessage(
        context,
        e.errorMessageKey.translate(context: context),
        ToastificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _processingNotificationId = null;
        });
      }
    }
  }

  Widget _buildShimmerLoading({int count = 6}) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      children: List.generate(
        count,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: ShimmerLoadingContainer(
            child: CustomShimmerContainer(
              borderRadius: UiUtils.borderRadiusOf10,
              width: double.infinity,
              height: 80,
            ),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colorScheme.primaryColor,
    appBar: UiUtils.getSimpleAppBar(
      context: context,
      title: 'notifications'.translate(context: context),
      statusBarColor: context.colorScheme.secondaryColor,
    ),
    body: BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final subscriptionsEnabled = context
            .watch<FetchSystemSettingsCubit>()
            .subscriptionsEnabled;
        if (state is NotificationFetchFailure) {
          return Center(
            child: ErrorContainer(
              onTapRetry: _fetchNotifications,
              errorMessage: state.errorMessage.translate(context: context),
            ),
          );
        }

        if (state is NotificationFetchSuccess) {
          final notifications = state.notificationsList
              .where((item) => subscriptionsEnabled || !item.isSubscription)
              .toList();
          // Continue past pages containing only hidden subscription notices.
          if (notifications.isEmpty &&
              context.read<NotificationsCubit>().hasMoreNotification()) {
            if (!state.isLoadingMoreData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted &&
                    identical(
                      context.read<NotificationsCubit>().state,
                      state,
                    )) {
                  context.read<NotificationsCubit>().fetchMoreNotifications();
                }
              });
            }
            return _buildShimmerLoading();
          }
          if (notifications.isEmpty) {
            return Center(
              child: NoDataContainer(
                title: 'noNotificationsFound'.translate(context: context),
                subTitle: 'noNotificationsFoundSubTitle'.translate(
                  context: context,
                ),
              ),
            );
          }

          return CustomRefreshIndicator(
            onRefresh: () async => _fetchNotifications(),
            child: BlocProvider(
              create: (context) => DeleteNotificationCubit(),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount:
                    notifications.length + (state.isLoadingMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end
                  if (index >= notifications.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: CustomCircularProgressIndicator(
                          color: context.colorScheme.accentColor,
                        ),
                      ),
                    );
                  }

                  final notification = notifications[index];
                  final itemLocation = _getItemLocation(notifications, index);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show group header for first or only items
                      if (itemLocation == NotificationItemLocation.first ||
                          itemLocation == NotificationItemLocation.onlyOne) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 6),
                          child: CustomText(
                            _getGroupTitle(context, notification.dateSent),
                            color: context.colorScheme.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      _buildNotificationItem(
                        context: context,
                        notification: notification,
                        itemLocation: itemLocation,
                        notificationsList: notifications,
                        index: index,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }

        // Loading state
        return _buildShimmerLoading();
      },
    ),
  );

  Widget _buildNotificationItem({
    required BuildContext context,
    required NotificationDataModel notification,
    required NotificationItemLocation itemLocation,
    required List<NotificationDataModel> notificationsList,
    required int index,
  }) {
    // Only personal notifications can be deleted
    final bool canDelete = notification.type?.toLowerCase() == 'personal';

    final isProcessing = _processingNotificationId == notification.id;

    return NotificationItemContainer(
      location: itemLocation,
      notification: notification,
      showArrow: notification.isNavigable,
      isLoading: isProcessing,
      onTap: notification.isNavigable
          ? () {
              _onNotificationTap(notification);
            }
          : null,
      slidableChild: canDelete
          ? BlocConsumer<DeleteNotificationCubit, DeleteNotificationsState>(
              listener: (context, deleteState) {
                if (deleteState is DeleteNotificationSuccess) {
                  UiUtils.showMessage(
                    context,
                    'notificationDeletedSuccessfully'.translate(
                      context: context,
                    ),
                    ToastificationType.success,
                  );
                  context.read<NotificationsCubit>().removeNotificationFromList(
                    deleteState.notificationId,
                  );
                } else if (deleteState is DeleteNotificationFailure) {
                  UiUtils.showMessage(
                    context,
                    deleteState.errorMessage.translate(context: context),
                    ToastificationType.error,
                  );
                }
              },
              builder: (context, deleteState) {
                if (deleteState is DeleteNotificationInProgress &&
                    notification.id == deleteState.notificationId) {
                  return Center(
                    child: CustomContainer(
                      color: Colors.transparent,
                      height: 20,
                      width: 20,
                      child: CustomCircularProgressIndicator(
                        color: context.colorScheme.secondaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                return SlidableAction(
                  backgroundColor: Colors.transparent,
                  autoClose: false,
                  onPressed: (_) {
                    context.read<DeleteNotificationCubit>().deleteNotification(
                      notification.id ?? '',
                    );
                  },
                  icon: Icons.delete_outline,
                  foregroundColor: context.colorScheme.secondaryColor,
                  label: 'delete'.translate(context: context),
                  borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
                );
              },
            )
          : null,
    );
  }
}
