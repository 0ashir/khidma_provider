import 'package:fixit_provider/utils/general_utils.dart';

import '../config.dart';

class WalletDropDown extends StatelessWidget {
  final String? icon;
  final int? val;
  final List? categoryList;
  final ValueChanged? onChanged;
  final bool? isIcon, isServiceManList;
  const WalletDropDown(
      {super.key,
      this.icon,
      this.val,
      this.categoryList,
      this.onChanged,
      this.isIcon,
      this.isServiceManList = false});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
            child: ButtonTheme(
                child: DropdownButtonFormField(
                    selectedItemBuilder: (context) =>
                        categoryList!.asMap().entries.map((e) {
                          return DropdownMenuItem(
                              value: e.value["id"],
                              child: Text(
                                  language(
                                      context, e.value["title"].toString()),
                                  style: appCss.dmDenseMedium14.textColor(
                                      appColor(context).appTheme.darkText)));
                        }).toList(),
                    decoration: InputDecoration(
                        prefixIcon: isIcon == true
                            ? SvgPicture.asset(icon!,
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                    isIcon!
                                        ? appColor(context).appTheme.darkText
                                        : appColor(context).appTheme.lightText,
                                    BlendMode.srcIn))
                            : null,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        disabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none)),
                    padding: EdgeInsets.only(
                        left: rtl(context)
                            ? 0
                            : isIcon == true
                                ? 0
                                : 15,
                        right: rtl(context)
                            ? isIcon == true
                                ? 0
                                : 15
                            : 0),
                    value: val!,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppRadius.r8)),
                    style: isIcon == false
                        ? appCss.dmDenseMedium12
                            .textColor(appColor(context).appTheme.darkText)
                        : appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.lightText),
                    icon: SvgPicture.asset(eSvgAssets.dropDown,
                        colorFilter: ColorFilter.mode(isIcon == true ? appColor(context).appTheme.darkText : appColor(context).appTheme.lightText, BlendMode.srcIn)),
                    isDense: true,
                    isExpanded: true,
                    items: categoryList!.asMap().entries.map((e) {
                      return DropdownMenuItem(
                          value: e.value["id"],
                          child: Row(
                            children: [
                              if (isIcon!)
                                Row(
                                  children: [
                                    SvgPicture.asset(e.value['image']),
                                    const HSpace(Sizes.s12)
                                  ],
                                ),
                              Text(
                                language(context, e.value["title"].toString()),
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText),
                              ),
                            ],
                          ));
                    }).toList(),
                    onChanged: onChanged)))
        .padding(vertical: isIcon == false ? Insets.i12 : Insets.i2, left: rtl(context) ? Insets.i15 : 0, right: rtl(context) ? 0 : Insets.i15)
        .decorated(color: isIcon == false ? appColor(context).appTheme.fieldCardBg : appColor(context).appTheme.whiteBg, borderRadius: BorderRadius.circular(AppRadius.r8));
  }
}

class PaymentDropDownLayout extends StatelessWidget {
  final String? icon;
  final String? val;
  final List<PaymentMethods>? list;
  final ValueChanged? onChanged;
  final bool? isIcon;

  const PaymentDropDownLayout(
      {super.key,
      this.icon,
      this.val,
      this.list,
      this.onChanged,
      this.isIcon = false});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
            child: ButtonTheme(
                child: DropdownButtonFormField(
                    selectedItemBuilder: (context) =>
                        list!.asMap().entries.map((e) {
                          return DropdownMenuItem(
                              value: e.value.name,
                              child: Text(
                                capitalizeFirstLetter(e.value.name.toString()),
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.darkText),
                              ));
                        }).toList(),
                    decoration: InputDecoration(
                        prefixIcon: isIcon == true
                            ? SvgPicture.asset(icon!,
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                    appColor(context).appTheme.darkText,
                                    BlendMode.srcIn))
                            : null,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        disabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(AppRadius.r8)),
                            borderSide: BorderSide.none)),
                    padding: EdgeInsets.only(
                        left: rtl(context)
                            ? 0
                            : isIcon == true
                                ? 0
                                : 15,
                        right: rtl(context)
                            ? isIcon == true
                                ? 0
                                : 15
                            : 0),
                    value: val,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppRadius.r8)),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.darkText),
                    icon: SvgPicture.asset(eSvgAssets.dropDown,
                        colorFilter: ColorFilter.mode(
                            isIcon == false
                                ? appColor(context).appTheme.darkText
                                : appColor(context).appTheme.lightText,
                            BlendMode.srcIn)),
                    isDense: true,
                    isExpanded: true,
                    items: list!.asMap().entries.map((e) {
                      return DropdownMenuItem(
                          value: e.value.slug,
                          child: Text(
                              capitalizeFirstLetter(e.value.name.toString())));
                    }).toList(),
                    onChanged: onChanged)))
        .padding(
            vertical: isIcon == false ? Insets.i12 : Insets.i2,
            left: rtl(context) ? Insets.i15 : 0,
            right: rtl(context) ? 0 : Insets.i15)
        .decorated(color: isIcon == false ? appColor(context).appTheme.fieldCardBg : appColor(context).appTheme.whiteBg, borderRadius: BorderRadius.circular(AppRadius.r8));
  }
}
