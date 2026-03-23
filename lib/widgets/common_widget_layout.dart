import 'package:fixit_provider/config.dart';
import 'package:flutter/cupertino.dart';

class CommonWidgetLayout {
  //small text box title and container layout
  Widget commonTitleWithSmallContainer(context, title) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const SmallContainer(),
          const HSpace(Sizes.s20),
          Text(language(context, title),
              style: appCss.dmDenseSemiBold14
                  .textColor(appColor(context).appTheme.darkText))
        ]),
        const VSpace(Sizes.s8)
      ]);

  //multiple selection text chip
  ChipConfig chipWidget(context) => ChipConfig(
      wrapType: WrapType.wrap,
      deleteIcon: Icon(CupertinoIcons.multiply,
          color: appColor(context).appTheme.darkText, size: Sizes.s15),
      backgroundColor: appColor(context).appTheme.fieldCardBg,
      labelColor: appColor(context).appTheme.darkText,
      deleteIconColor: appColor(context).appTheme.darkText,
      labelStyle: appCss.dmDenseMedium14
          .textColor(appColor(context).appTheme.darkText));

  //none text input input decoration
  //none text input input decoration
  OutlineInputBorder noneDecoration({double? radius, Color? color}) =>
      OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(radius ?? AppRadius.r30)),
          borderSide: BorderSide(color: color ?? Color(0xFFEEEEEE)));
}
