// ignore_for_file: must_be_immutable

import 'package:fixit_provider/widgets/multi_dropdown_common.dart';

import '../../../../config.dart';

class TextFieldLayout extends StatelessWidget {
  TextFieldLayout({super.key});
  CountryCodeCustom country = CountryCodeCustom();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileDetailProvider, LocationProvider>(
        builder: (context1, value, locationProvider, child) {
      return Column(children: [
        ContainerWithTextLayout(title: "${translations!.userName}*"),
        const VSpace(Sizes.s8),
        TextFieldCommon(
                controller: value.txtName,
                hintText: isServiceman
                    ? translations!.enterName!
                    : translations!.ownerName!,
                focusNode: value.nameFocus,
                onFieldSubmitted: (values) => validation.fieldFocusChange(
                    context, value.nameFocus, value.emailFocus),
                prefixIcon: eSvgAssets.user,
                validator: (value) => validation.nameValidation(context, value))
            .paddingSymmetric(horizontal: Insets.i20),
        const VSpace(Sizes.s15),
        ContainerWithTextLayout(title: language(context, translations!.email)),
        const VSpace(Sizes.s8),
        TextFieldCommon(
                controller: value.txtEmail,
                hintText: language(context, translations!.enterEmail),
                focusNode: value.emailFocus,
                onFieldSubmitted: (values) => validation.fieldFocusChange(
                    context, value.emailFocus, value.phoneFocus),
                prefixIcon: eSvgAssets.email,
                validator: (value) =>
                    validation.emailValidation(context, value))
            .paddingSymmetric(horizontal: Insets.i20),
        const VSpace(Sizes.s15),
        ContainerWithTextLayout(
            title: language(context, translations!.phoneNo)),
        const VSpace(Sizes.s10),
        RegisterWidgetClass().phoneTextBox(
            // dialCode: value.dialCode,
            dialCode:
                value.dialCode == country.dialCode ? null : value.dialCode,
            context,
            value.txtPhone,
            value.phoneFocus,
            onChanged: (CountryCodeCustom? code) => value.changeDialCode(code!),
            onFieldSubmitted: (values) => validation.fieldFocusChange(
                context, value.phoneFocus, value.phoneFocus)),
        ContainerWithTextLayout(title: "${translations!.experience} *")
            .paddingOnly(top: Insets.i24, bottom: Insets.i8),
        Row(children: [
          Expanded(
              flex: 3,
              child: TextFieldCommon(
                      keyboardType: TextInputType.number,
                      validator: (v) => validation.commonValidation(context, v),
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
                          radius: 0, color: appColor(context).appTheme.trans),
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
        if (isServiceman)
          Column(
            children: [
              const VSpace(Sizes.s15),
              ContainerWithTextLayout(
                  title: language(context, translations!.knowLanguage)),
              const VSpace(Sizes.s10),
              Stack(children: [
                MultiSelectDropDownCustom(
                        backgroundColor: appColor(context).appTheme.whiteBg,
                        onOptionSelected: (options) =>
                            value.onLanguageSelect(options),
                        selectedOptions: value.languageSelect,
                        options: knownLanguageList
                            .asMap()
                            .entries
                            .map((e) => ValueItem(
                                label: language(context, e.value.key),
                                value: e.value.id))
                            .toList(),
                        selectionType: SelectionType.multi,
                        hint: language(context, translations!.selectLanguage),
                        optionsBackgroundColor:
                            appColor(context).appTheme.whiteBg,
                        selectedOptionBackgroundColor:
                            appColor(context).appTheme.whiteBg,
                        hintStyle: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.lightText),
                        chipConfig: CommonWidgetLayout().chipWidget(context),
                        padding: EdgeInsets.only(
                            left: rtl(context) ? Insets.i10 : Insets.i40,
                            right: rtl(context) ? Insets.i40 : Insets.i10),
                        showClearIcon: false,
                        borderColor: appColor(context).appTheme.trans,
                        borderRadius: AppRadius.r8,
                        suffixIcon: SvgPicture.asset(eSvgAssets.dropDown,
                            colorFilter: ColorFilter.mode(
                                value.languageSelect.isNotEmpty
                                    ? appColor(context).appTheme.darkText
                                    : appColor(context).appTheme.lightText,
                                BlendMode.srcIn)),
                        optionTextStyle: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.darkText),
                        selectedOptionIcon: Icon(Icons.check_box_rounded,
                            color: appColor(context).appTheme.primary))
                    .paddingSymmetric(horizontal: Insets.i20),
                SvgPicture.asset(
                  eSvgAssets.country,
                  colorFilter: ColorFilter.mode(
                      value.languageSelect.isNotEmpty
                          ? appColor(context).appTheme.darkText
                          : appColor(context).appTheme.lightText,
                      BlendMode.srcIn),
                ).paddingOnly(
                    left: rtl(context) ? 0 : Insets.i35,
                    right: rtl(context) ? Insets.i35 : 0,
                    top: Insets.i16)
              ]),
              const VSpace(Sizes.s15),
              ContainerWithTextLayout(
                  title: language(context, translations!.location)),
              const VSpace(Sizes.s10),
              TextFieldCommon(
                      onTap: () =>
                          route.pushNamed(context, routeName.location, arg: {
                            "isServiceman":
                                userModel!.role == "provider" ? false : true,
                            "data": value.address,
                          }).then((e) {}),
                      focusNode: value.location,
                      validator: (name) => validation.dynamicTextValidation(
                          context, name, translations!.pleaseAddAddress),
                      controller: value.locationCtrl,
                      hintText: translations!.location!,
                      prefixIcon: eSvgAssets.locationOut)
                  .paddingSymmetric(horizontal: Insets.i20),
            ],
          ),
      ]);
    });
  }
}
