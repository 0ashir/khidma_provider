import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edemand_partner/ui/widgets/subscriptionAccessGuard.dart';
import 'package:edemand_partner/ui/screens/home/widgets/subscriptionCardWidget.dart';

FetchSystemSettingsSuccess settingsFor(bool enabled) =>
    FetchSystemSettingsSuccess(
      availableAmount: '',
      payableCommission: '',
      isDemoModeEnable: '0',
      isAcceptingCustomJob: '0',
      generalSettings: GeneralSettings.fromJson({
        'subscriptions_enabled': enabled ? '1' : '0',
      }),
      paymentGatewaysSettings: PaymentGatewaysSettings(),
      subscriptionInformation: SubscriptionInformation(),
      socialMediaURLs: [],
      appSetting: AppSetting(),
      loginSettings: LoginSettings.fromJson({}),
      chatSettings: ChatSettings.fromJson({}),
    );

void main() {
  test(
    'subscription notices are identified without hiding booking notices',
    () {
      for (final type in [
        'subscription_expired',
        'subscription_payment_successful',
        'subscription_payment_failed',
        'subscription_payment_pending',
        'subscription_changed',
        'subscription_removed',
      ]) {
        expect(NotificationDataModel.isSubscriptionType(type), isTrue);
      }
      expect(NotificationDataModel.isSubscriptionType('order'), isFalse);
      expect(NotificationDataModel.isSubscriptionType(null), isFalse);
    },
  );

  testWidgets('disabled plans hide cards, details, history and confirmation', (
    tester,
  ) async {
    final settings = FetchSystemSettingsCubit()..emit(settingsFor(false));
    addTearDown(settings.close);
    await tester.pumpWidget(
      BlocProvider.value(
        value: settings,
        child: MaterialApp(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Home')),
          ),
          home: Column(
            children: [
              const SubscriptionCardWidget(),
              SubscriptionDetailsContainer(
                subscriptionDetails: SubscriptionInformation(),
                onBuyButtonPressed: () {},
                isActiveSubscription: true,
                isAvailableForPurchase: true,
                isPreviousSubscription: false,
                needToShowPaymentStatus: true,
              ),
              const SubscriptionHistoryScreen(),
              const SubscriptionPaymentConfirmationScreen(
                isSuccess: true,
                subscriptionId: 'plan',
                paymentMethod: 'test',
                transactionId: 'transaction',
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(CustomText), findsNothing);
    expect(find.byType(CustomContainer), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('open subscription page exits only after confirmed disable', (
    tester,
  ) async {
    final settings = FetchSystemSettingsCubit()..emit(settingsFor(true));
    addTearDown(settings.close);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      BlocProvider.value(
        value: settings,
        child: MaterialApp(
          navigatorKey: navigator,
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Home')),
          ),
          home: const Scaffold(),
        ),
      ),
    );
    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (context) {
          return context.watch<FetchSystemSettingsCubit>().subscriptionsEnabled
              ? const Text('Plan details')
              : const SubscriptionAccessGuard();
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Plan details'), findsOneWidget);
    settings.emit(FetchSystemSettingsInProgress());
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsNothing);
    settings.emit(settingsFor(false));
    await tester.pumpAndSettle();
    expect(find.text('Plan details'), findsNothing);
    expect(find.text('Home'), findsOneWidget);
    expect(navigator.currentState!.canPop(), isFalse);
  });
  test(
    'subscription setting reads all API formats and preserves older servers',
    () {
      for (final value in [false, 0, '0', 'false']) {
        expect(
          GeneralSettings.fromJson({
            'subscriptions_enabled': value,
          }).subscriptionsEnabled,
          isFalse,
        );
      }
      for (final value in [true, 1, '1', 'true']) {
        expect(
          GeneralSettings.fromJson({
            'subscriptions_enabled': value,
          }).subscriptionsEnabled,
          isTrue,
        );
      }
      expect(GeneralSettings.fromJson({}).subscriptionsEnabled, isTrue);
      expect(GeneralSettings().subscriptionsEnabled, isFalse);
    },
  );

  testWidgets(
    'subscription routes follow disabled, enabled and disabled again',
    (tester) async {
      final settings = FetchSystemSettingsCubit();
      addTearDown(settings.close);
      await tester.pumpWidget(
        BlocProvider.value(
          value: settings,
          child: MaterialApp(
            navigatorKey: UiUtils.rootNavigatorKey,
            home: const Scaffold(),
          ),
        ),
      );

      for (final enabled in [false, true, false]) {
        settings.emit(settingsFor(enabled));
        await tester.pump();
        expect(settings.subscriptionsEnabled, enabled);
        for (final name in [
          Routes.subscriptionScreen,
          Routes.subscriptionPaymentConfirmationScreen,
          Routes.previousSubscriptions,
        ]) {
          final route =
              Routes.onGenerateRouted(
                    RouteSettings(
                      name: name,
                      arguments: const {
                        'from': 'drawer',
                        'isSuccess': true,
                        'transactionId': 'test-transaction',
                        'paymentMethod': 'test-payment',
                        'subscriptionId': 'test-plan',
                      },
                    ),
                  )
                  as CupertinoPageRoute<dynamic>;
          final screen = route.builder(
            UiUtils.rootNavigatorKey.currentContext!,
          );
          expect(screen is MainActivity, !enabled);
          route.dispose();
        }
      }
    },
  );
}
