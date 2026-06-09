import 'dart:developer';
import 'package:dio/dio.dart';
import 'google_translation_service.dart';
import 'environment.dart';

/// Dio interceptor that automatically translates human-readable string fields
/// in every API response when the user's locale is not English.
///
/// Only field names listed in [_translatableKeys] are translated — slugs,
/// URLs, IDs, tokens, and other machine-readable values are left untouched.
/// All translations are cached by [GoogleTranslationService], so a given
/// string is only sent to Google once per language.
class TranslationInterceptor extends Interceptor {
  /// Field names whose string values should be translated.
  static const _translatableKeys = {
    'title',
    'name',
    'description',
    'area',
    'city',
    'address',
    'street_address',
    'message',
    'content',
    'note',
    'reason',
    'label',
    'heading',
    'subtitle',
    'text',
    'tag',
    'detail',
    'alternative_name',
    'bank_name',
    'holder_name',
    'branch_name',
    'categories', // string form when backend returns a plain string
  };

  @override
  void onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    try {
      final locale = sharedPreferences.getString('selectedLocale') ?? 'en';

      if (locale != 'en' && response.data != null) {
        // ── Pass 1: collect every translatable string and its path ──────────
        final texts = <String>[];
        final paths = <List<dynamic>>[];
        _collect(response.data, [], texts, paths);

        if (texts.isNotEmpty) {
          log('[TranslationInterceptor] translating ${texts.length} strings → $locale');

          // ── Pass 2: batch-translate (cache handles duplicates) ──────────
          final translated =
              await GoogleTranslationService.translateBatch(texts, locale);

          // ── Pass 3: write translated values back into the response data ──
          for (int i = 0; i < paths.length; i++) {
            _setAtPath(response.data, paths[i], translated[i]);
          }
        }
      }
    } catch (e, s) {
      log('[TranslationInterceptor] error: $e\n$s');
    }
    handler.next(response);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _collect(dynamic node, List<dynamic> path, List<String> texts,
      List<List<dynamic>> paths) {
    if (node is Map) {
      for (final entry in node.entries) {
        final childPath = [...path, entry.key];
        if (entry.value is String &&
            _translatableKeys.contains(entry.key) &&
            _isTranslatable(entry.value as String)) {
          texts.add(entry.value as String);
          paths.add(childPath);
        } else {
          _collect(entry.value, childPath, texts, paths);
        }
      }
    } else if (node is List) {
      for (int i = 0; i < node.length; i++) {
        _collect(node[i], [...path, i], texts, paths);
      }
    }
  }

  void _setAtPath(dynamic root, List<dynamic> path, String value) {
    dynamic node = root;
    for (int i = 0; i < path.length - 1; i++) {
      final key = path[i];
      node = (node is Map) ? node[key] : (node as List)[key as int];
      if (node == null) return;
    }
    final last = path.last;
    if (node is Map) {
      node[last] = value;
    } else if (node is List && last is int) {
      node[last] = value;
    }
  }

  bool _isTranslatable(String text) {
    if (text.trim().length < 2) return false;
    if (text.startsWith('http')) return false; // URLs
    if (RegExp(r'^\d+$').hasMatch(text)) return false; // pure numbers
    if (text.contains('@')) return false; // emails
    if (RegExp(r'^\+?\d[\d\s\-]+$').hasMatch(text)) return false; // phones
    return true;
  }
}
