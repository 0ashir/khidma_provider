import 'package:edemand_partner/ui/screens/chat/blockChatScreen.dart';
import 'package:edemand_partner/ui/screens/liveTracking/liveTrackingScreen.dart';
import 'package:edemand_partner/ui/screens/mainActivity/widgets/changePasswordScreen.dart';
import 'package:edemand_partner/ui/screens/mainActivity/widgets/languageSelectionScreen.dart';
import 'package:edemand_partner/ui/screens/notifications/notificationsScreen.dart';
import 'package:edemand_partner/ui/screens/slotManagement/leaveHistoryScreen.dart';
import 'package:edemand_partner/ui/screens/slotManagement/leaveScreen.dart';
import 'package:edemand_partner/ui/screens/slotManagement/slotConfigurationScreen.dart';
import 'package:edemand_partner/ui/screens/slotManagement/slotManagementScreen.dart';
import 'package:edemand_partner/ui/screens/slotManagement/workingHoursScreen.dart';
import 'package:flutter/material.dart';

import 'generalImports.dart';

class Routes {
  static const String splash = 'splash';
  static const String main = 'mainActivity';
  static const String handymanMain = '/handymanMain';
  static const String registration = 'registration';
  static const String createService = 'CreateService';
  static const String promoCode = 'Promocode';
  static const String addPromoCode = 'AddPromocode';
  static const String withdrawalRequests = 'withdrawalRequests';
  static const String cashCollection = 'cashCollection';
  static const String categories = 'Categories';
  static const String serviceDetails = 'ServiceDetails';
  static const String bookingDetails = 'BookingDetails';
  static const String openJobRequestDetails = "OpenJobRequestDetails";
  static const String appliedJobrequestDetails = "AppliedJobRequestDetails";

  static const String loginScreenRoute = 'loginRoute';
  static const String loginFormScreen = '/loginFormScreen';
  static const String customPageDetailsRoute = 'appSettings';
  static const String otpVerificationRoute = '/login/OtpVerification';
  static const String createNewPassword = '/createNewPassword';
  static const String maintenanceModeScreen = '/maintenanceModeScreen';
  static const String appUpdateScreen = '/appUpdateScreen';
  static const String imagePreviewScreen = '/imagePreviewScreen';
  static const String countryCodePickerRoute = '/countryCodePicker';
  static const String sendOTPScreen = '/sendOTPScreen';
  static const String providerRegistration = '/providerRegistration';
  static const String successScreen = '/successScreen';
  static const String settlementHistoryScreen = '/settlementHistoryScreen';
  static const String subscriptionScreen = '/subscriptionScreen';
  static const String paypalPaymentScreen = "/paypalPaymentScreen";
  static const String subscriptionPaymentConfirmationScreen =
      "/subscriptionPaymentConfirmationScreen";
  static const String bookingPaymentDataScreen = "/bookingPaymentDataScreen";
  static const String previousSubscriptions = "/previousSubscriptions";
  static const String contactUsRoute = "/contactUs";
  static const String changePassword = "/changePassword";

  //chat
  static const String chatMessages = "/chatMessages";
  static const String chatUserProfile = "/chatUserProfile";
  static const String imagesFullScreenView = "/imagesFullScreenView";
  static const String languageSelectionScreen = "/languageSelectionScreen";
  static const String changePasswordScreen = "/changePasswordScreen";

  static const String jobRequestScreen = '/jobRequestScreen';

  static const String reviewsScreen = '/reviewsScreen';
  static const String handymanReviewsScreen = '/handymanReviewsScreen';

  static const String locationSearchScreen = '/locationSearchScreen';

  static const String blockUserScreen = '/blockUserScreen';

  static const String notificationsScreen = '/notificationsScreen';

  static const String customPages = '/customPages';

  static const String slotManagement = '/slotManagement';
  static const String workingHours = '/workingHours';
  static const String slotConfiguration = '/slotConfiguration';
  static const String leaveScreen = '/leaveScreen';
  static const String leaveHistoryScreen = '/leaveHistoryScreen';

  static const String seoSettings = '/seoSettings';

  static const String providerVerification = '/providerVerification';

  static const String manageHandymen = '/manageHandymen';
  static const String addHandyman = '/addHandyman';
  static const String handymanBookingDetails = '/handymanBookingDetails';
  static const String handymanEditProfile = '/handymanEditProfile';

  static const String liveTracking = '/liveTracking';
  static const String handymanLiveMap = '/handymanLiveMap';

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? '';

    switch (routeSettings.name) {
      case splash:
        return CupertinoPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );

      case main:
        return MainActivity.route(routeSettings);

      case handymanMain:
        return HandymanMainActivity.route(routeSettings);

      case registration:
        return RegistrationForm.route(routeSettings);

      case createService:
        return ManageService.route(routeSettings);

      case promoCode:
        return PromoCode.route(routeSettings);

      case addPromoCode:
        return ManagePromocode.route(routeSettings);

      case withdrawalRequests:
        return WithdrawalRequestsScreen.route(routeSettings);

      case cashCollection:
        return CashCollectionScreen.route(routeSettings);

