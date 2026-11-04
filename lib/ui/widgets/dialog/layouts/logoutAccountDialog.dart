import 'package:edemand_partner/cubits/logoutCubit.dart';
import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class LogoutAccountDialog extends StatelessWidget {
  const LogoutAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          UiUtils.showMessage(
            context,
            "logoutSuccess",
            ToastificationType.success,
          );
        }
        if (state is LogoutFailure) {
          UiUtils.showMessage(
            context,
            "logoutFailed",
            ToastificationType.error,
          );
        }
      },
      builder: (context, state) {
        return CustomDialogLayout(
          showProgressIndicator: state is LogoutLoading,
          icon: CustomContainer(
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.secondaryColor,
            borderRadius: UiUtils.borderRadiusOf50,
            child: Icon(
              Icons.help,
              color: Theme.of(context).colorScheme.accentColor,
              size: 70,
            ),
          ),
          title: "confirmLogout",
          description: "areYouSureYouWantToLogout",

          cancelButtonName: "cancel",
          cancelButtonBackgroundColor: Theme.of(
            context,
          ).colorScheme.secondaryColor,
          cancelButtonPressed: () {
            Navigator.of(context).pop();
          },

          confirmButtonChild: state is LogoutLoading
              ? const CircularProgressIndicator()
              : null,
          confirmButtonName: state is LogoutLoading
              ? "loggingOut"
              : "logoutLbl",
          confirmButtonBackgroundColor: AppColors.redColor,
          confirmButtonPressed: () async {
            try {
              await context.read<LogoutCubit>().logout(context);
            } catch (_) {}
          },
        );
      },
    );
  }
}
