import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/home_add_new_service_screen.dart';
import 'package:fixit_provider/screens/app_pages_screens/advertising_screens/ads_service_list.dart';
import 'package:fixit_provider/screens/app_pages_screens/app_details_screen/app_details_screen.dart';
import 'package:fixit_provider/screens/app_pages_screens/audio_call/audio_call.dart';
import 'package:fixit_provider/screens/app_pages_screens/chat_with_staff_screen/chat_with_staff_screen.dart';
import 'package:fixit_provider/screens/app_pages_screens/company_details_screen/layouts/company_detail_update.dart';
import 'package:fixit_provider/screens/app_pages_screens/help_support_screen/help_support_screen.dart';
import 'package:fixit_provider/screens/app_pages_screens/latest_blog_details/home_blog_details.dart';
import 'package:fixit_provider/screens/app_pages_screens/referral_screen/referral_screen.dart';
import 'package:fixit_provider/screens/app_pages_screens/referral_screen/referral_list_screen.dart';
import 'package:fixit_provider/screens/app_pages_screens/service_add_ons/create_service_add_ons.dart';
import 'package:fixit_provider/screens/app_pages_screens/video_call/video_call.dart';
import 'package:fixit_provider/screens/maintenance_screen/maintenance_screen.dart';

import '../config.dart';
import '../screens/app_pages_screens/advertising_screens/ads_details_screen.dart';
import '../screens/app_pages_screens/advertising_screens/advertising_screens.dart';
import '../screens/app_pages_screens/boost_screen/boost_screen.dart';
import '../screens/app_pages_screens/custom_job_request/job_request_details/job_home_details.dart';
import '../screens/app_pages_screens/custom_job_request/job_request_details/job_request_details.dart';
import '../screens/app_pages_screens/custom_job_request/job_request_list/job_request_list.dart';
import '../screens/app_pages_screens/maintenance_mode.dart';

import '../screens/app_pages_screens/provider_chat_screen/offer_screen.dart';
import '../screens/app_pages_screens/provider_chat_screen/provider_chat_screen.dart';
import '../screens/app_pages_screens/service_add_ons/service_add_on_list.dart';
import '../screens/app_pages_screens/services_details_screen/home_service_details.dart';
import '../widgets/no_internet_screen.dart';

