import '../../../../config.dart';

class DropDownLayout extends StatelessWidget {
  final String? icon, hintText, val;
  final List? categoryList;
  final String? doc;
  final double? textWidth;
  final CategoryModel? cat;
  final ValueChanged? onChanged;
  final bool? isIcon, isField, isBig, isListIcon, isOnlyText, isWidth;
  final List<DocumentModel>? document;
  final List<CategoryModel>? category;

  const DropDownLayout(
      {super.key,
      this.icon,
      this.hintText,
      this.val,
      this.onChanged,
      this.isField = false,
      this.isIcon = false,
      this.isBig = false,
      this.categoryList,
      this.isListIcon = false,
      this.isOnlyText = false,
      this.document,
      this.doc,
      this.category,
      this.cat,
      this.textWidth,
      this.isWidth});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
            child: ButtonTheme(
                child: DropdownButtonFormField(
                    hint: Text(language(context, hintText ?? ""),
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.lightText)),
                    decoration: InputDecoration(
                        prefixIcon: isIcon == true
                            ? SvgPicture.asset(icon!,
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                    document != null && document!.isNotEmpty
                                        ? doc == null
                                            ? appColor(context)
                                                .appTheme
                                                .lightText
                                            : appColor(context)
                                                .appTheme
                                                .darkText
                                        : category != null &&
                                                category!.isNotEmpty
                                            ? cat == null
                                                ? appColor(context)
                                                    .appTheme
                                                    .lightText
                                                : appColor(context)
                                                    .appTheme
                                                    .darkText
                                            : val == null
                                                ? appColor(context)
                                                    .appTheme
                                                    .lightText
                                                : appColor(context)
                                                    .appTheme
                                                    .darkText,
                                    BlendMode.srcIn))
                            : null,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        disabledBorder: CommonWidgetLayout().noneDecoration(
                            color: appColor(context).appTheme.trans),
                        focusedBorder: CommonWidgetLayout().noneDecoration(
                            color: appColor(context).appTheme.trans),
                        enabledBorder: CommonWidgetLayout().noneDecoration(
                            color: appColor(context).appTheme.trans),
                        border: CommonWidgetLayout().noneDecoration(
                            color: appColor(context).appTheme.trans)),
                    padding: EdgeInsets.zero,
                    value: document != null &&
                            document!.isNotEmpty &&
                            document!.any((e) => e.id.toString() == doc)
                        ? doc
                        : category != null &&
                                category!.isNotEmpty &&
                                category!.contains(cat)
                            ? cat
                            : categoryList != null &&
                                    categoryList!.contains(val)
                                ? val
                                : null,
                    /*  document != null && document!.isNotEmpty ? doc : val, */
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppRadius.r8)),
                    style: appCss.dmDenseMedium14
                        .textColor(document != null && document!.isNotEmpty
                            ? doc == null
                                ? appColor(context).appTheme.lightText
                                : appColor(context).appTheme.darkText
                            : category != null && category!.isNotEmpty
                                ? cat == null
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.darkText
                                : val == null
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.darkText),
                    icon: SvgPicture.asset(eSvgAssets.dropDown,
                        colorFilter: ColorFilter.mode(
                            document != null && document!.isNotEmpty
                                ? doc == null
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.darkText
                                : category != null && category!.isNotEmpty
                                    ? cat == null
                                        ? appColor(context).appTheme.lightText
                                        : appColor(context).appTheme.darkText
                                    : val == null
                                        ? appColor(context).appTheme.lightText
                                        : appColor(context).appTheme.darkText,
                            BlendMode.srcIn)),
                    isDense: true,
                    isExpanded: true,
                    items: document != null && document!.isNotEmpty
                        ? document!.asMap().entries.map((e) {
                            return DropdownMenuItem(
                                value: e.value.id.toString(),
                                child: Row(
                                  children: [
                                    isWidth == true
                                        ? Text(language(context, e.value.title),
                                                style: appCss.dmDenseMedium14
                                                    .textColor(doc == null
                                                        ? appColor(context)
                                                            .appTheme
                                                            .lightText
                                                        : appColor(context)
                                                            .appTheme
                                                            .darkText)
                                                    .textHeight(1.5))
                                            .width(Sizes.s200)
                                        : Text(language(context, e.value.title),
                                            style: appCss.dmDenseMedium14
                                                .textColor(doc == null
                                                    ? appColor(context)
                                                        .appTheme
                                                        .lightText
                                                    : appColor(context)
                                                        .appTheme
                                                        .darkText)
                                                .textHeight(1.8)),
                                  ],
                                ));
                          }).toList()
                        : category != null
                            ? category!.asMap().entries.map((e) {
                                return DropdownMenuItem(
                                    value: e.value,
                                    child: Row(
                                      children: [
                                        Text(language(context, e.value.title),
                                            style: appCss.dmDenseMedium14
                                                .textColor(doc == null
                                                    ? appColor(context)
                                                        .appTheme
                                                        .lightText
                                                    : appColor(context)
                                                        .appTheme
                                                        .darkText)),
                                      ],
                                    ));
                              }).toList()
                            : category == null
                                ? null
                                : categoryList!.asMap().entries.map((e) {
                                    return DropdownMenuItem(
                                        value: e.value,
                                        child: Row(
                                          children: [
                                            if (isListIcon == true)
                                              SizedBox(
                                                      height: Sizes.s13,
                                                      width: Sizes.s13,
                                                      child: SvgPicture.asset(
                                                        e.value["image"],
                                                        fit: BoxFit.scaleDown,
                                                      ))
                                                  .paddingAll(Insets.i4)
                                                  .decorated(
                                                      color: appColor(context)
                                                          .appTheme
                                                          .fieldCardBg,
                                                      shape: BoxShape.circle),
                                            if (isListIcon == true)
                                              const HSpace(Sizes.s12),
                                            Text(language(context, e.value),
                                                style: appCss.dmDenseMedium14
                                                    .textColor(val == null
                                                        ? appColor(context)
                                                            .appTheme
                                                            .lightText
                                                        : appColor(context)
                                                            .appTheme
                                                            .darkText)),
                                          ],
                                        ));
                                  }).toList(),
                    onChanged: onChanged)))
        .padding(
            vertical: isBig == true
                ? Insets.i14
                : isOnlyText == true
                    ? Insets.i5
                    : 0,
            left: isIcon == false
                ? rtl(context)
                    ? Insets.i15
                    : Insets.i10
                : rtl(context)
                    ? Insets.i15
                    : Insets.i2,
            right: rtl(context) ? 10 : Insets.i10)
        .decorated(
            color: isField == true
                ? appColor(context).appTheme.fieldCardBg
                : appColor(context).appTheme.whiteBg,
            borderRadius: BorderRadius.circular(AppRadius.r8));
  }
}

