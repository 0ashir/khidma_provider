// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../config.dart';

class CustomChartLayout extends StatelessWidget {
  const CustomChartLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      // log("value.totalW/eeklyRevenue:${value.totalWeeklyRevenue}");
      return Listener(
        onPointerMove: (event) {
          if (event.delta.dy != 0) {
            // Move the scroll position by the delta of the pointer movement
            Scrollable.of(context).position.moveTo(
                  Scrollable.of(context).position.pixels - event.delta.dy,
                );
          }
        },
        child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            enableAxisAnimation: true,
            enableSideBySideSeriesPlacement: false,
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: false,
              enableDoubleTapZooming: false,
              enableSelectionZooming: false,
            ),
            trackballBehavior: TrackballBehavior(
              enable: false,
            ),
            crosshairBehavior: CrosshairBehavior(
              enable: false,
            ),
            primaryXAxis: ChartSeriesClass().xAxis(context),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                opacity: 1,
                color: Colors.transparent,
                activationMode: ActivationMode.singleTap,
                shadowColor: Colors.transparent,
                borderColor: Colors.transparent,
                tooltipPosition: TooltipPosition.auto,
                elevation: 0,
                canShowMarker: false,
                // Templating the tooltip
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  return ChartToolTip2(
                      data: data,
                      point: point,
                      pointIndex: pointIndex,
                      series: series,
                      seriesIndex: seriesIndex);
                }),
            series: <CartesianSeries<ChartData, String>>[
              ChartSeriesClass().chartSeries1(
                context, value.selectedIndex, value.isToolTip,
                //         onPointTap: (pointInteractionDetails) {
                //   value.isToolTip = !value.isToolTip;
                //   value.notifyListeners();
                // }
              ),
              if (!value.isToolTip)
                ChartSeriesClass().chartSeries2(
                  context, value.selectedIndex, value.isToolTip,
                  //         onPointTap: (pointInteractionDetails) {
                  //   value.isToolTip = !value.isToolTip;
                  //   value.notifyListeners();
                  // }
                )
            ]),
      );
    });
  }
}