      case changePassword:
        return ChangePasswordScreen.route(routeSettings);

      case categories:
        return Categories.route(routeSettings);

      case serviceDetails:
        return ServiceDetails.route(routeSettings);

      case bookingDetails:
        return BookingDetails.route(routeSettings);

      case openJobRequestDetails:
        return OpenJobRequestDetails.route(routeSettings);

      case blockUserScreen:
        return BlockChatScreen.route(routeSettings);

      case appliedJobrequestDetails:
        return AppliedJobRequestDetails.route(routeSettings);

      case loginScreenRoute:
        return LoginTypeSelectionScreen.route(routeSettings);

      case loginFormScreen:
        return LoginScreen.route(routeSettings);

      case customPageDetailsRoute:
        return CustomPageDetailsScreen.route(routeSettings);

      case maintenanceModeScreen:
        return MaintenanceModeScreen.route(routeSettings);

      case appUpdateScreen:
        return AppUpdateScreen.route(routeSettings);

      case imagePreviewScreen:
        return ImagePreview.route(routeSettings);

      case countryCodePickerRoute:
        return CountryCodePickerScreen.route(routeSettings);

      case otpVerificationRoute:
        return VerifyOTPScreen.route(routeSettings);

      case reviewsScreen:
        return ReviewsScreen.route(routeSettings);

      case handymanReviewsScreen:
        return HandymanReviewsScreen.route(routeSettings);
      case createNewPassword:
        return CreateNewPassword.route(routeSettings);

      case sendOTPScreen:
        return SendOTPScreen.route(routeSettings);

      case providerRegistration:
        return ProviderRegistration.route(routeSettings);
      case settlementHistoryScreen:
        return SettlementHistoryScreen.route(routeSettings);

      case successScreen:
        return SuccessScreen.route(routeSettings);

      case subscriptionScreen:
        if (!(UiUtils.rootNavigatorKey.currentContext
                ?.read<FetchSystemSettingsCubit>()
                .subscriptionsEnabled ??
            false)) {
          return MainActivity.route(routeSettings);
        }
        return SubscriptionsScreen.route(routeSettings);

      case paypalPaymentScreen:
        return WebviewPaymentScreen.route(routeSettings);

      case subscriptionPaymentConfirmationScreen:
        if (!(UiUtils.rootNavigatorKey.currentContext
                ?.read<FetchSystemSettingsCubit>()
                .subscriptionsEnabled ??
            false)) {
          return MainActivity.route(routeSettings);
        }
        return SubscriptionPaymentConfirmationScreen.route(routeSettings);

      case previousSubscriptions:
        if (!(UiUtils.rootNavigatorKey.currentContext
                ?.read<FetchSystemSettingsCubit>()
                .subscriptionsEnabled ??
            false)) {
          return MainActivity.route(routeSettings);
        }
        return SubscriptionHistoryScreen.route(routeSettings);

      case bookingPaymentDataScreen:
        return BookingPaymentDataScreen.route(routeSettings);

      case contactUsRoute:
        return ContactUsScreen.route(routeSettings);

      case chatMessages:
        return ChatMessagesScreen.route(routeSettings);

      case imagesFullScreenView:
        return ImagesFullScreen.route(routeSettings);

      case languageSelectionScreen:
        return LanguageSelectionScreen.route(routeSettings);

      case changePasswordScreen:
        return ChangePasswordScreen.route(routeSettings);

      case jobRequestScreen:
        return JobRequestScreen.route(routeSettings);

      case notificationsScreen:
        return NotificationsScreen.route(routeSettings);

      case customPages:
        return CupertinoPageRoute(
          builder: (context) => BlocProvider<FetchCustomPagesCubit>(
            create: (_) => FetchCustomPagesCubit(CustomPageRepository()),
            child: const CustomPagesScreen(),
          ),
        );

      case slotManagement:
        return SlotManagementScreen.route(routeSettings);

      case workingHours:
        return WorkingHoursScreen.route(routeSettings);

      case slotConfiguration:
        return SlotConfigurationScreen.route(routeSettings);

      case leaveScreen:
        return LeaveScreen.route(routeSettings);

      case leaveHistoryScreen:
        return LeaveHistoryScreen.route(routeSettings);

      case seoSettings:
        return SeoSettingsScreen.route(routeSettings);

      case providerVerification:
        return VerificationScreen.route(routeSettings);

      case manageHandymen:
        return ManageHandymenListScreen.route(routeSettings);

      case addHandyman:
        return ManageHandymanScreen.route(routeSettings);

      case handymanBookingDetails:
        return HandymanBookingDetailsScreen.route(routeSettings);

      case handymanEditProfile:
        return HandymanEditProfileScreen.route(routeSettings);

      case liveTracking:
        return LiveTrackingScreen.route(routeSettings);

      case handymanLiveMap:
        return HandymanLiveMapScreen.route(routeSettings);

      default:
        return CupertinoPageRoute(
          builder: (BuildContext context) => Scaffold(
            body: CustomText(
              'pageNotFoundErrorMsg'.translate(context: context),
            ),
          ),
        );
    }
  }
}
