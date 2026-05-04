import '../../../../config.dart';

class SignUpOne extends StatelessWidget {
  const SignUpOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpCompanyProvider>(builder: (context1, value, child) {
      return Form(
          key: value.signupFormKey1,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContainerWithTextLayout(title: "${translations!.logo}"),
            const VSpace(Sizes.s12),
            CompanyLogoLayout(imageFile: value.imageFile)
                .inkWell(onTap: () => value.onImagePick(context))
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: "${translations!.companyName}")
                .paddingOnly(top: Insets.i24, bottom: Insets.i8),
            TextFieldCommon(
                    controller: value.companyName,
                    validator: (v) => validation.nameValidation(context, v),
                    focusNode: value.companyNameFocus,
                    hintText: translations!.enterCompanyName!,
                    prefixIcon: eSvgAssets.companyName)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: "${translations!.companyPhoneNo}")
                .paddingOnly(top: Insets.i24, bottom: Insets.i8),
            RegisterWidgetClass().phoneTextBox(
                dialCode: value.dialCode,
                context,
                value.companyPhone,
                value.phoneNameFocus,
                onChanged: (CountryCodeCustom? code) =>
                    value.changeDialCode(code!),
                onFieldSubmitted: (values) => validation.fieldFocusChange(
                    context, value.phoneNameFocus, value.companyMailFocus)),
            ContainerWithTextLayout(title: "${translations!.companyMail}")
                .paddingOnly(top: Insets.i24, bottom: Insets.i8),
            TextFieldCommon(
                    validator: (v) => validation.emailValidation(context, v),
                    controller: value.companyMail,
                    focusNode: value.companyMailFocus,
                    keyboardType: TextInputType.emailAddress,
                    hintText: translations!.enterMail!,
                    prefixIcon: eSvgAssets.email)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: "${translations!.experience}")
                .paddingOnly(top: Insets.i24, bottom: Insets.i8),
            Row(children: [
              Expanded(
                  flex: 3,
                  child: TextFieldCommon(
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              validation.commonValidation(context, v),
                          focusNode: value.experienceFocus,
                          controller: value.experience,
                          hintText: translations!.addExperience!,
                          prefixIcon: eSvgAssets.timer)
                      .paddingOnly(
                          left: rtl(context) ? 0 : Insets.i20,
                          right: rtl(context) ? Insets.i20 : 0)),
              Expanded(
                  flex: 2,
                  child: DarkDropDownLayout(
                          svgColor: appColor(context).appTheme.lightText,
                          border: CommonWidgetLayout().noneDecoration(
                              radius: 0,
                              color: appColor(context).appTheme.trans),
                          isBig: true,
                          val: value.chosenValue,
                          hintText: translations!.month,
                          isIcon: false,
                          categoryList: appArray.experienceList,
                          onChanged: (val) => value.onDropDownChange(val))
                      .paddingOnly(
                          right: rtl(context) ? Insets.i8 : Insets.i20,
                          left: rtl(context) ? Insets.i20 : Insets.i8))
            ]),
            ContainerWithTextLayout(title: "${translations!.description}")
                .paddingOnly(top: Insets.i24, bottom: Insets.i8),
            Stack(children: [
              TextFieldCommon(
                      focusNode: value.descriptionFocus,
                      isNumber: true,
                      validator: (v) => validation.dynamicTextValidation(
                          context, v, translations!.pleaseEnterDesc),
                      controller: value.description,
                      hintText: translations!.enterDetails!,
                      maxLines: 3,
                      minLines: 3,
                      isMaxLine: true)
                  .paddingSymmetric(horizontal: Insets.i20),
              SvgPicture.asset(eSvgAssets.details,
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                          !value.descriptionFocus.hasFocus
                              ? value.description.text.isNotEmpty
                                  ? appColor(context).appTheme.darkText
                                  : appColor(context).appTheme.lightText
                              : appColor(context).appTheme.darkText,
                          BlendMode.srcIn))
                  .paddingOnly(
                      left: rtl(context) ? 0 : Insets.i35,
                      right: rtl(context) ? Insets.i35 : 0,
                      top: Insets.i13)
            ])
          ]));
    });
  }
}
