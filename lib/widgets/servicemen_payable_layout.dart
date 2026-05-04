import '../config.dart';

class ServicemenPayableLayout extends StatelessWidget {
  final String? amount;
  const ServicemenPayableLayout({super.key, this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(language(context, translations!.servicemenPayableAmount),
          style: appCss.dmDenseMedium14
              .textColor(appColor(context).appTheme.darkText)),
      const VSpace(Sizes.s8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("${getSymbol(context)}${amount ?? "0"}",
            style: appCss.dmDenseSemiBold14
                .textColor(appColor(context).appTheme.green)),
        Text("${getSymbol(context)}{language(context, translations!.perServicemen)}",
            style: appCss.dmDenseRegular12
                .textColor(appColor(context).appTheme.lightText))
      ]).paddingAll(Insets.i15).boxShapeExtension(
          radius: AppRadius.r10,
          color: appColor(context).appTheme.green.withOpacity(0.1)),
    ])
        .paddingAll(Insets.i15)
        .boxBorderExtension(context,
            isShadow: true,
            bColor: appColor(context).appTheme.stroke,
            radius: AppRadius.r12)
        .paddingOnly(top: Insets.i25);
  }
}
