import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';
import '../../../../cubits/verifyBookingOTPCubit.dart';

class VerifyOTPDialog extends StatefulWidget {
  final String userId;

  VerifyOTPDialog({super.key, required this.userId});

  @override
  State<VerifyOTPDialog> createState() => _VerifyOTPDialogState();
}

class _VerifyOTPDialogState extends State<VerifyOTPDialog> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyBookingOTPCubit, VerifyBookingOTPState>(
      listener: (context, state) {
        if (state is VerifyBookingOTPSuccess) {
          Navigator.pop(context, _otpController.text.trim());
          context.read<VerifyBookingOTPCubit>().reset();
        } else if (state is VerifyBookingOTPFailure) {
          UiUtils.showMessage(
            context,
            state.errorMessage,
            ToastificationType.error,
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is VerifyBookingOTPInProgress;

        return CustomDialogLayout(
          title: "otp",
          description: "pleaseEnterOTPGivenByCustomer",
          confirmButtonName: "verify",
          cancelButtonName: "cancel",
          confirmButtonBackgroundColor: Theme.of(
            context,
          ).colorScheme.accentColor,
          cancelButtonBackgroundColor: Theme.of(
            context,
          ).colorScheme.secondaryColor,
          widgetUnderDescription: Form(
            key: otpFormKey,
            child: CustomTextFormField(
              bottomPadding: 0,
              textInputType: TextInputType.number,
              controller: _otpController,
              isDense: true,
              forceUnFocus: false,
              isReadOnly: isLoading,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'pleaseEnterOTP'.translate(context: context);
                }
                return null;
              },
              hintText: "enterOTP".translate(context: context),
              hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ),
          showProgressIndicator: isLoading,
          cancelButtonPressed: () {
            if (!isLoading) {
              context.read<VerifyBookingOTPCubit>().reset();
              Navigator.pop(context);
            }
          },
          confirmButtonPressed: () {
            if (isLoading) return;

            final FormState? form = otpFormKey.currentState;
            if (form == null) return;
            form.save();
            if (form.validate()) {
              context.read<VerifyBookingOTPCubit>().verifyBookingOTP(
                userId: widget.userId,
                otp: _otpController.text.trim(),
              );
            }
          },
        );
      },
    );
  }
}
