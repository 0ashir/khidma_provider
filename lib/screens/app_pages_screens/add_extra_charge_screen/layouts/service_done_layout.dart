import '../../../../config.dart';

class ServiceDoneLayout extends StatelessWidget {
  const ServiceDoneLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddExtraChargesProvider>(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Text(
              language(context, translations!.noOfServiceDoneByServicemen),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.darkText))),
      const HSpace(Sizes.s15),
      Stack(alignment: Alignment.center, children: [
        Container(
            width: Sizes.s100,
            height: Sizes.s40,
            decoration: BoxDecoration(
                color: appColor(context).appTheme.fieldCardBg,
                borderRadius: BorderRadius.circular(AppRadius.r6))),
        SizedBox(
            width: Sizes.s100,
            height: Sizes.s40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    IconButton(
                        onPressed: () => value.onRemoveService(),
                        icon: Icon(Icons.remove,
                            size: Sizes.s16,
                            color: appColor(context).appTheme.lightText)),
                    Text("${value.val}")
                  ]),
                  Container(
                      decoration: ShapeDecoration(
                          color: appColor(context).appTheme.primary,
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 6, cornerSmoothing: 1))),
                      child: IconButton(
                          onPressed: () => value.onAddService(),
                          icon: const Icon(Icons.add, size: Sizes.s16)))
                ]))
      ])
    ])
        .paddingAll(Insets.i15)
        .boxShapeExtension(
            color: appColor(context).appTheme.whiteBg, radius: AppRadius.r10)
        .paddingSymmetric(horizontal: Insets.i20);
  }
}
