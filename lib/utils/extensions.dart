import '../config.dart';

extension FixitUserExtensions on Widget {
  Widget boxShapeExtension({Color? color, double? radius}) => Container(
      decoration: ShapeDecoration(
          color: color,
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                  cornerRadius: radius ?? 8, cornerSmoothing: 1))),
      child: this);

  Widget boxBorderExtension(context,
          {Color? color, bColor, double? radius, bool? isShadow = false}) =>
      Container(
          decoration: ShapeDecoration(
              color: color ?? appColor(context).appTheme.whiteBg,
              shadows: isShadow == true
                  ? [
                      BoxShadow(
                          color: appColor(context)
                              .appTheme
                              .darkText
                              .withOpacity(0.05),
                          blurRadius: 3,
                          spreadRadius: 1)
                    ]
                  : [],
              shape: SmoothRectangleBorder(
                  side: BorderSide(
                      color: bColor ?? appColor(context).appTheme.fieldCardBg),
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: radius ?? 8, cornerSmoothing: 1))),
          child: this);

  Widget bottomSheetExtension(context) => Container(
      decoration: ShapeDecoration(
          color: appColor(context).appTheme.whiteBg,
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 20, cornerSmoothing: 1),
                  topRight:
                      SmoothRadius(cornerRadius: 20, cornerSmoothing: 1)))),
      child: this);

  Widget addAddressDropDown(context, isBig, isOnlyText, isIcon, isField) =>
      SizedBox(child: this)
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

snackBarMessengers(context, {message, color, isDuration = false}) {
  ScaffoldMessenger.of(context).showSnackBar(isDuration
      ? SnackBar(
          content: Container(
              padding: const EdgeInsets.all(Insets.i15),
              decoration: BoxDecoration(
                  color: color ?? appColor(context).appTheme.red,
                  borderRadius: BorderRadius.circular(AppRadius.r8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(message.toString(),
                      style: appCss.dmDenseMedium16
                          .textColor(appColor(context).appTheme.whiteBg)),
                  IconButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                      icon: Icon(
                        Icons.close,
                        color: appColor(context).appTheme.whiteColor,
                      ))
                ],
              )),
          backgroundColor: Colors.transparent,
          duration: Duration(milliseconds: 500),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          padding: EdgeInsets.zero)
      : SnackBar(
          content: Container(
              padding: const EdgeInsets.all(Insets.i15),
              decoration: BoxDecoration(
                  color: color ?? appColor(context).appTheme.red,
                  borderRadius: BorderRadius.circular(AppRadius.r8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(message.toString(),
                        style: appCss.dmDenseMedium16
                            .textColor(appColor(context).appTheme.whiteBg)),
                  ),
                  Icon(
                    Icons.close,
                    color: appColor(context).appTheme.whiteColor,
                  ).inkWell(
                    onTap: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  )
                ],
              )),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          padding: EdgeInsets.zero));
  /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message.toString(),
          style: appCss.dmDenseMedium16.textColor(appColor(context).appTheme.whiteBg)),
      backgroundColor: color ?? Colors.red.withOpacity(0.8)));*/
}
