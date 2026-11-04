import '../../app/generalImports.dart';

abstract class FetchSystemSettingsState {}

class FetchSystemSettingsInitial extends FetchSystemSettingsState {}

class FetchSystemSettingsInProgress extends FetchSystemSettingsState {}

class FetchSystemSettingsSuccess extends FetchSystemSettingsState {
  final String availableAmount;
  final String payableCommission;
  final String isDemoModeEnable;
  final String isAcceptingCustomJob;
  final GeneralSettings generalSettings;
  final PaymentGatewaysSettings paymentGatewaysSettings;
  final SubscriptionInformation subscriptionInformation;
  final LoginSettings loginSettings;
  final AppSetting appSetting;
  final ChatSettings chatSettings;
  final List<SocialMediaURL> socialMediaURLs;
  final String? mapProvider;

  FetchSystemSettingsSuccess({
    required this.availableAmount,
    required this.payableCommission,
    required this.isDemoModeEnable,
    required this.isAcceptingCustomJob,
    required this.paymentGatewaysSettings,
    required this.generalSettings,
    required this.subscriptionInformation,
    required this.socialMediaURLs,
    required this.appSetting,
    required this.loginSettings,
    required this.chatSettings,
    this.mapProvider,
  });

  FetchSystemSettingsSuccess copyWith({
    String? availableAmount,
    String? payableCommission,
    String? isAcceptingCustomJob,
    GeneralSettings? generalSettings,
    AppSetting? appSetting,
    PaymentGatewaysSettings? paymentGatewaysSettings,
    SubscriptionInformation? subscriptionInformation,
    LoginSettings? loginSettings,
    ChatSettings? chatSettings,
    List<SocialMediaURL>? socialMediaURLs,
    String? mapProvider,
  }) {
    return FetchSystemSettingsSuccess(
      generalSettings: generalSettings ?? this.generalSettings,

      isDemoModeEnable: isDemoModeEnable,
      availableAmount: availableAmount ?? this.availableAmount,
      payableCommission: payableCommission ?? this.payableCommission,
      isAcceptingCustomJob: isAcceptingCustomJob ?? this.isAcceptingCustomJob,
      paymentGatewaysSettings:
          paymentGatewaysSettings ?? this.paymentGatewaysSettings,
      subscriptionInformation:
          subscriptionInformation ?? this.subscriptionInformation,
      socialMediaURLs: socialMediaURLs ?? this.socialMediaURLs,
      appSetting: appSetting ?? this.appSetting,
      loginSettings: loginSettings ?? this.loginSettings,
      chatSettings: chatSettings ?? this.chatSettings,
      mapProvider: mapProvider ?? this.mapProvider,
    );
  }
}

class FetchSystemSettingsFailure extends FetchSystemSettingsState {
  final String errorMessage;

  FetchSystemSettingsFailure(this.errorMessage);
}

class FetchSystemSettingsCubit extends Cubit<FetchSystemSettingsState> {
  FetchSystemSettingsCubit() : super(FetchSystemSettingsInitial());
  final SettingsRepository _settingsRepository = SettingsRepository();

  void updateAcceptingCustomJobs(String value) {
    if (state is FetchSystemSettingsSuccess) {
      emit(
        (state as FetchSystemSettingsSuccess).copyWith(
          isAcceptingCustomJob: value,
        ),
      );
    }
  }

