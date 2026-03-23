import '../../../../config.dart';

class ExperienceLayout extends StatelessWidget {
  const ExperienceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddServicemenProvider>(context);

    return Column(children: [
      ContainerWithTextLayout(title: translations!.experience)
          .paddingOnly(bottom: Insets.i8, top: Insets.i20),
      Row(children: [
        Expanded(
            child: TextFieldCommon(
                    keyboardType: TextInputType.number,
                    focusNode: value.experienceFocus,
                    controller: value.experience,
                    hintText: translations!.experience!,
                    prefixIcon: eSvgAssets.timer)
                .paddingOnly(
                    left: rtl(context) ? 0 : Insets.i20,
                    right: rtl(context) ? Insets.i20 : 0)),
        Expanded(
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
      ])
    ]);
  }
}
