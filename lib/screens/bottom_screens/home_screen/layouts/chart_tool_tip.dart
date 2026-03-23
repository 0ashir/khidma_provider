import '../../../../config.dart';

class ChartToolTip extends StatelessWidget {
  final dynamic data, point, series;
  final int? pointIndex, seriesIndex;

  const ChartToolTip(
      {super.key,
      this.data,
      this.point,
      this.series,
      this.pointIndex,
      this.seriesIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return RotatedBox(
          quarterTurns: point.y >
                  (value.selectedIndex == 0
                      ? value.totalWeeklyRevenue.roundToDouble()
                      : value.selectedIndex == 1
                          ? value.totalMonthlyRevenue
                          : value.totalYearlyRevenue / 2)
              ? 2
              : 0,
          child: Container(
              height: 50,
              width: 45,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(eImageAssets.base), fit: BoxFit.fill)),
              child: RotatedBox(
                  quarterTurns: point.y >
                          (value.selectedIndex == 0
                              ? value.totalWeeklyRevenue.roundToDouble()
                              : value.selectedIndex == 1
                                  ? value.totalMonthlyRevenue
                                  : value.totalYearlyRevenue / 2)
                      ? 2
                      : 0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(point.y.toString(),
                            style: appCss.dmDenseSemiBold6.textColor(
                                appColor(context).appTheme.whiteColor)),
                        Text("Revenue",
                            style: appCss.dmDenseSemiBold6.textColor(
                                appColor(context).appTheme.whiteColor))
                      ]).marginOnly(bottom: 10))));
    });
  }
}

class ChartToolTip2 extends StatelessWidget {
  final dynamic data, point, series;
  final int? pointIndex, seriesIndex;

  const ChartToolTip2(
      {super.key,
      this.data,
      this.point,
      this.series,
      this.pointIndex,
      this.seriesIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return SizedBox(
          height: MediaQuery.of(context).size.height / 8,
          child: RotatedBox(
              quarterTurns: point.y >
                      (value.selectedIndex == 0
                          ? value.totalWeeklyRevenue.roundToDouble()
                          : value.selectedIndex == 1
                              ? value.totalMonthlyRevenue
                              : value.totalYearlyRevenue / 2)
                  ? 2
                  : 0,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Stack(alignment: Alignment.topCenter, children: [
                  Image.asset(eImageAssets.base,
                      height: MediaQuery.of(context).size.height / 11,
                      fit: BoxFit.fill),
                  RotatedBox(
                      quarterTurns: point.y >
                              (value.selectedIndex == 0
                                  ? value.totalWeeklyRevenue.roundToDouble()
                                  : value.selectedIndex == 1
                                      ? value.totalMonthlyRevenue
                                      : value.totalYearlyRevenue / 2)
                          ? 2
                          : 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(point.y.toString(),
                                style: appCss.dmDenseSemiBold10.textColor(
                                    appColor(context).appTheme.whiteColor)),
                            Text("Revenue",
                                style: appCss.dmDenseSemiBold10.textColor(
                                    appColor(context).appTheme.whiteColor))
                          ]).paddingOnly(
                          top: point.y >
                                  (value.selectedIndex == 0
                                      ? value.totalWeeklyRevenue.roundToDouble()
                                      : value.selectedIndex == 1
                                          ? value.totalMonthlyRevenue
                                          : value.totalYearlyRevenue / 2)
                              ? 0
                              : 15,
                          bottom: point.y >
                                  (value.selectedIndex == 0
                                      ? value.totalWeeklyRevenue.roundToDouble()
                                      : value.selectedIndex == 1
                                          ? value.totalMonthlyRevenue
                                          : value.totalYearlyRevenue / 2)
                              ? 15
                              : 0))
                ])
              ])));
    });
  }
}
