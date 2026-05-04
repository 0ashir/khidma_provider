import 'package:flutter/services.dart';

import '../config.dart';

class TextFieldCommon extends StatefulWidget {
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Color? fillColor;
  final bool obscureText, isMaxLine;
  final double? vertical, radius, hPadding;
  final InputBorder? border;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? maxLength, minLines, maxLines;
  final ValueChanged<String>? onFieldSubmitted;
  final String? counterText, prefixIcon;
  final TextStyle? hintStyle, style;
  final bool? isNumber, isEnable;
  final GestureTapCallback? onTap, prefixTap;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldCommon(
      {super.key,
      required this.hintText,
      this.validator,
      this.controller,
      this.suffixIcon,
      this.prefixIcon,
      this.textInputAction,
      this.border,
      this.obscureText = false,
      this.fillColor,
      this.vertical,
      this.keyboardType,
      this.focusNode,
      this.onChanged,
      this.onFieldSubmitted,
      this.radius,
      this.isNumber = false,
      this.maxLength,
      this.minLines,
      this.maxLines,
      this.counterText,
      this.hintStyle,
      this.style,
      this.hPadding,
      this.isMaxLine = false,
      this.onTap,
      this.isEnable = true,
      this.textCapitalization = TextCapitalization.none,
      this.prefixTap,
      this.inputFormatters});

  @override
  State<TextFieldCommon> createState() => _TextFieldCommonState();
}

class _TextFieldCommonState extends State<TextFieldCommon> {
  bool isFocus = false;

  /* @override
  void initState() {
    // TODO: implement initState

    widget.focusNode!.addListener(() {
      setState(() {});
    });
    super.initState();
  }*/
  @override
  void initState() {
    super.initState();

    // Add focus listener
    widget.focusNode?.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Remove focus listener
    widget.focusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: appColor(context).appTheme.whiteBg),
      child: Consumer<LanguageProvider>(builder: (context, value, child) {
        return TextFormField(
            enabled: widget.isEnable,
            maxLines: widget.maxLines ?? 1,
            textInputAction: widget.textInputAction,
            style: widget.style ??
                appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText),
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            obscureText: widget.obscureText,
            onTap: widget.onTap,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            controller: widget.controller,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            minLines: widget.minLines,
            textCapitalization: widget.textCapitalization,
            cursorColor: appColor(context).appTheme.darkText,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
                counterText: widget.counterText,
                fillColor:
                    widget.fillColor ?? appColor(context).appTheme.whiteBg,
                filled: true,
                isDense: true,
                disabledBorder: widget.border ??
                    OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius ?? AppRadius.r8)),
                        borderSide: BorderSide.none),
                focusedBorder: widget.border ??
                    OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius ?? AppRadius.r8)),
                        borderSide: BorderSide.none),
                enabledBorder: widget.border ??
                    OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius ?? AppRadius.r8)),
                        borderSide: BorderSide.none),
                border: widget.border ??
                    OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius ?? AppRadius.r8)),
                        borderSide: BorderSide.none),
                contentPadding: widget.isMaxLine
                    ? EdgeInsets.only(
                        left: value.getLocal() == 'ar' ? Insets.i15 : Sizes.s45,
                        right:
                            value.getLocal() == 'ar' ? Insets.i40 : Insets.i15,
                        top: Insets.i15,
                        bottom: Insets.i15)
                    : EdgeInsets.symmetric(
                        horizontal: widget.hPadding ?? Insets.i15,
                        vertical: widget.vertical ?? Insets.i15),
                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.isNumber == true
                    ? null
                    : SvgPicture.asset(
                        widget.prefixIcon!,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                            isDark(context)
                                ? appColor(context).appTheme.lightText
                                : appColor(context).appTheme.darkText,
                            BlendMode.srcIn),
                      ).inkWell(onTap: widget.prefixTap),
                hintStyle:
                    widget.hintStyle ?? appCss.dmDenseMedium14.textColor(appColor(context).appTheme.lightText),
                hintText: language(context, widget.hintText),
                errorMaxLines: 2));
      }),
    );
  }
}
