import 'package:fixit_provider/config.dart';

class ChartDataLayoutClass {
  Widget chartTitleLayout(context) =>
      Consumer<HomeProvider>(builder: (context, value, child) {
        return Row(children: [
          Text(language(context, translations!.weeklyAverage),
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.darkText))
              .width(Sizes.s100),
          const HSpace(Sizes.s8),
          Text(
              language(
                  context,
                  symbolPosition
                      ? "${getSymbol(context)}${value.selectedIndex == 0 ? value.totalWeeklyRevenue.toStringAsFixed(2) : value.selectedIndex == 1 ? value.totalMonthlyRevenue.toStringAsFixed(2) : value.totalYearlyRevenue.toStringAsFixed(2)}"
                      : "${value.selectedIndex == 0 ? value.totalWeeklyRevenue.toStringAsFixed(2) : value.selectedIndex == 1 ? value.totalMonthlyRevenue.toStringAsFixed(2) : value.totalYearlyRevenue.toStringAsFixed(2)}${getSymbol(context)}"),
              style: appCss.dmDenseBold14
                  .textColor(appColor(context).appTheme.primary))
        ]);
      });

  Widget weekMonthYearOption(context) =>
      Consumer<HomeProvider>(builder: (context, value, child) {
        return Row(children: [
          ...List.generate(value.wmy.length, (index) {
            return Text(value.wmy[index].toString(),
                    style: appCss.dmDenseMedium12.textColor(
                        value.selectedIndex == index
                            ? appColor(context).appTheme.whiteColor
                            : appColor(context).appTheme.lightText))
                .paddingSymmetric(horizontal: Insets.i7, vertical: Insets.i5)
                .decorated(
                    color: value.selectedIndex == index
                        ? appColor(context).appTheme.primary
                        : appColor(context).appTheme.fieldCardBg,
                    shape: BoxShape.circle)
                .paddingOnly(right: Insets.i10)
                .inkWell(onTap: () => value.onTapWmy(index));
          })
        ]);
      });
}
