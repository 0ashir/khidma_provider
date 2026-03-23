import '../../../../config.dart';

class RowTextBoxLayout extends StatelessWidget {
  final FocusNode? focusNode1, focusNode2;
  final TextEditingController? textEditingController1, textEditingController2;
  final String? text1, text2, icon1, icon2;
  final String? Function(String?)? validator1, validator2;

  const RowTextBoxLayout({
    super.key,
    this.focusNode1,
    this.focusNode2,
    this.textEditingController1,
    this.textEditingController2,
    this.text1,
    this.text2,
    this.validator1,
    this.validator2,
    this.icon1,
    this.icon2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Column(children: [
        ContainerWithTextLayout(title: text1)
            .paddingOnly(top: Insets.i24, bottom: Insets.i8),
        TextFieldCommon(
                focusNode: focusNode1,
                validator: validator1,
                controller: textEditingController1,
                keyboardType: text1 == translations!.city
                    ? TextInputType.name
                    : TextInputType.number,
                hintText: text1!,
                prefixIcon: icon1)
            .paddingOnly(
                left: rtl(context) ? 0 : Insets.i20,
                right: rtl(context) ? Insets.i20 : 0)
      ])),
      const HSpace(Sizes.s15),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(language(context, text2),
                style: appCss.dmDenseSemiBold14
                    .textColor(appColor(context).appTheme.darkText))
            .paddingOnly(top: Insets.i30, bottom: Insets.i8),
        TextFieldCommon(
                focusNode: focusNode2,
                controller: textEditingController2,
                validator: validator2,
                keyboardType: TextInputType.number,
                hintText: text2!,
                prefixIcon: icon2!)
            .paddingOnly(
                right: rtl(context) ? 0 : Insets.i20,
                left: rtl(context) ? Insets.i20 : 0)
      ]))
    ]);
  }
}

class RowTextBoxLayoutWithoutContainer extends StatelessWidget {
  final FocusNode? focusNode1, focusNode2;
  final TextEditingController? textEditingController1, textEditingController2;
  final String? text1, text2, icon1, icon2;
  final String? Function(String?)? validator1, validator2;

  const RowTextBoxLayoutWithoutContainer({
    super.key,
    this.focusNode1,
    this.focusNode2,
    this.textEditingController1,
    this.textEditingController2,
    this.text1,
    this.text2,
    this.validator1,
    this.validator2,
    this.icon1,
    this.icon2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(language(context, text1),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
            .paddingOnly(bottom: Insets.i8),
        TextFieldCommon(
            keyboardType: TextInputType.number,
            focusNode: focusNode1,
            controller: textEditingController1,
            hintText: text1!,
            prefixIcon: icon1)
      ])),
      const HSpace(Sizes.s15),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(language(context, text2),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))
            .paddingOnly(bottom: Insets.i8),
        TextFieldCommon(
            keyboardType: TextInputType.number,
            focusNode: focusNode2,
            controller: textEditingController2,
            hintText: text2!,
            prefixIcon: icon2)
      ]))
    ]);
  }
}
