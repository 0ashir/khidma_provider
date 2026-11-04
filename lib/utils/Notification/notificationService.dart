import 'dart:convert';

import 'package:edemand_partner/app/generalImports.dart';
import 'dart:developer' as developer;

@pragma('vm:entry-point')
Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await LocalAwesomeNotification.initializeChannels();
  if (message.data["type"] == "chat" || message.data['type'] == "new_message") {
    //background chat message storing
    final List<ChatNotificationData> oldList =
        await ChatNotificationsRepository().getBackgroundChatNotificationData();
    final messageChatData = ChatNotificationData.fromRemoteMessage(
      remoteMessage: message,
    );
    oldList.add(messageChatData);

    ChatNotificationsRepository().setBackgroundChatNotificationData(
      data: oldList,
    );
    if (Platform.isAndroid) {
      ChatNotificationsUtils.createChatNotification(
        chatData: messageChatData,
        message: message,
      );
    }
  } else {
    if ((message.data['type'] == "order" ||
            message.data['type'] == "booking_status" ||
            message.data['type'] == 'new_booking_received_for_provider') &&
        Platform.isAndroid) {
      localNotification.createSoundNotification(notificationData: message);
    } else {
      if (message.data["image"] == null && Platform.isAndroid) {
        localNotification.createNotification(
          isLocked: false,
          notificationData: message,
          playCustomSound: false,
        );
      } else if (Platform.isAndroid) {
        localNotification.createImageNotification(
          isLocked: false,
          notificationData: message,
          playCustomSound: false,
        );
      }
    }
  }
}

LocalAwesomeNotification localNotification = LocalAwesomeNotification();

class NotificationService {
  static FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

  static StreamSubscription<RemoteMessage>? foregroundStream;
  static StreamSubscription<RemoteMessage>? onMessageOpen;

  static Future<void> requestPermission() async {
    try {
      final NotificationSettings settings = await messagingInstance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      developer.log(
        'Notification permission status: ${settings.authorizationStatus}',
      );
    } catch (e) {
      developer.log('Error requesting notification permission: $e', error: e);
      rethrow;
    }
  }

  static Future<void> init(context) async {
    try {
      developer.log('Initializing notification service...');

      await ChatNotificationsUtils.initialize();
      await requestPermission();
      await registerListeners(context);

      developer.log('Notification service initialized successfully');
    } catch (e) {
      developer.log('Failed to initialize notification service: $e', error: e);
      rethrow;
    }
  }

  static Future<void> foregroundNotificationHandler() async {
    try {
      foregroundStream = FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          if (NotificationDataModel.isSubscriptionType(
                message.data['type']?.toString(),
              ) &&
              !(UiUtils.rootNavigatorKey.currentContext
                      ?.read<FetchSystemSettingsCubit>()
                      .subscriptionsEnabled ??
                  false)) {
            return;
          }
          debugPrint('Received foreground message: ${message.data}');

          if (message.data["type"] == "chat" ||
              message.data["type"] == "new_message") {
            ChatNotificationsUtils.addChatStreamAndShowNotification(
              message: message,
            );
          } else if ((message.data['type'] == "order" ||
                  message.data['type'] == "booking_status" ||
                  message.data['type'] ==
                      'new_booking_received_for_provider') &&
              Platform.isAndroid) {
            localNotification.createSoundNotification(
              notificationData: message,
            );
          } else {
            if (message.data["image"] == null && Platform.isAndroid) {
              localNotification.createNotification(
                isLocked: false,
                notificationData: message,
                playCustomSound: false,
              );
            } else if (Platform.isAndroid) {
              localNotification.createImageNotification(
                isLocked: false,
                notificationData: message,
                playCustomSound: false,
              );
            }
          }
        },
        onError: (error) {
          developer.log(
            'Error in foreground notification stream: $error',
            error: error,
          );
        },
      );

