import 'package:intl/intl.dart';
import '../../utils/constant.dart';

class PaymentGatewaysSettings {
  PaymentGatewaysSettings({
    this.razorpayApiStatus,
    this.razorpayMode,
    this.razorpayCurrency,
    this.razorpayKey,
    this.paystackStatus,
    this.paystackMode,
    this.paystackCurrency,
    this.paystackKey,
    this.stripeStatus,
    this.stripeMode,
    this.stripeCurrency,
    this.stripePublishableKey,
    this.paypalStatus,
    this.isOnlinePaymentEnable,
    this.isPayLaterEnable,
    this.isFlutterwaveEnable,
    this.flutterwaveWebsiteUrl,
    this.paypalWebsiteUrl,
    this.isXenditEnabled,
    this.cashfreeStatus,
    this.cashfreeEnvironment,
  });

  PaymentGatewaysSettings.fromJson(final Map<String, dynamic> json) {
    isPayLaterEnable = json["cod_setting"]?.toString() ?? "1";
    isOnlinePaymentEnable =
        json["provider_online_payment_setting"]?.toString() ?? "0";
    razorpayApiStatus = json["razorpayApiStatus"]?.toString() ?? "disable";
    razorpayMode = json["razorpay_mode"]?.toString() ?? '';
    razorpayCurrency = json["razorpay_currency"]?.toString() ?? '';
    razorpayKey = json["razorpay_key"]?.toString() ?? '';
    paystackStatus = json["paystack_status"]?.toString() ?? "disable";
    paystackMode = json["paystack_mode"]?.toString() ?? '';
    paystackCurrency = json["paystack_currency"]?.toString() ?? '';
    paystackKey = json["paystack_key"]?.toString() ?? '';
    stripeStatus = json["stripe_status"]?.toString() ?? "disable";
    stripeMode = json["stripe_mode"]?.toString() ?? '';
    stripeCurrency = json["stripe_currency"]?.toString() ?? '';
    stripePublishableKey = json["stripe_publishable_key"]?.toString() ?? '';
    paypalStatus = json["paypal_status"]?.toString() ?? "disable";
    isFlutterwaveEnable = json["flutterwave_status"]?.toString() ?? '';
    flutterwaveWebsiteUrl = json["flutterwave_website_url"]?.toString() ?? '';
    paypalWebsiteUrl = json["paypal_website_url"]?.toString() ?? '';
    isXenditEnabled = (json['xendit_status']?.toString() ?? '') == 'enable';
    cashfreeStatus = json['cashfree_status']?.toString() ?? 'disable';
    cashfreeEnvironment = json['cashfree_mode']?.toString() ?? '';
  }

  String? razorpayApiStatus;
  String? razorpayMode;
  String? razorpayCurrency;
  String? razorpayKey;
  String? paystackStatus;
  String? paystackMode;
  String? paystackCurrency;
  String? paystackKey;
  String? stripeStatus;
  String? stripeMode;
  String? stripeCurrency;
  String? stripePublishableKey;
  String? paypalStatus;
  String? isPayLaterEnable;
  String? isOnlinePaymentEnable;
  String? isFlutterwaveEnable;
  String? flutterwaveWebsiteUrl;
  String? paypalWebsiteUrl;
  String? defaultCurrencyCode;
  bool? isXenditEnabled;
  // Cashfree fields
  String? cashfreeStatus; // 'enable' or 'disable'
  String? cashfreeEnvironment; // 'sandbox' or 'production'
}

class GeneralSettings {
  bool subscriptionsEnabled = false;
  GeneralSettings({
    this.subscriptionsEnabled = false,
    this.supportEmail,
    this.phone,
    this.address,
    this.shortDescription,
    this.copyrightDetails,
    this.supportHours,
    this.atDoorStepOptionAvailable,
    this.atStoreOptionAvailable,
    this.isOrderOTPConfirmationEnable,
    this.nationalIdRequiredStatus,
    this.addressIdVerificationStatus,
    this.addressIdRequiredStatus,
    this.countryCurrencyCode,
    this.currency,
    this.decimalPoint,
    this.maxServiceableDistanceType,
  });

