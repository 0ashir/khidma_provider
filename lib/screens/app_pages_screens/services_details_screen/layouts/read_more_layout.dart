import 'package:flutter_html/flutter_html.dart';
import '../../../../config.dart';

class ReadMoreLayout extends StatefulWidget {
  final String? text;
  final bool isHtml;
  final Color? color;
  final int trimLines;

  const ReadMoreLayout({
    super.key,
    this.text,
    this.color,
    this.isHtml = false,
    this.trimLines = 4,
  });

  @override
  State<ReadMoreLayout> createState() => _ReadMoreLayoutState();
}

class _ReadMoreLayoutState extends State<ReadMoreLayout> {
  bool isExpanded = false;
  bool isOverflowing = false;

  final double lineHeight = 24.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    if (!mounted) return;

    if (!widget.isHtml) {
      final span = TextSpan(
        text: widget.text ?? '',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.dmSans().fontFamily,
        ),
      );

      final tp = TextPainter(
        text: span,
        maxLines: widget.trimLines,
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: MediaQuery.of(context).size.width);

      final exceeds = tp.didExceedMaxLines;

      if (exceeds != isOverflowing) {
        setState(() => isOverflowing = exceeds);
      }
    } else {
      // HTML height check using RenderBox
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final exceeds = box.size.height > widget.trimLines * lineHeight + 2;

        if (exceeds != isOverflowing) {
          setState(() => isOverflowing = exceeds);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.color ?? appColor(context).appTheme.darkText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                : BoxConstraints(
                    maxHeight: widget.trimLines * lineHeight,
                  ),
            child: widget.isHtml
                ? Html(
                    data: widget.text ?? '',
                    style: {
                      "*": Style(
                        color: textColor,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: FontSize(16),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  )
                : Text(
                    widget.text ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
          ),
        ),

        /// 🔥 Show only if overflow exists
        if (isOverflowing)
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                isExpanded
                    ? language(context, translations!.readLess)
                    : language(context, translations!.readMore),
                style: TextStyle(
                  color: textColor,
                  fontFamily: GoogleFonts.dmSans().fontFamily,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
