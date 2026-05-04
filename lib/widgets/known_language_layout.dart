import '../config.dart';

class KnownLanguageLayout extends StatelessWidget {
  const KnownLanguageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddServicemenProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
      padding: const EdgeInsets.symmetric(
          horizontal: Sizes.s15, vertical: Sizes.s10),
      decoration: ShapeDecoration(
          color: appColor(context).appTheme.whiteBg,
          shape: SmoothRectangleBorder(
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(eSvgAssets.country,
                        colorFilter: ColorFilter.mode(
                            value.languageSelect.isNotEmpty
                                ? appColor(context).appTheme.darkText
                                : appColor(context).appTheme.lightText,
                            BlendMode.srcIn))
                    .padding(
                        left: Insets.i5,
                        right: rtl(context) ? Insets.i5 : 0,
                        top: Sizes.s5,
                        vertical: Sizes.s5),
                const HSpace(Sizes.s12),
                if (value.languageSelect.isNotEmpty)
                  Expanded(
                    child: Wrap(
                        direction: Axis.horizontal,
                        children: value.languageSelect
                            .asMap()
                            .entries
                            .map((e) => Container(
                                    margin: EdgeInsets.only(
                                        bottom: value.languageSelect.length -
                                                    1 !=
                                                e.key
                                            ? Sizes.s8
                                            : 0,
                                        right: Sizes.s10),
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: Sizes.s9,
                                            vertical: Sizes.s5),
                                    decoration: ShapeDecoration(
                                        shape: SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: 8,
                                              cornerSmoothing: 1),
                                        ),
                                        color: Color.fromRGBO(84, 101, 255, 0.1)),
                                    child:
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          SvgPicture.asset(
                                            eSvgAssets.cross,
                                            height: 16,
                                            colorFilter: ColorFilter.mode(
                                                appColor(context)
                                                    .appTheme
                                                    .primary,
                                                BlendMode.srcIn),
                                          ),
                                          const HSpace(Sizes.s2),
                                          Text(e.value.key!,
                                              style: appCss.dmDenseLight14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .primary))
                                        ]))
                                .inkWell(
                                    onTap: () =>
                                        value.onLanguageSelect(e.value)))
                            .toList()),
                  ),
                if (value.languageSelect.isEmpty)
                  Text(language(context, translations!.knowLanguage),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.lightText))
              ],
            ),
          ),
          SvgPicture.asset(eSvgAssets.dropDown,
              colorFilter: ColorFilter.mode(
                  value.languageSelect.isNotEmpty
                      ? appColor(context).appTheme.darkText
                      : appColor(context).appTheme.lightText,
                  BlendMode.srcIn))
        ],
      ),
    ).inkWell(onTap: () => value.onBottomSheet(context));
    /* return Stack(children: [
      MultiSelectDropDownCustom(

              backgroundColor: appColor(context).appTheme.whiteBg,
              onOptionSelected: (options) => value.onLanguageSelect(options),
              selectedOptions: value.languageSelect,
              options: knownLanguageList
                  .asMap()
                  .entries
                  .map((e) => ValueItem(
                      label: language(context, e.value.key), value: e.value.id))
                  .toList(),
              selectionType: SelectionType.multi,
              hint: language(context, translations!.selectLanguage),
              optionsBackgroundColor: appColor(context).appTheme.whiteBg,
              selectedOptionBackgroundColor: appColor(context).appTheme.whiteBg,
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
    ]);*/
  }
}
