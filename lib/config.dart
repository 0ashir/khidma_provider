import 'dart:developer';

import 'package:fixit_provider/model/translation_model.dart';
import 'package:fixit_provider/services/api_methods.dart';
import 'package:fixit_provider/services/api_service.dart';
export 'package:fixit_provider/widgets/common_list_index.dart';
export 'package:fixit_provider/common_shimmer/shimmer_list.dart';

import '../common/app_array.dart';
import '../common/app_fonts.dart';
import '../common/languages/app_language.dart';
import '../common/session.dart';
import '../helper/navigation_class.dart';
export 'package:fixit_provider/widgets/common_empty.dart';

import 'config.dart';
export '../packages_list.dart';
export 'package:flutter/material.dart';
export '../routes/index.dart';
export '../common/assets/index.dart';
export '../providers/index.dart';
export '../common/extension/text_style_extensions.dart';
export '../widgets/common_state.dart';
export '../common/extension/spacing.dart';
export '../common/theme/app_css.dart';
export '../common/extension/widget_extension.dart';
export '../../routes/screen_list.dart';
export '../common/theme/theme_service.dart';
export '../utils/general_utils.dart';
export 'package:fixit_provider/services/common_list_services.dart';

export '../helper/alert_class.dart';
export 'package:fixit_provider/model/index.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum NotificationType {
  createBookingEvent,
  updateBookingStatusEvent,
  assignBooking,
  createProvider,
  extraChargeEvent,
  addServiceProofEvent,
  updateServiceProofEvent,
  createBid,
  createServicemanWithdraw,
  createWithdrawRequest
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.createBookingEvent:
        return "createBookingEvent";
      case NotificationType.updateBookingStatusEvent:
        return "updateBookingStatusEvent";
      case NotificationType.assignBooking:
        return "assignBooking";
      case NotificationType.createProvider:
        return "createProvider";
      case NotificationType.extraChargeEvent:
        return "extraChargeEvent";
      case NotificationType.addServiceProofEvent:
        return "addServiceProofEvent";
      case NotificationType.updateServiceProofEvent:
        return "UpdateServiceProofEvent";
      case NotificationType.createBid:
        return "createBid";
      case NotificationType.createServicemanWithdraw:
        return "createServicemanWithdraw";
      case NotificationType.createWithdrawRequest:
        return "createWithdrawRequest";
    }
  }
}

Future<void> createBookingNotification(NotificationType type) async {
  log("Calling API for type: ${type.value}");
  try {
    final response = await apiServices
        .getApi("${api.notification}?type=${type.value}", [], isToken: true);

    if (response.isSuccess!) {
      log("Notification success: ${response.message}");
    } else {
      log("Notification failed");
    }
  } catch (e) {
    log("Error in notification: $e");
  }
}

ThemeService appColor(context) {
  final themeServices = Provider.of<ThemeService>(context, listen: false);
  return themeServices;
}

CurrencyProvider currency(context) {
  final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
  return currencyData;
}

getSymbol(context) {
/* log("=-=-=-=-=-Currancy${zoneIds == zoneList.asMap().entries.map((e)=> e.value.id)}"); */

  final currencyData =
      Provider.of<CurrencyProvider>(context, listen: true).priceSymbol;

  return currencyData;
}

showLoading(context) async {
  if (context.mounted) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Provider.of<LoadingProvider>(context, listen: false).showLoading();
      }
    });
  }
}

hideLoading(context) async {
  if (context.mounted) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Provider.of<LoadingProvider>(context, listen: false).hideLoading();
      }
    });
  }
}

String language(context, String? text) {
  return AppLocalizations.of(context)!.translate(text ?? "");
}

bool rtl(BuildContext context) {
  final languageProvider = context.watch<LanguageProvider>();
  return languageProvider.locale?.languageCode == 'ar';
}

bool isDark(context) {
  final themeServices = Provider.of<ThemeService>(context, listen: false);

  return themeServices.isDarkMode;
}

int themeIndex(context) {
  final themeServices = Provider.of<ThemeService>(context, listen: false);

  return themeServices.themeIndex;
}

Session session = Session();
AppFonts appFonts = AppFonts();
NavigationClass route = NavigationClass();
AppArray appArray = AppArray();
Validation validation = Validation();
AppCss appCss = AppCss();
TextCommon textCommon = TextCommon();
ApiServices apiServices = ApiServices();
ApiMethods api = ApiMethods();
CollectionName collectionName = CollectionName();
Translation? translations;
AppSettingModel? appSettingModel;
