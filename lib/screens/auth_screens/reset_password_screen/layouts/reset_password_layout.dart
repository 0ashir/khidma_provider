import '../../../../config.dart';

class ResetPasswordLayout extends StatelessWidget {
  const ResetPasswordLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ResetPasswordProvider, DeleteDialogProvider>(
        builder: (context1, resetPass, delVal, child) {
      return StatefulWrapper(
          onInit: () {},
          child: Stack(clipBehavior: Clip.none, children: [
            const FieldsBackground(),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContainerWithTextLayout(
                      title: language(context, translations!.newPassword)),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                          hintText:
                              language(context, translations!.enterNewPassword),
                          obscureText: resetPass.isNewPassword,
                          controller: resetPass.txtNewPassword,
                          focusNode: resetPass.passwordFocus,
                          prefixIcon: eSvgAssets.lock,
                          validator: (value) =>
                              validation.passValidation(context, value),
                          onFieldSubmitted: (value) =>
                              validation.fieldFocusChange(
                                  context,
                                  resetPass.passwordFocus,
                                  resetPass.confirmPasswordFocus),
                          suffixIcon: SvgPicture.asset(
                                  resetPass.isNewPassword
                                      ? eSvgAssets.hide
                                      : eSvgAssets.eye,
                                  fit: BoxFit.scaleDown)
                              .inkWell(
                                  onTap: () => resetPass.newPasswordSeenTap()))
                      .paddingSymmetric(horizontal: Insets.i20),
                  const VSpace(Sizes.s15),
                  ContainerWithTextLayout(
                      title: language(context, translations!.confirmPassword)),
                  const VSpace(Sizes.s8),
                  TextFieldCommon(
                          hintText: language(
                              context, translations!.enterConfirmPassword),
                          controller: resetPass.txtConfirmPassword,
                          obscureText: resetPass.isConfirmPassword,
                          focusNode: resetPass.confirmPasswordFocus,
                          validator: (value) =>
                              validation.confirmPassValidation(context, value,
                                  resetPass.txtNewPassword.text),
                          suffixIcon: SvgPicture.asset(
                                  resetPass.isConfirmPassword
                                      ? eSvgAssets.hide
                                      : eSvgAssets.eye,
                                  fit: BoxFit.scaleDown)
                              .inkWell(
                                  onTap: () =>
                                      resetPass.confirmPasswordSeenTap()),
                          prefixIcon: eSvgAssets.lock)
                      .paddingSymmetric(horizontal: Insets.i20),
                  const VSpace(Sizes.s40),
                  ButtonCommon(
                      title: translations!.resetPassword,
                      onTap: () {resetPass.reset(context);
                      }).paddingSymmetric(horizontal: Insets.i20)
                ]).paddingSymmetric(vertical: Insets.i20)
          ]));
    });
  }
}