  GeneralSettings.fromJson(Map<String, dynamic> json) {
    subscriptionsEnabled = const [
      '1',
      'true',
    ].contains((json['subscriptions_enabled'] ?? '1').toString().toLowerCase());
    supportEmail = json['support_email']?.toString() ?? '';
    phone = json['phone']?.toString() ?? '';
    isOrderOTPConfirmationEnable = json['otp_system']?.toString() ?? '';
    address = (json['translated_address']?.toString() ?? '').isNotEmpty
        ? json['translated_address'].toString()
        : (json['address']?.toString() ?? '');
    shortDescription =
        (json['translated_short_description']?.toString() ?? '').isNotEmpty
        ? json['translated_short_description'].toString()
        : (json['short_description']?.toString() ?? '');
    copyrightDetails =
        (json['translated_copyright_details']?.toString() ?? '').isNotEmpty
        ? json['translated_copyright_details'].toString()
        : (json['copyright_details']?.toString() ?? '');
    supportHours = json['support_hours']?.toString() ?? '';
    atStoreOptionAvailable = json['at_store']?.toString() ?? '';
    atDoorStepOptionAvailable = json['at_doorstep']?.toString() ?? '';

    passportVerificationStatus =
        (json['passport_verification_status']?.toString() ?? '0') == "1"
        ? true
        : false;
    passportRequiredStatus =
        (json['passport_required_status']?.toString() ?? '0') == "1"
        ? true
        : false;
    nationalIdVerificationStatus =
        (json['national_id_verification_status']?.toString() ?? '0') == "1"
        ? true
        : false;
    nationalIdRequiredStatus =
        (json['national_id_required_status']?.toString() ?? '0') == "1"
        ? true
        : false;
    addressIdVerificationStatus =
        (json['address_id_verification_status']?.toString() ?? '0') == "1"
        ? true
        : false;
    addressIdRequiredStatus =
        (json['address_id_required_status']?.toString() ?? '0') == "1"
        ? true
        : false;

    countryCurrencyCode = json['country_currency_code']?.toString();
    currency = json['currency']?.toString();
    decimalPoint = json["decimal_point"] == ""
        ? "0"
        : json["decimal_point"]?.toString();
    maxServiceableDistanceType =
        json['max_serviceable_distance_type']?.toString() ?? '';
  }

  String? supportEmail;
  String? phone;
  String? isOrderOTPConfirmationEnable;
  String? address;
  String? shortDescription;
  String? copyrightDetails;
  String? supportHours;
  String? atStoreOptionAvailable;
  String? atDoorStepOptionAvailable;

  bool? passportVerificationStatus;
  bool? passportRequiredStatus;
  bool? nationalIdVerificationStatus;
  bool? nationalIdRequiredStatus;
  bool? addressIdVerificationStatus;
  bool? addressIdRequiredStatus;

  String? countryCurrencyCode;
  String? currency;
  String? decimalPoint;
  String? maxServiceableDistanceType;
}

class ChatSettings {
  final int maxFilesOrImagesInOneMessage;
  final int maxFileSizeInMBCanBeSent;
  final int maxCharactersInATextMessage;
  final bool isPreBookingChatAllowed;
  final bool isPostBookingChatAllowed;
  final bool isImageUploadAllowed;
  final bool isFileUploadAllowed;

  ChatSettings({
    required this.maxFilesOrImagesInOneMessage,
    required this.maxFileSizeInMBCanBeSent,
    required this.maxCharactersInATextMessage,
    required this.isPreBookingChatAllowed,
    required this.isPostBookingChatAllowed,
    required this.isImageUploadAllowed,
    required this.isFileUploadAllowed,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) {
    return ChatSettings(
      maxFilesOrImagesInOneMessage:
          int.tryParse(
            json['maxFilesOrImagesInOneMessage']?.toString() ?? '0',
          ) ??
          0,
      maxFileSizeInMBCanBeSent:
          int.tryParse(json['maxFileSizeInMBCanBeSent']?.toString() ?? '0') ??
          0,
      maxCharactersInATextMessage:
          int.tryParse(
            json['maxCharactersInATextMessage']?.toString() ?? '0',
          ) ??
          0,
      isPreBookingChatAllowed:
          json['allow_pre_booking_chat']?.toString() == '1',
      isPostBookingChatAllowed:
          json['allow_post_booking_chat']?.toString() == '1',
      isImageUploadAllowed: json['enable_chat_image_upload']?.toString() == '1',
      isFileUploadAllowed: json['enable_chat_file_upload']?.toString() == '1',
    );
  }
}

class SocialMediaURL {
  SocialMediaURL({this.imageURL, this.url});

  SocialMediaURL.fromJson(final Map<String, dynamic> json) {
    imageURL = json["file"]?.toString() ?? '';
    url = json["url"]?.toString() ?? '';
  }

  String? imageURL;
  String? url;
}

class AppSetting {
  AppSetting({
    this.providerAppScheduleMaintenanceMode,
    this.providerAppMaintenanceModeStartDateTime,
    this.providerAppMaintenanceModeEndDateTime,
    this.providerCurrentVersionAndroidApp,
    this.providerCurrentVersionIosApp,
    this.providerCompulsaryUpdateForceUpdate,
    this.messageForProviderApplication,
    this.translatedMessageForProviderApplication,
    this.providerAppMaintenanceMode,
    this.providerAppAppStoreURL,
    this.providerAppPlayStoreURL,
    this.customerAppAppStoreURL,
    this.customerAppPlayStoreURL,
    this.androidBannerId,
    this.androidInterstitialId,
    this.isAndroidAdEnabled,
    this.iosBannerId,
    this.iosInterstitialId,
    this.isIosAdEnabled,
  });

