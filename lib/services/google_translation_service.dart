import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleTranslationService {
  static const String _apiKey = 'AIzaSyDb8zk-JshdVYLf3139WSoNZUh5DT6vl1w';
  static const String _endpoint =
      'https://translation.googleapis.com/language/translate/v2';
  static const String _persistKey = 'google_translation_cache_provider';

  static final Map<String, String> _cache = {};
  static bool _dirty = false;

  static String _cacheKey(String text, String lang) => '$lang\x00$text';

  /// Load persisted cache from disk on startup — first screen renders instantly.
  static Future<void> loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_persistKey);
      if (stored != null && stored.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(stored);
        _cache.addAll(decoded.cast<String, String>());
        log('[Translation] loaded ${_cache.length} entries from disk cache');
      }
    } catch (e) {
      log('[Translation] loadCache error: $e');
    }
  }

  static void _persist() {
    if (!_dirty) return;
    _dirty = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_persistKey, jsonEncode(_cache));
    }).catchError((e) {
      log('[Translation] persist error: $e');
    });
  }

  /// Translates [text] to [targetLang]. Source language is auto-detected.
  static Future<String> translate(String text, String targetLang) async {
    if (text.trim().isEmpty) return text;

    final key = _cacheKey(text, targetLang);
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final response = await http
          .post(
            Uri.parse('$_endpoint?key=$_apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'q': text,
              'target': targetLang,
              'format': 'text',
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translated =
            data['data']['translations'][0]['translatedText'] as String;
        _cache[key] = translated;
        _dirty = true;
        _persist();
        return translated;
      }
    } catch (e) {
      log('[Translation] error: $e');
    }
    return text;
  }

  /// Translates a batch of strings in a single API call. Cache hits are skipped.
  static Future<List<String>> translateBatch(
      List<String> texts, String targetLang) async {
    if (texts.isEmpty) return [];

    // Separate cached from uncached, preserving original indices
    final results = List<String>.from(texts);
    final uncachedIndices = <int>[];
    final uncachedTexts = <String>[];

    for (int i = 0; i < texts.length; i++) {
      final key = _cacheKey(texts[i], targetLang);
      if (_cache.containsKey(key)) {
        results[i] = _cache[key]!;
      } else {
        uncachedIndices.add(i);
        uncachedTexts.add(texts[i]);
      }
    }

    if (uncachedTexts.isEmpty) return results;

    try {
      final response = await http
          .post(
            Uri.parse('$_endpoint?key=$_apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'q': uncachedTexts,
              'target': targetLang,
              'format': 'text',
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translations =
            data['data']['translations'] as List<dynamic>;
        for (int j = 0; j < uncachedIndices.length; j++) {
          final translated =
              translations[j]['translatedText'] as String;
          final idx = uncachedIndices[j];
          results[idx] = translated;
          _cache[_cacheKey(texts[idx], targetLang)] = translated;
          _dirty = true;
        }
        _persist();
      }
    } catch (e) {
      log('[Translation] translateBatch error: $e');
    }

    return results;
  }

  /// Clear cache when user switches language so stale translations are discarded.
  static void clearCache() {
    _cache.clear();
    _dirty = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(_persistKey);
    });
    log('[Translation] cache cleared');
  }
}
