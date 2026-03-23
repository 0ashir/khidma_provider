import '../../../config.dart';

class TextFiledLayout extends StatelessWidget {
  final String? icon, hintText, val;
  final List? categoryList;
  final ValueChanged? onChanged;

  const TextFiledLayout(
      {super.key,
      this.icon,
      this.hintText,
      this.val,
      this.categoryList,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
            child: ButtonTheme(
                child: DropdownButtonFormField(
                    value: val,
                    hint: Text(language(context, hintText ?? ""),
                        style: appCss.dmDenseRegular14
                            .textColor(appColor(context).appTheme.lightText)),
                    decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(icon!,
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                appColor(context).appTheme.darkText,
                                BlendMode.srcIn)),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        disabledBorder: CommonWidgetLayout().noneDecoration(
                            color: Colors.transparent, radius: 0),
                        focusedBorder: CommonWidgetLayout().noneDecoration(
                            color: Colors.transparent, radius: 0),
                        enabledBorder: CommonWidgetLayout().noneDecoration(
                            color: Colors.transparent, radius: 0),
                        border: CommonWidgetLayout().noneDecoration(
                            color: Colors.transparent, radius: 0)),
                    padding: EdgeInsets.zero,
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText),
                    icon: SvgPicture.asset(eSvgAssets.dropDown,
                        colorFilter: ColorFilter.mode(
                            val == null
                                ? appColor(context).appTheme.lightText
                                : appColor(context).appTheme.darkText,
                            BlendMode.srcIn)),
                    isDense: true,
                    isExpanded: true,
                    items: categoryList!.asMap().entries.map((e) {
                      return DropdownMenuItem(
                          value: e.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  capitalizeFirstLetter(
                                      language(context, e.value)),
                                  style: appCss.dmDenseRegular14.textColor(
                                      appColor(context).appTheme.darkText)),
                            ],
                          ));
                    }).toList(),
                    onChanged: onChanged)))
        .decorated(
            color: appColor(context).appTheme.whiteBg,
            borderRadius: BorderRadius.circular(AppRadius.r8))
        .padding(horizontal: Sizes.s20);
  }
}
