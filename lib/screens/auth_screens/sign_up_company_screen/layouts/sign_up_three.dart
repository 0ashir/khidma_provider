import '../../../../config.dart';

class SignUpThree extends StatelessWidget {
  const SignUpThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SignUpCompanyProvider, CommonApiProvider>(
        builder: (context1, value, api, child) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
              key: value.signupFormKey3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerWithTextLayout(title: "${translations!.logo}"),
                    const VSpace(Sizes.s12),
                    CompanyLogoLayout(imageFile: value.imageFile)
                        .inkWell(onTap: () => value.onImagePick(context))
                        .padding(bottom: Insets.i15, horizontal: Insets.i20),
                    ContainerWithTextLayout(
                            title:
                                "${isFreelancer ? translations!.userName : translations!.ownerName}")
                        .paddingOnly(bottom: Insets.i8),
                    TextFieldCommon(
                            focusNode: value.ownerNameFocus,
                            controller: value.ownerName,
                            validator: (v) =>
                                validation.nameValidation(context, v),
                            hintText: translations!.enterName!,
                            prefixIcon: eSvgAssets.user)
                        .paddingSymmetric(horizontal: Insets.i20),
                    ContainerWithTextLayout(title: "${translations!.phoneNo}")
                        .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    RegisterWidgetClass().phoneTextBox(
                        dialCode: value.providerDialCode,
                        context,
                        value.providerNumber,
                        value.providerNumberFocus,
                        onChanged: (CountryCodeCustom? code) =>
                            value.changeProviderDialCode(code!),
                        onFieldSubmitted: (values) =>
                            validation.fieldFocusChange(context,
                                value.providerNumberFocus, value.emailFocus)),
                    ContainerWithTextLayout(title: "${translations!.email}")
                        .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    TextFieldCommon(
                            focusNode: value.providerEmailFocus,
                            validator: (v) =>
                                validation.emailValidation(context, v),
                            controller: value.providerEmail,
                            hintText: translations!.enterEmail!,
                            prefixIcon: eSvgAssets.email)
                        .paddingSymmetric(horizontal: Insets.i20),
                    // ContainerWithTextLayout(title: "${translations!.knownLanguage} *")
                    //     .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    // Stack(children: [
                    //   MultiSelectDropDownCustom(
                    //           backgroundColor: appColor(context).appTheme.whiteBg,
                    //           optionsBackgroundColor:
                    //               appColor(context).appTheme.whiteBg,
                    //           onOptionSelected: (options) =>
                    //               value.onLanguageSelect(options),
                    //           searchEnabled: true,
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
                    //           selectedOptionBackgroundColor:
                    //               appColor(context).appTheme.whiteBg,
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
                    // ContainerWithTextLayout(title: "${translations!.identityType} *")
                    //     .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    // DropDownLayout(
                    //         hintText: translations!.selectType,
                    //         icon: eSvgAssets.identity,
                    //         doc: value.documentModel,
                    //         isIcon: true,
                    //         document: documentList,
                    //         onChanged: (val) => value.onIdentityChange(val))
                    //     .paddingSymmetric(horizontal: Insets.i20),
                    // ContainerWithTextLayout(title: "${translations!.identityNo} *")
                    //     .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    // TextFieldCommon(
                    //         focusNode: value.identityNumberFocus,
                    //         validator: (v) => validation.dynamicTextValidation(
                    //             context, v, translations!.enterIdentityNo),
                    //         controller: value.identityNumber,
                    //         hintText: translations!.enterIdentityNo!,
                    //         prefixIcon: eSvgAssets.identity)
                    //     .paddingSymmetric(horizontal: Insets.i20),

                    ContainerWithTextLayout(title: "${translations!.password}")
                        .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    TextFieldCommon(
                            obscureText: value.isNewPassword,
                            focusNode: value.passwordFocus,
                            controller: value.password,
                            suffixIcon: SvgPicture.asset(
                                    value.isNewPassword
                                        ? eSvgAssets.hide
                                        : eSvgAssets.eye,
                                    fit: BoxFit.scaleDown)
                                .inkWell(
                                    onTap: () => value.newPasswordSeenTap()),
                            validator: (v) => validation.dynamicTextValidation(
                                context, v, translations!.pleaseEnterPassword),
                            hintText: translations!.enterPassword!,
                            prefixIcon: eSvgAssets.lock)
                        .paddingSymmetric(horizontal: Insets.i20),
                    ContainerWithTextLayout(
                            title: "${translations!.confirmPassword}")
                        .paddingOnly(bottom: Insets.i8, top: Insets.i20),
                    TextFieldCommon(
                            obscureText: value.isConfirmPassword,
                            focusNode: value.reEnterPasswordFocus,
                            suffixIcon: SvgPicture.asset(
                                    value.isConfirmPassword
                                        ? eSvgAssets.hide
                                        : eSvgAssets.eye,
                                    fit: BoxFit.scaleDown)
                                .inkWell(
                                    onTap: () =>
                                        value.confirmPasswordSeenTap()),
                            controller: value.reEnterPassword,
                            hintText: translations!.reEnterPassword!,
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
                    const ContainerWithTextLayout(title: "Role")
                        .paddingOnly(bottom: Insets.i8, top: Insets.i20),

                    RoleDropDownLayout(
                            hintText: "Select Role",
                            icon: eSvgAssets.role,
                            isIcon: true,
                            roles: const ["Serviceman", "Provider"],
                            selectedValue: value.selectedRole,
                            onChanged: (val) => value.onRoleChanged(val))
                        .paddingSymmetric(horizontal: Insets.i20),
                    value.selectedRole == "Provider"
                        ? const ServiceAvailabilityLayout()
                        : Container(),

                    value.selectedRole == "Serviceman"
                        ? const ContainerWithTextLayout(
                                title: "Select Category")
                            .paddingOnly(bottom: Insets.i8, top: Insets.i20)
                        : Container(),

                    value.selectedRole == "Serviceman"
                        ? Consumer<SignUpCompanyProvider>(
                            builder: (context, categoryProvider, _) {
                            final categories = categoryProvider.categoryList;
                            final selected = categoryProvider.selectedCategory;

                            return CategoryDropDownLayout(
                                hintText: "Select Category",
                                categories: categories,
                                selectedValue: selected,
                                onChanged: (val) =>
                                    value.category(context, val),
                                icon: eSvgAssets.categorySmall,
                                isIcon: true);
                          }).marginSymmetric(horizontal: Insets.i20)
                        : Container(),
                    value.selectedRole == "Serviceman"
                        ? const ContainerWithTextLayout(
                                title: "Select Provider")
                            .paddingOnly(bottom: Insets.i8, top: Insets.i20)
                        : Container(),

                    value.selectedRole == "Serviceman"
                        ? Consumer<SignUpCompanyProvider>(
                            builder: (context, categoryProvider, _) {
                            return ProviderDropDownLayout(
                                hintText: "Select Provider",
                                providers: categoryProvider.providerList,
                                selectedValue:
                                    categoryProvider.selectedProvider,
                                onChanged: (val) => value.providerListing(val),
                                icon: eSvgAssets.profile,
                                isIcon: true);
                          }).marginSymmetric(horizontal: Insets.i20)
                        : Container(),
                  ])));
    });
  }
}
