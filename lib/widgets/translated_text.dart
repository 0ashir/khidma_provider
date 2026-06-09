import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/languages/language_change.dart';
import '../services/google_translation_service.dart';

/// Drop-in replacement for [Text] that auto-translates dynamic API content
/// via Google Cloud Translation when the user's locale is not English.
/// Shows the original text immediately and updates once the translation arrives.
class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  late String _displayText;

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
    _translate(widget.text);
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() => _displayText = widget.text);
      _translate(widget.text);
    }
  }

  Future<void> _translate(String text) async {
    if (!mounted) return;
    final locale =
        Provider.of<LanguageProvider>(context, listen: false).locale?.languageCode ?? 'en';
    if (locale == 'en' || text.trim().isEmpty) return;
    final translated = await GoogleTranslationService.translate(text, locale);
    if (mounted && translated != _displayText) {
      setState(() => _displayText = translated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
    );
  }
}
