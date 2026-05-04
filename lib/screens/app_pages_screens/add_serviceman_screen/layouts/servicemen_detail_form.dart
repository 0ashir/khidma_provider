import '../../../../config.dart';

class ServicemenDetailForm extends StatelessWidget {
  const ServicemenDetailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddServicemenProvider>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ContainerWithTextLayout(title: translations!.userName)
          .paddingOnly(bottom: Insets.i8),
      TextFieldCommon(
              focusNode: value.userNameFocus,
              controller: value.userName,
              validator: (name) => validation.nameValidation(context, name),
              hintText: translations!.enterName!,
              prefixIcon: eSvgAssets.user)
          .paddingSymmetric(horizontal: Insets.i20),
      ContainerWithTextLayout(title: translations!.phoneNo)
          .paddingOnly(bottom: Insets.i8, top: Insets.i20),
      RegisterWidgetClass().phoneTextBox(
          dialCode: value.dialCode,
          context,
          value.number,
          value.providerNumberFocus,
          onChanged: (CountryCodeCustom? code) => value.changeDialCode(code!),
          onFieldSubmitted: (values) => validation.fieldFocusChange(
              context, value.providerNumberFocus, value.emailFocus)),
      ContainerWithTextLayout(title: translations!.email)
          .paddingOnly(bottom: Insets.i8, top: Insets.i20),
      TextFieldCommon(
              focusNode: value.emailFocus,
              keyboardType: TextInputType.emailAddress,
              validator: (name) => validation.emailValidation(context, name),
              controller: value.email,
              hintText: translations!.enterEmail!,
              prefixIcon: eSvgAssets.email)
          .paddingSymmetric(horizontal: Insets.i20),
      if (value.servicemanModel == null)
        ContainerWithTextLayout(title: translations!.identityType)
            .paddingOnly(bottom: Insets.i8, top: Insets.i20),
      if (value.servicemanModel == null)
        DropDownLayout(
                isWidth: true,
                hintText: translations!.selectType,
                icon: eSvgAssets.identity,
                doc: value.identityValue,
                isIcon: true,
                document: documentList,
                onChanged: (val) => value.onChangeIdentity(val))
            .paddingSymmetric(horizontal: Insets.i20),
      if (value.servicemanModel == null)
        ContainerWithTextLayout(title: translations!.identityNo)
            .paddingOnly(bottom: Insets.i8, top: Insets.i20),
      if (value.servicemanModel == null)
        TextFieldCommon(
                focusNode: value.identityNumberFocus,
                controller: value.identityNumber,
                validator: (name) => validation.dynamicTextValidation(
                    context, name, translations!.pleaseEnterNumber),
                hintText: translations!.enterIdentityNo!,
                prefixIcon: eSvgAssets.identity)
            .paddingSymmetric(horizontal: Insets.i20),
      if (value.servicemanModel == null)
        ContainerWithTextLayout(title: translations!.identityPhoto)
            .paddingOnly(bottom: Insets.i8, top: Insets.i20),
      if (value.servicemanModel == null)
        appArray.servicemanDocImageList.isNotEmpty
            ? const ServicemanDocImageList()
            : UploadImageLayout(onTap: () => value.onImagePick(context, false))
    ]);
  }
}
