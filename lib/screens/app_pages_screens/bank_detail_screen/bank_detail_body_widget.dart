import '../../../config.dart';

class BankDetailBodyWidget extends StatelessWidget {
  const BankDetailBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailProvider>(builder: (context1, value, child) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerWithTextLayout(
                title: language(context, translations!.bankName)),
            const VSpace(Sizes.s8),
            TextFieldCommon(
                    focusNode: value.bankNameFocus,
                    onFieldSubmitted: (v) => validation.fieldFocusChange(
                        context, value.bankNameFocus, value.holdNameFocus),
                    textCapitalization: TextCapitalization.characters,
                    controller: value.bankNameCtrl,
                    hintText: translations!.bankName!,
                    prefixIcon: eSvgAssets.bank)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: translations!.holderName)
                .paddingOnly(top: Insets.i10, bottom: Insets.i5),
            TextFieldCommon(
                    focusNode: value.holdNameFocus,
                    controller: value.holderNameCtrl,
                    onFieldSubmitted: (v) => validation.fieldFocusChange(
                        context, value.holdNameFocus, value.accountFocus),
                    textCapitalization: TextCapitalization.characters,
                    hintText: translations!.holderName!,
                    prefixIcon: eSvgAssets.profile)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: translations!.accountNo)
                .paddingOnly(top: Insets.i10, bottom: Insets.i5),
            TextFieldCommon(
                    keyboardType: TextInputType.number,
                    focusNode: value.accountFocus,
                    onFieldSubmitted: (v) => validation.fieldFocusChange(
                        context, value.accountFocus, value.branchFocus),
                    controller: value.accountCtrl,
                    hintText: translations!.accountNo!,
                    prefixIcon: eSvgAssets.account)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: translations!.branchName)
                .paddingOnly(top: Insets.i10, bottom: Insets.i5),
            TextFieldCommon(
                    focusNode: value.branchFocus,
                    onFieldSubmitted: (v) => validation.fieldFocusChange(
                        context, value.branchFocus, value.ifscFocus),
                    controller: value.branchCtrl,
                    textCapitalization: TextCapitalization.characters,
                    hintText: translations!.branchName!,
                    prefixIcon: eSvgAssets.bank)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: translations!.ifscCode)
                .paddingOnly(top: Insets.i10, bottom: Insets.i5),
            TextFieldCommon(
                    focusNode: value.ifscFocus,
                    onFieldSubmitted: (v) => validation.fieldFocusChange(
                        context, value.ifscFocus, value.swiftFocus),
                    controller: value.ifscCtrl,
                    textCapitalization: TextCapitalization.characters,
                    hintText: translations!.ifscCode!,
                    prefixIcon: eSvgAssets.identity)
                .paddingSymmetric(horizontal: Insets.i20),
            ContainerWithTextLayout(title: translations!.swiftCode)
                .paddingOnly(top: Insets.i10, bottom: Insets.i5),
            TextFieldCommon(
                    focusNode: value.swiftFocus,
                    onFieldSubmitted: (v) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: value.swiftCtrl,
                    textCapitalization: TextCapitalization.characters,
                    hintText: translations!.swiftCode!,
                    prefixIcon: eSvgAssets.identity)
                .paddingSymmetric(horizontal: Insets.i20),
          ]).paddingSymmetric(vertical: Insets.i20);
    });
  }
}
