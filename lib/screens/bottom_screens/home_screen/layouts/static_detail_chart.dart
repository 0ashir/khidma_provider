import '../../../../config.dart';

class StaticDetailChart extends StatelessWidget {
  const StaticDetailChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Column(children: [
        Text(language(context, translations!.staticsDetails),
                style: appCss.dmDenseBold18
                    .textColor(appColor(context).appTheme.darkText))
            .alignment(Alignment.centerLeft),
        const VSpace(Sizes.s15),
        Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ChartDataLayoutClass().chartTitleLayout(context),
            ChartDataLayoutClass().weekMonthYearOption(context),
          ]).paddingAll(Insets.i15),
          SizedBox(
              height: Sizes.s225,
              width: MediaQuery.of(context).size.width,
              child: Theme(
                data: ThemeData(
                    tooltipTheme: const TooltipThemeData(
                        decoration: BoxDecoration(color: Colors.transparent))),
                child: const CustomChartLayout(),
              )).paddingSymmetric(horizontal: Insets.i8)
        ])
            .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
            .marginOnly(bottom: isServiceman ? Insets.i20 : 0)
      ])
          .paddingSymmetric(
              vertical: servicemanList.isNotEmpty ? Insets.i25 : 0,
              horizontal: Insets.i20)
          .padding(
              bottom: servicemanList.isNotEmpty ? 0 : Insets.i25,
              top: servicemanList.isNotEmpty ? 0 : Insets.i25)
          .decorated(color: appColor(context).appTheme.fieldCardBg);
    });
  }
}
