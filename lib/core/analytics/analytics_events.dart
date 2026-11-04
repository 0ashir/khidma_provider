class ClarityActions {
  const ClarityActions._();

  static const String appLaunch = 'app_launch';
  static const String appResume = 'app_resume';
  static const String appBackground = 'app_background';

  static const String loginAttempt = 'login_attempt';
  static const String loginSuccess = 'login_success';
  static const String loginFailure = 'login_failure';
  static const String logout = 'logout';
  static const String registrationAttempt = 'registration_attempt';
  static const String registrationCompleted = 'registration_completed';

  static const String categoryTapped = 'category_tapped';
  static const String serviceTapped = 'service_tapped';
  static const String serviceViewed = 'service_viewed';
  static const String serviceCreated = 'service_created';
  static const String serviceDeleted = 'service_deleted';

  static const String bookingAccepted = 'booking_accepted';
  static const String bookingCancelled = 'booking_cancelled';
  static const String bookingCompleted = 'booking_completed';
  static const String bookingRejected = 'booking_rejected';
  static const String bookingStatusUpdated = 'booking_status_updated';

  static const String promocodeCreated = 'promocode_created';
  static const String promocodeDeleted = 'promocode_deleted';

  static const String profileUpdated = 'profile_updated';
  static const String languageChanged = 'language_changed';
  static const String passwordChanged = 'password_changed';
  static const String deleteAccount = 'delete_account';

  static const String customJobApplied = 'custom_job_applied';
  static const String withdrawalRequestSent = 'withdrawal_request_sent';

  static const String chatMessageSent = 'chat_message_sent';
  static const String contactUsSubmitted = 'contact_us_submitted';
  static const String userReported = 'user_reported';
}
