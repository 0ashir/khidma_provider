import '../../../common_shimmer/service_shimmer.dart';
import '../../../config.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServiceListProvider>(
        builder: (context1, lang, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(const Duration(milliseconds: 150),
                () => value.onReady(context, this)),
            child: Scaffold(
                appBar: AppBar(
                    leadingWidth: 80,
                    title: Text(language(context, translations!.serviceList),
                        style: appCss.dmDenseBold18
                            .textColor(appColor(context).appTheme.darkText)),
                    centerTitle: true,
                    leading: CommonArrow(
                            arrow: rtl(context)
                                ? eSvgAssets.arrowRight
                                : eSvgAssets.arrowLeft,
                            onTap: () => value.onBack(context, true))
                        .paddingAll(Insets.i8),
                    actions: [
                      if (categoryList.isNotEmpty)
                        CommonArrow(
                                arrow: eSvgAssets.search,
                                onTap: () =>
                                    route.pushNamed(context, routeName.search))
                            .paddingOnly(right: Insets.i10),
                      CommonArrow(
                              arrow: eSvgAssets.add,
                              onTap: () {
                                appArray.webServiceImageList.clear();
                                route.pushNamed(
                                    context, routeName.addNewService);
                              })
                          .paddingOnly(
                              right: Insets.i20,
                              left: lang.getLocal() == 'ar' ? Insets.i20 : 0)
                    ]),
                body: /* categoryList.isEmpty
                    ? const CommonEmpty()
                    : */
                    SingleChildScrollView(
                        child: Column(children: [
                  if (value.demoList.isNotEmpty)
                    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(language(context, translations!.categories),
                                  style: appCss.dmDenseMedium12.textColor(
                                      appColor(context).appTheme.lightText))
                              .paddingSymmetric(horizontal: Insets.i20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: IntrinsicHeight(
                                      child: Row(
                                              children: value.demoList
                                                  .asMap()
                                                  .entries
                                                  .map((e) {
                                    return TopCategoriesLayout(
                                        index: e.key,
                                        rPadding: Sizes.s10,
                                        isCategories: false,
                                        data: e.value,
                                        selectedIndex: value.selectedIndex,
                                        onTap: () => value.onSubCategories(
                                            context, e.key, e.value.id));
                                  }).toList())
                                          .padding(
                                              vertical: Insets.i15,
                                              left: Insets.i20)))
                            ],
                          )
                        ])
                        .paddingSymmetric(vertical: Insets.i15)
                        .decorated(
                            color: appColor(context).appTheme.fieldCardBg)
                        .paddingOnly(top: Insets.i10, bottom: Insets.i25)
                        .width(MediaQuery.of(context).size.width),
                  value.isLoading
                      ? const ServicesShimmer(count: 3)
                          .padding(horizontal: Insets.i20)
                      : value.filteredServices.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 Services Title
                                Text(
                                  language(context, translations!.services),
                                  style: appCss.dmDenseBold16.textColor(
                                    appColor(context).appTheme.darkText,
                                  ),
                                ).paddingOnly(
                                  left: rtl(context) ? 0 : Insets.i20,
                                  right: rtl(context) ? Insets.i20 : 0,
                                  bottom: Insets.i10,
                                ),

                                // 🔹 Service List
                                ...value.filteredServices
                                    .asMap()
                                    .entries
                                    .map((e) => FeaturedServicesLayout(
                                          data: e.value,
                                          onToggle: (val) =>
                                              Provider.of<ServiceListProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateActiveStatusService(
                                                      context,
                                                      e.value.id,
                                                      val,
                                                      e.key),
                                          onTap: () => route.pushNamed(
                                              context, routeName.serviceDetails,
                                              arg: {"detail": e.value.id}),
                                        ).paddingSymmetric(
                                            horizontal: Insets.i20))
                                    .toList(),
                              ],
                            ).marginOnly(top: Insets.i15)
                          : CommonEmpty()
                ])))),
      );
    });
  }
}
