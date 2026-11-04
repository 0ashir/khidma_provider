import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomPasswordFieldWithValidators extends StatefulWidget {
  const CustomPasswordFieldWithValidators({
    required this.controller,
    super.key,
    this.textInputAction,
    this.currentFocusNode,
    this.nextFocusNode,
    this.labelText,
    this.hintText,
    this.validator,
    this.bottomPadding,
    this.fillColor,
    this.hintTextColor,
    this.labelStyle,
    this.isDense,
  });

  final TextEditingController controller;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final double? bottomPadding;
  final Color? fillColor;
  final Color? hintTextColor;
  final TextStyle? labelStyle;
  final bool? isDense;

  @override
  State<CustomPasswordFieldWithValidators> createState() =>
      _CustomPasswordFieldWithValidatorsState();
}

class _CustomPasswordFieldWithValidatorsState
    extends State<CustomPasswordFieldWithValidators> {
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePassword);
    super.dispose();
  }

  void _validatePassword() {
    final password = widget.controller.text;

    setState(() {
      hasMinLength =
          password.length >=
          (context
                  .read<FetchSystemSettingsCubit>()
                  .loginSettings
                  ?.minumumPasswordLength ??
              0);
      hasUppercase = password.contains(RegExp('[A-Z]'));
      hasLowercase = password.contains(RegExp('[a-z]'));
      hasNumber = password.contains(RegExp('[0-9]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginSettings = context
        .read<FetchSystemSettingsCubit>()
        .loginSettings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          controller: widget.controller,
          labelText: widget.labelText,
          hintText: widget.hintText,
          isPassword: true,
          textInputAction: widget.textInputAction,
          currentFocusNode: widget.currentFocusNode,
          nextFocusNode: widget.nextFocusNode,
          validator: widget.validator,
          bottomPadding: 0,
          fillColor: widget.fillColor,
          hintTextColor: widget.hintTextColor,
          labelStyle: widget.labelStyle,
          isDense: widget.isDense,
        ),
        if (loginSettings != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                if (loginSettings.minumumPasswordLength != null)
                  _buildValidationItem(
                    "${"passwordMustBeAtLeastChars".translate(context: context)} ${loginSettings.minumumPasswordLength!} ${"characterLong".translate(context: context)}",
                    hasMinLength,
                  ),
                if (loginSettings.requireAtLeastOneUppercase == true)
                  _buildValidationItem(
                    'passwordMustHaveUppercase'.translate(context: context),
                    hasUppercase,
                  ),
                if (loginSettings.requireAtLeastOneLowercase == true)
                  _buildValidationItem(
                    'passwordMustHaveLowercase'.translate(context: context),
                    hasLowercase,
                  ),
                if (loginSettings.requireAtLeastOneNumber == true)
                  _buildValidationItem(
                    'passwordMustHaveNumber'.translate(context: context),
                    hasNumber,
                  ),
                if (loginSettings.requireAtLeastOneSpecialCharacter == true)
                  _buildValidationItem(
                    'passwordMustHaveSpecialChar'.translate(context: context),
                    hasSpecialChar,
                  ),
              ],
            ),
          ),
        if (widget.bottomPadding != null && widget.bottomPadding! > 0)
          SizedBox(height: widget.bottomPadding),
      ],
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    final greyColor = Theme.of(context).colorScheme.lightGreyColor;
    const greenColor = AppColors.greenColor;

    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            key: ValueKey(isValid),
            size: 16,
            color: isValid ? greenColor : greyColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 300),
            tween: ColorTween(
              begin: greyColor,
              end: isValid ? greenColor : greyColor,
            ),
            builder: (context, color, child) {
              return Text(text, style: TextStyle(fontSize: 12, color: color));
            },
          ),
        ),
      ],
    );
  }
}
