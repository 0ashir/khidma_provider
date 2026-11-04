import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CustomReadMoreTextContainer extends StatelessWidget {
  final String text;
  final int? trimLines;
  final TextStyle? textStyle;

  const CustomReadMoreTextContainer({
    super.key,
    required this.text,
    this.trimLines,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if text is null or empty
    final String trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReadMoreText(
      trimmedText,
      trimLines: trimLines ?? 3,
      trimMode: TrimMode.Line,
      style: textStyle ?? const TextStyle(),
      trimCollapsedText: " ${"showMore".translate(context: context)}",
      trimExpandedText: " ${"showLess".translate(context: context)}",
      lessStyle: TextStyle(
        color: Theme.of(context).colorScheme.accentColor,
        fontSize: textStyle?.fontSize ?? 12,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
      moreStyle: TextStyle(
        color: Theme.of(context).colorScheme.accentColor,
        fontSize: textStyle?.fontSize ?? 12,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
      delimiter: "... ",
      delimiterStyle: textStyle,
    );
  }
}
