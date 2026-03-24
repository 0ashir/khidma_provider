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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initializeAppSettings();
  // await _configureSDK();
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        name: 'Fixit',
        options: const FirebaseOptions(
           apiKey: 'AIzaSyDNbeNlSQb8NyHK-z-JlVQWicssGnzyJms',
    appId: '1:526848120057:android:e2b0eb76acb9bd701ebe28',
    messagingSenderId: '526848120057',
    projectId: 'khidma-plus-52001',
    databaseURL: 'https://khidma-plus-52001-default-rtdb.firebaseio.com',
    storageBucket: 'khidma-plus-52001.firebasestorage.app',
        ),
      );
    } else {
      await Firebase.initializeApp(
        name: 'Fixit',
        options: const FirebaseOptions(
          apiKey: "Enter your iOS API key here",
          projectId: "Enter your Firebase project ID here",
          messagingSenderId: "Enter your messaging sender ID here",
          appId: "Enter your iOS app ID here",
          storageBucket:
              "Enter your storage bucket here (example: your-project-id.appspot.com)",
        ),
      );
    }
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  cameras = await availableCameras();

  setupFCMToken();
  runApp(const MyApp());
}

void setupFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Get the current token
  String? token = await messaging.getToken();
  debugPrint("✅ Initial FCM Token: $token");

  // Handle token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint("🔄 Token refreshed: $newToken");
    // Save this token locally if needed
  });
}

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
        if (snapData.hasData) {
          // snapData.data!.remove("selectedLocale");
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ThemeService(snapData.data!, context),
              ),
              ChangeNotifierProvider(create: (_) => SplashProvider()),
              ChangeNotifierProvider(
                create: (_) => LanguageProvider(snapData.data!, context),
              ),
              ChangeNotifierProvider(
                create: (_) => CurrencyProvider(snapData.data!),
              ),
              ChangeNotifierProvider(create: (_) => LoginAsProvider()),
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(
                create: (_) => LoginAsServicemanProvider(),
              ),
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
                create: (_) => LatestBLogDetailsProvider(),
              ),
              ChangeNotifierProvider(create: (_) => ProfileProvider()),
              ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
              ChangeNotifierProvider(create: (_) => CompanyDetailProvider()),
              ChangeNotifierProvider(
                create: (_) => AppSettingProvider(snapData.data!),
              ),
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
              ChangeNotifierProvider(create: (_) => SubscriptionPlanProvider()),
              ChangeNotifierProvider(create: (_) => WalletProvider()),
              ChangeNotifierProvider(create: (_) => BookingProvider()),
              ChangeNotifierProvider(create: (_) => NoInternetProvider()),
              ChangeNotifierProvider(create: (_) => PendingBookingProvider()),
              ChangeNotifierProvider(create: (_) => AcceptedBookingProvider()),
              ChangeNotifierProvider(
                create: (_) => BookingServicemenListProvider(),
              ),
              ChangeNotifierProvider(create: (_) => ChatProvider()),
              ChangeNotifierProvider(create: (_) => ChatWithStaffProvider()),
              ChangeNotifierProvider(create: (_) => AssignBookingProvider()),
              ChangeNotifierProvider(
                create: (_) => PendingApprovalBookingProvider(),
              ),
              ChangeNotifierProvider(create: (_) => OngoingBookingProvider()),
              ChangeNotifierProvider(create: (_) => AddExtraChargesProvider()),
              ChangeNotifierProvider(create: (_) => HoldBookingProvider()),
              ChangeNotifierProvider(create: (_) => CompletedBookingProvider()),
              ChangeNotifierProvider(create: (_) => AddServiceProofProvider()),
              ChangeNotifierProvider(create: (_) => CancelledBookingProvider()),
              ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
              ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
              ChangeNotifierProvider(create: (_) => LocationListProvider()),
              ChangeNotifierProvider(create: (_) => ServicemenDetailProvider()),
              ChangeNotifierProvider(create: (_) => NewLocationProvider()),
              ChangeNotifierProvider(create: (_) => IdVerificationProvider()),
              ChangeNotifierProvider(
                create: (_) => CommissionHistoryProvider(),
              ),
              ChangeNotifierProvider(create: (_) => SearchProvider()),
              ChangeNotifierProvider(create: (_) => ViewLocationProvider()),
              ChangeNotifierProvider(create: (_) => CommonApiProvider()),
              ChangeNotifierProvider(create: (_) => UserDataApiProvider()),
              ChangeNotifierProvider(create: (_) => PaymentProvider()),
              // ChangeNotifierProvider(create: (_) => AudioCallProvider()),
              ChangeNotifierProvider(create: (_) => OfferChatProvider()),
              // ChangeNotifierProvider(create: (_) => VideoCallProvider()),
              ChangeNotifierProvider(
                create: (_) => HomeAddNewServiceProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => JobRequestDetailsProvider(),
              ),
              ChangeNotifierProvider(create: (_) => JobRequestListProvider()),
            ],
            child: const RouteToPage(),
          );
        } else {
          return MaterialApp(
            theme: AppTheme.fromType(ThemeType.light).themeData,
            darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const SplashLayout(),
          );
        }
      },
    );
  }
}

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

  // Match these with your App Store Connect product IDs
  static const Set<String> _subscriptionIds = {'one_month_sub', 'one_year_sub'};

  @override
  void initState() {
    super.initState();

    // Initialize IAP first
    _initializeIAP();

    // Other initializations
    if (Platform.isAndroid) {
      checkForUpdate(context);
    }
    CustomNotificationController().initNotification(context);
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

  Future<void> checkForUpdate(context) async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform an immediate update (forced update)
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Perform a flexible update (allows user to continue using the app)
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      print("Error checking for update: $e");
    }
  }

  Future<void> _initializeIAP() async {
    // For iOS: Enable pending purchase handling
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // Check if IAP is available
    final bool available = await _iap.isAvailable();

    if (!mounted) return;

    setState(() {
      _isAvailable = available;
    });

    if (!available) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('❌ In-App Purchase is not available on this device');
      return;
    }

    // Set up purchase stream listener
    _subscription = _iap.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        debugPrint('❌ Purchase stream error: $error');
      },
    );

    // Fetch product details
    await _loadProducts();

    // Restore previous purchases (important for iOS subscriptions)
    await _restorePurchases();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        _subscriptionIds,
      );

      if (response.error != null) {
        debugPrint('❌ Error loading products: ${response.error}');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (response.productDetails.isEmpty) {
        debugPrint(
          '⚠️ No products found. Check your product IDs and App Store Connect setup',
        );
      } else {
        debugPrint('✅ Loaded ${response.productDetails.length} products');
        for (var product in response.productDetails) {
          debugPrint('  - ${product.id}: ${product.title} - ${product.price}');
        }
      }

      if (!mounted) return;

      setState(() {
        _products = response.productDetails;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Exception loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await _iap.restorePurchases();
      debugPrint('✅ Restore purchases initiated');
    } catch (e) {
      debugPrint('❌ Error restoring purchases: $e');
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      debugPrint(
        '📱 Purchase status: ${purchaseDetails.status} for ${purchaseDetails.productID}',
      );

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _showSnackBar('Purchase is pending...');
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Verify the purchase with your backend here
          _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.error:
          _showSnackBar(
            'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}',
          );
          if (!purchaseDetails.pendingCompletePurchase) {
            _iap.completePurchase(purchaseDetails);
          }
          break;

        case PurchaseStatus.canceled:
          _showSnackBar('Purchase was canceled');
          break;
      }

      // Always complete purchase for non-consumables
      if (purchaseDetails.pendingCompletePurchase) {
        _iap.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    // TODO: Verify purchase with your backend server
    // Send purchaseDetails.verificationData.serverVerificationData to your server
    // and purchaseDetails.verificationData.localVerificationData for iOS receipt

    try {
      // Example: Send to your backend
      // await yourApiService.verifyPurchase(
      //   productId: purchaseDetails.productID,
      //   purchaseToken: purchaseDetails.verificationData.serverVerificationData,
      //   platform: Platform.isIOS ? 'ios' : 'android',
      // );

      if (!mounted) return;

      setState(() {
        _subscriptionStatus = 'Subscribed to ${purchaseDetails.productID}';
      });

      _showSnackBar('Subscription successful! ✅');

      // Complete the purchase
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

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
      applicationUserName: null, // Optional: your user ID for tracking
    );

    try {
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
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  // Rest of your build method...
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
              final provider = Provider.of<LanguageProvider>(
                context,
                listen: true,
              );

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
                initialRoute: "/",
                routes: appRoute.route,
                builder: (context, child) {
                  return Directionality(
                    textDirection: lang.locale?.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: child!,
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

// iOS Payment Queue Delegate for handling transactions
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDNbeNlSQb8NyHK-z-JlVQWicssGnzyJms',
    appId: '1:526848120057:android:e2b0eb76acb9bd701ebe28',
    messagingSenderId: '526848120057',
    projectId: 'khidma-plus-52001',
    databaseURL: 'https://khidma-plus-52001-default-rtdb.firebaseio.com',
    storageBucket: 'khidma-plus-52001.firebasestorage.app',
     
    ),
  );
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    playSound: true,
    importance: Importance.high,
    sound:
        (message.data['title'] != 'Incoming Audio Call...' ||
            message.data['title'] != 'Incoming Video Call...')
        ? null
        : const RawResourceAndroidNotificationSound('callsound'),
    showBadge: true,
  );
  log("jahsdjkashdajksdfna ${message}");
  showNotification(message);
}
