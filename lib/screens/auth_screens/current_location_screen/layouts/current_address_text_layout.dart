import '../../../../config.dart';

class CurrentAddressTextLayout extends StatelessWidget {
  final String? currentAddress, street;
  const CurrentAddressTextLayout({super.key, this.currentAddress, this.street});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SvgPicture.asset(eSvgAssets.location,
                colorFilter: ColorFilter.mode(
                    appColor(context).appTheme.primary, BlendMode.srcIn))
            .paddingAll(Insets.i7)
            .decorated(
                color: appColor(context).appTheme.primary.withOpacity(0.15),
                shape: BoxShape.circle),
        const HSpace(Sizes.s12),
        if (currentAddress != null && street != null)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (currentAddress != null)
              Text(currentAddress!,
                  style: appCss.dmDenseBold14
                      .textColor(appColor(context).appTheme.darkText)),
            const VSpace(Sizes.s8),
            SizedBox(
                width: Sizes.s200,
                child: Text(street!,
                    style: appCss.dmDenseRegular12
                        .textColor(appColor(context).appTheme.lightText)))
          ])
      ])
    ])
        .paddingAll(Insets.i12)
        .boxBorderExtension(context,
            bColor: appColor(context).appTheme.fieldCardBg,
            color: appColor(context).appTheme.fieldCardBg,
            radius: AppRadius.r8)
        .paddingOnly(bottom: Insets.i15);
  }
}
