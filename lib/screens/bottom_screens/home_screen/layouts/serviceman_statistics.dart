import '../../../../config.dart';

class ServicemanStatistics extends StatelessWidget {
  final Animation? animation;

  const ServicemanStatistics({super.key, this.animation});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, HomeProvider>(
        builder: (context1, lang, value, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ...appArray.serviceManEarningList.asMap().entries.map((e) =>
              Stack(children: [
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: Sizes.s106,
                        margin: const EdgeInsets.only(top: 10),
                        padding:
                            const EdgeInsets.symmetric(horizontal: Insets.i20),
                        decoration: ShapeDecoration(
                            color: appColor(context).appTheme.fieldCardBg,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 8, cornerSmoothing: 1))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const VSpace(Sizes.s20),
                              Text(language(context, e.value["title"]),
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      style: appCss.dmDenseMedium12.textColor(
                                          appColor(context).appTheme.lightText))
                                  .width(Sizes.s60),
                              const VSpace(Sizes.s2),
                              FittedBox(
                                  child: Text(
                                      "${e.key == 0 ? "${getSymbol(context)}" : ""}${e.value["price"]}",
                                      style: appCss.dmDenseBold16.textColor(
                                          appColor(context).appTheme.primary)))
                            ]))),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: Sizes.s40,
                      width: Sizes.s40,
                      padding: const EdgeInsets.all(Insets.i10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColor(context).appTheme.whiteColor,
                          border: Border.all(
                              color: appColor(context).appTheme.fieldCardBg,
                              width: 1)),
                      child: SvgPicture.asset(e.value["image"].toString(),
                          colorFilter: ColorFilter.mode(
                              appColor(context).appTheme.darkText,
                              BlendMode.srcIn)),
                    ).paddingAll(Insets.i3).decorated(
                        color: appColor(context).appTheme.whiteColor,
                        shape: BoxShape.circle))
              ]).height(Sizes.s125).width(Sizes.s110).inkWell(
                  onTap: () => value.onStatisticTapOption(e.key, context)))
        ])
                .paddingSymmetric(horizontal: Insets.i20)
                .marginOnly(bottom: Insets.i20),
      );
    });
  }
}
