import '../data/model/accountType.dart';

abstract class AppAssets {
  static const String _svgs = "assets/images/svg";
  static const String _brandingAssetsPath = "$_svgs/branding";

  // Branding assets

  static const String loginLogo = "$_brandingAssetsPath/app_logo.png";
  static const String providerLoginLogo = "$_brandingAssetsPath/app_logo.png";
  static const String handymanLoginLogo = "$_brandingAssetsPath/app_logo.png";

  /// Auth screen logo for the selected [UserType].
  static String loginLogoFor(UserType userType) =>
      userType.isHandyman ? handymanLoginLogo : providerLoginLogo;

  static const String loginTypeImage = "$_svgs/login_type_image.png";
  /// White K+ and "Khidma Provider" on transparent, drawn on the brand colour.
  static const String splashLogo = "$_brandingAssetsPath/splash_logo.png";

  /// Full-screen splash artwork (recoloured to the brand palette).
  static const String splashScreenArt =
      "$_brandingAssetsPath/splash_screen.jpg";
  static const String wrteamLogo = "$_brandingAssetsPath/app_logo.png";
  static const String placeholder = "$_brandingAssetsPath/app_logo.png";
  static const String noImageFound = "$_brandingAssetsPath/app_logo.png";

  // General assets

  static const String handyman = "$_svgs/handyman.svg";
  static const String customerPin = "$_svgs/customer_pin.svg";

  static const String addAttachment = "$_svgs/add_attachment.svg";
  static const String adrs = "$_svgs/adrs.svg";
  static const String americaFlag = "$_svgs/america_flag.svg";
  static const String arabFlag = "$_svgs/arab_flag.svg";
  static const String arrowNext = "$_svgs/arrow_next.svg";
  static const String attFile = "$_svgs/att_file.svg";
  static const String attGallary = "$_svgs/att_gallary.svg";
  static const String bCalender = "$_svgs/b_calender.svg";
  static const String bClock = "$_svgs/b_clock.svg";
  static const String bMoney = "$_svgs/b_money.svg";
  static const String deactive = "$_svgs/deactive.svg";
  static const String backArrowLight = "$_svgs/back_arrow_light.svg";
  static const String bagImage = "$_svgs/bag_image.svg";
  static const String booking = "$_svgs/booking.svg";
  static const String briefcase = "$_svgs/briefcase.svg";
  static const String call = "$_svgs/call.svg";
  static const String chat = "$_svgs/chat.svg";
  static const String closeService = "$_svgs/close_service.svg";
  static const String commissionSettlement = "$_svgs/commission_settlement.svg";
  static const String dProfile = "$_svgs/d_profile.svg";
  static const String delete = "$_svgs/delete.svg";
  static const String design = "$_svgs/design.svg";
  static const String downloadIcon = "$_svgs/download_icon.svg";
  static const String drAboutUs = "$_svgs/dr_aboutus.svg";
  static const String drBookingPayment = "$_svgs/dr_booking_payment.svg";
  static const String drCashCollection = "$_svgs/dr_cashcollection.svg";
  static const String drCategories = "$_svgs/dr_categories.svg";
  static const String drChangePass = "$_svgs/dr_changepass.svg";
  static const String drChat = "$_svgs/dr_chat.svg";
  static const String drContactUs = "$_svgs/dr_contactus.svg";
  static const String drDeleteAccount = "$_svgs/dr_deleteaccount.svg";
  static const String drLanguage = "$_svgs/dr_language.svg";
  static const String drLogout = "$_svgs/dr_logout.svg";
  static const String drPrivacyPolicy = "$_svgs/dr_privacypolicy.svg";
  static const String drProfile = "$_svgs/dr_profile.svg";
  static const String drPromoCode = "$_svgs/dr_promocode.svg";
  static const String drSettlementHistory = "$_svgs/dr_settlementhistory.svg";
  static const String drShareApp = "$_svgs/dr_shareapp.svg";
  static const String drSubscription = "$_svgs/dr_subscription.svg";
  static const String drTermsConditions = "$_svgs/dr_termsconditions.svg";
  static const String drTheme = "$_svgs/dr_theme.svg";
  static const String drWithdrawalRequest = "$_svgs/dr_withdrawalrequest.svg";
  static const String drawer = "$_svgs/drawer.svg";
  static const String edit = "$_svgs/edit.svg";
  static const String emptyStateFeatureOff = "$_svgs/emptystateFeatureOff.svg";
  static const String filter = "$_svgs/filter.svg";
  static const String home = "$_svgs/home.svg";
  static const String icFlutterwave = "$_svgs/ic_flutterwave.svg";
  static const String icXendit = "$_svgs/ic_xendit.svg";
  static const String icPaypal = "$_svgs/ic_paypal.svg";
  static const String icPaystack = "$_svgs/ic_paystack.svg";
  static const String icRazorpay = "$_svgs/ic_razorpay.svg";
  static const String icStripe = "$_svgs/ic_stripe.svg";
  static const String icCashfree = "$_svgs/ic_cashfree.svg";
  static const String cod = "$_svgs/ic_cod.svg";
  static const String indiaFlag = "$_svgs/india_flag.svg";

