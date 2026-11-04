import 'dart:math' as math;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class GoogleAnalyticsService {
  const GoogleAnalyticsService._();

  static FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  static Future<void> logEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) async {
    final sanitizedName = _sanitizeIdentifier(
      name,
      maxLength: 40,
      allowPrefix: true,
    );
    if (sanitizedName == null) return;

    try {
      final sanitizedParameters = <String, Object>{};
      if (parameters != null) {
        for (final entry in parameters.entries) {
          final sanitizedKey = _sanitizeIdentifier(entry.key, maxLength: 24);
          if (sanitizedKey == null) continue;
          final sanitizedValue = _coerceValue(entry.value);
          if (sanitizedValue != null) {
            sanitizedParameters[sanitizedKey] = sanitizedValue;
          }
        }
      }
      await _analytics.logEvent(
        name: sanitizedName,
        parameters: sanitizedParameters.isEmpty ? null : sanitizedParameters,
      );
    } catch (error, stackTrace) {
      _debugPrint('logEvent', error, stackTrace);
    }
  }

  static Future<void> setUserId(String userId) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) return;
    try {
      await _analytics.setUserId(id: trimmed);
    } catch (error, stackTrace) {
      _debugPrint('setUserId', error, stackTrace);
    }
  }

  static Future<void> setUserProperty(String key, String value) async {
    final sanitizedKey = _sanitizeIdentifier(key, maxLength: 24);
    final trimmedValue = value.trim();
    if (sanitizedKey == null || trimmedValue.isEmpty) return;

    try {
      await _analytics.setUserProperty(
        name: sanitizedKey,
        value: trimmedValue.length <= 36
            ? trimmedValue
            : trimmedValue.substring(0, 36),
      );
    } catch (error, stackTrace) {
      _debugPrint('setUserProperty', error, stackTrace);
    }
  }

  static Future<void> logScreenView(String screenName) async {
    final sanitizedName = _sanitizeIdentifier(screenName, maxLength: 36);
    if (sanitizedName == null) return;

    try {
      await _analytics.logScreenView(
        screenName: sanitizedName,
        screenClass: sanitizedName,
      );
    } catch (error, stackTrace) {
      _debugPrint('logScreenView', error, stackTrace);
    }
  }

  static String? _sanitizeIdentifier(
    String value, {
    required int maxLength,
    bool allowPrefix = false,
  }) {
    final trimmed = value.trim().toLowerCase();
    if (trimmed.isEmpty) return null;

    final sanitized = trimmed
        .replaceAll(RegExp('[^a-z0-9_]'), '_')
        .replaceAll(RegExp('_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    if (sanitized.isEmpty) return null;

    var candidate = sanitized.substring(
      0,
      math.min(maxLength, sanitized.length),
    );

    if (allowPrefix && _reservedEventNames.contains(candidate)) {
      candidate = 'ce_$candidate';
    }

    if (_reservedEventNames.contains(candidate)) {
      return null;
    }

    return candidate;
  }

  static Object? _coerceValue(Object? value) {
    if (value is num || value is String) return value;
    if (value is bool) return value ? 1 : 0;
    return value?.toString();
  }

  static void _debugPrint(String method, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint(
        '[GoogleAnalyticsService] $method failed: $error\n$stackTrace',
      );
    }
  }

  static const Set<String> _reservedEventNames = {
    'ad_activeview',
    'ad_click',
    'ad_exposure',
    'ad_impression',
    'ad_query',
    'ad_reward',
    'adunit_exposure',
    'app_background',
    'app_clear_data',
    'app_exception',
    'app_install',
    'app_remove',
    'app_store_refund',
    'app_store_subscription_cancel',
    'app_store_subscription_convert',
    'app_store_subscription_renew',
    'app_update',
    'app_upgrade',
    'dynamic_link_app_open',
    'dynamic_link_app_update',
    'dynamic_link_first_open',
    'error',
    'firebase_campaign',
    'firebase_in_app_message_action',
    'firebase_in_app_message_dismiss',
    'firebase_in_app_message_impression',
    'first_open',
    'first_visit',
    'in_app_purchase',
    'notification_dismiss',
    'notification_foreground',
    'notification_open',
    'notification_receive',
    'notification_send',
    'os_update',
    'screen_view',
    'session_start',
    'user_engagement',
  };
}
