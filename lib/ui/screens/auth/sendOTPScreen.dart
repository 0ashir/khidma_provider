import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class SendOTPScreen extends StatefulWidget {
  const SendOTPScreen({
    super.key,
    required this.screenTitle,
    required this.screenSubTitle,
    this.userType = UserType.provider,
  });

  final String screenTitle;
  final String screenSubTitle;
  final UserType userType;

  @override
  State<SendOTPScreen> createState() => _SendOTPScreenState();

  static Route route(RouteSettings routeSettings) {
    final Map<String, dynamic> arguments =
        routeSettings.arguments as Map<String, dynamic>;

    return CupertinoPageRoute(
      builder: (_) {
        return SendOTPScreen(
          screenTitle: arguments['screenTitle'],
          screenSubTitle: arguments['screenSubTitle'],
          userType: (arguments['userType'] as UserType?) ?? UserType.provider,
        );
      },
    );
  }
}

class _SendOTPScreenState extends State<SendOTPScreen> {
  String phoneNumberWithCountryCode = '';
  String phoneNumberWithoutCountryCode = '';
  String countryCode = '';
  String? email;

  final GlobalKey<FormState> verifyPhoneNumberFormKey = GlobalKey<FormState>();
  final TextEditingController _numberFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _numberFieldController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onContinueButtonClicked() {
    UiUtils.removeFocus();

    final bool isvalidNumber = verifyPhoneNumberFormKey.currentState!
        .validate();

    if (isvalidNumber) {
      final String input = _numberFieldController.text;
      final bool isPhone = RegExp(r'^[0-9]+$').hasMatch(input);

      if (isPhone) {
        final String countryCallingCode = context
            .read<CountryCodeCubit>()
            .getSelectedCountryCode();

        phoneNumberWithCountryCode =
            countryCallingCode + _numberFieldController.text;
        phoneNumberWithoutCountryCode = _numberFieldController.text;
        countryCode = countryCallingCode;
        email = null;

        context.read<VerifyPhoneNumberFromAPICubit>().verifyPhoneNumberFromAPI(
          mobileNumber: phoneNumberWithoutCountryCode,
          countryCode: countryCode,
          loginType: LoginType.phone.value,
        );
      } else {
        email = input;
        phoneNumberWithCountryCode = '';
        phoneNumberWithoutCountryCode = '';
        countryCode = '';

        context.read<VerifyPhoneNumberFromAPICubit>().verifyPhoneNumberFromAPI(
          email: email,
          loginType: LoginType.email.value,
        );
      }
    }
  }

