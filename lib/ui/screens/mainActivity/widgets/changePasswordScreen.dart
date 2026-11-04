import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (context) => const ChangePasswordScreen(),
    );
  }

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordTextController =
      TextEditingController();
  final TextEditingController _newPasswordTextController =
      TextEditingController();
  final TextEditingController _confirmNewPasswordTextController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    _confirmNewPasswordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedSafeArea(
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'changePassword'.translate(context: context),
          statusBarColor: context.colorScheme.secondaryColor,
        ),
        body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (BuildContext context, ChangePasswordState state) async {
            if (state is ChangePasswordSuccess) {
              _oldPasswordTextController.clear();
              _newPasswordTextController.clear();
              _confirmNewPasswordTextController.clear();

              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.success,
              );

              // await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                Navigator.pop(context);
              }
            }
            if (state is ChangePasswordFailure) {
              UiUtils.showMessage(
                context,
                state.errorMessage,
                ToastificationType.error,
              );
            }
          },
          builder: (BuildContext context, ChangePasswordState state) {
            Widget? child;
            if (state is ChangePasswordInProgress) {
              child = CustomCircularProgressIndicator(
                color: AppColors.whiteColors,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // Scrollable fields
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              bottomPadding: 15,
                              controller: _oldPasswordTextController,
                              isPassword: true,
                              labelText: 'oldPassword'.translate(
                                context: context,
                              ),
                              validator: (value) =>
                                  Validator.nullCheck(context, value),
                            ),
                            CustomPasswordFieldWithValidators(
                              controller: _newPasswordTextController,
                              labelText: 'newPassword'.translate(
                                context: context,
                              ),
                              validator: (value) =>
                                  Validator.validatePassword(context, value),
                              bottomPadding: 15,
                            ),
                            CustomTextFormField(
                              bottomPadding: 15,
                              controller: _confirmNewPasswordTextController,
                              isPassword: true,
                              labelText: 'confirmPasswordLbl'.translate(
                                context: context,
                              ),
                              validator: (value) =>
                                  Validator.nullCheck(context, value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Fixed bottom button
                  CustomRoundedButton(
                    widthPercentage: 1,
                    backgroundColor: Theme.of(context).colorScheme.accentColor,
                    buttonTitle: 'changePassword'.translate(context: context),
                    titleColor: AppColors.whiteColors,
                    showBorder: false,
                    child: child,
                    onTap: () {
                      UiUtils.removeFocus();
                      final form = formKey.currentState;
                      if (form == null) return;
                      form.save();
                      if (form.validate()) {
                        final newPassword = _newPasswordTextController.text
                            .trim();
                        final confirmNewPassword =
                            _confirmNewPasswordTextController.text.trim();
                        final oldPassword = _oldPasswordTextController.text
                            .trim();

                        if (newPassword == confirmNewPassword) {
                          context.read<ChangePasswordCubit>().changePassword(
                            oldPassword: oldPassword,
                            newPassword: newPassword,
                          );
                        } else {
                          UiUtils.showMessage(
                            context,
                            'passwordDoesNotMatch'.translate(context: context),
                            ToastificationType.warning,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
