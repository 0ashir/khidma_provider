import 'dart:developer';

import '../../../../config.dart';


class TaxDropDownLayout extends StatelessWidget {
  final String? icon, hintText;
  final int? doc;
  final ValueChanged? onChanged;
  final bool? isIcon, isField, isBig, isListIcon, isOnlyText;
  final List<TaxModel>? tax;

  const TaxDropDownLayout(
      {super.key,
        this.icon,
        this.hintText,
        this.onChanged,
        this.isField = false,
        this.isIcon = false,
        this.isBig = false,
        this.isListIcon = false,
        this.isOnlyText = false,
        this.doc,
        this.tax});

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
                            tax != null && tax!.isNotEmpty
                                ? doc == null
                                ? appColor(context)
                                .appTheme
                                .lightText
                                : appColor(context)
                                .appTheme
                                .darkText
                                : appColor(context).appTheme.lightText,
                            BlendMode.srcIn))
                        : null,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    disabledBorder: InputBorder
                        .none /*  CommonWidgetLayout().noneDecoration() */,
                    focusedBorder: InputBorder.none,
                    /* CommonWidgetLayout().noneDecoration(), */
                    enabledBorder: InputBorder
                        .none /* CommonWidgetLayout().noneDecoration() */,
                    border: InputBorder
                        .none /* CommonWidgetLayout().noneDecoration() */),
                padding:
                EdgeInsets.only(top: Sizes.s13) /* EdgeInsets.zero */,
                value: doc,
                borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)),
                style: appCss.dmDenseMedium14.textColor(doc == null
                    ? appColor(context).appTheme.lightText
                    : appColor(context).appTheme.darkText),
                icon: SvgPicture.asset(eSvgAssets.dropDown,
                    colorFilter: ColorFilter.mode(
                        doc == null
                            ? appColor(context).appTheme.lightText
                            : appColor(context).appTheme.darkText,
                        BlendMode.srcIn)),
                isDense: true,
                isExpanded: true,
                items: tax!.asMap().entries.map((e) {
                  return DropdownMenuItem(
                      value: e.value.id,
                      child: Row(
                        children: [
                          Text(language(context, e.value.name),
                              style: appCss.dmDenseMedium14.textColor(doc ==
                                  null
                                  ? appColor(context).appTheme.lightText
                                  : appColor(context).appTheme.darkText)),
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
class ZoneDropDownLayout extends StatelessWidget {
  final String? icon, hintText;
  final int? doc;
  final ValueChanged<int?>? onChanged;
  final bool? isIcon, isField, isBig, isListIcon, isOnlyText;
  final List<ZoneModel>? zone;

  const ZoneDropDownLayout({
    super.key,
    this.icon,
    this.hintText,
    this.onChanged,
    this.isField = false,
    this.isIcon = false,
    this.isBig = false,
    this.isListIcon = false,
    this.isOnlyText = false,
    this.doc,
    this.zone,
  });

  @override
  Widget build(BuildContext context) {
    // Remove duplicates by using a Set to track unique IDs
    final Set<int> seenIds = <int>{};
    final List<DropdownMenuItem<int>> zoneItems = (zone ?? [])
        .where((z) => z.id != null && seenIds.add(z.id!)) // Only add if ID is unique
        .map((e) => DropdownMenuItem<int>(
      value: e.id,
      child: Row(
        children: [
          Text(
            language(context, e.name),
            style: appCss.dmDenseMedium14.textColor(
                doc == null
                    ? appColor(context).appTheme.lightText
                    : appColor(context).appTheme.darkText),
          ),
        ],
      ),
    ))
        .toList();

    // Ensure doc exists in zone list
    final isValidValue = zoneItems.any((item) => item.value == doc);

    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButtonFormField<int>(
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
                (zone != null && zone!.isNotEmpty)
                    ? doc == null
                    ? appColor(context).appTheme.lightText
                    : appColor(context).appTheme.darkText
                    : appColor(context).appTheme.lightText,
                BlendMode.srcIn,
              ),
            )
                : null,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          padding: EdgeInsets.only(top: Sizes.s13),
          value: isValidValue ? doc : null,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)),
          style: appCss.dmDenseMedium14.textColor(
              doc == null
                  ? appColor(context).appTheme.lightText
                  : appColor(context).appTheme.darkText),
          icon: SvgPicture.asset(
            eSvgAssets.dropDown,
            colorFilter: ColorFilter.mode(
              doc == null
                  ? appColor(context).appTheme.lightText
                  : appColor(context).appTheme.darkText,
              BlendMode.srcIn,
            ),
          ),
          isDense: true,
          isExpanded: true,
          items: zoneItems,
          onChanged: onChanged,
        ),
      ),
    )
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
      right: rtl(context) ? 10 : Insets.i10,
    )
        .decorated(
      color: isField == true
          ? appColor(context).appTheme.fieldCardBg
          : appColor(context).appTheme.whiteBg,
      borderRadius: BorderRadius.circular(AppRadius.r8),
    );
  }
}
