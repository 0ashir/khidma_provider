import '../../../../config.dart';

class ServiceAreaLayout extends StatefulWidget {
  final GestureTapCallback? onTapAdd;

  const ServiceAreaLayout({super.key, this.onTapAdd});

  @override
  State<ServiceAreaLayout> createState() => _ServiceAreaLayoutState();
}

class _ServiceAreaLayoutState extends State<ServiceAreaLayout>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationListProvider, ServiceDetailsProvider>(
        builder: (context, value, service, child) {
      return Column(children: [
        Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(language(context, translations!.serviceAvailableArea),
                style: appCss.dmDenseRegular14
                    .textColor(appColor(context).appTheme.lightText)),
            Text(language(context, "+${language(context, translations!.add)}"),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.primary))
                .inkWell(onTap: widget.onTapAdd)
          ]).paddingSymmetric(vertical: Insets.i10),
          if (service.services!.serviceAvailabilities != null)
            ...service.services!.serviceAvailabilities!
                .asMap()
                .entries
                .map((e) => ServicemanListLayout(
                    isDetail: true,
                    onDelete: () => service.onTapDetailLocationDelete(
                        e.value.id, context, this, e.key),
                    data: e.value.address,
                    index: e.key,
                    list: service.services!.serviceAvailabilities!))
                .toList()
        ])
      ]);
    });
  }
}
