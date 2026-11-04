import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pinput/pinput.dart';

import '../../../app/generalImports.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({
    super.key,
    required this.phoneNumberWithCountryCode,
    required this.phoneNumberWithOutCountryCode,
    required this.countryCode,
    required this.isItForForgotPassword,
    required this.authenticationMode,
    this.email,
    this.loginType,
    this.userType = UserType.provider,
  });

  final UserType userType;
  final String phoneNumberWithCountryCode;
  final String phoneNumberWithOutCountryCode;
  final String countryCode;
  final String authenticationMode;
  final bool isItForForgotPassword;
  final String? email;
  final String? loginType;

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();

  static Route route(RouteSettings routeSettings) {
    final Map parameters = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (_) {
        return BlocProvider(
          create: (BuildContext context) => VerifyOtpCubit(),
          child: VerifyOTPScreen(
            phoneNumberWithCountryCode:
                parameters['phoneNumberWithCountryCode'],
            phoneNumberWithOutCountryCode:
                parameters['phoneNumberWithOutCountryCode'],
            countryCode: parameters['countryCode'],
            isItForForgotPassword: parameters['isItForForgotPassword'],
            authenticationMode: parameters['authenticationMode'],
            email: parameters['email'],
            loginType: parameters['loginType'],
            userType:
                (parameters['userType'] as UserType?) ?? UserType.provider,
          ),
        );
      },
    );
  }
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  bool isCountdownFinished = false;
  bool isOtpSent = false;
  TextEditingController otpController = TextEditingController();
  bool shouldShowOtpResendSuccessMessage = false;
  FocusNode otpFiledFocusNode = FocusNode();
  CountDownTimer countDownTimer = CountDownTimer();

  ValueNotifier<bool> isCountDownCompleted = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    countDownTimer.start(() => _onCountdownComplete());
  }

  @override
  void dispose() {
    otpFiledFocusNode.dispose();
    otpController.dispose();
    countDownTimer.timerController.close();
    isCountDownCompleted.dispose();
    super.dispose();
  }

  void _onCountdownComplete() {
    isCountDownCompleted.value = true;
  }

  void _onResendOtpClick() {
    if (isCountDownCompleted.value) {
      // If email is provided, always use SMS gateway API (which handles email OTP)
      // Firebase is only for phone number authentication
      if (widget.email != null && widget.email!.isNotEmpty) {
        context.read<ResendOtpCubit>().resendOtpUsingSMSGateway(
          phoneNumber: widget.phoneNumberWithCountryCode,
          phoneNumberWithoutCountryCode: widget.phoneNumberWithOutCountryCode,
          countryCode: widget.countryCode,
          email: widget.email,
          loginType: widget.loginType,
          onOtpSent: () {
            otpController.clear();
            isCountdownFinished = false;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          },
        );
      } else if (widget.authenticationMode == "sms_gateway") {
        context.read<ResendOtpCubit>().resendOtpUsingSMSGateway(
          phoneNumber: widget.phoneNumberWithCountryCode,
          phoneNumberWithoutCountryCode: widget.phoneNumberWithOutCountryCode,
          countryCode: widget.countryCode,
          email: widget.email,
          loginType: widget.loginType,
          onOtpSent: () {
            otpController.clear();
            isCountdownFinished = false;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          },
        );
      } else {
        context.read<ResendOtpCubit>().resendOtpUsingFirebase(
          phoneNumber: widget.phoneNumberWithCountryCode,
          phoneNumberWithoutCountryCode: widget.phoneNumberWithOutCountryCode,
          countryCode: widget.countryCode,
          onOtpSent: () {
            otpController.clear();
            isCountdownFinished = false;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          },
        );
      }
    }
  }

  Widget _responseMessages(ResendOtpState resendOtpState) {
    return SizedBox(
      height: 30,
      child: Builder(
        builder: (BuildContext context) {
          if (resendOtpState is ResendOtpSuccess) {
            Future.delayed(const Duration(seconds: 3)).then((value) {
              context.read<ResendOtpCubit>().setDefaultOtpState();
            });
          }

          if (resendOtpState is ResendOtpInProcess) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(radius: 8),
                const SizedBox(width: 5),
                Text(
                  'sending_otp'.translate(context: context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          if (resendOtpState is ResendOtpFail) {
            UiUtils.showMessage(
              context,
              resendOtpState.error.toString(),
              ToastificationType.error,
            );
          }

          // Show different message based on whether email or phone was used
          final String message =
              (widget.email != null && widget.email!.isNotEmpty)
              ? 'codeHasBeenSentToYourEmail'
              : 'codeHasBeenSentToYourMobileNumber';

          return Visibility(
            visible: resendOtpState is ResendOtpSuccess,
            child: Text(
              message.translate(context: context),
              style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Text(
        'otp_verification'.translate(context: context),
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.blackColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubHeading() {
    // Show email if provided, otherwise show phone number
    final String displayValue =
        (widget.email != null && widget.email!.isNotEmpty)
        ? widget.email!
        : widget.phoneNumberWithCountryCode;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Text(
            "${"enter_verification_code".translate(context: context)}\n$displayValue",
            style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  BlocConsumer<VerifyOtpCubit, VerifyOtpState> _buildResendButton(
    BuildContext context,
    resendOtpState,
  ) {
    return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
      listener: (BuildContext context, VerifyOtpState verifyOtpState) {
        if (verifyOtpState is VerifyOtpSuccess) {
          countDownTimer.close();

          UiUtils.showMessage(context, 'verified', ToastificationType.success);

          if (widget.isItForForgotPassword) {
            Navigator.pushReplacementNamed(
              context,
              Routes.createNewPassword,
              arguments: {
                'countryCode': widget.countryCode,
                'phoneNumberWithOutCountryCode':
                    widget.phoneNumberWithOutCountryCode,
                'email': widget.email,
                'loginType': widget.loginType,
                'userType': widget.userType,
              },
            );

            return;
          }

          // Determine login type based on whether email is provided
          final LoginType loginType =
              widget.email != null && widget.email!.isNotEmpty
              ? LoginType.email
              : LoginType.phone;

          Navigator.pushReplacementNamed(
            context,
            Routes.providerRegistration,
            arguments: {
              'registeredMobileNumber': widget.phoneNumberWithCountryCode,
              'countryCode': widget.countryCode,
              'phoneNumberWithOutCountryCode':
                  widget.phoneNumberWithOutCountryCode,
              'email': widget.email,
              'loginType': loginType,
            },
          );
        } else if (verifyOtpState is VerifyOtpFail) {
          Future.delayed(const Duration(seconds: 3), () {
            context.read<VerifyOtpCubit>().setInitialState();
          });
          Future.delayed(Duration.zero, () {
            otpController.clear();
          });
          String errorMessage = '';
          errorMessage = verifyOtpState.error.toString().translate(
            context: context,
          );

          UiUtils.showMessage(context, errorMessage, ToastificationType.error);
        }
      },
      builder: (BuildContext context, VerifyOtpState verifyOtpState) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 42, minWidth: 130),
          child: OutlinedButton(
            onPressed: _onResendOtpClick,
            style: _resendButtonStyle(),
            child: ValueListenableBuilder(
              valueListenable: isCountDownCompleted,
              builder: (BuildContext context, Object? value, Widget? child) {
                return isCountDownCompleted.value
                    ? Text(
                        'resend_otp'.translate(context: context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : _resendCountDownButton();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _resendCountDownButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'resend_otp_in'.translate(context: context),
          style: TextStyle(
            color: Theme.of(context).colorScheme.lightGreyColor,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(width: 3),
        countDownTimer.listenText(
          color: Theme.of(context).colorScheme.lightGreyColor,
        ),
      ],
    );
  }

  ButtonStyle _resendButtonStyle() {
    return ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
        ),
      ),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Theme.of(context).colorScheme.lightGreyColor;
        }
        return Theme.of(context).colorScheme.blackColor;
      }),
      side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: Theme.of(context).colorScheme.lightGreyColor,
          );
        } else {
          return BorderSide(color: Theme.of(context).colorScheme.blackColor);
        }
      }),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Pinput(
            controller: otpController,
            keyboardType: TextInputType.number,
            closeKeyboardWhenCompleted: false,
            length: 6,
            focusNode: otpFiledFocusNode,
            pinAnimationType: PinAnimationType.scale,
            focusedPinTheme: PinTheme(
              height: 50,
              textStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.blackColor,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.accentColor,
                ),
                borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf5),
              ),
            ),
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            isCursorAnimationEnabled: true,
            defaultPinTheme: PinTheme(
              height: 50,
              textStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.blackColor,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.lightGreyColor,
                ),
                borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf10),
              ),
            ),
            readOnly:
                context.watch<VerifyOtpCubit>().state is VerifyOtpInProcess ||
                context.watch<VerifyPhoneNumberFromAPICubit>().state
                    is VerifyPhoneNumberFromAPIInProgress,
            onCompleted: (final otpValue) {
              if (otpValue.length == 6) {
                UiUtils.removeFocus();

                // If email is provided, always use SMS gateway API (which handles email OTP)
                // Firebase is only for phone number authentication
                if (widget.email != null && widget.email!.isNotEmpty) {
                  context.read<VerifyOtpCubit>().verifyOtpUsingSMSGateway(
                    otp: otpValue,
                    countryCode: widget.countryCode,
                    phoneNumberWithOutCountryCode:
                        widget.phoneNumberWithOutCountryCode,
                    email: widget.email,
                    loginType: widget.loginType,
                  );
                } else if (widget.authenticationMode == "sms_gateway") {
                  context.read<VerifyOtpCubit>().verifyOtpUsingSMSGateway(
                    otp: otpValue,
                    countryCode: widget.countryCode,
                    phoneNumberWithOutCountryCode:
                        widget.phoneNumberWithOutCountryCode,
                    email: widget.email,
                    loginType: widget.loginType,
                  );
                } else {
                  context.read<VerifyOtpCubit>().verifyOtpUsingFirebase(
                    otp: otpValue,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(context: context, elevation: 1),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
        child: BlocConsumer<ResendOtpCubit, ResendOtpState>(
          listener: (BuildContext context, ResendOtpState state) {
            if (state is ResendOtpSuccess) {
              isCountDownCompleted.value = false;

              countDownTimer.start(() => _onCountdownComplete());

              context.read<ResendOtpCubit>().setDefaultOtpState();
            }
          },
          builder: (BuildContext context, ResendOtpState resendOtpState) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CustomSvgPicture(
                      svgImage: AppAssets.loginLogoFor(widget.userType),
                      width: 240,
                      height: 100,
                      boxFit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    _buildHeader(),
                    _buildSubHeading(),
                    _buildOtpField(context),
                    if (context.watch<VerifyOtpCubit>().state
                        is VerifyOtpInProcess) ...[
                      _buildOTPVerificationStatus(context),
                    ] else ...[
                      _responseMessages(resendOtpState),
                    ],
                    _buildResendButton(context, resendOtpState),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOTPVerificationStatus(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Builder(
        builder: (BuildContext context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(radius: 8),
              const SizedBox(width: 5),
              Text('otpVerifying'.translate(context: context)),
            ],
          );
        },
      ),
    );
  }
}
