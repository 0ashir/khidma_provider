import 'dart:ffi';

import 'package:intl/intl.dart';

import '../../../../config.dart';

class PackageLayout extends StatelessWidget {
  final ServicePackageModel? data;
  final ValueChanged<bool>? onToggle;
  final GestureTapCallback? onDelete, onEdit;

  const PackageLayout(
      {super.key, this.data, this.onToggle, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                    height: Sizes.s60,
                    width: Sizes.s60,
                    child: Image.asset(eImageAssets.package,
                        height: Sizes.s60,
                        width: Sizes.s60,
                        fit: BoxFit.cover)),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language(context, data!.title!),
                            overflow: TextOverflow.ellipsis,
                            style: appCss.dmDenseMedium16.textColor(
                                appColor(context).appTheme.darkText)),
                        const VSpace(Sizes.s3),
                        Text(
                            language(
                                context,
                                symbolPosition
                                    ? "${getSymbol(context)}${(currency(context).currencyVal * (data!.price!)).toStringAsFixed(2)}"
                                    : "${(currency(context).currencyVal * (data!.price!)).toStringAsFixed(2)}${getSymbol(context)}"),
                            style: appCss.dmDenseblack16
                                .textColor(appColor(context).appTheme.online)),
                      ]).padding(top: Insets.i5, horizontal: Insets.i12),
                )
              ]),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              CommonArrow(
                  arrow: eSvgAssets.edit, onTap: onEdit, isThirteen: true),
              const HSpace(Sizes.s10),
              CommonArrow(
                  arrow: eSvgAssets.delete,
                  color: appColor(context).appTheme.red.withOpacity(0.1),
                  svgColor: appColor(context).appTheme.red,
                  onTap: onDelete,
                  isThirteen: true)
            ])
          ]).paddingOnly(top: Insets.i17),
      IntrinsicHeight(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PackageDetailRowLayout(
            title: translations!.startDate,
            subtext: DateFormat("dd MMM, yyyy")
                .format(DateTime.parse(data!.startedAt!))),
        const PackageVerticalDivider(),
        PackageDetailRowLayout(
            title: translations!.endDate,
            subtext: DateFormat("dd MMM, yyyy")
                .format(DateTime.parse(data!.endedAt!))),
        const PackageVerticalDivider(),
        PackageDetailRowLayout(
            title: translations!.serviceIncluded,
            subtext: data?.serviceCount.toString())
      ])),
      const DottedLines(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, translations!.activeStatus),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.primary)),
        FlutterSwitchCommon(
            value: data!.status == 1 ? true : false, onToggle: onToggle)
      ]).paddingOnly(top: Insets.i14, bottom: Insets.i17)
    ])
        .paddingSymmetric(horizontal: Insets.i15)
        .boxBorderExtension(context,
            isShadow: true, bColor: appColor(context).appTheme.stroke)
        .paddingOnly(bottom: Insets.i15)
        .inkWell(onTap: () {
      Provider.of<PackageDetailProvider>(context, listen: false)
          .getServicePackageById(context, data!.id);
      route.pushNamed(context, routeName.packageDetails);
    });
  }
}
