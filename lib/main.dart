import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:fixit_provider/debug_helper.dart';
import 'package:fixit_provider/providers/app_pages_provider/ads_detail_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/ads_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/app_details_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/boost_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/chat_with_staff_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/home_add_new_service_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/offer_chat_provider.dart';
import 'package:camera/camera.dart';
import 'package:fixit_provider/providers/app_pages_provider/job_request_providers/job_request_details_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/job_request_providers/job_request_list_provider.dart';
import 'package:fixit_provider/providers/app_pages_provider/service_add_ons_provider.dart';
import 'package:fixit_provider/providers/common_providers/notification_provider.dart';
import 'package:fixit_provider/services/environment.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:upgrader/upgrader.dart';

import 'common/languages/app_language.dart';
import 'common/theme/app_theme.dart';
import 'config.dart';

// ─── Global error log collected during startup ────────────────────────────────
// Every caught error is appended here. The app reads this list to show a
// non-fatal banner so the user can still use the app even when something fails.
final List<String> startupErrors = [];

void main() async {
  // Catch Flutter framework errors and surface them on-screen instead of
  // crashing silently.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    startupErrors.add('Flutter error: ${details.exceptionAsString()}');
    debugPrint('🔴 Flutter error: ${details.exceptionAsString()}');
  };

  // Catch all errors thrown outside the Flutter framework (async isolates etc.)
  // and keep the app alive.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ── Orientation ───────────────────────────────────────────────────────────
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      startupErrors.add('Orientation lock failed: $e');
      debugPrint('⚠️ Orientation lock failed: $e');
    }

    // ── App settings (custom initialiser) ─────────────────────────────────────
    try {
      await initializeAppSettings();
    } catch (e) {
      startupErrors.add('initializeAppSettings failed: $e');
      debugPrint('⚠️ initializeAppSettings failed: $e');
      // Non-fatal — continue booting.
    }

    // ── Firebase ──────────────────────────────────────────────────────────────
    bool firebaseInitialized = false;
    try {
      // Guard against hot-restart re-initialisation.
      final existingApp =
          Firebase.apps.where((a) => a.name == 'Khidma Provider').toList();

      if (existingApp.isEmpty) {
        if (Platform.isAndroid) {
          await Firebase.initializeApp(
            name: 'Khidma Provider',
            options: const FirebaseOptions(
              apiKey: 'AIzaSyDNbeNlSQb8NyHK-z-JlVQWicssGnzyJms',
              appId: '1:526848120057:android:e2b0eb76acb9bd701ebe28',
              messagingSenderId: '526848120057',
              projectId: 'khidma-plus-52001',
              databaseURL:
                  'https://khidma-plus-52001-default-rtdb.firebaseio.com',
              storageBucket: 'khidma-plus-52001.firebasestorage.app',
            ),
          );
        } else {
          await Firebase.initializeApp(
            name: 'Khidma Provider',
            options: const FirebaseOptions(
              apiKey: 'AIzaSyCYl_fGjuDX-rMHwNyncbTkUPyfyqq7htY',
              appId: '1:526848120057:ios:6283f602c1c024ac1ebe28',
              messagingSenderId: '526848120057',
              projectId: 'khidma-plus-52001',
              databaseURL:
                  'https://khidma-plus-52001-default-rtdb.firebaseio.com',
              storageBucket: 'khidma-plus-52001.firebasestorage.app',
              androidClientId:
                  '526848120057-9656bjp8n0k53ad8mtm6m3d89qr7u2ln.apps.googleusercontent.com',
              iosClientId:
                  '526848120057-4pcsheifnmgt6uhkjamsh74f89odlhac.apps.googleusercontent.com',
              iosBundleId: 'com.khidmaplus.provider',
            ),
          );
        }
      }

      firebaseInitialized = true;
      debugPrint('✅ Firebase initialized');
    } catch (e) {
      startupErrors.add('Firebase init failed: $e');
      debugPrint('🔴 Firebase init failed: $e');
      // App continues — push notifications simply won't work.
    }

    // ── FCM background handler & token (only when Firebase is up) ─────────────
    if (firebaseInitialized) {
      try {
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
      } catch (e) {
        startupErrors.add('FCM background handler registration failed: $e');
        debugPrint('⚠️ FCM background handler registration failed: $e');
      }

      try {
        await setupFCMToken();
      } catch (e) {
        startupErrors.add('FCM token setup failed: $e');
        debugPrint('⚠️ FCM token setup failed: $e');
      }
    }

    // ── Cameras ───────────────────────────────────────────────────────────────
    try {
      cameras = await availableCameras();
    } catch (e) {
      startupErrors.add('Camera init failed: $e');
      debugPrint('⚠️ Camera init failed: $e');
      cameras = []; // Fallback — app works without camera access.
    }

    runApp(const MyApp());
  }, (error, stack) {
    // Last-resort handler for unhandled async errors — app stays alive.
    startupErrors.add('Unhandled async error: $error');
    debugPrint('🔴 Unhandled async error: $error\n$stack');
  });
}

