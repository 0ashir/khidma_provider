import '../../../config.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationListProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationsDelay.ms150)
              .then((_) => value.onReady(context)),
          child: LoadingComponent(
              child: Scaffold(
                  appBar: AppBar(
                      leadingWidth: 80,
                      title: Text(language(context, translations!.locationList),
                          style: appCss.dmDenseBold18
                              .textColor(appColor(context).appTheme.darkText)),
                      centerTitle: true,
                      leading: CommonArrow(
                              arrow: rtl(context)
                                  ? eSvgAssets.arrowRight
                                  : eSvgAssets.arrowLeft,
                              onTap: () => route.pop(context))
                          .paddingAll(Insets.i8),
                      actions: [
                        CommonArrow(
                                arrow: eSvgAssets.add,
                                onTap: () => route.pushNamed(
                                    context, routeName.location))
                            .paddingOnly(right: Insets.i20)
                      ]),
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          ...addressList.asMap().entries.map((e) =>
                              ServicemanListLayout(
                                  isCheck: value.selectedLocation
                                      .contains(e.value.id),
                                  onIconTap: () =>
                                      value.onTapLocation(e.value.id, e.value),
                                  isBorder: true,
                                  onEdit: () => value.onEditLocation(
                                      e.key, e.value, context),
                                  onDelete: () => value.onLocationDelete(
                                      e.key, context, this, e.value.id),
                                  data: e.value,
                                  index: e.key,
                                  list: value.locationList))
                        ]),
                        ButtonCommon(
                            title: translations!.addSelectLocation,
                            onTap: () => value.onAddSelectLocation(context),
                            style: appCss.dmDenseRegular16.textColor(
                                value.selectedLocation.isNotEmpty
                                    ? appColor(context).appTheme.whiteColor
                                    : appColor(context).appTheme.primary),
                            color: value.selectedLocation.isNotEmpty
                                ? appColor(context).appTheme.primary
                                : appColor(context).appTheme.trans,
                            borderColor: appColor(context).appTheme.primary)
                      ]).paddingSymmetric(
                      horizontal: Insets.i20, vertical: Insets.i20))));
    });
  }
}
