import '../config.dart';

class ViewLocationCommon extends StatelessWidget {
  final PrimaryAddress? address;

  const ViewLocationCommon({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: ShapeDecoration(
                color: appColor(context).appTheme.primary.withOpacity(0.15),
                shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        bottomRight: SmoothRadius(
                            cornerRadius: AppRadius.r8, cornerSmoothing: 1),
                        bottomLeft: SmoothRadius(
                            cornerRadius: AppRadius.r8, cornerSmoothing: 1)))),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      language(context, translations!.viewLocationOnMap)
                          .toUpperCase(),
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.primary)),
                  ArrowRightCommon(onTap: () {
                    route.pushNamed(context, routeName.viewLocation, arg: {
                      'latitude': address!.latitude,
                      "longitude": address!.longitude
                    });
                  })
                ]).padding(
                horizontal: Insets.i15, top: Insets.i13, bottom: Insets.i11))
        .inkWell(onTap: () {
      route.pushNamed(context, routeName.viewLocation, arg: {
        'latitude': address!.latitude,
        "longitude": address!.longitude
      });
    } /* => route.pushNamed(context, routeName.viewLocation, arg: {
                  'latitude': address!.latitude,
                  "longitude": address!.longitude
                }) */
            );
  }
}
