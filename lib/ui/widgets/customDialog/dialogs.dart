import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomDialogs {
  static AlertDialog showTextFieldDialog(
    BuildContext context, {
    required String title,
    GlobalKey<FormState>? formKey,
    TextEditingController? controller,
    String? hint,
    Color? titleColor,
    required String message,
    required String hintText,
    required VoidCallback onConfirmed,
    required VoidCallback onCancled,
    required Function(String) validator,
    Color? confirmButtonColor,
    TextInputType? textInputType,
    String? confirmButtonName,
    bool? showProgress,
    bool? isPasswordField,
    String? cancleButtonName,
    Color? progressColor,
  }) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: titleColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isNotEmpty) ...[
            Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
          ],
          Form(
            key: formKey,
            child: CustomTextFormField(
              bottomPadding: 0,
              textInputType: textInputType ?? TextInputType.text,
              controller: controller,
              isDense: true,
              isPassword: isPasswordField ?? false,
              forceUnFocus: false,
              validator: (String? value) => validator(value!),
              fillColor: Theme.of(context).colorScheme.primaryColor,
              hintText: hintText.translate(context: context),
              hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: onCancled,
          child: Text(cancleButtonName ?? 'cancel'.translate(context: context)),
        ),
        MaterialButton(
          disabledColor: confirmButtonColor?.withValues(alpha: 0.7),
          onPressed: (showProgress == false)
              ? () {
                  if (formKey?.currentState?.validate() ?? false) {
                    onConfirmed();
                  }
                }
              : null,
          color: confirmButtonColor,
          elevation: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                confirmButtonName ?? 'ok'.translate(context: context),
                style: TextStyle(color: AppColors.whiteColors),
              ),
              const SizedBox(width: 5),
              if (showProgress ?? false) ...[
                SizedBox(
                  width: 13,
                  height: 13,
                  child: CustomCircularProgressIndicator(
                    strokeWidth: 2,
                    color: progressColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