// ─── FCM token helper ─────────────────────────────────────────────────────────
Future<void> setupFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  debugPrint('✅ Initial FCM Token: $token');

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint('🔄 Token refreshed: $newToken');
  });
}

// ─── IAP constants ────────────────────────────────────────────────────────────
final bool _kAutoConsume = Platform.isIOS || true;
const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'subscription_silver';
const String _kGoldSubscriptionId = 'subscription_gold';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

// ─── Root widget ──────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
        // SharedPreferences itself failed — show a bare error screen.
        if (snapData.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _StartupErrorScreen(
              errors: ['SharedPreferences failed: ${snapData.error}'],
            ),
          );
        }

        if (snapData.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => ThemeService(snapData.data!, context)),
              ChangeNotifierProvider(create: (_) => SplashProvider()),
              ChangeNotifierProvider(
                  create: (_) => LanguageProvider(snapData.data!, context)),
              ChangeNotifierProvider(
                  create: (_) => CurrencyProvider(snapData.data!)),
              ChangeNotifierProvider(create: (_) => LoginAsProvider()),
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(
                  create: (_) => LoginAsServicemanProvider()),
              ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
              ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
              ChangeNotifierProvider(create: (_) => AdsProvider()),
              ChangeNotifierProvider(create: (_) => AdsDetailProvider()),
              ChangeNotifierProvider(create: (_) => ServiceAddOnsProvider()),
              ChangeNotifierProvider(create: (_) => BoostProvider()),
              ChangeNotifierProvider(create: (_) => AppDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
              ChangeNotifierProvider(create: (_) => IntroProvider()),
              ChangeNotifierProvider(create: (_) => SignUpCompanyProvider()),
              ChangeNotifierProvider(create: (_) => LocationProvider()),
              ChangeNotifierProvider(create: (_) => DashboardProvider()),
              ChangeNotifierProvider(create: (_) => HomeProvider()),
              ChangeNotifierProvider(create: (_) => EarningHistoryProvider()),
              ChangeNotifierProvider(create: (_) => NotificationProvider()),
              ChangeNotifierProvider(create: (_) => ServiceListProvider()),
              ChangeNotifierProvider(create: (_) => AddNewServiceProvider()),
              ChangeNotifierProvider(create: (_) => ServiceDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ServiceReviewProvider()),
              ChangeNotifierProvider(create: (_) => CategoriesListProvider()),
              ChangeNotifierProvider(create: (_) => ServicemanListProvider()),
              ChangeNotifierProvider(create: (_) => AddServicemenProvider()),
              ChangeNotifierProvider(
                  create: (_) => LatestBLogDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ProfileProvider()),
              ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
              ChangeNotifierProvider(create: (_) => CompanyDetailProvider()),
              ChangeNotifierProvider(
                  create: (_) => AppSettingProvider(snapData.data!)),
              ChangeNotifierProvider(create: (_) => ProfileDetailProvider()),
              ChangeNotifierProvider(create: (_) => BankDetailProvider()),
              ChangeNotifierProvider(create: (_) => TimeSlotProvider()),
              ChangeNotifierProvider(create: (_) => PackageListProvider()),
              ChangeNotifierProvider(create: (_) => ProviderDetailsProvider()),
              ChangeNotifierProvider(create: (_) => PackageDetailProvider()),
              ChangeNotifierProvider(create: (_) => AddPackageProvider()),
              ChangeNotifierProvider(create: (_) => SelectServiceProvider()),
              ChangeNotifierProvider(create: (_) => BookingDetailsProvider()),
              ChangeNotifierProvider(create: (_) => CommissionInfoProvider()),
              ChangeNotifierProvider(create: (_) => PlanDetailsProvider()),
              ChangeNotifierProvider(create: (_) => CheckoutWebViewProvider()),
              ChangeNotifierProvider(create: (_) => ReferralProvider()),
              ChangeNotifierProvider(
                  create: (_) => SubscriptionPlanProvider()),
              ChangeNotifierProvider(create: (_) => WalletProvider()),
              ChangeNotifierProvider(create: (_) => BookingProvider()),
              ChangeNotifierProvider(create: (_) => NoInternetProvider()),
              ChangeNotifierProvider(create: (_) => PendingBookingProvider()),
              ChangeNotifierProvider(create: (_) => AcceptedBookingProvider()),
              ChangeNotifierProvider(
                  create: (_) => BookingServicemenListProvider()),
              ChangeNotifierProvider(create: (_) => ChatProvider()),
              ChangeNotifierProvider(create: (_) => ChatWithStaffProvider()),
              ChangeNotifierProvider(create: (_) => AssignBookingProvider()),
              ChangeNotifierProvider(
                  create: (_) => PendingApprovalBookingProvider()),
              ChangeNotifierProvider(create: (_) => OngoingBookingProvider()),
              ChangeNotifierProvider(create: (_) => AddExtraChargesProvider()),
              ChangeNotifierProvider(create: (_) => HoldBookingProvider()),
              ChangeNotifierProvider(
                  create: (_) => CompletedBookingProvider()),
              ChangeNotifierProvider(create: (_) => AddServiceProofProvider()),
              ChangeNotifierProvider(
                  create: (_) => CancelledBookingProvider()),
              ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
              ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
              ChangeNotifierProvider(create: (_) => LocationListProvider()),
              ChangeNotifierProvider(
                  create: (_) => ServicemenDetailProvider()),
              ChangeNotifierProvider(create: (_) => NewLocationProvider()),
              ChangeNotifierProvider(create: (_) => IdVerificationProvider()),
              ChangeNotifierProvider(
                  create: (_) => CommissionHistoryProvider()),
              ChangeNotifierProvider(create: (_) => SearchProvider()),
              ChangeNotifierProvider(create: (_) => ViewLocationProvider()),
              ChangeNotifierProvider(create: (_) => CommonApiProvider()),
              ChangeNotifierProvider(create: (_) => UserDataApiProvider()),
              ChangeNotifierProvider(create: (_) => PaymentProvider()),
              // ChangeNotifierProvider(create: (_) => AudioCallProvider()),
              ChangeNotifierProvider(create: (_) => OfferChatProvider()),
              // ChangeNotifierProvider(create: (_) => VideoCallProvider()),
              ChangeNotifierProvider(
                  create: (_) => HomeAddNewServiceProvider()),
              ChangeNotifierProvider(
                  create: (_) => JobRequestDetailsProvider()),
              ChangeNotifierProvider(create: (_) => JobRequestListProvider()),
            ],
            child: const RouteToPage(),
          );
        }

        // Still loading SharedPreferences — show splash.
        return MaterialApp(
          theme: AppTheme.fromType(ThemeType.light).themeData,
          darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const SplashLayout(),
        );
      },
    );
  }
}

