import '../../../config.dart';

class CommissionDetailScreen extends StatelessWidget {
  const CommissionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesListProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(DurationsDelay.ms50)
            .then((vaj) => value.onReady(context)),
        child: LoadingComponent(
          child: Scaffold(
              appBar: AppBarCommon(
                  title: value.categoryModel == null
                      ? ""
                      : value.categoryModel!.title!),
              body: value.categoryModel == null
                  ? Container()
                  : Column(children: [
                      const VSpace(Sizes.s5),
                      Column(children: [
                        /* Container(
                        decoration: ShapeDecoration(
                            color: appColor(context).appTheme.primary.withOpacity(0.15),
                            shape: const SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.only(
                                    topRight: SmoothRadius(
                                        cornerRadius: AppRadius.r6, cornerSmoothing: 1),
                                    topLeft: SmoothRadius(
                                        cornerRadius: AppRadius.r6,
                                        cornerSmoothing: 1)))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language(context, translations!.acRepair),
                                  style: appCss.dmDenseMedium16
                                      .textColor(appColor(context).appTheme.primary)),
                              Text("30%",
                                  style: appCss.dmDenseMedium16
                                      .textColor(appColor(context).appTheme.primary)),
                            ]).paddingAll(Insets.i15)),*/
                        Column(children: [
                          ...value.categoryModel!.hasSubCategories!
                              .map((e) => CommissionRowCommon(data: e)),
                          const DottedLines().paddingOnly(bottom: Insets.i15),
                          Text(language(context, translations!.noteTheHighest),
                              style: appCss.dmDenseMedium12
                                  .textColor(appColor(context).appTheme.red))
                        ]).paddingAll(Insets.i15)
                      ]).boxBorderExtension(context, isShadow: true)
                    ]).paddingSymmetric(horizontal: Insets.i20)),
        ),
      );
    });
  }
}