class AppRoute {
  Map<String, Widget Function(BuildContext)> route = {
    routeName.splash: (p0) => const SplashScreen(),
    routeName.intro: (p0) => const IntroScreen(),
    routeName.loginProvider: (p0) => const LoginAsProviderScreen(),
    routeName.loginServiceman: (p0) => const LoginAsServicemanScreen(),
    routeName.forgetPassword: (p0) => const ForgotPasswordScreen(),
    routeName.verifyOtp: (p0) => const VerifyOtpScreen(),
    routeName.resetPass: (p0) => const ResetPasswordScreen(),
    routeName.signUpCompany: (p0) => const SignUpCompanyScreen(),
    routeName.location: (p0) => const CurrentLocationScreen(),
    routeName.dashboard: (p0) => const DashboardScreen(),
    routeName.earningHistory: (p0) => const EarningHistoryScreen(),
    routeName.notification: (p0) => const NotificationScreen(),
    routeName.serviceList: (p0) => const ServiceListScreen(),
    routeName.addNewService: (p0) => const AddNewServiceScreen(),
    routeName.serviceDetails: (p0) => const ServicesDetailsScreen(),
    routeName.serviceReview: (p0) => const ServiceReviewScreen(),
    routeName.locationList: (p0) => const LocationListScreen(),
    routeName.categories: (p0) => const CategoriesListScreen(),
    routeName.servicemanList: (p0) => const ServicemanListScreen(),
    routeName.servicemanDetail: (p0) => const ServicemanDetailScreen(),
    routeName.addServicemen: (p0) => const AddServicemenScreen(),
    routeName.latestBlogDetails: (p0) => const LatestBlogDetailsScreen(),
    // routeName.homeLatestBlogDetails: (p0) =>
    //     const HomeLatestBlogDetailsScreen(),
    routeName.latestBlogViewAll: (p0) => const LatestBlogViewAll(),
    routeName.popularServiceScreen: (p0) => const PopularServiceScreen(),
    routeName.appSetting: (p0) => const AppSettingScreen(),
    routeName.changePassword: (p0) => const ChangePasswordScreen(),
    routeName.changeLanguage: (p0) => const ChangeLanguageScreen(),
    routeName.companyDetails: (p0) => const CompanyDetailsScreen(),
    routeName.profileDetails: (p0) => const ProfileDetailScreen(),
    routeName.bankDetails: (p0) => const BankDetailScreen(),
    routeName.idVerification: (p0) => const IdVerificationScreen(),
    routeName.timeSlot: (p0) => const TimeSlotScreen(),
    routeName.packagesList: (p0) => const PackagesListScreen(),
    routeName.packageDetails: (p0) => const PackageDetailsScreen(),
    routeName.appPackage: (p0) => const AddPackageScreen(),
    routeName.addServiceAddons: (p0) => const CreateServiceAddOns(),
    routeName.selectService: (p0) => const SelectServiceScreen(),
    routeName.commissionHistory: (p0) => const CommissionHistory(),
    routeName.bookingDetails: (p0) => const BookingDetailsScreen(),
    routeName.commissionInfo: (p0) => const CommissionInfoScreen(),
    routeName.commissionDetail: (p0) => const CommissionDetailScreen(),
    routeName.providerReview: (p0) => const ProviderReviewScreen(),
    routeName.planDetails: (p0) => const PlanDetailsScreen(),
    routeName.subscriptionPlan: (p0) => const SubscriptionPlanScreen(),
    routeName.pendingBooking: (p0) => const PendingBookingScreen(),
    routeName.acceptedBooking: (p0) => const AcceptBookingScreen(),
    routeName.bookingServicemenList: (p0) =>
        const BookingServicemenListScreen(),
    routeName.chat: (p0) => const ChatScreen(),
    routeName.chatWithStaffScreen: (p0) => const ChatWithStaffScreen(),
    routeName.referralScreen: (p0) => const ReferralScreen(),
    routeName.referralList: (p0) => const ReferralListScreen(),
    routeName.assignBooking: (p0) => const AssignBookingScreen(),
    routeName.pendingApprovalBooking: (p0) =>
        const PendingApprovalBookingScreen(),
    routeName.ongoingBooking: (p0) => const OngoingBookingScreen(),
    routeName.addExtraCharges: (p0) => const AddExtraChargeScreen(),
    routeName.holdBooking: (p0) => const HoldBookingScreen(),
    routeName.completedBooking: (p0) => const CompletedBookingScreen(),
    routeName.addServiceProof: (p0) => const AddServiceProofScreen(),
    routeName.cancelledBooking: (p0) => const CancelledBookingScreen(),
    routeName.earnings: (p0) => const EarningScreen(),
    routeName.chatHistory: (p0) => const ChatHistoryScreen(),
    routeName.addNewLocation: (p0) => const AddNewLocation(),
    routeName.signUpFreelancer: (p0) => const SignupFreelancerScreen(),
    routeName.search: (p0) => const SearchScreen(),
    routeName.viewLocation: (p0) => const ViewLocationScreen(),
    routeName.noInternet: (p0) => const NoInternetScreen(),
    routeName.providerDetail: (p0) => const ProviderDetailsScreen(),
    routeName.paymentMethodList: (p0) => const PaymentScreen(),
    routeName.checkoutWebView: (p0) => const CheckoutWebView(),
    routeName.companyDetailUpdate: (p0) => const CompanyDetailUpdate(),
    routeName.jobRequestList: (p0) => const JobRequestList(),
    routeName.jobRequestDetail: (p0) => const JobRequestDetails(),
    routeName.homeJobRequestDetails: (p0) => const HomeJobRequestDetails(),
    routeName.maintenanceMode: (p0) => const MaintenanceMode(),
    // routeName.videoCall: (p0) => const VideoCall(),
    // routeName.audioCall: (p0) => const AudioCall(),
    routeName.homeAddNewService: (p0) => const HomeAddNewServiceScreen(),
    routeName.homeServicesDetailsScreen: (p0) =>
        const HomeServicesDetailsScreen(),
    routeName.adsDetailsScreen: (p0) => const AdsDetailsScreen(),
    routeName.advertisingScreens: (p0) => const AdvertisingScreens(),
    routeName.boostScreen: (p0) => const BoostScreen(),
    routeName.offerScreen: (p0) => const OfferScreen(),
    routeName.providerChatScreen: (p0) => const ProviderChatScreen(),
    routeName.maintenance: (p0) => const MaintenanceScreen(),
    routeName.adsServiceList: (p0) => const AdsServiceList(),
    routeName.helpSupport: (p0) => const HelpSupportScreen(),
    routeName.appDetails: (p0) => const AppDetailsScreen(),
    routeName.serviceAddOnList: (p0) => const ServiceAddOnList(),
  };
}
