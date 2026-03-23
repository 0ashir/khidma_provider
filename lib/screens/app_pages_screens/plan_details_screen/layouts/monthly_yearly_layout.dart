import '../../../../config.dart';

class MonthlyYearlyLayout extends StatelessWidget {
  final bool? isMonthly;
  final ValueChanged<bool>? onToggle;
  const MonthlyYearlyLayout({super.key, this.isMonthly = false, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(language(context, translations!.yearly),
          style: isMonthly == false
              ? appCss.dmDenseSemiBold14
                  .textColor(appColor(context).appTheme.primary)
              : appCss.dmDenseRegular14
                  .textColor(appColor(context).appTheme.lightText)),
      Theme(
              data: ThemeData(useMaterial3: false),
              child: FlutterSwitch(
                  width: Sizes.s32,
                  height: Sizes.s20,
                  toggleSize: Sizes.s12,
                  value: isMonthly!,
                  borderRadius: 15,
                  padding: 4,
                  toggleColor: appColor(context).appTheme.whiteBg,
                  inactiveToggleColor: appColor(context).appTheme.whiteBg,
                  activeColor: appColor(context).appTheme.primary,
                  inactiveColor: appColor(context).appTheme.primary,
                  onToggle: onToggle!))
          .paddingSymmetric(horizontal: Insets.i8),
      Text(language(context, translations!.monthly),
          style: isMonthly!
              ? appCss.dmDenseSemiBold14
                  .textColor(appColor(context).appTheme.primary)
              : appCss.dmDenseRegular14
                  .textColor(appColor(context).appTheme.lightText))
    ])
        .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i13)
        .boxShapeExtension(
            color: appColor(context).appTheme.primary.withOpacity(0.12))
        .alignment(Alignment.center);
  }
}