class RoleDropDownLayout extends StatelessWidget {
  final String? icon, hintText, selectedValue;
  final List<String> roles;
  final ValueChanged<String?>? onChanged;
  final bool? isIcon;

  const RoleDropDownLayout({
    super.key,
    this.icon,
    this.hintText,
    required this.roles,
    this.selectedValue,
    this.onChanged,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButtonFormField<String>(
          hint: Text(
            language(context, hintText ?? ""),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.lightText),
          ),
          decoration: InputDecoration(
            prefixIcon: isIcon == true
                ? SvgPicture.asset(
                    icon!,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      selectedValue == null
                          ? appColor(context).appTheme.lightText
                          : appColor(context).appTheme.darkText,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            enabledBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            focusedBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            disabledBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)),
          value: roles.contains(selectedValue) ? selectedValue : null,
          style: appCss.dmDenseMedium14.textColor(
            selectedValue == null
                ? appColor(context).appTheme.lightText
                : appColor(context).appTheme.darkText,
          ),
          icon: SvgPicture.asset(
            eSvgAssets.dropDown,
            colorFilter: ColorFilter.mode(
              selectedValue == null
                  ? appColor(context).appTheme.lightText
                  : appColor(context).appTheme.darkText,
              BlendMode.srcIn,
            ),
          ),
          isDense: true,
          isExpanded: true,
          items: roles.map((role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(
                language(context, role),
                style: appCss.dmDenseMedium14.textColor(
                  selectedValue == null
                      ? appColor(context).appTheme.lightText
                      : appColor(context).appTheme.darkText,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    )
        .padding(
          vertical: Insets.i8,
          left: isIcon == false ? Insets.i10 : Insets.i2,
          right: Insets.i10,
        )
        .decorated(
          color: appColor(context).appTheme.whiteBg,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        );
  }
}

class CategoryDropDownLayout extends StatelessWidget {
  final String? icon, hintText;
  final List<CategoryModel> categories;
  final CategoryModel? selectedValue;
  final ValueChanged<CategoryModel?>? onChanged;
  final bool? isIcon;

  const CategoryDropDownLayout({
    super.key,
    this.icon,
    this.hintText,
    required this.categories,
    this.selectedValue,
    this.onChanged,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButtonFormField<CategoryModel>(
          hint: Text(
            language(context, hintText ?? ""),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.lightText),
          ),
          decoration: InputDecoration(
            prefixIcon: isIcon == true && icon != null
                ? SvgPicture.asset(
                    icon!,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      selectedValue == null
                          ? appColor(context).appTheme.lightText
                          : appColor(context).appTheme.darkText,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            enabledBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            focusedBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            disabledBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)),
          value: selectedValue,
          style: appCss.dmDenseMedium14.textColor(
            selectedValue == null
                ? appColor(context).appTheme.lightText
                : appColor(context).appTheme.darkText,
          ),
          icon: SvgPicture.asset(
            eSvgAssets.dropDown,
            colorFilter: ColorFilter.mode(
              selectedValue == null
                  ? appColor(context).appTheme.lightText
                  : appColor(context).appTheme.darkText,
              BlendMode.srcIn,
            ),
          ),
          isDense: true,
          isExpanded: true,
          items: categories.map((category) {
            return DropdownMenuItem<CategoryModel>(
              value: category,
              child: Row(
                children: [
                  if (category.media != null && category.media!.isNotEmpty)
                    Image.network(category.media![0].originalUrl!, height: 20),
                  HSpace(20),
                  Text(
                    language(context, category.title ?? ""),
                    style: appCss.dmDenseMedium14.textColor(
                      selectedValue == null
                          ? appColor(context).appTheme.lightText
                          : appColor(context).appTheme.darkText,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return categories.map((category) {
              return Row(
                children: [
                  Text(
                    language(context, category.title ?? ""),
                    style: appCss.dmDenseMedium14.textColor(
                      selectedValue == null
                          ? appColor(context).appTheme.lightText
                          : appColor(context).appTheme.darkText,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          onChanged: onChanged,
        ),
      ),
    )
        .padding(
          vertical: Insets.i8,
          left: isIcon == false ? Insets.i10 : Insets.i2,
          right: Insets.i10,
        )
        .decorated(
          color: appColor(context).appTheme.whiteBg,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        );
  }
}

class ProviderDropDownLayout extends StatelessWidget {
  final String? icon, hintText;
  final List<ProviderModel> providers;
  final ProviderModel? selectedValue;
  final ValueChanged<ProviderModel?>? onChanged;
  final bool? isIcon;

  const ProviderDropDownLayout({
    super.key,
    this.icon,
    this.hintText,
    required this.providers,
    this.selectedValue,
    this.onChanged,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButtonFormField<ProviderModel>(
          hint: Text(
            language(context, hintText ?? ""),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.lightText),
          ),
          decoration: InputDecoration(
            prefixIcon: isIcon == true && icon != null
                ? SvgPicture.asset(
                    icon!,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      selectedValue == null
                          ? appColor(context).appTheme.lightText
                          : appColor(context).appTheme.darkText,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            enabledBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            focusedBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
            disabledBorder: CommonWidgetLayout()
                .noneDecoration(color: appColor(context).appTheme.trans),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)),
          value: selectedValue,
          style: appCss.dmDenseMedium14.textColor(
            selectedValue == null
                ? appColor(context).appTheme.lightText
                : appColor(context).appTheme.darkText,
          ),
          icon: SvgPicture.asset(
            eSvgAssets.dropDown,
            colorFilter: ColorFilter.mode(
              selectedValue == null
                  ? appColor(context).appTheme.lightText
                  : appColor(context).appTheme.darkText,
              BlendMode.srcIn,
            ),
          ),
          isDense: true,
          isExpanded: true,
          items: providers.length == 0
              ? [
                  DropdownMenuItem(
                      child: Text(
                          "No Provider found in this category \nPlease Select another category",
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.darkText)))
                ]
              : providers.map((provider) {
                  return DropdownMenuItem<ProviderModel>(
                      value: provider,
                      child: Row(children: [
                        if (provider.media != null &&
                            provider.media!.isNotEmpty &&
                            provider.media![0].originalUrl != null)
                          Image.network(
                            provider.media![0].originalUrl!,
                            height: 20,
                          ),
                        HSpace(20),
                        Text(language(context, provider.name ?? ""),
                            style: appCss.dmDenseMedium14.textColor(
                                selectedValue == null
                                    ? appColor(context).appTheme.lightText
                                    : appColor(context).appTheme.darkText))
                      ]));
                }).toList(),
          selectedItemBuilder: (context) {
            return providers.map((provider) {
              return Row(
                children: [
                  Text(
                    language(context, provider.name ?? ""),
                    style: appCss.dmDenseMedium14.textColor(
                      selectedValue == null
                          ? appColor(context).appTheme.lightText
                          : appColor(context).appTheme.darkText,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          onChanged: onChanged,
        ),
      ),
    )
        .padding(
          vertical: Insets.i8,
          left: isIcon == false ? Insets.i10 : Insets.i2,
          right: Insets.i10,
        )
        .decorated(
          color: appColor(context).appTheme.whiteBg,
          borderRadius: BorderRadius.circular(AppRadius.r8),
        );
  }
}
