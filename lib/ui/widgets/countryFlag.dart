import 'package:edemand_partner/data/model/countryCodeModel.dart';
import 'package:flutter/material.dart';

/// Flag of [country]: its `flag_image` URL, else the emoji for its ISO code,
/// else a flag icon.
///
/// The API sends an empty `flag_image` when no flag file was uploaded, which
/// must not reach `Image.asset` ("Unable to load asset").
class CountryFlag extends StatelessWidget {
  const CountryFlag({super.key, required this.country});

  final CountryCodeModel country;

  /// Regional-indicator emoji for a two-letter ISO code (`SA` -> 🇸🇦).
  static String? emojiFor(String isoCode) {
    final code = isoCode.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return null;
    return String.fromCharCodes(code.codeUnits.map((c) => c - 0x41 + 0x1F1E6));
  }

  Widget _fallback() {
    final emoji = emojiFor(country.countryCode);
    if (emoji == null) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.flag, size: 20),
      );
    }
    return FittedBox(child: Text(emoji));
  }

  @override
  Widget build(BuildContext context) {
    if (!country.flagImage.startsWith('http')) return _fallback();
    return Image.network(
      country.flagImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }
}