  static const String mobile = "$_svgs/mobile.svg";
  static const String myProfile = "$_svgs/myProfile.svg";
  static const String noInternet = "$_svgs/noInternet.svg";
  static const String notebookSvgRepo = "$_svgs/notebook-svgrepo-com.svg";
  static const String notification = "$_svgs/notification.svg";

  static const String portugueseFlag = "$_svgs/portugese_flag.svg";
  static const String registration = "$_svgs/registration.svg";
  static const String reviews = "$_svgs/reviews.svg";
  static const String search = "$_svgs/search.svg";
  static const String sendMessage = "$_svgs/send_message.svg";
  static const String services = "$_svgs/services.svg";
  static const String spDown = "$_svgs/sp_down.svg";
  static const String spainFlag = "$_svgs/spain_flag.svg";
  static const String star = "$_svgs/star.svg";
  static const String success = "$_svgs/success.svg";
  static const String transactions = "$_svgs/transactions.svg";
  static const String ttlBookingWhite = "$_svgs/ttl_booking_white.svg";
  static const String ttlBooking = "$_svgs/ttl_booking.svg";
  static const String ttlCancelWhite = "$_svgs/ttl_cancel_white.svg";
  static const String ttlCancel = "$_svgs/ttl_cancel.svg";
  static const String ttlEarningWhite = "$_svgs/ttl_earning_white.svg";
  static const String ttlEarning = "$_svgs/ttl_earning.svg";
  static const String ttlServices = "$_svgs/ttl_services.svg";
  static const String user = "$_svgs/user.svg";
  static const String add = "$_svgs/add.svg";
  static const String crown = "$_svgs/crown.svg";
  static const String history = "$_svgs/history.svg";
  static const String addCircle = "$_svgs/add_circle.svg";
  static const String checkCircle = "$_svgs/check_circle.svg";
  static const String camera = "$_svgs/att_camara.svg";
  static const String pProfile = "$_svgs/p_profile.svg";
  static const String pMoney = "$_svgs/p_money.svg";
  static const String pDate = "$_svgs/p_date.svg";
  static const String pQuestion = "$_svgs/p_question.svg";
  static const String defaultFilter = "$_svgs/defaultFilter.svg";
  static const String lowToHigh = "$_svgs/lowToHigh.svg";
  static const String highToLow = "$_svgs/highToLow.svg";
  static const String close = "$_svgs/close.svg";
  static const String gallery = "$_svgs/gallery.svg";
  static const String group = "$_svgs/group.svg";
  static const String duration = "$_svgs/duration.svg";
  static const String activeState = "$_svgs/active_state.svg";
  static const String trash = "$_svgs/trash.svg";
  static const String mapPic = "$_svgs/map_pic.svg";
  static const String letter = "$_svgs/letter.svg";
  static const String note = "$_svgs/note.svg";
  static const String check = "$_svgs/check.svg";
  static const String descendingFilter = "$_svgs/descendingFilter.svg";
  static const String ascendingFilter = "$_svgs/ascendingFilter.svg";

  static const String noDataFound = "$_svgs/noDataFound.svg";
  static const String noConnection = "$_svgs/noConnection.svg";
  static const String somethingWentWrong = "$_svgs/somethingWentWrong.svg";
  static const String noBooking = "$_svgs/noBookmarks.svg";
  static const String noChat = "$_svgs/noChat.svg";
  static const String pageNotFound = "$_svgs/pageNotFound.svg";
  static const String noAddresses = "$_svgs/noAddresses.svg";
  static const String noSearchResult = "$_svgs/noSearchResult.svg";
  static const String location = "$_svgs/location.svg";
  static const String drBlockedUsers = "$_svgs/drBlockedUsers.svg";
  static const String support = "$_svgs/support.svg";
}
