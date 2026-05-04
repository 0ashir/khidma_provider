import '../../../../config.dart';

class AddressDropDownLayout extends StatelessWidget {
  final String? icon, hintText;
  final PrimaryAddress? doc;
  final ValueChanged? onChanged;
  final bool? isIcon, isField, isBig, isListIcon, isOnlyText;
  final List<PrimaryAddress>? addressData;

  const AddressDropDownLayout(
      {super.key,
      this.icon,
      this.hintText,
      this.onChanged,
      this.isField = false,
      this.isIcon = false,
      this.isBig = false,
      this.isListIcon = false,
      this.isOnlyText = false,
      this.addressData,
      this.doc});

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
                                    doc == null
                                        ? appColor(context).appTheme.lightText
                                        : appColor(context).appTheme.darkText,
                                    BlendMode.srcIn))
                            : null,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        disabledBorder: CommonWidgetLayout().noneDecoration(),
                        focusedBorder: CommonWidgetLayout().noneDecoration(),
                        enabledBorder: CommonWidgetLayout().noneDecoration(),
                        border: CommonWidgetLayout().noneDecoration()),
                    padding: EdgeInsets.zero,
                    // /value:doc,
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
                    items: addressData!.asMap().entries.map((e) {
                      return DropdownMenuItem(
                          value: e.value,
                          child: Row(children: [
                            Text(
                                "${e.value.address} - ${e.value.country!.name} - ${e.value.state!.name}",
                                style: appCss.dmDenseMedium14.textColor(
                                    doc == null
                                        ? appColor(context).appTheme.lightText
                                        : appColor(context).appTheme.darkText))
                          ]));
                    }).toList(),
                    onChanged: onChanged)))
        .addAddressDropDown(context, isBig, isOnlyText, isIcon, isField);
  }
}
