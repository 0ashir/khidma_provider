import 'package:fixit_provider/screens/app_pages_screens/serviceman_detail_screen/serviceman_shimmer/serviceman_shimmer.dart';

import '../../../config.dart';

class ServicemanDetailScreen extends StatefulWidget {
  const ServicemanDetailScreen({super.key});

  @override
  State<ServicemanDetailScreen> createState() => _ServicemanDetailScreenState();
}

class _ServicemanDetailScreenState extends State<ServicemanDetailScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicemenDetailProvider>(
        builder: (context1, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: RefreshIndicator(
            onRefresh: () {
              return value.onRefresh(context);
            },
            child: value.widget1Opacity == 0.0
                ? const ServicemanShimmer()
                : Scaffold(
                    appBar: AppBar(
                        leadingWidth: 80,
                        title: Text(
                            language(context, translations!.servicemanDetail),
                            style: appCss.dmDenseBold18.textColor(
                                appColor(context).appTheme.darkText)),
                        centerTitle: true,
                        leading: CommonArrow(
                                arrow: rtl(context)
                                    ? eSvgAssets.arrowRight
                                    : eSvgAssets.arrowLeft,
                                onTap: () => value.onBack(context, true))
                            .paddingAll(Insets.i8),
                        actions: [
                          if (value.isIcons)
                            CommonArrow(
                                    arrow: eSvgAssets.delete,
                                    svgColor: appColor(context).appTheme.red,
                                    color: appColor(context)
                                        .appTheme
                                        .red
                                        .withOpacity(0.1),
                                    onTap: () =>
                                        value.onServicemenDelete(context, this))
                                .paddingSymmetric(horizontal: Insets.i20)
                        ]),
                    body: (value.widget1Opacity == 0.0)
                        ? const ServicemanShimmer()
                        : value.servicemanModel != null
                            ? SingleChildScrollView(
                                child: Column(children: [
                                Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      const ServicemenDetailProfileLayout(),
                                      const VSpace(Sizes.s20),
                                      PersonalInfoLayout(
                                          servicemanModel:
                                              value.servicemanModel)
                                    ])
                                    .paddingAll(Insets.i15)
                                    .boxBorderExtension(context, isShadow: true)
                                    .paddingSymmetric(
                                        horizontal: Insets.i20,
                                        vertical: Insets.i2)
                              ]).paddingSymmetric(vertical: Insets.i15))
                            : const ServicemanShimmer()),
          ),
        ),
      );
    });
  }
}
