import 'dart:io';

import '../../../../config.dart';

class SignUpOneFreelancer extends StatelessWidget {
  const SignUpOneFreelancer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpCompanyProvider>(builder: (context1, value, child) {
      return Form(
        key: value.signupFreelanceFormKey1,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ContainerWithTextLayout(title: "${translations!.uploadPhoto}")
              .paddingOnly(bottom: Insets.i8),

          DottedBorder(
                  color: appColor(context).appTheme.stroke,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(AppRadius.r10),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppRadius.r8)),
                      child: value.docFile != null
                          ? ClipSmoothRect(
                              radius: SmoothBorderRadius(
                                cornerRadius: 8,
                                cornerSmoothing: 1,
                              ),
                              child: Image.file(
                                File(value.docFile!.path),
                                height: Sizes.s70,
                                width: Sizes.s70,
                                fit: BoxFit.cover,
                              ))
                          : Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              color: appColor(context).appTheme.whiteBg,
                              child: Column(children: [
                                SvgPicture.asset(eSvgAssets.upload),
                                const VSpace(Sizes.s6),
                                Text(
                                    language(
                                        context, translations!.uploadLogoImage),
                                    style: appCss.dmDenseMedium12.textColor(
                                        appColor(context).appTheme.lightText))
                              ]).paddingSymmetric(vertical: Insets.i15))))
              .inkWell(onTap: () => value.onImagePick(context, isLogo: false))
              .padding(bottom: 15, horizontal: Insets.i20),

          ContainerWithTextLayout(title: "${translations!.userName}")
              .paddingOnly(bottom: Insets.i8),
          TextFieldCommon(
                  focusNode: value.ownerNameFocus,
                  controller: value.ownerName,
                  hintText: translations!.enterName!,
                  validator: (v) => validation.nameValidation(context, v),
                  prefixIcon: eSvgAssets.user)
              .paddingSymmetric(horizontal: Insets.i20),
          ContainerWithTextLayout(title: "${translations!.email}")
              .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          TextFieldCommon(
                  focusNode: value.providerEmailFocus,
                  controller: value.providerEmail,
                  validator: (v) => validation.emailValidation(context, v),
                  hintText: translations!.enterEmail!,
                  prefixIcon: eSvgAssets.email)
              .paddingSymmetric(horizontal: Insets.i20),
          ContainerWithTextLayout(title: "${translations?.phoneNo}")
              .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          RegisterWidgetClass().phoneTextBox(
              dialCode: value.dialCode,
              context,
              value.providerNumber,
              value.providerNumberFocus,
              onChanged: (CountryCodeCustom? code) =>
                  value.changeDialCode(code!),
              onFieldSubmitted: (values) => validation.fieldFocusChange(
                  context, value.providerNumberFocus, value.emailFocus)),

          // ContainerWithTextLayout(title: "${translations!.knownLanguage} *")
          //     .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          // Stack(children: [
          //   MultiSelectDropDownCustom(
          //           backgroundColor: appColor(context).appTheme.whiteBg,
          //           optionsBackgroundColor: appColor(context).appTheme.whiteBg,
          //           onOptionSelected: (options) =>
          //               value.onLanguageSelect(options),
          //           searchEnabled: true,
          //           /* selectedOptions: value.languageSelect, */
          //           options: knownLanguageList
          //               .asMap()
          //               .entries
          //               .map((e) => ValueItem(
          //                   label: language(context, e.value.key),
          //                   value: e.value.id))
          //               .toList(),
          //           selectionType: SelectionType.multi,
          //           hint: "Select language",
          //           hintStyle: appCss.dmDenseMedium14
          //               .textColor(appColor(context).appTheme.lightText),
          //           chipConfig: CommonWidgetLayout().chipWidget(context),
          //           dropdownHeight: 300,
          //           padding: const EdgeInsets.only(
          //               left: Insets.i40, right: Insets.i10),
          //           showClearIcon: false,
          //           borderColor: appColor(context).appTheme.trans,
          //           borderRadius: AppRadius.r8,
          //           suffixIcon: SvgPicture.asset(eSvgAssets.dropDown,
          //               colorFilter: ColorFilter.mode(
          //                   value.languageSelect.isNotEmpty
          //                       ? appColor(context).appTheme.darkText
          //                       : appColor(context).appTheme.lightText,
          //                   BlendMode.srcIn)),
          //           optionTextStyle: appCss.dmDenseMedium14
          //               .textColor(appColor(context).appTheme.darkText),
          //           selectedOptionIcon: Icon(Icons.check_box_rounded,
          //               color: appColor(context).appTheme.primary))
          //       .paddingSymmetric(horizontal: Insets.i20),
          //   SvgPicture.asset(
          //     eSvgAssets.country,
          //     colorFilter: ColorFilter.mode(
          //         value.languageSelect.isNotEmpty
          //             ? appColor(context).appTheme.darkText
          //             : appColor(context).appTheme.lightText,
          //         BlendMode.srcIn),
          //   ).paddingOnly(
          //       left: rtl(context) ? 0 : Insets.i35,
          //       right: rtl(context) ? Insets.i35 : 0,
          //       top: Insets.i16)
          // ]),
          //
          // ContainerWithTextLayout(title: "${translations!.identityType} *")
          //     .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          // DropDownLayout(
          //         hintText: translations!.selectType,
          //         icon: eSvgAssets.identity,
          //         // doc: value.documentModel,
          //         isIcon: true,
          //         document: documentList,
          //         onChanged: (val) => value.onIdentityChange(val))
          //     .paddingSymmetric(horizontal: Insets.i20),
          //
          // ContainerWithTextLayout(title: "${translations!.identityNo} *")
          //     .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          // TextFieldCommon(
          //         focusNode: value.identityNumberFocus,
          //         controller: value.identityNumber,
          //         validator: (v) => validation.dynamicTextValidation(
          //             context, v, translations!.enterIdentityNo),
          //         hintText: translations!.enterIdentityNo!,
          //         prefixIcon: eSvgAssets.identity)
          //     .paddingSymmetric(horizontal: Insets.i20),
          //
          // ContainerWithTextLayout(title: "${translations!.experience} *")
          //     .paddingOnly(top: Insets.i24, bottom: Insets.i8),
          // Row(children: [
          //   Expanded(
          //       flex: 3,
          //       child: TextFieldCommon(
          //               keyboardType: TextInputType.number,
          //               focusNode: value.experienceFocus,
          //               controller: value.experience,
          //               validator: (v) =>
          //                   validation.commonValidation(context, v),
          //               hintText: translations!.addExperience!,
          //               prefixIcon: eSvgAssets.timer)
          //           .paddingOnly(
          //               left: rtl(context) ? 0 : Insets.i20,
          //               right: rtl(context) ? Insets.i20 : 0)),
          //   Expanded(
          //       flex: 2,
          //       child: DarkDropDownLayout(
          //               border: InputBorder.none,
          //               isBig: true,
          //               // val: value.chosenValue,
          //               hintText: translations!.month,
          //               isIcon: false,
          //               categoryList: appArray.experienceList,
          //               onChanged: (val) => value.onDropDownChange(val))
          //           .paddingOnly(
          //               right: rtl(context) ? Insets.i8 : Insets.i20,
          //               left: rtl(context) ? Insets.i20 : Insets.i8))
          // ]),
          ContainerWithTextLayout(title: "${translations!.password}")
              .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          TextFieldCommon(
                  focusNode: value.passwordFocus,
                  controller: value.password,
                  hintText: translations!.enterPassword!,
                  suffixIcon: SvgPicture.asset(
                          value.isPassword ? eSvgAssets.hide : eSvgAssets.eye,
                          fit: BoxFit.scaleDown)
                      .inkWell(onTap: () => value.passwordSeenTap()),
                  obscureText: value.isPassword,
                  validator: (v) => validation.dynamicTextValidation(
                      context, v, translations!.pleaseEnterPassword),
                  prefixIcon: eSvgAssets.lock)
              .paddingSymmetric(horizontal: Insets.i20),
          ContainerWithTextLayout(title: "${translations!.confirmPassword}")
              .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          TextFieldCommon(
                  focusNode: value.reEnterPasswordFocus,
                  controller: value.reEnterPassword,
                  hintText: translations!.reEnterPassword!,
                  suffixIcon: SvgPicture.asset(
                          value.isConfirmPasswordobscure
                              ? eSvgAssets.hide
                              : eSvgAssets.eye,
                          fit: BoxFit.scaleDown)
                      .inkWell(
                          onTap: () => value.confirmPasswordObscureSeenTap()),
                  obscureText: value.isConfirmPasswordobscure,
                  validator: (v) => validation.confirmPassValidation(
                      context, v, value.password.text),
                  prefixIcon: eSvgAssets.lock)
              .paddingSymmetric(horizontal: Insets.i20),
          ContainerWithTextLayout(
                  title:
                      "${translations!.referralCode} (${translations!.optional})")
              .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          TextFieldCommon(
                  focusNode: value.referralCodeFocus,
                  controller: value.referralCode,
                  hintText: translations!.enterReferralCode ?? "",
                  prefixIcon: eSvgAssets.user)
              .paddingSymmetric(horizontal: Insets.i20),
          const ServiceAvailabilityLayout(),
        ]),
      );
    });
  }
}
