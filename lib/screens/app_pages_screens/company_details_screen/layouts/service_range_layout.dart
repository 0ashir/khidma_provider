import '../../../../config.dart';

class ServiceRangeLayout extends StatelessWidget {
  final PrimaryAddress? data;
  final GestureTapCallback? onDelete, onEdit;
  final ValueChanged<bool>? onToggle;
  final int? index;
  final List? list;

  const ServiceRangeLayout(
      {super.key,
      this.data,
      this.onToggle,
      this.list,
      this.index,
      this.onDelete,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(children: [
        ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: SvgPicture.asset(eSvgAssets.location,
                    colorFilter: ColorFilter.mode(
                        appColor(context).appTheme.primary, BlendMode.srcIn))
                .paddingAll(Insets.i7)
                .decorated(
                    shape: BoxShape.circle,
                    color: appColor(context).appTheme.primary.withOpacity(0.1)),
            title: Row(children: [
              Text(language(context, "${data!.address} - ${data!.city}"),
                      overflow: TextOverflow.ellipsis,
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.darkText))
                  .width(Sizes.s110)
            ]),
            subtitle: Text(
                language(context, "${data!.state!.name} - ${data!.postalCode}"),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              CommonArrow(
                  arrow: eSvgAssets.edit, onTap: onEdit, isThirteen: true),
              const HSpace(Sizes.s10),
              CommonArrow(
                  arrow: eSvgAssets.delete,
                  color: appColor(context).appTheme.red.withOpacity(0.1),
                  svgColor: appColor(context).appTheme.red,
                  onTap: onDelete,
                  isThirteen: true)
            ])),
        const DividerCommon().paddingOnly(top: Insets.i10, bottom: Insets.i15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(language(context, translations!.serviceAvailable),
              style: appCss.dmDenseRegular12
                  .textColor(appColor(context).appTheme.darkText)),
          FlutterSwitchCommon(
              value: data!.status != null
                  ? data!.status == 1
                      ? true
                      : false
                  : false,
              onToggle: onToggle)
        ]).paddingOnly(bottom: Insets.i15)
      ])
          .paddingSymmetric(horizontal: Insets.i15)
          .boxShapeExtension(color: appColor(context).appTheme.fieldCardBg)
    ]);
  }
}