  Future<void> getSettings({required bool isAnonymous}) async {
    try {
      emit(FetchSystemSettingsInProgress());
      final result = await _settingsRepository.getSystemSettings(
        isAnonymous: isAnonymous,
      );

      emit(
        FetchSystemSettingsSuccess(
          socialMediaURLs: ((result["social_media"] ?? []) as List).isNotEmpty
              ? (result["social_media"] as List)
                    .map((e) => SocialMediaURL.fromJson(Map.from(e)))
                    .toList()
              : [],
          generalSettings: GeneralSettings.fromJson(
            result['general_settings'] ?? {},
          ),
          availableAmount: result['balance'] ?? '',
          isDemoModeEnable: result['demo_mode'] ?? '0',
          isAcceptingCustomJob:
              result['is_accepting_custom_jobs']?.toString() ?? "0",
          subscriptionInformation: result["subscription_information"] != null
              ? SubscriptionInformation.fromJson(
                  Map.from(result["subscription_information"] ?? {}),
                )
              : SubscriptionInformation(),
          loginSettings: LoginSettings.fromJson(result["login_settings"] ?? {}),
          paymentGatewaysSettings: PaymentGatewaysSettings.fromJson(
            result["payment_gateways_settings"] ?? {},
          ),
          appSetting: AppSetting.fromJson(result["app_settings"] ?? {}),
          chatSettings: ChatSettings.fromJson(result["chat_settings"] ?? {}),
          payableCommission: result['payable_commision'] ?? '',
          mapProvider: result['map_provider']?.toString().toLowerCase(),
        ),
      );
    } catch (e) {
      emit(FetchSystemSettingsFailure(e.toString()));
    }
  }

