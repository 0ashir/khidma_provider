import 'package:flutter/material.dart';

import '../../../app/generalImports.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({
    super.key,
    required this.phoneNumberWithoutCountryCode,
    required this.countryCode,
    this.email,
    this.loginType,
    this.userType = UserType.provider,
  });

  final UserType userType;
  final String phoneNumberWithoutCountryCode;
  final String countryCode;
  final String? email;
  final String? loginType;

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();

  static Route route(RouteSettings routeSettings) {
    final Map<String, dynamic> arguments =
        routeSettings.arguments as Map<String, dynamic>;

    return CupertinoPageRoute(
      builder: (_) {
        return BlocProvider<CreateNewPasswordCubit>(
          create: (BuildContext context) => CreateNewPasswordCubit(),
          child: CreateNewPassword(
            countryCode: arguments['countryCode'],
            phoneNumberWithoutCountryCode:
                arguments['phoneNumberWithOutCountryCode'],
            email: arguments['email'],
            loginType: arguments['loginType'],
            userType: (arguments['userType'] as UserType?) ?? UserType.provider,
          ),
        );
      },
    );
  }
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  String phoneNumberWithCountryCode = '';
  String onlyPhoneNumber = '';
  String countryCode = '';

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _confirmNewPasswordController.dispose();
    _newPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onContinueButtonClicked() {
    UiUtils.removeFocus();

    final bool validateForm = changePasswordFormKey.currentState!.validate();

    if (validateForm) {
      final String newPassword = _newPasswordController.text.trim();
      final String confirmNewPassword = _confirmNewPasswordController.text
          .trim();

      if (newPassword != confirmNewPassword) {
        UiUtils.showMessage(
          context,
          'confirmPasswordDoesNotMatch',
          ToastificationType.error,
        );
        return;
      }
      final String countryCode = context
          .read<CountryCodeCubit>()
          .getSelectedCountryCode();

      context.read<CreateNewPasswordCubit>().createNewPassword(
        countryCode: countryCode,
        mobileNumber: widget.phoneNumberWithoutCountryCode,
        email: widget.email,
        newPassword: confirmNewPassword,
        loginType: widget.loginType,
      );
    }
  }

  Widget _buildPasswordFiled({
    required TextEditingController controller,
    required String hintText,
    bool isConfirmPassword = false,
  }) {
    if (isConfirmPassword) {
      return CustomTextFormField(
        bottomPadding: 10,
        controller: controller,
        isDense: false,
        fillColor: Colors.transparent,
        hintText: hintText.translate(context: context),
        labelText: hintText.translate(context: context),
        hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
        isPassword: true,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.blackColor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        validator: (String? password) => Validator.nullCheck(context, password),
      );
    }

    return CustomPasswordFieldWithValidators(
      controller: controller,
      bottomPadding: 10,
      isDense: false,
      fillColor: Colors.transparent,
      hintText: hintText.translate(context: context),
      labelText: hintText.translate(context: context),
      hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      validator: (String? password) =>
          Validator.validatePassword(context, password),
    );
  }

  Widget _buildHeading() {
    return Text(
      'createNewPassword'.translate(context: context),
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
      'yourNewPasswordMustBeDifferentFromPreviouslyUsedPassword'.translate(
        context: context,
      ),
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: '',
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Form(
            key: changePasswordFormKey,
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
                    const SizedBox(height: 10),
                    _buildSubHeading(),
                    const SizedBox(height: 40),
                    _buildPasswordFiled(
                      controller: _newPasswordController,
                      hintText: 'newPassword',
                    ),
                    _buildPasswordFiled(
                      controller: _confirmNewPasswordController,
                      hintText: 'confirmNewPassword',
                      isConfirmPassword: true,
                    ),
                    const SizedBox(height: 20),
                    _buildContinueButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocConsumer<CreateNewPasswordCubit, CreateNewPasswordState>(
      listener: (BuildContext context, CreateNewPasswordState state) {
        if (state is CreateNewPasswordFailure) {
          UiUtils.showMessage(
            context,
            state.errorMessage,
            ToastificationType.error,
          );
        } else if (state is CreateNewPasswordSuccess) {
          Navigator.pushReplacementNamed(
            context,
            Routes.successScreen,
            arguments: {
              'title': 'resetPasswordSuccessful'.translate(context: context),
              'message':
                  'youHaveSuccessfullyResetYourPasswordPleaseUseYourNewPasswordWhenLoggingIn'
                      .translate(context: context),
              'imageName': AppAssets.success,
            },
          );
        }
      },
      builder: (BuildContext context, CreateNewPasswordState state) {
        Widget? child;
        if (state is CreateNewPasswordInProgress) {
          child = CustomCircularProgressIndicator(color: AppColors.whiteColors);
        } else if (state is CreateNewPasswordFailure ||
            state is CreateNewPasswordSuccess) {
          child = null;
        }
        return CustomRoundedButton(
          onTap: () {
            _onContinueButtonClicked();
          },
          buttonTitle: 'continue'.translate(context: context),
          widthPercentage: 1,
          backgroundColor: Theme.of(context).colorScheme.accentColor,
          showBorder: false,
          child: child,
        );
      },
    );
  }
}
