import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.controller,
    this.iconURL,
    super.key,
    this.textInputAction,
    this.currentFocusNode,
    this.nextFocusNode,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.heightVal = 75,
    this.prefix,
    this.hintText,
    this.labelText,
    this.isReadOnly,
    this.callback,
    this.isDense,
    this.hintTextColor,
    this.validator,
    this.forceUnFocus,
    this.onSubmit,
    this.inputFormatters,
    this.expands,
    this.minLines,
    this.labelStyle,
    this.allowOnlySingleDecimalPoint,
    this.suffixIcon,
    this.isDropdown,
    this.borderColor,
    this.maxLength,
    this.suffixText,
    this.textCapitalization,
    this.showFullBorder = false,
    this.fillColor,
    this.iconColor,
    this.bottomPadding,
  }) : assert(
         !(suffixIcon != null && suffixText != null),
         'Only one of suffixIcon or suffixText can be provided.',
       );

  final TextEditingController? controller;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final TextInputType textInputType;
  final bool? isPassword;
  final bool? isDropdown;
  final double? heightVal;
  final Widget? prefix;
  final Widget? suffixIcon;
  final String? suffixText;
  final String? hintText;
  final String? iconURL;
  final String? labelText;
  final bool? isReadOnly;
  final VoidCallback? callback;
  final bool? isDense;
  final Color? hintTextColor;
  final Color? iconColor;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final bool? forceUnFocus;
  final VoidCallback? onSubmit;
  final List<TextInputFormatter>? inputFormatters;
  final bool? expands;
  final int? minLines;
  final int? maxLength;
  final TextStyle? labelStyle;
  final bool? allowOnlySingleDecimalPoint;
  final Color? borderColor;
  final TextCapitalization? textCapitalization;
  final bool showFullBorder;
  final double? bottomPadding;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with SingleTickerProviderStateMixin {
  bool isFocused = false;

  late AnimationController _animationController;
  late Animation<Offset> _animation;

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentFocusNode != null) {
      widget.currentFocusNode?.addListener(_controlledListener);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ), // Match CSS animation duration
    );

    // Create a sequence of movements to match the CSS keyframes
    final shakeSequence = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: Offset.zero),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0.02, 0.0)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0.02, 0.0),
          end: const Offset(-0.02, 0.0),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(-0.02, 0.0),
          end: const Offset(0.02, 0.0),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0.02, 0.0),
          end: const Offset(-0.02, 0.0),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.02, 0.0), end: Offset.zero),
        weight: 24,
      ),
    ]);

    _animation = shakeSequence.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Match CSS ease-in-out
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Run the animation twice to match CSS animation iteration count of 2

        _animationController.reset();
      }
    });
  }

  void shake() {
    if (_animationController.isAnimating) {
      _animationController.reset();
    }
    _animationController.forward();
  }

  IconButton passwordIcon() {
    return IconButton(
      onPressed: () {
        if (mounted) {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        }
      },
      icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
    );
  }

  Widget dropdownIcon() {
    return IconButton(
      onPressed: () {
        widget.callback?.call();
      },
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colorScheme.blackColor,
        size: 24,
      ),
    );
  }

  bool _checkPasswordField() {
    if (widget.isPassword ?? false) {
      // if it is password field.
      // it will check the variable to check if we should show password or not
      return isPasswordVisible == false;
    } else {
      return false;
    }
  }

  InputBorder _buildBorder(
    BuildContext context, {
    required bool isPrimaryBorder,
    bool? isErrorBorder,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: isPrimaryBorder ? 1 : 0.5,
        color:
            widget.borderColor ??
            (isPrimaryBorder
                ? context.colorScheme.accentColor
                : isErrorBorder ?? false
                ? AppColors.redColor
                : context.colorScheme.blackColor.withAlpha(50)),
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: CustomContainer(
        // height: widget.textInputType == TextInputType.multiline
        //     ? 100
        //     : widget.heightVal,
        padding: EdgeInsetsDirectional.only(bottom: widget.bottomPadding ?? 10),
        child: TextFormField(
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          focusNode: widget.currentFocusNode,
          inputFormatters: widget.allowOnlySingleDecimalPoint ?? false
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
              : widget.inputFormatters,
          onFieldSubmitted: (String value) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            } else if (widget.currentFocusNode != null) {
              if (widget.forceUnFocus ?? false) {
                widget.currentFocusNode!.unfocus();
              }
              widget.onSubmit?.call();
            }
          },
          validator: (value) {
            final error = widget.validator?.call(value);
            if (error != null) {
              shake();
              UiUtils.getVibrationEffect();
            }
            return error;
          },
          onTap: widget.callback,
          cursorColor: context.colorScheme.accentColor,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            counterText: widget.maxLength != null ? '' : null,
            constraints: const BoxConstraints(minHeight: 55),
            contentPadding: const EdgeInsets.all(12),
            labelText: widget.labelText,
            labelStyle:
                widget.labelStyle ??
                TextStyle(
                  color: context.colorScheme.blackColor.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
            prefixIcon: widget.prefix != null
                ? widget.prefix
                : widget.iconURL?.isEmpty ?? true
                ? null
                : _buildPrefixIcon(
                    iconName: widget.iconURL!,
                    isFocused: isFocused,
                  ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color:
                  widget.hintTextColor ??
                  context.colorScheme.blackColor.withValues(alpha: 0.6),
            ),
            isDense: widget.isDense ?? true,
            suffixIcon: (widget.suffixText != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 12, right: 12),
                    child: CustomText(
                      widget.suffixText!,
                      color: context.colorScheme.blackColor,
                    ),
                  )
                : (widget.isPassword ?? false)
                ? passwordIcon()
                : (widget.isDropdown ?? false)
                ? dropdownIcon()
                : widget.suffixIcon,
            filled: true,
            fillColor:
                widget.fillColor ??
                context.colorScheme.surfaceDim.withAlpha(20),
            errorStyle: const TextStyle(
              fontSize: 10,
              color: AppColors.redColor,
            ),
            errorBorder: _buildBorder(
              context,
              isPrimaryBorder: false,
              isErrorBorder: true,
            ),
            focusedErrorBorder: _buildBorder(context, isPrimaryBorder: true),
            enabledBorder: _buildBorder(context, isPrimaryBorder: false),
            focusedBorder: _buildBorder(
              context,
              isPrimaryBorder: !(widget.isReadOnly ?? false),
            ),
          ),
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(color: context.colorScheme.blackColor, fontSize: 14),
          readOnly: widget.isReadOnly ?? false,
          keyboardType: widget.textInputType,
          minLines: widget.minLines,
          maxLines: (widget.textInputType == TextInputType.multiline)
              ? ((widget.expands ?? false) ? null : 5)
              : 1,
          //assigned 1 because null is not working with Ob-secureText
          textInputAction:
              widget.textInputAction ??
              ((widget.nextFocusNode != null)
                  ? TextInputAction.next
                  : (widget.textInputType == TextInputType.multiline)
                  ? TextInputAction.newline
                  : TextInputAction.done),
          obscureText: _checkPasswordField(),
          controller: widget.controller,
        ),
      ),
    );
  }

  Widget _buildPrefixIcon({required String iconName, required bool isFocused}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 0, 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSvgPicture(
            svgImage: iconName,
            color:
                widget.iconColor ??
                (isFocused
                    ? context.colorScheme.accentColor
                    : context.colorScheme.blackColor),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller?.removeListener(_controlledListener);
    super.dispose();
  }

  void _controlledListener() {
    if (widget.currentFocusNode!.hasPrimaryFocus) {
      if (mounted) {
        setState(() {
          isFocused = true;
        });
      }
    } else if ((widget.controller?.text ?? '').isEmpty) {
      if (mounted) {
        setState(() {
          isFocused = false;
        });
      }
    }
  }
}