      developer.log('Foreground notification handler setup complete');
    } catch (e) {
      developer.log(
        'Failed to setup foreground notification handler: $e',
        error: e,
      );
      rethrow;
    }
  }

  static Future<void> terminatedStateNotificationHandler() async {
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) async {
      if (message == null) {
        return;
      }

      // Don't show notification, just handle redirection
      await handleNotificationRedirection(message.data);
    });
  }

  static Future<void> onTapNotificationHandler(BuildContext context) async {
    onMessageOpen = FirebaseMessaging.onMessageOpenedApp.listen((
      final message,
    ) async {
      await handleNotificationRedirection(message.data);
    });
  }

  /// Handle maintenance mode notification
  static Future<void> _handleMaintenanceModeNotification(
    Map<String, dynamic> data,
  ) async {
    // Step 1: Get message from notification data or use empty string
    final String message = data['message']?.toString() ?? '';

    // Step 2: Create instance for this notification
    final FetchSystemSettingsCubit fetchSystemSettingsCubit =
        FetchSystemSettingsCubit();

    StreamSubscription? subscription;

    try {
      // Step 3: Set up stream listener to wait for state completion
      final completer = Completer<void>();

      bool isCompleted = false;

      subscription = fetchSystemSettingsCubit.stream.listen((state) {
        if (!isCompleted) {
          if (state is FetchSystemSettingsSuccess) {
            isCompleted = true;
            if (!completer.isCompleted) {
              completer.complete();
            }
          } else if (state is FetchSystemSettingsFailure) {
            isCompleted = true;
            if (!completer.isCompleted) {
              completer.complete();
            }
          }
        }
      });

      // Step 4: Call settings API first
      await fetchSystemSettingsCubit.getSettings(
        isAnonymous: !HiveRepository.isUserLoggedIn,
      );

      // Step 5: Wait for state to complete (success or failure)
      await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          isCompleted = true;
          developer.log('Timeout waiting for system settings');
        },
      );

      // Step 6: Check if settings API call was successful
      final state = fetchSystemSettingsCubit.state;
      if (state is FetchSystemSettingsSuccess) {
        // Step 7: Check if maintenance mode is enabled in settings
        if (fetchSystemSettingsCubit.appSetting.providerAppMaintenanceMode ==
            "1") {
          // Step 8: Navigate to maintenance mode screen only if maintenance mode is enabled
          await UiUtils.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.maintenanceModeScreen,
            (route) => false,
            arguments: message,
          );
        }
      }
    } catch (e) {
      developer.log('Error handling maintenance_mode notification: $e');
    } finally {
      // Cancel subscription and dispose the cubit instance
      await subscription?.cancel();
      fetchSystemSettingsCubit.close();
    }
  }

  /// Common helper function to navigate to booking details page
  /// Now passes only bookingId to let the BookingDetails screen handle loading
  static Future<void> _navigateToBookingDetails(
    Map<String, dynamic> data,
  ) async {
    try {
      // Extract booking ID from either booking_id or order_id
      final String bookingId =
          data['booking_id']?.toString() ?? data['order_id']?.toString() ?? '';

      if (bookingId.isEmpty) {
        return;
      }

      // Navigate directly with just the bookingId
      // The BookingDetails screen will handle fetching and show a shimmer loader
      await UiUtils.rootNavigatorKey.currentState?.pushNamed(
        Routes.bookingDetails,
        arguments: {'bookingId': bookingId},
      );
    } catch (_) {}
  }

  static Future<void> handleNotificationRedirection(
    Map<String, dynamic> data,
  ) async {
    if (data["type"] == "chat" ||
        data["type"] == "user_reported" ||
        data["type"] == "user_blocked" ||
        data["type"] == "new_message") {
      try {
        if (Routes.currentRoute == Routes.chatMessages) {
          UiUtils.rootNavigatorKey.currentState?.pop();
        }

        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.chatMessages,
          arguments: {
            "chatUser": data['chat_user']?.isEmpty ?? true
                ? ChatUser(
                    customerId: '0',
                    customerName: "customerSupport",
                    unReadChats: 0,
                    bookingId: null,
                    chatUserType: ChatUserType.adminSupport,
                    image: '',
                  )
                : ChatUser.fromJson(
                    jsonDecode(data['chat_user'].toString()) ?? {},
                  ),
          },
        );
      } catch (_) {}
    } else if (data["type"] == "order" ||
        data["type"] == "booking_status" ||
        data["type"] == "new_booking_received_for_provider") {
      await _navigateToBookingDetails(data);
    } else if (data["type"] == "job_notification") {
      //navigate to booking tab
      UiUtils
              .mainActivityNavigationBarGlobalKey
              .currentState
              ?.selectedIndexOfBottomNavigationBar
              .value =
          2;
      await UiUtils.rootNavigatorKey.currentState?.pushNamed(
        Routes.jobRequestScreen,
      );
    } else if (data["type"] == "withdraw_request" ||
        data["type"] == "withdraw_request_approved" ||
        data["type"] == "withdraw_request_disapproved") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.withdrawalRequests,
        );
      } catch (_) {}
    } else if (data["type"] == "settlement") {
    } else if (data["type"] == "payment_settlement") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.settlementHistoryScreen,
        );
      } catch (_) {}
    } else if (data["type"] == "provider_request_status") {
      try {
        final String status = data['status']?.toString().toLowerCase() ?? '';

        if (status == "approve" || status == "approved") {
          // Handle approved status - navigate to login screen
          await UiUtils.rootNavigatorKey.currentState?.pushReplacementNamed(
            Routes.loginScreenRoute,
          );
        } else if (status == "reject" ||
            status == "rejected" ||
            status == "disapprove" ||
            status == "disapproved") {
          // Handle disapproved/rejected status - logout and navigate to login
          if (HiveRepository.isUserLoggedIn) {
            // Perform logout operations
            HiveRepository.setUserLoggedIn = false;
            HiveRepository.clearBoxValues(
              boxName: HiveRepository.userDetailBoxKey,
            );

            // Access AuthenticationCubit via root navigator context
            final context = UiUtils.rootNavigatorKey.currentContext;
            if (context != null) {
              context.read<AuthenticationCubit>().setUnAuthenticated();
            }

            // Dispose notification listeners
            disposeListeners();

            // Clear quick actions
            AppQuickActions.clearShortcutItems();

            // Navigate to login screen
            UiUtils.rootNavigatorKey.currentState?.popUntil(
              (Route route) => route.isFirst,
            );
            await UiUtils.rootNavigatorKey.currentState?.pushReplacementNamed(
              Routes.loginScreenRoute,
            );
          } else {
            // If not logged in, just navigate to login
            await UiUtils.rootNavigatorKey.currentState?.pushReplacementNamed(
              Routes.loginScreenRoute,
            );
          }
        }
      } catch (_) {}
    } else if (data["type"] == "url") {
      final String url = data["url"].toString();
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        throw 'somethingWentWrongTitle';
      }
    } else if (data["type"] == "provider_approved") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushReplacementNamed(
          Routes.loginScreenRoute,
        );
      } catch (_) {}
    } else if (data["type"] == "provider_disapproved") {
      try {
        // Check if user is logged in
        if (HiveRepository.isUserLoggedIn) {
          // Perform logout operations
          HiveRepository.setUserLoggedIn = false;
          HiveRepository.clearBoxValues(
            boxName: HiveRepository.userDetailBoxKey,
          );

          // Access AuthenticationCubit via root navigator context
          final context = UiUtils.rootNavigatorKey.currentContext;
          if (context != null) {
            context.read<AuthenticationCubit>().setUnAuthenticated();
          }

          // Dispose notification listeners
          disposeListeners();

          // Clear quick actions
          AppQuickActions.clearShortcutItems();

          // Navigate to login screen
          UiUtils.rootNavigatorKey.currentState?.popUntil(
            (Route route) => route.isFirst,
          );
          await UiUtils.rootNavigatorKey.currentState?.pushReplacementNamed(
            Routes.loginScreenRoute,
          );
        } else {
          // If not logged in, just navigate to login
          await UiUtils.rootNavigatorKey.currentState?.pushReplacementNamed(
            Routes.loginScreenRoute,
          );
        }
      } catch (_) {}
    } else if (data["type"] == "service_approved" ||
        data["type"] == "service_disapproved") {
      try {
        final String serviceIdStr = data['service_id']?.toString() ?? '';

        if (serviceIdStr.isEmpty) {
          return;
        }

        final int? serviceId = int.tryParse(serviceIdStr);
        if (serviceId == null) {
          return;
        }

        // Create instance for this notification
        final FetchServicesCubit fetchServicesCubit = FetchServicesCubit();

        // Fetch service by service_id
        await fetchServicesCubit.fetchServices(serviceId: serviceId);

        final state = fetchServicesCubit.state;
        if (state is FetchServicesSuccess && state.services.isNotEmpty) {
          await UiUtils.rootNavigatorKey.currentState?.pushNamed(
            Routes.serviceDetails,
            arguments: {'serviceModel': state.services.first},
          );
        }
      } catch (_) {}
    } else if (data["type"] == "new_rating_given_by_customer") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.reviewsScreen,
        );
      } catch (_) {}
    } else if (data["type"] == "cash_collection_by_provider") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.cashCollection,
        );
      } catch (_) {}
    } else if (data["type"] == "new_custom_job_request") {
      try {
        final String jobRequestIdStr =
            data['custom_job_request_id']?.toString() ?? '';

        if (jobRequestIdStr.isEmpty) {
          return;
        }

        // Create instance for this notification
        final FetchJobRequestCubit fetchJobRequestCubit =
            FetchJobRequestCubit();

        // Fetch open job requests
        await fetchJobRequestCubit.FetchJobRequest(
          id: jobRequestIdStr,
          jobType: null,
        );

        final state = fetchJobRequestCubit.state;
        if (state is FetchJobRequestSuccess) {
          await UiUtils.rootNavigatorKey.currentState?.pushNamed(
            state.jobRequest.first.bidApplied == true
                ? Routes.appliedJobrequestDetails
                : Routes.openJobRequestDetails,
            arguments: {'jobRequestModel': state.jobRequest.first},
          );
        } else {
          throw NotificationTapError('jobRequestNotFound');
        }
      } catch (_) {
        throw NotificationTapError('jobRequestNotFound');
      }
    } else if (data["type"] == "new_category_available" ||
        data["type"] == "category_removed") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.jobRequestScreen,
        );
      } catch (_) {}
    } else if (data["type"] == "promo_code_added") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.promoCode,
        );
      } catch (_) {}
    } else if (data["type"] == "subscription_expired" ||
        data["type"] == "subscription_payment_successful" ||
        data["type"] == "subscription_payment_failed" ||
        data["type"] == "subscription_payment_pending" ||
        data["type"] == "subscription_changed" ||
        data["type"] == "subscription_removed") {
      try {
        final subscriptionsEnabled =
            UiUtils.rootNavigatorKey.currentContext
                ?.read<FetchSystemSettingsCubit>()
                .subscriptionsEnabled ??
            false;
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          subscriptionsEnabled ? Routes.subscriptionScreen : Routes.main,
          arguments: {"from": "drawer"},
        );
      } catch (_) {}
    } else if (data["type"] == "privacy_policy_changed") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.customPageDetailsRoute,
          arguments: {'title': 'privacyPolicyLbl', 'pageKey': 'privacy_policy'},
        );
      } catch (_) {}
    } else if (data["type"] == "terms_and_conditions_changed") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.customPageDetailsRoute,
          arguments: {
            'title': 'termsConditionLbl',
            'pageKey': 'terms_conditions',
          },
        );
      } catch (_) {}
    } else if (data["type"] == "maintenance_mode") {
      await _handleMaintenanceModeNotification(data);
    } else if (data["type"] == "general" || data["type"] == "personal") {
      try {
        await UiUtils.rootNavigatorKey.currentState?.pushNamed(
          Routes.notificationsScreen,
        );
      } catch (_) {}
    }
  }

  static Future<void> registerListeners(context) async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);

    await foregroundNotificationHandler();
    await terminatedStateNotificationHandler();
    await onTapNotificationHandler(context);
  }

  static void disposeListeners() {
    ChatNotificationsUtils.dispose();

    onMessageOpen?.cancel();
    onMessageOpen = null;
    foregroundStream?.cancel();
    foregroundStream = null;
  }
}

class NotificationTapError implements Exception {
  final String errorMessageKey;

  NotificationTapError(this.errorMessageKey);
}
