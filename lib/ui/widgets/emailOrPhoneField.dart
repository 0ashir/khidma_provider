import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class EmailOrPhoneField extends StatefulWidget {
  const EmailOrPhoneField({
    required this.controller,
    super.key,
    this.bottomPadding,
    this.hintText,
    this.validator,
    this.currentFocusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onSubmit,
    this.forceUnFocus,
    this.fillColor,
    this.hintTextColor,
    this.labelStyle,
    this.isPhoneAuthEnabled = true,
    this.isEmailAuthEnabled = false,
    this.isReadOnly = false,
  });

  final TextEditingController controller;
  final double? bottomPadding;
  final String? hintText;
  final String? Function(String?)? validator;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmit;
  final bool? forceUnFocus;
  final Color? fillColor;
  final Color? hintTextColor;
  final TextStyle? labelStyle;
  final bool isPhoneAuthEnabled;
  final bool isEmailAuthEnabled;
  final bool isReadOnly;

  @override
  State<EmailOrPhoneField> createState() => _EmailOrPhoneFieldState();
}

class _EmailOrPhoneFieldState extends State<EmailOrPhoneField> {
  bool _isPhoneMode = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _checkInputType();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    _checkInputType();
  }

  void _checkInputType() {
    // If both auth methods are not enabled, stick to the enabled one
    if (!widget.isPhoneAuthEnabled && !widget.isEmailAuthEnabled) {
      // Both disabled - fallback to phone
      if (_isPhoneMode != true) {
        setState(() {
          _isPhoneMode = true;
        });
      }
      return;
    }

    if (!widget.isPhoneAuthEnabled) {
      // Only email enabled
      if (_isPhoneMode != false) {
        setState(() {
          _isPhoneMode = false;
        });
      }
      return;
    }

    if (!widget.isEmailAuthEnabled) {
      // Only phone enabled - always stay in phone mode
      if (_isPhoneMode != true) {
        setState(() {
          _isPhoneMode = true;
        });
      }
      return;
    }

    // Both enabled - auto-detect based on input
    final String text = widget.controller.text;

    // If field is empty, default to phone mode (show country code prefix)
    // If user enters any non-numeric character, switch to email mode
    bool shouldBePhoneMode;
    if (text.isEmpty) {
      shouldBePhoneMode = true; // Default to phone when empty (shows prefix)
    } else {
      shouldBePhoneMode = _isNumeric(text); // Switch to email if non-numeric
    }

    if (shouldBePhoneMode != _isPhoneMode) {
      setState(() {
        _isPhoneMode = shouldBePhoneMode;
      });
    }
  }

  bool _isNumeric(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  List<TextInputFormatter>? _getInputFormatters() {
    // If only phone is enabled, always restrict to digits
    if (widget.isPhoneAuthEnabled && !widget.isEmailAuthEnabled) {
      return UiUtils.allowOnlyDigits();
    }

    // If only email is enabled, allow all characters
    if (!widget.isPhoneAuthEnabled && widget.isEmailAuthEnabled) {
      return null;
    }

    // If both are enabled, allow all characters to support mixed formats like 123@gmail.com
    return null;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldMustNotBeEmpty'.translate(context: context);
    }

    // Validate based on which auth methods are enabled
    if (widget.isPhoneAuthEnabled && widget.isEmailAuthEnabled) {
      // Both enabled - validate based on detected mode
      if (_isPhoneMode) {
        return Validator.validateNumber(context, value);
      } else {
        return Validator.validateEmail(context, value);
      }
    } else if (widget.isPhoneAuthEnabled) {
      // Only phone enabled
      return Validator.validateNumber(context, value);
    } else if (widget.isEmailAuthEnabled) {
      // Only email enabled
      return Validator.validateEmail(context, value);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Determine hint text based on enabled auth methods
    String defaultHintText;
    if (widget.isPhoneAuthEnabled && widget.isEmailAuthEnabled) {
      defaultHintText = 'enterEmailOrPhone'.translate(context: context);
    } else if (widget.isPhoneAuthEnabled) {
      defaultHintText = 'enterMobileNumber'.translate(context: context);
    } else if (widget.isEmailAuthEnabled) {
      defaultHintText = 'enterEmail'.translate(context: context);
    } else {
      defaultHintText = 'enterMobileNumber'.translate(context: context);
    }

    return CustomTextFormField(
      bottomPadding: widget.bottomPadding ?? 0,
      controller: widget.controller,
      textInputType: widget.isEmailAuthEnabled
          ? TextInputType.emailAddress
          : TextInputType.phone,
      inputFormatters: _getInputFormatters(),
      isDense: false,
      validator: widget.validator ?? _validateInput,
      labelStyle:
          widget.labelStyle ??
          TextStyle(
            color: Theme.of(context).colorScheme.blackColor,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
      fillColor: widget.fillColor ?? Colors.transparent,
      hintText: widget.hintText ?? defaultHintText,
      hintTextColor:
          widget.hintTextColor ?? Theme.of(context).colorScheme.lightGreyColor,
      currentFocusNode: widget.currentFocusNode,
      nextFocusNode: widget.nextFocusNode,
      textInputAction: widget.textInputAction,
      onSubmit: widget.onSubmit,
      forceUnFocus: widget.forceUnFocus,
      isReadOnly: widget.isReadOnly,
      prefix: (_isPhoneMode && widget.isPhoneAuthEnabled)
          ? _buildCountryCodePrefix()
          : null,
    );
  }

  Widget _buildCountryCodePrefix() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12.0, bottom: 2),
      child: BlocBuilder<CountryCodeCubit, CountryCodeState>(
        builder: (BuildContext context, CountryCodeState state) {
          String code = '--';

          if (state is CountryCodeFetchSuccess) {
            code = state.selectedCountry!.callingCode;
          }

          return SizedBox(
            height: 27,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInkWellContainer(
                  onTap: () {
                    if (widget.isReadOnly ||
                        allowOnlySingleCountry ||
                        (state is CountryCodeFetchSuccess &&
                            state.temporaryCountryList != null &&
                            state.temporaryCountryList!.length == 1)) {
                      return;
                    }
                    Navigator.pushNamed(
                      context,
                      Routes.countryCodePickerRoute,
                    ).then((Object? value) {
                      Future.delayed(const Duration(milliseconds: 250)).then((
                        value,
                      ) {
                        context.read<CountryCodeCubit>().fillTemporaryList();
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          if (state is CountryCodeFetchSuccess) {
                            return SizedBox(
                              width: 35,
                              height: 27,
                              child: CountryFlag(
                                country: state.selectedCountry!,
                              ),
                            );
                          }
                          if (state is CountryCodeFetchFail) {
                            return ErrorContainer(
                              errorMessage: state.error.toString().translate(
                                context: context,
                              ),
                            );
                          }
                          return const CustomCircularProgressIndicator();
                        },
                      ),
                      const SizedBox(width: 10),
                      if (!widget.isReadOnly &&
                          !allowOnlySingleCountry &&
                          !(state is CountryCodeFetchSuccess &&
                              state.temporaryCountryList != null &&
                              state.temporaryCountryList!.length == 1))
                        CustomSvgPicture(
                          svgImage: AppAssets.spDown,
                          height: 5,
                          width: 5,
                          color: Theme.of(context).colorScheme.accentColor,
                        ),
                    ],
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  indent: 6,
                  endIndent: 6,
                  color: Theme.of(context).colorScheme.lightGreyColor,
                ),
                Text(
                  code,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 5),
              ],
            ),
          );
        },
      ),
    );
  }
}
