import '../../../../config.dart';

class ChangePasswordLayout extends StatelessWidget {
  const ChangePasswordLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordProvider>(
        builder: (context1, resetPass, child) {
      return Stack(clipBehavior: Clip.none, children: [
        const FieldsBackground(),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerWithTextLayout(
                  title: language(context, translations!.currentPassword)),
              const VSpace(Sizes.s8),
              TextFieldCommon(
                      hintText:
                          language(context, translations!.enterCurrentPassword),
                      obscureText: resetPass.isOldPassword,
                      controller: resetPass.txtOldPassword,
                      focusNode: resetPass.oldPasswordFocus,
                      prefixIcon: eSvgAssets.lock,
                      validator: (value) =>
                          validation.passValidation(context, value),
                      onFieldSubmitted: (value) => validation.fieldFocusChange(
                          context,
                          resetPass.oldPasswordFocus,
                          resetPass.passwordFocus),
                      suffixIcon: SvgPicture.asset(
                              resetPass.isOldPassword
                                  ? eSvgAssets.hide
                                  : eSvgAssets.eye,
                              fit: BoxFit.scaleDown)
                          .inkWell(onTap: () => resetPass.oldPasswordSeenTap()))
                  .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s15),
              ContainerWithTextLayout(
                  title: language(context, translations!.newPassword)),
              const VSpace(Sizes.s8),
              TextFieldCommon(
                  hintText: language(context, translations!.enterNewPassword),
                  obscureText: resetPass.isNewPassword,
                  controller: resetPass.txtNewPassword,
                  focusNode: resetPass.passwordFocus,
                  prefixIcon: eSvgAssets.lock,
                  validator: (value) =>
                      validation.passValidation(context, value),
                  onFieldSubmitted: (value) => validation.fieldFocusChange(
                      context,
                      resetPass.passwordFocus,
                      resetPass.confirmPasswordFocus),
                  suffixIcon: SvgPicture.asset(
                          resetPass.isNewPassword
                              ? eSvgAssets.hide
                              : eSvgAssets.eye,
                          fit: BoxFit.scaleDown)
                      .inkWell(
                          onTap: () =>
                              resetPass.newPasswordSeenTap())).paddingSymmetric(
                  horizontal: Insets.i20),
              const VSpace(Sizes.s15),
              ContainerWithTextLayout(
                  title: language(context, translations!.confirmPassword)),
              const VSpace(Sizes.s8),
              TextFieldCommon(
                      focusNode: resetPass.confirmPasswordFocus,
                      hintText:
                          language(context, translations!.enterConfirmPassword),
                      controller: resetPass.txtConfirmPassword,
                      obscureText: resetPass.isConfirmPassword,
                      validator: (value) => validation.confirmPassValidation(
                          context, value, resetPass.txtNewPassword.text),
                      suffixIcon: SvgPicture.asset(
                              resetPass.isConfirmPassword
                                  ? eSvgAssets.hide
                                  : eSvgAssets.eye,
                              fit: BoxFit.scaleDown)
                          .inkWell(
                              onTap: () => resetPass.confirmPasswordSeenTap()),
                      prefixIcon: eSvgAssets.lock)
                  .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s40),
              ButtonCommon(
                isLoading: resetPass.isResetPassword ? true : false,
                title: translations!.updatePassword,
                onTap: () => resetPass.updatePassword(context),
              ).paddingSymmetric(horizontal: Insets.i20)
            ]).paddingSymmetric(vertical: Insets.i20)
      ]);
    });
  }
}