  AppSetting.fromJson(final Map<String, dynamic> json) {
    providerCurrentVersionAndroidApp =
        json["provider_current_version_android_app"]?.toString() ?? '';
    providerCurrentVersionIosApp =
        json["provider_current_version_ios_app"]?.toString() ?? '';
    providerCompulsaryUpdateForceUpdate =
        json["provider_compulsary_update_force_update"]?.toString() ?? '';
    messageForProviderApplication =
        json["message_for_provider_application"]?.toString() ?? '';
    translatedMessageForProviderApplication =
        json["translated_message_for_provider_application"]?.toString() ?? '';
    providerAppMaintenanceMode =
        json["provider_app_maintenance_mode"]?.toString() ?? '';
    customerAppPlayStoreURL = customerPlayStoreUrl;
    customerAppAppStoreURL = customerAppStoreUrl;
    providerAppPlayStoreURL = providerPlayStoreUrl;
    providerAppAppStoreURL = providerAppStoreUrl;
    isAndroidAdEnabled = enableAds
        ? (json['provider_android_google_ads_status']?.toString() ?? '0')
        : '0';
    androidInterstitialId =
        json['provider_android_google_interstitial_id']?.toString() ?? '';
    androidBannerId =
        json['provider_android_google_banner_id']?.toString() ?? '';
    isIosAdEnabled = enableAds
        ? (json['provider_ios_google_ads_status']?.toString() ?? '0')
        : '0';
    iosInterstitialId =
        json['provider_ios_google_interstitial_id']?.toString() ?? '';
    iosBannerId = json['provider_ios_google_banner_id']?.toString() ?? '';
    providerAppScheduleMaintenanceMode =
        json['provider_app_scheduled_maintenance_mode']?.toString() == '1';
    providerAppMaintenanceModeStartDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .tryParse(
          json['provider_app_maintenance_mode_start_datetime']?.toString() ??
              '',
          true,
        );
    providerAppMaintenanceModeEndDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .tryParse(
          json['provider_app_maintenance_mode_end_datetime']?.toString() ?? '',
          true,
        );
  }

  String? providerCurrentVersionAndroidApp;
  String? providerCurrentVersionIosApp;
  String? providerCompulsaryUpdateForceUpdate;
  String? messageForProviderApplication;
  String? translatedMessageForProviderApplication;
  String? providerAppMaintenanceMode;
  String? getMessageForProviderApplication() {
    if (translatedMessageForProviderApplication != null &&
        translatedMessageForProviderApplication!.isNotEmpty) {
      return translatedMessageForProviderApplication;
    }
    return messageForProviderApplication;
  }

  String? customerAppAppStoreURL;
  String? customerAppPlayStoreURL;
  String? providerAppAppStoreURL;
  String? providerAppPlayStoreURL;
  String? isAndroidAdEnabled;
  String? androidBannerId;
  String? androidInterstitialId;
  String? isIosAdEnabled;
  String? iosBannerId;
  String? iosInterstitialId;
  bool? providerAppScheduleMaintenanceMode;
  DateTime? providerAppMaintenanceModeStartDateTime;
  DateTime? providerAppMaintenanceModeEndDateTime;
}

class LoginSettings {
  bool? isPhoneAuthEnabled;
  bool? isEmailAuthEnabled;
  int? minumumPasswordLength;
  bool? requireAtLeastOneUppercase;
  bool? requireAtLeastOneLowercase;
  bool? requireAtLeastOneNumber;
  bool? requireAtLeastOneSpecialCharacter;

  LoginSettings({
    this.isPhoneAuthEnabled,
    this.isEmailAuthEnabled,
    this.minumumPasswordLength,
    this.requireAtLeastOneUppercase,
    this.requireAtLeastOneLowercase,
    this.requireAtLeastOneNumber,
    this.requireAtLeastOneSpecialCharacter,
  });

  LoginSettings.fromJson(final Map<String, dynamic> json) {
    final phoneValue = json["phone_authentication_enabled"]?.toString() ?? "1";
    final emailValue = json["email_authentication_enabled"]?.toString() ?? "1";

    final minumumPasswordLengthValue =
        json["minimum_password_length"]?.toString() ?? "0";
    final requireAtLeastOneUppercaseValue =
        json["require_at_least_one_uppercase"]?.toString() ?? "0";
    final requireAtLeastOneLowercaseValue =
        json["require_at_least_one_lowercase"]?.toString() ?? "0";
    final requireAtLeastOneNumberValue =
        json["require_at_least_one_number"]?.toString() ?? "0";
    final requireAtLeastOneSpecialCharacterValue =
        json["require_at_least_one_special_character"]?.toString() ?? "0";

    isPhoneAuthEnabled = phoneValue == "1";
    isEmailAuthEnabled = emailValue == "1";

    minumumPasswordLength = int.tryParse(minumumPasswordLengthValue);
    //we'll not check for validation if it's null, so going with null for 0
    if (minumumPasswordLength == 0) {
      minumumPasswordLength = null;
    }
    requireAtLeastOneUppercase = requireAtLeastOneUppercaseValue == "1";
    requireAtLeastOneLowercase = requireAtLeastOneLowercaseValue == "1";
    requireAtLeastOneNumber = requireAtLeastOneNumberValue == "1";
    requireAtLeastOneSpecialCharacter =
        requireAtLeastOneSpecialCharacterValue == "1";
  }
}