// ─── Main page shell ──────────────────────────────────────────────────────────
class RouteToPage extends StatefulWidget {
  const RouteToPage({super.key});

  @override
  State<RouteToPage> createState() => _RouteToPageState();
}

class _RouteToPageState extends State<RouteToPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  String _subscriptionStatus = 'Not Subscribed';

  static const Set<String> _subscriptionIds = {
    'one_month_sub',
    'one_year_sub',
  };

  @override
  void initState() {
    super.initState();
    _safeInitializeIAP();
    if (Platform.isAndroid) _safeCheckForUpdate();
    _safeInitNotifications();

    // TEMPORARY: Auto-open IAP Debug after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IAPDebugHelper()),
        );
      }
    });
  }

  // ── Safe wrappers — a failure in one section never crashes the widget ────────

  void _safeInitNotifications() {
    try {
      CustomNotificationController().initNotification(context);
    } catch (e) {
      startupErrors.add('Notification init failed: $e');
      debugPrint('⚠️ Notification init failed: $e');
    }
  }

  Future<void> _safeCheckForUpdate() async {
    try {
      await _checkForUpdate();
    } catch (e) {
      startupErrors.add('Update check failed: $e');
      debugPrint('⚠️ Update check failed: $e');
    }
  }

  Future<void> _safeInitializeIAP() async {
    try {
      await _initializeIAP();
    } catch (e) {
      startupErrors.add('IAP init failed: $e');
      debugPrint('⚠️ IAP init failed: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkForUpdate() async {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    }
  }

  Future<void> _initializeIAP() async {
    if (Platform.isIOS) {
      try {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      } catch (e) {
        startupErrors.add('StoreKit delegate setup failed: $e');
        debugPrint('⚠️ StoreKit delegate setup failed: $e');
      }
    }

    bool available = false;
    try {
      available = await _iap.isAvailable();
    } catch (e) {
      startupErrors.add('IAP availability check failed: $e');
      debugPrint('⚠️ IAP availability check failed: $e');
    }

    if (!mounted) return;
    setState(() => _isAvailable = available);

    if (!available) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint('❌ In-App Purchase not available on this device');
      return;
    }

    try {
      _subscription = _iap.purchaseStream.listen(
        _listenToPurchaseUpdated,
        onDone: () => _subscription.cancel(),
        onError: (error) => debugPrint('❌ Purchase stream error: $error'),
      );
    } catch (e) {
      startupErrors.add('Purchase stream subscription failed: $e');
      debugPrint('⚠️ Purchase stream subscription failed: $e');
    }

    await _loadProducts();
    await _restorePurchases();
  }

  Future<void> _loadProducts() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_subscriptionIds);

      if (response.error != null) {
        debugPrint('❌ Error loading products: ${response.error}');
      } else if (response.productDetails.isEmpty) {
        debugPrint('⚠️ No products found.');
      } else {
        debugPrint('✅ Loaded ${response.productDetails.length} products');
        for (var p in response.productDetails) {
          debugPrint('  - ${p.id}: ${p.title} - ${p.price}');
        }
      }

      if (!mounted) return;
      setState(() {
        _products = response.productDetails;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Exception loading products: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await _iap.restorePurchases();
      debugPrint('✅ Restore purchases initiated');
    } catch (e) {
      debugPrint('⚠️ Restore purchases failed: $e');
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      try {
        debugPrint(
            '📱 Purchase status: ${purchaseDetails.status} for ${purchaseDetails.productID}');

        switch (purchaseDetails.status) {
          case PurchaseStatus.pending:
            _showSnackBar('Purchase is pending...');
            break;
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            _handleSuccessfulPurchase(purchaseDetails);
            break;
          case PurchaseStatus.error:
            _showSnackBar(
                'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}');
            if (!purchaseDetails.pendingCompletePurchase) {
              _iap.completePurchase(purchaseDetails);
            }
            break;
          case PurchaseStatus.canceled:
            _showSnackBar('Purchase was canceled');
            break;
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      } catch (e) {
        debugPrint('⚠️ Error processing purchase update: $e');
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(
      PurchaseDetails purchaseDetails) async {
    try {
      if (!mounted) return;
      setState(
          () => _subscriptionStatus = 'Subscribed to ${purchaseDetails.productID}');
      _showSnackBar('Subscription successful! ✅');
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
      debugPrint('✅ Purchase completed: ${purchaseDetails.productID}');
    } catch (e) {
      debugPrint('❌ Error handling purchase: $e');
      _showSnackBar('Error processing purchase');
    }
  }

  Future<void> _buySubscription(ProductDetails product) async {
    if (!_isAvailable) {
      _showSnackBar('In-App Purchase is not available');
      return;
    }
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null,
      );
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      debugPrint('🛒 Purchase initiated for: ${product.id}');
    } catch (e) {
      debugPrint('❌ Error initiating purchase: $e');
      _showSnackBar('Failed to initiate purchase');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    try {
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _iap
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        iosPlatformAddition.setDelegate(null);
      }
    } catch (_) {}
    try {
      _subscription.cancel();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      upgrader: Upgrader(
        storeController: UpgraderStoreController(
          onAndroid: () => UpgraderPlayStore(),
        ),
      ),
      child: Consumer<ThemeService>(
        builder: (context, theme, child) {
          return Consumer<LanguageProvider>(
            builder: (context, lang, child) {
              final provider =
                  Provider.of<LanguageProvider>(context, listen: true);

              return MaterialApp(
                title: 'Khidma Provider',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                locale: provider.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  AppLocalizationDelagate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                themeMode: theme.theme,
                initialRoute: '/',
                routes: appRoute.route,
                builder: (context, child) {
                  // Overlay a collapsible error banner if any startup errors occurred.
                  // The user can still use the app normally — the banner just
                  // informs them (and you, during debugging) what went wrong.
                  Widget page = child!;

                  if (startupErrors.isNotEmpty) {
                    page = Stack(
                      children: [
                        page,
                        _StartupErrorBanner(errors: startupErrors),
                      ],
                    );
                  }

                  return Directionality(
                    textDirection: lang.locale?.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: page,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─── iOS StoreKit delegate ────────────────────────────────────────────────────
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) =>
      true;

  @override
  bool shouldShowPriceConsent() => false;
}

// ─── FCM background handler ───────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    final existingApp =
        Firebase.apps.where((a) => a.name == 'Khidma Provider').toList();

    if (existingApp.isEmpty) {
      if (Platform.isIOS) {
        await Firebase.initializeApp(
          name: 'Khidma Provider',
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCYl_fGjuDX-rMHwNyncbTkUPyfyqq7htY',
            appId: '1:526848120057:ios:6283f602c1c024ac1ebe28',
            messagingSenderId: '526848120057',
            projectId: 'khidma-plus-52001',
            databaseURL:
                'https://khidma-plus-52001-default-rtdb.firebaseio.com',
            storageBucket: 'khidma-plus-52001.firebasestorage.app',
            androidClientId:
                '526848120057-9656bjp8n0k53ad8mtm6m3d89qr7u2ln.apps.googleusercontent.com',
            iosClientId:
                '526848120057-4pcsheifnmgt6uhkjamsh74f89odlhac.apps.googleusercontent.com',
            iosBundleId: 'com.khidmaplus.provider',
          ),
        );
      } else {
        await Firebase.initializeApp(
          name: 'Khidma Provider',
          options: const FirebaseOptions(
            apiKey: 'AIzaSyDNbeNlSQb8NyHK-z-JlVQWicssGnzyJms',
            appId: '1:526848120057:android:e2b0eb76acb9bd701ebe28',
            messagingSenderId: '526848120057',
            projectId: 'khidma-plus-52001',
            databaseURL:
                'https://khidma-plus-52001-default-rtdb.firebaseio.com',
            storageBucket: 'khidma-plus-52001.firebasestorage.app',
          ),
        );
      }
    }
  } catch (e) {
    // Cannot show UI in a background isolate — log and return gracefully.
    debugPrint('🔴 Firebase init in background handler failed: $e');
    return;
  }

  try {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      playSound: true,
      importance: Importance.high,
      sound: (message.data['title'] != 'Incoming Audio Call...' ||
              message.data['title'] != 'Incoming Video Call...')
          ? null
          : const RawResourceAndroidNotificationSound('callsound'),
      showBadge: true,
    );
    log('background message received: $message');
    showNotification(message);
  } catch (e) {
    debugPrint('⚠️ showNotification in background handler failed: $e');
  }
}

// ─── Startup error UI helpers ─────────────────────────────────────────────────

/// Full-screen error page — used when SharedPreferences itself fails and the
/// normal app cannot be rendered at all.
class _StartupErrorScreen extends StatelessWidget {
  final List<String> errors;
  const _StartupErrorScreen({required this.errors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'App failed to start',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 8),
              const Text(
                'The following errors occurred. '
                'Please report them to support.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: errors.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) => Text(
                    '• ${errors[i]}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Collapsible banner overlaid on top of the normal app when non-fatal startup
/// errors occurred. Tap ▾ to expand the error list, ✕ to dismiss.
class _StartupErrorBanner extends StatefulWidget {
  final List<String> errors;
  const _StartupErrorBanner({required this.errors});

  @override
  State<_StartupErrorBanner> createState() => _StartupErrorBannerState();
}

class _StartupErrorBannerState extends State<_StartupErrorBanner> {
  bool _expanded = false;
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 12,
      right: 12,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFFFEEEE),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${widget.errors.length} startup warning'
                      '${widget.errors.length > 1 ? 's' : ''} '
                      '(app is still running)',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => setState(() => _dismissed = true),
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.black45),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 6),
                ...widget.errors.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $e',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black87)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}