  AppSetting get appSetting {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).appSetting;
    }
    return AppSetting();
  }

  bool get subscriptionsEnabled => generalSettings.subscriptionsEnabled;

  String get SystemCurrency => generalSettings.currency ?? '';

  String get SystemCurrencyCountryCode =>
      generalSettings.countryCurrencyCode ?? '';

  String get SystemDecimalPoint => generalSettings.decimalPoint ?? "0";

  bool get isOrderOTPConfirmationEnable =>
      generalSettings.isOrderOTPConfirmationEnable == '1';

  bool get isDoorstepOptionAvailable =>
      generalSettings.atDoorStepOptionAvailable == '1';

  GeneralSettings get generalSettings {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).generalSettings;
    }
    return GeneralSettings();
  }

  ChatSettings get chatSettings {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).chatSettings;
    }
    return ChatSettings.fromJson({});
  }

  bool get isOpenStreetMap {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).mapProvider ==
          'openstreetmap';
    }
    return false;
  }

  LoginSettings? get loginSettings {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).loginSettings;
    }
    return null;
  }

  bool get isStoreOptionAvailable =>
      generalSettings.atStoreOptionAvailable == '1';

  bool get isProviderWiseDistance =>
      generalSettings.maxServiceableDistanceType == 'provider_wise';

  String get getAppStoreURL => providerAppStoreUrl;
  String get getPlayStoreURL => providerPlayStoreUrl;

  String get getProviderAppURL => providerStoreUrl(isIOS: Platform.isIOS);

  void updateAmount(String amount) {
    if (state is FetchSystemSettingsSuccess) {
      emit(
        (state as FetchSystemSettingsSuccess).copyWith(availableAmount: amount),
      );
    }
  }

  void updatePayebleCommision(String payableAmount) {
    if (state is FetchSystemSettingsSuccess) {
      emit(
        (state as FetchSystemSettingsSuccess).copyWith(
          payableCommission: payableAmount,
        ),
      );
    }
  }

  String getIsAcceptingCustomJobs() {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).isAcceptingCustomJob;
    }
    return "0";
  }

  bool get isDemoModeEnable {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).isDemoModeEnable == '1';
    }
    return false;
  }

  PaymentGatewaysSettings get paymentGatewaysSettings {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).paymentGatewaysSettings;
    }
    return PaymentGatewaysSettings();
  }

  bool get isPayLaterAllowedByAdmin {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess)
              .paymentGatewaysSettings
              .isPayLaterEnable ==
          "1";
    }
    return false;
  }

  List<SocialMediaURL> get socialMediaURLs {
    if (state is FetchSystemSettingsSuccess) {
      return (state as FetchSystemSettingsSuccess).socialMediaURLs;
    }
    return [];
  }

  Map<String, dynamic> get getContactUsDetails {
    return {
      "email": generalSettings.supportEmail ?? '',
      "mobile": generalSettings.phone ?? '',
      "address": generalSettings.address ?? '',
      "supportHours": generalSettings.supportHours ?? '',
    };
  }

  bool get isAdBannerEnabled => Platform.isAndroid
      ? appSetting.isAndroidAdEnabled == "1"
      : appSetting.isIosAdEnabled == "1";

  String get bannerAdId => Platform.isAndroid
      ? appSetting.androidBannerId ?? ''
      : appSetting.iosBannerId ?? '';

  String get interstitialAdId => Platform.isAndroid
      ? appSetting.androidInterstitialId ?? ''
      : appSetting.iosInterstitialId ?? '';

  /// Methods enabled in the system settings.
  List<Map<String, dynamic>> getEnabledPaymentMethods() {
    if (state is FetchSystemSettingsSuccess) {
      return getAllPaymentMethods()
          .where((element) => element["isEnabled"] == true)
          .toList();
    }
    return [];
  }

  /// Every payment method the app supports; `isEnabled` follows the system
  /// settings (the country settings can override it).
  List<Map<String, dynamic>> getAllPaymentMethods() {
    final PaymentGatewaysSettings paymentGatewaySetting =
        paymentGatewaysSettings;

    ///title will be shown in radio button
    ///description will be shown in radio button under title (conditional based on deliverable option)
    ///optionDescription will be shown in radio button under title (conditional based on deliverable option)
    ///image will be shown in radio button (icon)
    ///isEnabled will be shown in radio button (if enabled then only give option to select)
    ///paymentType will be used to identify the payment method (this type will be used in placeOrder)
    final List<Map<String, dynamic>> paymentMethods = [
      {
        "title": 'paypal',
        "description": 'payOnlineNowUsingPaypal',
        "image": AppAssets.icPaypal,
        "isEnabled": paymentGatewaySetting.paypalStatus == "enable",
        "paymentType": "paypal",
      },
      {
        "title": 'razorpay',
        "description": 'payOnlineNowUsingRazorpay',
        "image": AppAssets.icRazorpay,
        "isEnabled": paymentGatewaySetting.razorpayApiStatus == "enable",
        "paymentType": "razorpay",
      },
      {
        "title": 'paystack',
        "description": 'payOnlineNowUsingPaystack',
        "image": AppAssets.icPaystack,
        "isEnabled": paymentGatewaySetting.paystackStatus == "enable",
        "paymentType": "paystack",
      },
      {
        "title": 'stripe',
        "description": 'payOnlineNowUsingStripe',
        "image": AppAssets.icStripe,
        "isEnabled": paymentGatewaySetting.stripeStatus == "enable",
        "paymentType": "stripe",
      },
      {
        "title": 'flutterwave',
        "description": 'payOnlineNowUsingFlutterwave',
        "image": AppAssets.icFlutterwave,
        "isEnabled": paymentGatewaySetting.isFlutterwaveEnable == "enable",
        "paymentType": "flutterwave",
      },
      {
        "title": 'xendit',
        "description": 'payOnlineNowUsingXendit',
        "image": AppAssets.icXendit,
        "isEnabled": paymentGatewaySetting.isXenditEnabled,
        "paymentType": "xendit",
      },
      {
        "title": 'cashfree',
        "description": 'payOnlineNowUsingCashfree',
        "image": AppAssets.icCashfree,
        "isEnabled": paymentGatewaySetting.cashfreeStatus == "enable",
        "paymentType": "cashfree",
      },
    ];

    return paymentMethods;
  }

  bool get isPhoneAuthEnabled {
    final result = loginSettings?.isPhoneAuthEnabled ?? true;
    return result;
  }

  bool get isEmailAuthEnabled {
    final result = loginSettings?.isEmailAuthEnabled ?? true;
    return result;
  }
}
