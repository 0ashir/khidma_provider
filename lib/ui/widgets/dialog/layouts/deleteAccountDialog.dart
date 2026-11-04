import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class DeleteProviderAccountDialog extends StatefulWidget {
  DeleteProviderAccountDialog({super.key});

  @override
  State<DeleteProviderAccountDialog> createState() =>
      _DeleteProviderAccountDialogState();
}

class _DeleteProviderAccountDialogState
    extends State<DeleteProviderAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> deleteAccountFormKey = GlobalKey();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          context.read<DeleteProviderAccountCubit>().deleteProviderAccount();
        } else if (state is SignInFailure) {
          UiUtils.showMessage(
            context,
            state.errorMessage,
            ToastificationType.error,
          );
        }
      },
      builder: (context, signInState) {
        bool? showProgress;

        return BlocConsumer<
          DeleteProviderAccountCubit,
          DeleteProviderAccountState
        >(
          listener:
              (
                final BuildContext context,
                final DeleteProviderAccountState state,
              ) async {
                if (state is DeleteProviderAccountSuccess) {
                  AppQuickActions.clearShortcutItems();

                  Navigator.of(
                    context,
                  ).popUntil((Route route) => route.isFirst);
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.loginScreenRoute,
                  );
                }
              },
          builder:
              (
                final BuildContext context,
                final DeleteProviderAccountState state,
              ) {
                showProgress =
                    state is DeleteProviderAccountInProgress ||
                    signInState is SignInInProgress;
                return CustomDialogLayout(
                  title: "deleteAccount",
                  description: "deleteAccountWarning",
                  confirmButtonName: "delete",
                  cancelButtonName: "cancel",
                  confirmButtonBackgroundColor: AppColors.redColor,
                  cancelButtonBackgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryColor,
                  widgetUnderDescription: Form(
                    key: deleteAccountFormKey,
                    child: CustomTextFormField(
                      bottomPadding: 0,
                      textInputType: TextInputType.text,
                      controller: _passwordController,
                      isDense: true,
                      // isRoundedBorder: true,
                      isPassword: true,
                      forceUnFocus: false,
                      validator: (password) {
                        if (password == null || password.trim().isEmpty) {
                          return "pleaseEnterPassword".translate(
                            context: context,
                          );
                        }

                        return null;
                      },
                      // backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      hintText: "enterYourPassword".translate(context: context),
                      hintTextColor: Theme.of(
                        context,
                      ).colorScheme.lightGreyColor,
                    ),
                  ),
                  showProgressIndicator: showProgress,
                  cancelButtonPressed: () {
                    if (signInState is SignInInProgress ||
                        state is DeleteProviderAccountInProgress) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                  confirmButtonPressed: () {
                    final FormState? form = deleteAccountFormKey.currentState;
                    if (form == null) return;
                    form.save();
                    if (form.validate()) {
                      context.read<SignInCubit>().signIn(
                        phoneNumber:
                            context
                                .read<ProviderDetailsCubit>()
                                .providerDetails
                                .user
                                ?.phone ??
                            '',
                        password: _passwordController.text.trim(),
                        countryCode:
                            context
                                .read<ProviderDetailsCubit>()
                                .providerDetails
                                .user
                                ?.countryCode ??
                            '',
                        fcmId: '',
                      );
                    }
                  },
                );
              },
        );
      },
    );
  }
}
