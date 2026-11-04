import "package:edemand_partner/app/generalImports.dart";
import "package:edemand_partner/cubits/chat/reportReasonCubit.dart";
import "package:edemand_partner/cubits/chat/submitBlockReportCubit.dart";
import "package:edemand_partner/cubits/logoutCubit.dart";
import "package:edemand_partner/cubits/verifyBookingOTPCubit.dart";
import "package:edemand_partner/cubits/downloadInvoiceCubit.dart";

List<BlocProvider> registerBlocks() {
  return [
    BlocProvider<AuthenticationCubit>(create: (_) => AuthenticationCubit()),
    BlocProvider<SignInCubit>(create: (_) => SignInCubit()),
    BlocProvider<ProviderDetailsCubit>(create: (_) => ProviderDetailsCubit()),
    BlocProvider<AppThemeCubit>(create: (_) => AppThemeCubit()),
    BlocProvider<LanguageListCubit>(
      create: (final BuildContext context) => LanguageListCubit(),
    ),
    BlocProvider<LanguageDataCubit>(
      create: (final BuildContext context) => LanguageDataCubit(),
    ),
    BlocProvider<FetchBookingsCubit>(create: (_) => FetchBookingsCubit()),
    BlocProvider<FetchServicesCubit>(create: (_) => FetchServicesCubit()),
    BlocProvider<FetchServiceReviewsCubit>(
      create: (_) => FetchServiceReviewsCubit(),
    ),
    BlocProvider<FetchServiceCategoryCubit>(
      create: (_) => FetchServiceCategoryCubit(),
    ),
    BlocProvider(create: (_) => UpdateFCMCubit()),
    BlocProvider<CreatePromocodeCubit>(create: (_) => CreatePromocodeCubit()),
    BlocProvider<FetchHomeDataCubit>(create: (_) => FetchHomeDataCubit()),
    BlocProvider<FetchReviewsCubit>(create: (_) => FetchReviewsCubit()),
    BlocProvider<DeleteServiceCubit>(create: (_) => DeleteServiceCubit()),
    BlocProvider<TimeSlotCubit>(create: (_) => TimeSlotCubit()),
    BlocProvider<FetchPromocodesCubit>(create: (_) => FetchPromocodesCubit()),
    BlocProvider<FetchSystemSettingsCubit>(
      create: (_) => FetchSystemSettingsCubit(),
    ),
    BlocProvider<CountryCodeCubit>(create: (_) => CountryCodeCubit()),
    BlocProvider<FetchCountrySettingsCubit>(
      create: (_) => FetchCountrySettingsCubit(),
    ),
    BlocProvider<AuthenticationCubit>(create: (_) => AuthenticationCubit()),
    BlocProvider<SendVerificationCodeCubit>(
      create: (_) => SendVerificationCodeCubit(),
    ),
    BlocProvider<CountryCodeCubit>(create: (_) => CountryCodeCubit()),
    BlocProvider<ResendOtpCubit>(create: (_) => ResendOtpCubit()),
    BlocProvider<ChangePasswordCubit>(create: (_) => ChangePasswordCubit()),
    BlocProvider<FetchTaxesCubit>(create: (_) => FetchTaxesCubit()),
    BlocProvider<FetchPreviousSubscriptionsCubit>(
      create: (_) => FetchPreviousSubscriptionsCubit(),
    ),
    BlocProvider<VerifyPhoneNumberFromAPICubit>(
      create: (_) => VerifyPhoneNumberFromAPICubit(
        authenticationRepository: AuthRepository(),
      ),
    ),
    BlocProvider<AddSubscriptionTransactionCubit>(
      create: (_) => AddSubscriptionTransactionCubit(),
    ),
    BlocProvider<GetProviderDetailsCubit>(
      create: (_) => GetProviderDetailsCubit(),
    ),
    BlocProvider<FetchJobRequestCubit>(create: (_) => FetchJobRequestCubit()),
    BlocProvider<FetchJobRequestAppliedJobCubit>(
      create: (_) => FetchJobRequestAppliedJobCubit(),
    ),
    BlocProvider<ManageCustomJobValueCubit>(
      create: (_) => ManageCustomJobValueCubit(),
    ),
    BlocProvider<ApplyForCustomJobCubit>(
      create: (_) => ApplyForCustomJobCubit(),
    ),
    BlocProvider<ManageCategoryPreferenceCubit>(
      create: (_) => ManageCategoryPreferenceCubit(),
    ),
    BlocProvider<LogoutCubit>(create: (_) => LogoutCubit()),
    BlocProvider<GooglePlaceAutocompleteCubit>(
      create: (_) => GooglePlaceAutocompleteCubit(),
    ),
    BlocProvider<GetReportReasonsCubit>(
      create: (_) => GetReportReasonsCubit(ChatRepository()),
    ),
    BlocProvider<SubmitReportCubit>(
      create: (_) => SubmitReportCubit(ChatRepository()),
    ),
    BlocProvider<VerifyBookingOTPCubit>(create: (_) => VerifyBookingOTPCubit()),
    BlocProvider<DownloadInvoiceCubit>(create: (_) => DownloadInvoiceCubit()),
    BlocProvider<GetCancellationReasonsCubit>(
      create: (_) => GetCancellationReasonsCubit(),
    ),

    BlocProvider<EnquiryChatUserCubit>(
      create: (context) => EnquiryChatUserCubit(ChatRepository()),
    ),
    BlocProvider<BookingChatUserCubit>(
      create: (context) => BookingChatUserCubit(ChatRepository()),
    ),
    BlocProvider<HandymanSignInCubit>(create: (_) => HandymanSignInCubit()),
    BlocProvider<FetchHandymenCubit>(create: (_) => FetchHandymenCubit()),
    BlocProvider<ManageHandymanCubit>(create: (_) => ManageHandymanCubit()),
    BlocProvider<DeleteHandymanCubit>(create: (_) => DeleteHandymanCubit()),
    BlocProvider<HandymanToggleCubit>(create: (_) => HandymanToggleCubit()),
    BlocProvider<FetchBookingsDetailsCubit>(
      create: (_) => FetchBookingsDetailsCubit(),
    ),
    BlocProvider<AssignHandymanCubit>(create: (_) => AssignHandymanCubit()),
    BlocProvider<UnassignHandymanCubit>(create: (_) => UnassignHandymanCubit()),
    BlocProvider<SetLeadHandymanCubit>(create: (_) => SetLeadHandymanCubit()),
    BlocProvider<HandymanBookingsCubit>(create: (_) => HandymanBookingsCubit()),
    BlocProvider<HandymanBookingStatusCubit>(
      create: (_) => HandymanBookingStatusCubit(),
    ),
    BlocProvider<HandymanBookingDetailCubit>(
      create: (_) => HandymanBookingDetailCubit(),
    ),
    BlocProvider<HandymanCashCollectionCubit>(
      create: (_) => HandymanCashCollectionCubit(),
    ),
    BlocProvider<HandymanProfileCubit>(create: (_) => HandymanProfileCubit()),
    BlocProvider<HandymanDashboardCubit>(create: (_) => HandymanDashboardCubit()),
    BlocProvider<HandymanLiveTrackingCubit>(
      create: (_) => HandymanLiveTrackingCubit(),
    ),
    BlocProvider<GetCustomFieldsCubit>(create: (_) => GetCustomFieldsCubit()),
    BlocProvider<GetVerificationStatusCubit>(
      create: (_) => GetVerificationStatusCubit(),
    ),
    BlocProvider<SubmitVerificationRequestCubit>(
      create: (_) => SubmitVerificationRequestCubit(),
    ),
  ];
}
