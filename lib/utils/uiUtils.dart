import 'dart:ui' as ui;
import 'package:edemand_partner/utils/custom_timeago.dart';
// import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../app/generalImports.dart';
import 'package:vibration/vibration.dart';

class UiUtils {
  //key for Global navigation
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<MainActivityState> bottomNavigationBarGlobalKey =
      GlobalKey<MainActivityState>();
  static GlobalKey<MainActivityState> mainActivityNavigationBarGlobalKey =
      GlobalKey<MainActivityState>();

  static int animationDuration = 1; //value is in seconds
  static bool authenticationError = false;
  static const String chatLimit = "25";

  static String customRequestCounter = '0';

  static int numberOfShimmerContainer = 7;

  static const String limitOfAPIData = "10";

  static int resendOTPCountDownTime = 30; //in seconds

  static int limit = 10;

  static double maxHeadingValue = 120;

  static double maxHeadingTitelSizeValue = 22;

  /// Toast message display duration
  static const int messageDisplayDuration = 3000;

  ///space from bottom for buttons
  static const double bottomButtonSpacing = 56;

  ///required days to create PromoCode
  static const int noOfDaysAllowToCreatePromoCode = 365;

  static const int minimumMobileNumberDigit = 6;
  static const int maximumMobileNumberDigit = 15;

