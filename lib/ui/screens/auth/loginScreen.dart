import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.userType = UserType.provider});

  final UserType userType;

  static Route route(RouteSettings settings) {
    final Map<String, dynamic>? arguments =
        settings.arguments as Map<String, dynamic>?;
    return CupertinoPageRoute(
      builder: (BuildContext context) => LoginScreen(
        userType: (arguments?['userType'] as UserType?) ?? UserType.provider,
      ),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  late UserType _userType;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userType = widget.userType;
    _fillDemoCredentials();
  }

  void _fillDemoCredentials() {
    final bool isDemoModeEnabled = context
        .read<FetchSystemSettingsCubit>()
        .isDemoModeEnable;
    if (!isDemoModeEnabled) return;

    if (_userType.isHandyman) {
      _emailOrPhoneController.text = "1231231231";
      _passwordController.text = "Test@123";
    } else {
      _emailOrPhoneController.text = "1234567890";
      _passwordController.text = "12345678";
    }
  }

  Future<void> _onLoginButtonClick() async {
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState!.validate()) {
      final String input = _emailOrPhoneController.text;
      final bool isPhone = RegExp(r'^[0-9]+$').hasMatch(input);

      String? fcmId;
      try {
        fcmId = await FirebaseMessaging.instance.getToken() ?? '';
      } catch (_) {}

      if (isPhone) {
        // Login with phone number
        final String countryCallingCode = context
            .read<CountryCodeCubit>()
            .getSelectedCountryCode();
        context.read<SignInCubit>().signIn(
          phoneNumber: input,
          password: _passwordController.text,
          countryCode: countryCallingCode,
          fcmId: fcmId,
          loginType: LoginType.phone.value,
          requestedUserType: _userType,
        );
      } else {
        // Login with email
        context.read<SignInCubit>().signIn(
          email: input,
          password: _passwordController.text,
          fcmId: fcmId,
          loginType: LoginType.email.value,
          requestedUserType: _userType,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: BlocConsumer<SignInCubit, SignInState>(
          listener: (BuildContext context, SignInState state) async {
            if (state is SignInSuccess) {
              if (state.error) {
                UiUtils.showMessage(
                  context,
                  state.message,
                  ToastificationType.error,
                );
                return;
              }

              HiveRepository.setUserLoggedIn = true;

              // Provider sessions seed the provider details cubit; handyman
              // sessions don't have ProviderDetails.
              if (state.userType.isProvider) {
                context.read<ProviderDetailsCubit>().setUserInfo(
                  state.providerDetails,
                );
              }

              // Currency, date and time format of this account's country.
              context.read<FetchCountrySettingsCubit>().fetch();

              // Role-based navigation is centralized in UiUtils.
              Future.delayed(Duration.zero, () {
                UiUtils.navigateAfterAuth(context, clearStack: true);
              });
            }
            if (state is SignInFailure) {
              Future.delayed(Duration.zero, () {
                UiUtils.showMessage(
                  context,
                  state.errorMessage,
                  ToastificationType.error,
                );
              });
            }
          },
          builder: (BuildContext context, SignInState state) {
            return Form(
              key: _loginFormKey,
              child: SingleChildScrollView(
                child: CustomContainer(
                  height: context.screenHeight - (Platform.isAndroid ? 0 : 8),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CustomSvgPicture(
                        svgImage: AppAssets.loginLogoFor(_userType),
                        width: 240,
                        height: 100,
                        boxFit: BoxFit.contain,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        (_userType.isHandyman
                                ? 'welcome-handyman'
                                : 'welcome-provider')
                            .translate(context: context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      EmailOrPhoneField(
                        controller: _emailOrPhoneController,
                        bottomPadding: 0,
                        fillColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        hintTextColor: Theme.of(
                          context,
                        ).colorScheme.lightGreyColor,
                        isPhoneAuthEnabled: context
                            .read<FetchSystemSettingsCubit>()
                            .isPhoneAuthEnabled,
                        isEmailAuthEnabled: context
                            .read<FetchSystemSettingsCubit>()
                            .isEmailAuthEnabled,
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        bottomPadding: 0,
                        controller: _passwordController,
                        isDense: false,
                        // isRoundedBorder: true,
                        isPassword: true,
                        validator: (String? value) =>
                            Validator.nullCheck(context, value),
                        fillColor: Colors.transparent,
                        hintText: 'enterYourPassword'.translate(
                          context: context,
                        ),
                        hintTextColor: Theme.of(
                          context,
                        ).colorScheme.lightGreyColor,
                      ),
                      const SizedBox(height: 8),
                      buildForgotPasswordLabel(),
                      const SizedBox(height: 20),
                      buildLoginButton(
                        context,
                        showProgress: state is SignInInProgress,
                      ),
                      const SizedBox(height: 16),
                      buildOtherLoginOption(),
                      if (_userType.isProvider) ...[
                        const SizedBox(height: 25),
                        buildNewRegistrationContainer(),
                      ],
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'byContinueYouAccept'.translate(context: context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.blackColor.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                top: 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomInkWellContainer(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.customPageDetailsRoute,
                                        arguments: {
                                          'title': 'termsConditionLbl',
                                          'pageKey': _userType.isHandyman
                                              ? 'handyman_terms_conditions'
                                              : 'terms_conditions',
                                          'userType': _userType,
                                        },
                                      );
                                    },
                                    child: Text(
                                      'termsConditionLbl'.translate(
                                        context: context,
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' & ',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.blackColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  CustomInkWellContainer(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.customPageDetailsRoute,
                                        arguments: {
                                          'title': 'privacyPolicyLbl',
                                          'pageKey': _userType.isHandyman
                                              ? 'handyman_privacy_policy'
                                              : 'privacy_policy',
                                          'userType': _userType,
                                        },
                                      );
                                    },
                                    child: Text(
                                      'privacyPolicyLbl'.translate(
                                        context: context,
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.blackColor,
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildForgotPasswordLabel() {
    return CustomContainer(
      alignment: AlignmentDirectional.centerEnd,
      child: CustomInkWellContainer(
        child: Text(
          'forgotPassword'.translate(context: context),
          style: TextStyle(
            color: Theme.of(context).colorScheme.accentColor,
            fontSize: 14,
          ),
        ),
        onTap: () {
          final bool isPhoneEnabled = context
              .read<FetchSystemSettingsCubit>()
              .isPhoneAuthEnabled;
          final bool isEmailEnabled = context
              .read<FetchSystemSettingsCubit>()
              .isEmailAuthEnabled;

          String subtitle;
          if (isPhoneEnabled && isEmailEnabled) {
            subtitle = 'weWillSendYouCode';
          } else if (isEmailEnabled) {
            subtitle = 'weWillSendYouCode';
          } else {
            subtitle = 'weWillTextYouVerificationCodeToResetYourPassword';
          }

          Navigator.pushNamed(
            context,
            Routes.sendOTPScreen,
            arguments: {
              'screenTitle': 'forgotPassword',
              'screenSubTitle': subtitle,
              'userType': _userType,
            },
          );
        },
      ),
    );
  }

  Widget buildOtherLoginOption() {
    final UserType otherType = _userType.isHandyman
        ? UserType.provider
        : UserType.handyman;
    final String label = otherType.isHandyman
        ? 'loginAsHandyman'
        : 'loginAsProvider';
    // return CustomRoundedButton(
    //   onTap: () {
    //     setState(() => _userType = otherType);
    //     _fillDemoCredentials();
    //   },
    //   buttonTitle: label.translate(context: context),
    //   widthPercentage: 1,
    //   backgroundColor: Colors.transparent,
    //   showBorder: true,
    //   borderColor: Theme.of(context).colorScheme.accentColor,
    //   titleColor: Theme.of(context).colorScheme.accentColor,
    // );
    return CustomInkWellContainer(
      onTap: () {
        setState(() => _userType = otherType);
        _fillDemoCredentials();
      },
      showSplashEffect: false,
      child: Text.rich(
        TextSpan(
          text: '${'loginAs'.translate(context: context)} ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.accentColor,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: label.translate(context: context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context, {bool? showProgress}) {
    return CustomRoundedButton(
      onTap: _onLoginButtonClick,
      buttonTitle: 'login'.translate(context: context),
      widthPercentage: 1,
      backgroundColor: Theme.of(context).colorScheme.accentColor,
      showBorder: false,
      child: (showProgress ?? false)
          ? CustomCircularProgressIndicator(color: AppColors.whiteColors)
          : null,
    );
  }

  Row buildNewRegistrationContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${"notMember".translate(context: context)} ",
          style: TextStyle(
            color: Theme.of(context).colorScheme.accentColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'PlusJakartaSans',
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
        ),
        CustomInkWellContainer(
          child: Text(
            'registerNow'.translate(context: context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.accentColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlusJakartaSans',
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
          onTap: () {
            final bool isPhoneEnabled = context
                .read<FetchSystemSettingsCubit>()
                .isPhoneAuthEnabled;
            final bool isEmailEnabled = context
                .read<FetchSystemSettingsCubit>()
                .isEmailAuthEnabled;

            String title;
            if (isPhoneEnabled && isEmailEnabled) {
              title = 'enterEmailOrPhone';
            } else if (isEmailEnabled) {
              title = 'enterEmail';
            } else {
              title = 'enterYouMobile';
            }

            Navigator.pushNamed(
              context,
              Routes.sendOTPScreen,
              arguments: {
                'screenTitle': title,
                'screenSubTitle': 'weWillSendYouCode',
                'userType': _userType,
              },
            );
          },
        ),
      ],
    );
  }
}
