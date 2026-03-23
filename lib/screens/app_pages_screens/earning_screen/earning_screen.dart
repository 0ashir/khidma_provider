// import 'dart:developer';

// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../../config.dart';

// class EarningScreen extends StatelessWidget {
//   const EarningScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserDataApiProvider>(builder: (context, value, child) {
//       return Scaffold(
//           appBar: AppBarCommon(title: translations!.earnings),
//           body: value.isCommissionLoader == true
//               ? Center(
//                   child: Image.asset(eGifAssets.loaderGif, height: Sizes.s100))
//               : commissionList == null
//                   ? const CommonEmpty()
//                   : SingleChildScrollView(
//                       child: Column(children: [
//                       Column(children: [
//                         if (commissionList!.total != 0.0)
//                           Container(
//                               height: Sizes.s63,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           eImageAssets.balanceContainer),
//                                       fit: BoxFit.fill)),
//                               child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                         language(context,
//                                             "${language(context, translations!.totalEarning)} :"),
//                                         style: appCss.dmDenseBold18.textColor(
//                                             appColor(context)
//                                                 .appTheme
//                                                 .whiteBg)),
//                                     Text(
//                                         symbolPosition
//                                             ? "${getSymbol(context)}${(currency(context).currencyVal * commissionList!.total!).toStringAsFixed(2)}"
//                                             : "${(currency(context).currencyVal * commissionList!.total!).toStringAsFixed(2)}${getSymbol(context)}",
//                                         style: appCss.dmDenseBold18.textColor(
//                                             appColor(context)
//                                                 .appTheme
//                                                 .whiteColor))
//                                   ]).paddingSymmetric(horizontal: Insets.i20)),
//                         const VSpace(Sizes.s30),
//                         if (commissionList!.histories!.isNotEmpty)
//                           Column(children: [
//                             Stack(alignment: Alignment.center, children: [
//                               SfCircularChart(series: <CircularSeries>[
//                                 DoughnutSeries<ChartDataColor, String>(
//                                     dataSource: appArray.earningChartData,
//                                     xValueMapper: (ChartDataColor data, _) =>
//                                         data.x,
//                                     yValueMapper: (ChartDataColor data, _) =>
//                                         data.y,
//                                     cornerStyle: CornerStyle.bothCurve,
//                                     pointColorMapper:
//                                         (ChartDataColor data, _) => data.color,
//                                     explodeAll: false,
//                                     innerRadius: '85%',
//                                     explode: true)
//                               ]),
//                               SizedBox(
//                                   width: Sizes.s120,
//                                   child: Text(
//                                       language(
//                                           context, translations!.topCategorys),
//                                       textAlign: TextAlign.center,
//                                       style: appCss.dmDenseMedium16.textColor(
//                                           appColor(context).appTheme.darkText)))
//                             ]),
//                             const EarningPercentageLayout()
//                           ]).paddingAll(Insets.i15).boxShapeExtension(
//                               color: appColor(context).appTheme.fieldCardBg)
//                       ]).paddingSymmetric(horizontal: Insets.i20),
//                       const VSpace(Sizes.s25),
//                       if (commissionList!.histories!.isEmpty)
//                         const CommonEmpty(),
//                       if (commissionList!.histories!.isNotEmpty)
//                         const HistoryBody()
//                     ])));
//     });
//   }
// }

import 'dart:developer';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../config.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataApiProvider>(builder: (context, value, child) {
      /// 🔢 Total for percentage calculation
      final double total = appArray.earningChartData.fold(
        0,
        (sum, item) => sum + item.y,
      );

      final tooltipBehavior = TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          ChartDataColor item = data;
          final double percentage = total == 0 ? 0 : (item.y / total) * 100;
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '${item.x}\n${percentage.toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColor(context).appTheme.whiteColor,
                fontSize: 12,
              ),
            ),
          );
        },
      );

      return Scaffold(
          appBar: AppBarCommon(title: translations!.earnings),
          body: value.isCommissionLoader == true
              ? Center(
                  child: Image.asset(eGifAssets.loaderGif, height: Sizes.s100))
              : commissionList == null
                  ? const CommonEmpty()
                  : SingleChildScrollView(
                      child: Column(children: [
                      Column(children: [
                        if (commissionList!.total != 0.0)
                          Container(
                              height: Sizes.s63,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          eImageAssets.balanceContainer),
                                      fit: BoxFit.fill)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        language(context,
                                            "${language(context, translations!.totalEarning)} :"),
                                        style: appCss.dmDenseBold18.textColor(
                                            appColor(context)
                                                .appTheme
                                                .whiteBg)),
                                    Text(
                                        symbolPosition
                                            ? "${getSymbol(context)}${(currency(context).currencyVal * commissionList!.total!).toStringAsFixed(2)}"
                                            : "${(currency(context).currencyVal * commissionList!.total!).toStringAsFixed(2)}${getSymbol(context)}",
                                        style: appCss.dmDenseBold18.textColor(
                                            appColor(context)
                                                .appTheme
                                                .whiteColor))
                                  ]).paddingSymmetric(horizontal: Insets.i20)),
                        const VSpace(Sizes.s30),

                        /// 📊 Chart Section
                        if (commissionList!.histories!.isNotEmpty)
                          Column(children: [
                            Stack(alignment: Alignment.center, children: [
                              SfCircularChart(
                                tooltipBehavior: tooltipBehavior,
                                series: <CircularSeries>[
                                  DoughnutSeries<ChartDataColor, String>(
                                    dataSource: appArray.earningChartData,
                                    xValueMapper: (ChartDataColor data, _) =>
                                        data.x,
                                    yValueMapper: (ChartDataColor data, _) =>
                                        data.y,
                                    pointColorMapper:
                                        (ChartDataColor data, _) => data.color,
                                    cornerStyle: CornerStyle.bothCurve,
                                    innerRadius: '85%',
                                    explode: true,
                                    enableTooltip: true,
                                  )
                                ],
                              ),
                              SizedBox(
                                  width: Sizes.s120,
                                  child: Text(
                                      language(
                                          context, translations!.topCategorys),
                                      textAlign: TextAlign.center,
                                      style: appCss.dmDenseMedium16.textColor(
                                          appColor(context).appTheme.darkText)))
                            ]),
                            const EarningPercentageLayout()
                          ]).paddingAll(Insets.i15).boxShapeExtension(
                              color: appColor(context).appTheme.fieldCardBg)
                      ]).paddingSymmetric(horizontal: Insets.i20),
                      const VSpace(Sizes.s25),
                      if (commissionList!.histories!.isEmpty)
                        const CommonEmpty(),
                      if (commissionList!.histories!.isNotEmpty)
                        const HistoryBody()
                    ])));
    });
  }
}