  static Locale getLocaleFromLanguageCode(String languageCode) {
    final List<String> result = languageCode.split('-');
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static Future<void> getVibrationEffect() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 100);
    }
  }

  //border radius
  static const double borderRadiusOf5 = 5;
  static const double borderRadiusOf6 = 6;
  static const double borderRadiusOf8 = 8;
  static const double borderRadiusOf10 = 10;
  static const double borderRadiusOf15 = 15;
  static const double borderRadiusOf20 = 20;
  static const double borderRadiusOf50 = 50;

  static Future<dynamic> showModelBottomSheets({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    bool? enableDrag,
    bool? useSafeArea,
    bool? isScrollControlled,
    BoxConstraints? constraints,
  }) async {
    final result = await showModalBottomSheet(
      enableDrag: enableDrag ?? false,
      isScrollControlled: isScrollControlled ?? true,
      useSafeArea: useSafeArea ?? false,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.secondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadiusOf20),
          topRight: Radius.circular(borderRadiusOf20),
        ),
      ),
      context: context,
      builder: (final _) {
        //using backdropFilter to blur the background screen
        //while bottomSheet is open
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: child,
        );
      },
    );

    return result;
  }

  static String getTimeAgo(BuildContext context, {required DateTime? date}) {
    if (date == null) {
      return "";
    }
    // Force incoming date to be treated as UTC
    final utcDate = DateTime.utc(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );

    final localDate = utcDate.toLocal();
    return CustomTimeago.format(
      localDate,
      locale: context.read<LanguageDataCubit>().state is GetLanguageDataSuccess
          ? (context.read<LanguageDataCubit>().state as GetLanguageDataSuccess)
                .currentLanguage
                .languageCode
          : null,
    );
  }

  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Only numbers can be entered
  static List<TextInputFormatter> allowOnlyDigits() {
    return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
  }

  /// Digits with at most [decimals] places; no decimal point when it is 0.
  /// A keystroke that would break that is ignored.
  static TextInputFormatter decimalPlacesFormatter(int decimals) {
    final RegExp pattern = RegExp(
      decimals > 0 ? '^\\d*\\.?\\d{0,$decimals}\$' : r'^\d*$',
    );
    return TextInputFormatter.withFunction(
      (oldValue, newValue) =>
          pattern.hasMatch(newValue.text) ? newValue : oldValue,
    );
  }

  /// Max length of the provider's tax registration number (GST, SIN, VAT...).
  static const int taxRegistrationNumberMaxLength = 50;

  /// Letters, digits, space, `-`, `/` and `.` only.
  static List<TextInputFormatter> taxRegistrationNumberFormatters() {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 \-/.]')),
    ];
  }

  static SystemUiOverlayStyle getSystemUiOverlayStyle({
    required BuildContext context,
    Color? statusBarColor,
    AppTheme? appTheme,
  }) {
    // Use provided theme or get from context
    final currentTheme =
        appTheme ?? context.read<AppThemeCubit>().state.appTheme;

    // Get the appropriate bottom navigation bar color based on theme
    final bottomNavColor = currentTheme == AppTheme.dark
        ? AppColors.darkSecondaryColor
        : AppColors.lightSecondaryColor;

    return SystemUiOverlayStyle(
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: bottomNavColor,
      systemNavigationBarIconBrightness: currentTheme == AppTheme.dark
          ? Brightness.light
          : Brightness.dark,
      statusBarColor:
          statusBarColor ?? Theme.of(context).colorScheme.primaryColor,
      statusBarIconBrightness: currentTheme == AppTheme.dark
          ? Brightness.light
          : Brightness.dark,
    );
  }

  static Future<void> openMap(
    BuildContext context, {
    required dynamic latitude,
    required dynamic longitude,
  }) async {
    final bool isAppleMap = await mapLocationPlatformSelection(context);

    //final String appleMapsUrl = "http://maps.apple.com/?ll=$latitude,$longitude";
    final String appleMapsUrl =
        "https://maps.apple.com/?q=$latitude,$longitude";
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    // Determine primary and fallback URLs based on platform
    final Uri primaryUrl = Uri.parse(isAppleMap ? appleMapsUrl : googleMapsUrl);
    final Uri fallbackUrl = Uri.parse(googleMapsUrl);

    // Try to launch the primary map URL
    if (await canLaunchUrl(primaryUrl)) {
      await launchUrl(primaryUrl, mode: LaunchMode.externalApplication);
    }
    // Fallback for iOS if Apple Maps fails
    else if (Platform.isIOS && await canLaunchUrl(fallbackUrl)) {
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    }
    // Show error if both fail
    else {
      UiUtils.showMessage(
        context,
        'somethingWentWrong',
        ToastificationType.error,
      );
    }
  }

  static Future<bool> mapLocationPlatformSelection(BuildContext context) async {
    if (Platform.isAndroid) return false;
    bool isAppleMap = false;
    await UiUtils.showModelBottomSheets(
      enableDrag: true,
      context: context,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomText(
                'select'.translate(context: context),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: CustomText(
                  'googleMap'.translate(context: context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: CustomText(
                  'appleMap'.translate(context: context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) async {
      if (value != null) {
        isAppleMap = value;
      }
    });
    return isAppleMap;
  }

  static dynamic showDemoModeWarning({required BuildContext context}) {
    return showMessage(context, 'demoModeWarning', ToastificationType.warning);
  }

  static Future<void> share(
    String text, {
    required BuildContext context,
    List<XFile>? files,
    String? subject,
  }) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;

    await SharePlus.instance.share(
      ShareParams(
        files: files,
        text: text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  /// Single source of truth for post-authentication navigation. Routes purely
  /// on the authenticated user's role (stored in Hive) and provider KYC status —
  /// no manual role selection. Used by both login success and the splash screen.
  ///
  /// [clearStack] drops the whole back stack, so back from the landing screen
  /// cannot return to the account type or login screens. Pass it after a login
  /// or registration; the splash screen is the only route below it otherwise.
  static void navigateAfterAuth(
    BuildContext context, {
    bool clearStack = false,
  }) {
    final NavigatorState navigator = Navigator.of(context);

    void goTo(String routeName, {Object? arguments}) {
      if (clearStack) {
        navigator.pushNamedAndRemoveUntil(
          routeName,
          (_) => false,
          arguments: arguments,
        );
      } else {
        navigator.pushReplacementNamed(routeName, arguments: arguments);
      }
    }

    if (HiveRepository.isHandymanSession) {
      goTo(Routes.handymanMain);
      return;
    }

    final providerInformation = context
        .read<ProviderDetailsCubit>()
        .providerDetails
        .providerInformation;

    if (providerInformation?.kycStatus == '1') {
      goTo(Routes.main);
    } else {
      goTo(Routes.registration, arguments: {'isEditing': false});
    }
  }

  static void showMessage(
    BuildContext context,
    String message,
    ToastificationType type, {
    VoidCallback? onMessageClosed,
  }) {
    toastification
      ..dismissAll()
      ..show(
        context: context,
        type: type,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        title: Text(
          message.translate(context: context),
          maxLines: 100,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        alignment: Alignment.bottomCenter,
        direction: ui.TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300),
        // icon: const Icon(Icons.check),
        showIcon: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
          ),
        ],
        showProgressBar: false,
        closeButton: const ToastCloseButton(
          showType: CloseButtonShowType.always,
        ),
        closeOnClick: false,
        pauseOnHover: false,
        dragToClose: true,
        applyBlurEffect: true,
      );

    // Trigger the callback after the duration (if provided)
    if (onMessageClosed != null) {
      Future.delayed(const Duration(seconds: 3), onMessageClosed);
    }
  }

  static String getPaymentStatus(String? paymentMethod) {
    return paymentMethod!.toLowerCase() == "cod"
        ? "codPaid"
        : paymentMethod.toLowerCase();
  }

  static String getPaymentMethod(String? paymentMethod) {
    return paymentMethod!.toLowerCase() == "cod"
        ? "codPaid"
        : paymentMethod.toLowerCase();
  }

  static Color getPaymentStatusColor({required String paymentStatus}) {
    switch (paymentStatus) {
      case "pending":
        return AppColors.pendingPaymentStatusColor;
      case "failed":
        return AppColors.failedPaymentStatusColor;
      case "success" || "completed":
        return AppColors.successPaymentStatusColor;
      case "1":
        return AppColors.successPaymentStatusColor;
      case "2":
        return AppColors.failedPaymentStatusColor;
      case "0":
        return AppColors.pendingPaymentStatusColor;
      default:
        return AppColors.pendingPaymentStatusColor;
    }
  }

  static Future<Object?> showAnimatedDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    final result = await showGeneralDialog(
      context: context,
      pageBuilder: (final context, final animation, final secondaryAnimation) =>
          const CustomContainer(),
      transitionBuilder:
          (
            final context,
            final animation,
            final secondaryAnimation,
            Widget _,
          ) => Transform.scale(
            scale: Curves.easeInOut.transform(animation.value),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: child,
              ),
            ),
          ),
    );
    return result;
  }

  static double inRange({
    required double currentValue,
    required double minValue,
    required double maxValue,
    required double newMaxValue,
    required double newMinValue,
  }) {
    double converatedValue = 0.0;
    converatedValue =
        (currentValue - minValue) /
            (maxValue - minValue) *
            (newMaxValue - newMinValue) +
        newMinValue;
    return converatedValue;
  }

  static Widget getBackArrow(BuildContext context, {VoidCallback? onTap}) {
    return CustomInkWellContainer(
      onTap: () {
        if (onTap != null) {
          onTap.call();
        } else {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: CustomSvgPicture(
            width: 50,
            height: 20,
            svgImage:
                Directionality.of(
                  context,
                ).toString().contains(TextDirection.RTL.value.toLowerCase())
                ? AppAssets.arrowNext
                : AppAssets.backArrowLight,
            color: context.colorScheme.accentColor,
          ),
        ),
      ),
    );
  }

  static AppBar getSimpleAppBar({
    required final BuildContext context,
    final String? title,
    final Widget? titleWidget,
    final Color? backgroundColor,
    final bool? centerTitle,
    final bool? isLeadingIconEnable,
    final double? elevation,
    final List<Widget>? actions,
    final FontWeight? fontWeight,
    final double? fontSize,
    final PreferredSize? bottom,
    final VoidCallback? onTap,
    Color? statusBarColor,
  }) => AppBar(
    leadingWidth: isLeadingIconEnable ?? true ? null : 0,
    surfaceTintColor: context.colorScheme.secondaryColor,
    systemOverlayStyle: UiUtils.getSystemUiOverlayStyle(
      context: context,
      statusBarColor: statusBarColor,
    ),
    leading: isLeadingIconEnable ?? true
        ? getBackArrow(context, onTap: onTap)
        : const SizedBox(),
    shadowColor: Colors.black,
    title: title != null
        ? CustomText(
            title,
            color: context.colorScheme.blackColor,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 16,
          )
        : titleWidget,
    centerTitle: centerTitle ?? false,
    elevation: elevation ?? 0.0,
    backgroundColor: backgroundColor ?? context.colorScheme.secondaryColor,
    actions: actions ?? [],
    bottom: bottom,
  );

  static Color getStatusColor({
    required final BuildContext context,
    required final String statusVal,
  }) {
    switch (statusVal) {
      case "awaiting":
        // return AppColors.awaitingOrderColor;
        return context.colorScheme.blackColor;
      case "pending":
        return AppColors.rescheduledOrderColor;
      case "confirmed" || "approved":
        return AppColors.confirmedOrderColor;
      case "started":
        return AppColors.startedOrderColor;
      case "rescheduled" || "settled": //Rescheduled
        return AppColors.rescheduledOrderColor;
      case "cancelled" || "cancel" || "rejected": //Cancelled
        return AppColors.cancelledOrderColor;
      case "completed":
        return AppColors.completedOrderColor;
      case "booked":
        return AppColors.completedOrderColor;
      case "ended" || "booking_ended":
        return AppColors.startedOrderColor;
      default:
        return AppColors.redColor;
    }
  }

  static String formatDateTime(
    DateTime dateTime, {
    bool convertToLocal = false,
  }) {
    try {
      final languageCode =
          Hive.box(
            HiveRepository.languageBoxKey,
          ).get(HiveRepository.currentLanguageKey)?['code'] ??
          'en';

      if (convertToLocal) {
        // Force incoming date to be treated as UTC
        final utcDate = DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );

        dateTime = utcDate.toLocal();
      }

      if (dateAndTimeSetting["use24HourFormat"]) {
        return DateFormat('dd/MM/yyyy - kk:mm', languageCode).format(dateTime);
      }
      return DateFormat('dd/MM/yyyy - h:mm a', languageCode).format(dateTime);
    } catch (e) {
      if (dateAndTimeSetting["use24HourFormat"]) {
        return DateFormat('dd/MM/yyyy - kk:mm').format(dateTime);
      }
      return DateFormat('dd/MM/yyyy - h:mm a').format(dateTime);
    }
  }

  static String formatTimeWithDateTime(DateTime dateTime) {
    if (dateAndTimeSetting["use24HourFormat"]) {
      return DateFormat("kk:mm").format(dateTime);
    } else {
      return DateFormat("hh:mm a").format(dateTime);
    }
  }

  static Future<void> downloadOrShareFile({
    required String url,
    String? customFileName,
    required bool isDownload,
  }) async {
    try {
      String downloadFilePath = isDownload
          ? (await getApplicationDocumentsDirectory()).path
          : (await getTemporaryDirectory()).path;
      downloadFilePath =
          "$downloadFilePath/${customFileName != null ? customFileName : DateTime.now().toIso8601String()}";

      if (await File(downloadFilePath).exists()) {
        if (isDownload) {
          OpenFile.open(downloadFilePath);
        } else {
          SharePlus.instance.share(
            ShareParams(files: [XFile(downloadFilePath)]),
          );
        }
        return;
      }

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);

      await File(downloadFilePath).writeAsBytes(bytes, flush: !isDownload);
      if (isDownload) {
        OpenFile.open(downloadFilePath);
      } else {
        SharePlus.instance.share(ShareParams(files: [XFile(downloadFilePath)]));
      }
    } catch (_) {}
  }

  //add  gradient color to show in the chart on home screen
  static List<LinearGradient> gradientColorForBarChart = [
    LinearGradient(
      colors: [Colors.green.shade300, Colors.green],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.blue.shade300, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.purple.shade300, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}

//scroll controller extension
extension ScrollEndListen on ScrollController {
  ///It will check if scroll is at the bottom or not
  bool isEndReached() {
    return offset >= position.maxScrollExtent;
  }
}

class AnnotatedSafeArea extends StatefulWidget {
  final Widget child;
  final bool isAnnotated;

  const AnnotatedSafeArea({
    super.key,
    required this.child,
    this.isAnnotated = false,
  });

  @override
  State<AnnotatedSafeArea> createState() => _AnnotatedSafeAreaState();
}

class _AnnotatedSafeAreaState extends State<AnnotatedSafeArea> {
  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      color: context.colorScheme.secondaryColor,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: widget.child,
    );

    if (widget.isAnnotated) {
      content = AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: content,
      );
    }

    return content;
  }
}
