import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../config.dart';

class ChartSeriesClass {
  CartesianSeries<ChartData, String> chartSeries1(
          context, selectedIndex, isToolTip,
          {Function(ChartPointDetails)? onPointTap}) =>
      ColumnSeries<ChartData, String>(
          dataSource: selectedIndex == 0
              ? appArray.weekData
              : selectedIndex == 1
                  ? appArray.monthData
                  : appArray.yearData,
          xValueMapper: (ChartData data, _) =>
              selectedIndex == 0 || selectedIndex == 1
                  ? data.x!.substring(0, 2)
                  : data.x,
          yValueMapper: (ChartData data, _) => data.y,
          borderRadius: const SmoothBorderRadius.only(
              topLeft:
                  SmoothRadius(cornerRadius: AppRadius.r4, cornerSmoothing: 1),
              topRight:
                  SmoothRadius(cornerRadius: AppRadius.r4, cornerSmoothing: 1)),
          borderWidth: 5,
          width: !isToolTip ? .5 : .3,
          enableTooltip: true,
          isTrackVisible: false,
          onPointTap: onPointTap,
          selectionBehavior: SelectionBehavior(
              enable: true,
              unselectedOpacity: 1,
              selectedOpacity: 1,
              unselectedColor: appColor(context).appTheme.fieldCardBg,
              selectedBorderColor: Colors.transparent,
              selectedBorderWidth: 0,
              selectedColor: appColor(context).appTheme.fieldCardBg),
          color: appColor(context).appTheme.fieldCardBg);

  CartesianSeries<ChartData, String> chartSeries2(
          context, selectedIndex, isToolTip,
          {Function(ChartPointDetails)? onPointTap}) =>
      ColumnSeries<ChartData, String>(
          dataSource: selectedIndex == 0
              ? appArray.weekData
              : selectedIndex == 1
                  ? appArray.monthData
                  : appArray.yearData,
          xValueMapper: (ChartData data, _) =>
              selectedIndex == 0 || selectedIndex == 1
                  ? data.x!.substring(0, 2)
                  : data.x,
          yValueMapper: (ChartData data, _) => data.y,
          borderRadius: const SmoothBorderRadius.only(
              topLeft:
                  SmoothRadius(cornerRadius: AppRadius.r4, cornerSmoothing: 1),
              topRight:
                  SmoothRadius(cornerRadius: AppRadius.r4, cornerSmoothing: 1)),
          borderWidth: 5,
          width: .26,
          enableTooltip: true,
          isTrackVisible: false,
          selectionBehavior: SelectionBehavior(
              enable: true,
              unselectedOpacity: 1,
              selectedOpacity: 1,
              unselectedColor: appColor(context).appTheme.primary,
              selectedBorderColor: Colors.transparent,
              selectedBorderWidth: 0,
              selectedColor: appColor(context).appTheme.primary),
          color: appColor(context).appTheme.primary);

  CategoryAxis xAxis(context) => CategoryAxis(
      isVisible: true,
      majorGridLines: const MajorGridLines(width: 0),
      //minorGridLines: const MinorGridLines(width: 0),
      majorTickLines: const MajorTickLines(width: 0),
      /*minorTickLines: const MinorTickLines(width: 0),
      visibleMaximum: 5,*/
      labelStyle: appCss.dmDenseMedium12
          .textColor(appColor(context).appTheme.lightText),
      /*,
      axisLine: AxisLine(
          color: appColor(context).appTheme.stroke)*/);

  NumericAxis yAxis(context, selectedIndex, totalWeeklyRevenue,
          totalMonthlyRevenue, totalYearlyRevenue) =>
      NumericAxis(
          minimum: 0,
          maximum: selectedIndex == 0
              ? totalWeeklyRevenue.roundToDouble()
              : selectedIndex == 1
                  ? totalMonthlyRevenue
                  : totalYearlyRevenue,
          interval: 100,
          labelStyle: appCss.dmDenseMedium12
              .textColor(appColor(context).appTheme.lightText),
          labelFormat: '{value}',
          majorGridLines: const MajorGridLines(width: 0),
          minorGridLines: const MinorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          minorTickLines: const MinorTickLines(width: 0),
          axisLine: AxisLine(
              color: appColor(context).appTheme.stroke));
}