  Padding _buildPhoneNumberFiled() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10.0, bottom: 25),
      child: EmailOrPhoneField(
        controller: _numberFieldController,
        bottomPadding: 0,
        fillColor: Colors.transparent,
        hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
        textInputAction: TextInputAction.done,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.blackColor,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        isPhoneAuthEnabled: context
            .read<FetchSystemSettingsCubit>()
            .isPhoneAuthEnabled,
        isEmailAuthEnabled: context
            .read<FetchSystemSettingsCubit>()
            .isEmailAuthEnabled,
      ),
    );
  }

  Widget _buildHeading() {
    return Text(
      widget.screenTitle.translate(context: context),
      style: TextStyle(
        color: Theme.of(context).colorScheme.blackColor,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 28.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubHeading() {
    return Text(
      widget.screenSubTitle.translate(context: context),
      style: TextStyle(
        color: Theme.of(context).colorScheme.blackColor.withValues(alpha: 0.5),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 16.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        //appBar: UiUtils.getSimpleAppBar(context: context, elevation: 1),
        body: Form(
          key: verifyPhoneNumberFormKey,
          child: CustomContainer(
            height: context.screenHeight,
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40),
                    CustomSvgPicture(
                      svgImage: AppAssets.loginLogoFor(widget.userType),
                      width: 240,
                      height: 100,
                      boxFit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    _buildHeading(),
                    const SizedBox(height: 8),
                    _buildSubHeading(),
                    const SizedBox(height: 40),
                    _buildPhoneNumberFiled(),
                    _buildContinueButton(),
                    const SizedBox(height: 40),
                    Expanded(child: _buildPrivacyPolicyAndTnCContainer()),
                    const SizedBox(height: 10),
                  ],
                ),
                if (Navigator.canPop(context))
                  PositionedDirectional(
                    top: MediaQuery.of(context).padding.top,
                    start: 0,
                    child: UiUtils.getBackArrow(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocConsumer<
      VerifyPhoneNumberFromAPICubit,
      VerifyPhoneNumberFromAPIState
    >(
      listener: (BuildContext context, VerifyPhoneNumberFromAPIState state) async {
        if (state is VerifyPhoneNumberFromAPIFailure) {
          UiUtils.showMessage(
            context,
            state.errorMessage,
            ToastificationType.error,
          );
        }
        if (state is VerifyPhoneNumberFromAPISuccess) {
          //messageCode
          // 101:- Mobile number already registered and Active
          // 102:- Mobile number is not registered
          // 103:- Mobile number is De-active
          // 104:- Email already registered and Active
          // 105:- Email is not registered
          // 106:- Email is De-active

          final bool isNewUser = widget.screenTitle != 'forgotPassword';

          if (state.messageCode == '101' && isNewUser) {
            UiUtils.showMessage(
              context,
              'mobileAlreadyRegistered',
              ToastificationType.error,
            );
          } else if (state.messageCode == '102' && !isNewUser) {
            UiUtils.showMessage(
              context,
              'mobileNumberIsNotRegistered',
              ToastificationType.error,
            );
          } else if (state.messageCode == '103') {
            UiUtils.showMessage(
              context,
              'mobileNumberIsDeactivate',
              ToastificationType.error,
            );
          } else if (state.messageCode == '104' && isNewUser) {
            UiUtils.showMessage(
              context,
              'emailAlreadyRegistered',
              ToastificationType.error,
            );
          } else if (state.messageCode == '105' && !isNewUser) {
            UiUtils.showMessage(
              context,
              'emailIsNotRegistered',
              ToastificationType.error,
            );
          } else if (state.messageCode == '106') {
            UiUtils.showMessage(
              context,
              'emailIsDeactivate',
              ToastificationType.error,
            );
          } else {
            // If email is provided, always use SMS gateway API (which handles email OTP)
            // Firebase is only for phone number authentication
            if (email != null && email!.isNotEmpty) {
              context
                  .read<SendVerificationCodeCubit>()
                  .sendVerificationCodeUsingSMSGateway(
                    phoneNumberWithoutCountryCode:
                        phoneNumberWithoutCountryCode,
                    countryCode: context
                        .read<CountryCodeCubit>()
                        .getSelectedCountryCode(),
                    phoneNumberWithCountryCode: phoneNumberWithCountryCode,
                    email: email,
                    loginType: LoginType.email.value,
                  );
            } else if (state.authenticationMode == 'sms_gateway') {
              context
                  .read<SendVerificationCodeCubit>()
                  .sendVerificationCodeUsingSMSGateway(
                    phoneNumberWithoutCountryCode:
                        phoneNumberWithoutCountryCode,
                    countryCode: context
                        .read<CountryCodeCubit>()
                        .getSelectedCountryCode(),
                    phoneNumberWithCountryCode: phoneNumberWithCountryCode,
                    email: email,
                    loginType: LoginType.phone.value,
                  );
            } else {
              context
                  .read<SendVerificationCodeCubit>()
                  .sendVerificationCodeUsingFirebase(
                    phoneNumber: phoneNumberWithCountryCode,
                    countryCode: context
                        .read<CountryCodeCubit>()
                        .getSelectedCountryCode(),
                    phoneNumberWithCountryCode: phoneNumberWithCountryCode,
                  );
            }
          }
        }
      },
      builder: (BuildContext context, VerifyPhoneNumberFromAPIState state) {
        return BlocConsumer<
          SendVerificationCodeCubit,
          SendVerificationCodeState
        >(
          listener:
              (
                BuildContext context,
                SendVerificationCodeState verifyPhoneNumberState,
              ) {
                if (verifyPhoneNumberState
                    is SendVerificationCodeSuccessState) {
                  // Show different message based on whether email or phone was used
                  final String message = (email != null && email!.isNotEmpty)
                      ? 'codeHasBeenSentToYourEmail'
                      : 'codeHasBeenSentToYourMobileNumber';

                  UiUtils.showMessage(
                    context,
                    message,
                    ToastificationType.success,
                  );
                  final String authenticationMode =
                      verifyPhoneNumberState.authenticationMode;
                  context.read<SendVerificationCodeCubit>().setInitialState();

                  Navigator.pushNamed(
                    context,
                    Routes.otpVerificationRoute,
                    arguments: {
                      'phoneNumberWithCountryCode': phoneNumberWithCountryCode,
                      'phoneNumberWithOutCountryCode':
                          phoneNumberWithoutCountryCode,
                      'countryCode': context
                          .read<CountryCodeCubit>()
                          .getSelectedCountryCode(),
                      'isItForForgotPassword':
                          widget.screenTitle == 'forgotPassword',
                      "authenticationMode": authenticationMode,
                      'email': email,
                      'loginType': email != null && email!.isNotEmpty
                          ? LoginType.email.value
                          : LoginType.phone.value,
                      'userType': widget.userType,
                    },
                  );
                } else if (verifyPhoneNumberState
                    is SendVerificationCodeFailureState) {
                  String errorMessage = '';

                  errorMessage = verifyPhoneNumberState.error
                      .toString()
                      .translate(context: context);
                  UiUtils.showMessage(
                    context,
                    errorMessage,
                    ToastificationType.error,
                  );
                }
              },
          builder:
              (
                BuildContext context,
                SendVerificationCodeState verifyPhoneNumberState,
              ) {
                final bool isLoading =
                    verifyPhoneNumberState
                        is SendVerificationCodeInProgressState ||
                    state is VerifyPhoneNumberFromAPIInProgress;

                return CustomRoundedButton(
                  height: 50,
                  onTap: () async {
                    if (verifyPhoneNumberState
                        is SendVerificationCodeInProgressState) {
                      return;
                    }
                    _onContinueButtonClicked();
                  },
                  buttonTitle: 'continue'.translate(context: context),
                  widthPercentage: 0.9,
                  backgroundColor: Theme.of(context).colorScheme.accentColor,
                  showBorder: false,
                  child: isLoading
                      ? CustomCircularProgressIndicator(
                          color: AppColors.whiteColors,
                        )
                      : null,
                );
              },
        );
      },
    );
  }

  Widget _buildPrivacyPolicyAndTnCContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'byContinueYouAccept'.translate(context: context),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.lightGreyColor,
              fontSize: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomInkWellContainer(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.customPageDetailsRoute,
                      arguments: {
                        'title': 'privacyPolicyLbl',
                        'pageKey': 'privacy_policy',
                      },
                    );
                  },
                  child: Text(
                    'privacyPolicyLbl'.translate(context: context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  ' & ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontSize: 12,
                  ),
                ),
                CustomInkWellContainer(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.customPageDetailsRoute,
                      arguments: {
                        'title': 'termsConditionLbl',
                        'pageKey': 'terms_conditions',
                      },
                    );
                  },
                  child: Text(
                    'termsConditionLbl'.translate(context: context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
