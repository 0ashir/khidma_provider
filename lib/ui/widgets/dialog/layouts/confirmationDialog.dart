import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String confirmButtonName;
  final Color? confirmButtonBackgroundColor;
  final Color? cancelButtonBackgroundColor;
  final Function confirmButtonPressed;
  final Widget? icon;
  final Widget? confirmButtonChild;
  final Widget? widgetUnderDescription;
  final bool? showProgressIndicator;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmButtonName,
    required this.confirmButtonPressed,
    this.icon,
    this.confirmButtonChild,
    this.widgetUnderDescription,
    this.showProgressIndicator,
    this.confirmButtonBackgroundColor,
    this.cancelButtonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialogLayout(
      showProgressIndicator: showProgressIndicator,
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
      title: title,
      description: description,

      widgetUnderDescription: widgetUnderDescription,

      cancelButtonName: "cancel",
      cancelButtonBackgroundColor:
          cancelButtonBackgroundColor ??
          Theme.of(context).colorScheme.secondaryColor,
      cancelButtonPressed: () {
        Navigator.of(context).pop();
      },

      confirmButtonName: confirmButtonName,
      confirmButtonBackgroundColor:
          confirmButtonBackgroundColor ?? AppColors.redColor,
      confirmButtonPressed: () async {
        confirmButtonPressed.call();
      },
    );
  }
}
