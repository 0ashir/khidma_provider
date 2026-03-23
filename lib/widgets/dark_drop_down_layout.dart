import '../../../../config.dart';

class DarkDropDownLayout extends StatelessWidget {
  final String? icon, hintText, val;
  final List? categoryList, durationList, reviewLowHighList;
  final ValueChanged? onChanged;
  final Color? svgColor;
  final InputBorder? border;
  final bool? isIcon, isField, isBig, isListIcon, isOnlyText, isWidth;

  const DarkDropDownLayout(
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
      this.durationList,
      this.reviewLowHighList,
      this.svgColor,
      this.isWidth = false,
      this.border});

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
                        prefixIcon: isIcon == true
                            ? SvgPicture.asset(icon!,
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                    svgColor ??
                                        appColor(context).appTheme.darkText,
                                    BlendMode.srcIn))
                            : null,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        disabledBorder:
                            border ?? CommonWidgetLayout().noneDecoration(),
                        focusedBorder:
                            border ?? CommonWidgetLayout().noneDecoration(),
                        enabledBorder:
                            border ?? CommonWidgetLayout().noneDecoration(),
                        border:
                            border ?? CommonWidgetLayout().noneDecoration()),
                    padding: EdgeInsets.zero,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppRadius.r8)),
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
                    items: reviewLowHighList != null &&
                            reviewLowHighList!.isNotEmpty
                        ? reviewLowHighList!.asMap().entries.map((e) {
                            return DropdownMenuItem(
                                value: e.value['id'],
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isListIcon == true)
                                      SizedBox(
                                              height: Sizes.s13,
                                              width: Sizes.s13,
                                              child: SvgPicture.asset(
                                                  e.value["image"],
                                                  fit: BoxFit.scaleDown))
                                          .paddingAll(Insets.i4)
                                          .decorated(
                                              color: appColor(context)
                                                  .appTheme
                                                  .fieldCardBg,
                                              shape: BoxShape.circle),
                                    if (isListIcon == true)
                                      const HSpace(Sizes.s12),
                                    Text(
                                        capitalizeFirstLetter(language(
                                            context, e.value['title'])),
                                        style: appCss.dmDenseRegular14
                                            .textColor(appColor(context)
                                                .appTheme
                                                .darkText)),
                                  ],
                                ));
                          }).toList()
                        : durationList != null
                            ? durationList!.asMap().entries.map((e) {
                                return DropdownMenuItem(
                                    value: e.value,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                                        Text(
                                            capitalizeFirstLetter(
                                                language(context, e.value)),
                                            style: appCss.dmDenseRegular14
                                                .textColor(appColor(context)
                                                    .appTheme
                                                    .darkText)),
                                      ],
                                    ));
                              }).toList()
                            : categoryList!.asMap().entries.map((e) {
                                return DropdownMenuItem(
                                    value: e.value,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                                        Text(
                                            capitalizeFirstLetter(language(
                                                context, e.value ?? e.value)),
                                            style: appCss.dmDenseRegular14
                                                .textColor(appColor(context)
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
                    ? Insets.i6
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
            color: isField == true ? appColor(context).appTheme.fieldCardBg : appColor(context).appTheme.whiteBg,
            borderRadius: BorderRadius.circular(AppRadius.r8));
  }
}

class PromotionPlanAndService extends StatelessWidget {
  final String? icon, hintText, val;
  final List? promotionPlanList;
  final List<Services>? serviceList;

  final Services? service;
  final ValueChanged? onChanged;
  final double? borderRadius, vPadding;
  final Color? borderColor, bgColor, svgColor;
  final bool? isIcon, isField, isBig, isListIcon, isOnlyText;

  const PromotionPlanAndService(
      {super.key,
      this.icon,
      this.hintText,
      this.val,
      this.onChanged,
      this.isField = false,
      this.isIcon = false,
      this.isBig = false,
      this.isListIcon = false,
      this.isOnlyText = false,
      this.borderRadius,
      this.bgColor,
      this.borderColor,
      this.vPadding,
      this.svgColor,
      this.promotionPlanList,
      this.serviceList,
      this.service});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
            child: ButtonTheme(
                buttonColor: appColor(context).appTheme.whiteBg,
                child: DropdownButtonFormField(
                    value: val ?? service,
                    hint: Text(language(context, hintText ?? ""),
                        style: appCss.dmDenseRegular14
                            .textColor(appColor(context).appTheme.lightText)),
                    decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(icon!,
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                svgColor ?? appColor(context).appTheme.darkText,
                                BlendMode.srcIn)),
                        // contentPadding: EdgeInsets.symmetric(
                        //     vertical: vPadding ?? Sizes.s15,
                        //     horizontal: Sizes.s15),
                        isDense: true,
                        disabledBorder: CommonWidgetLayout().noneDecoration(
                            radius: 0, color: appColor(context).appTheme.trans),
                        focusedBorder: CommonWidgetLayout().noneDecoration(
                            radius: 0, color: appColor(context).appTheme.trans),
                        enabledBorder: CommonWidgetLayout().noneDecoration(
                            radius: 0, color: appColor(context).appTheme.trans),
                        border: CommonWidgetLayout().noneDecoration(
                            radius: 0,
                            color: appColor(context).appTheme.trans)),
                    padding: EdgeInsets.zero,
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.r8)),
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
                    items: serviceList!.asMap().entries.map((e) {
                      //  log("serviceList::$serviceList");
                      return DropdownMenuItem(
                          value: e.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.value.title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: appCss.dmDenseRegular14.textColor(
                                      appColor(context).appTheme.darkText)),
                            ],
                          ));
                    }).toList(),
                    onChanged: onChanged)))
        .decorated(
            color: isField == true
                ? bgColor ?? appColor(context).appTheme.fieldCardBg
                : appColor(context).appTheme.whiteBg,
            borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.r8));
  }
}
