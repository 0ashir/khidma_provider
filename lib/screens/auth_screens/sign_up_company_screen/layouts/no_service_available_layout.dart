import '../../../../config.dart';

class NoServiceAvailableLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  const NoServiceAvailableLayout({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(language(context, translations!.listOfAvailableService),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.lightText))
          .alignment(Alignment.centerLeft)
          .paddingSymmetric(horizontal: Insets.i20),
      const VSpace(Sizes.s30),
      SvgPicture.asset(eSvgAssets.location,
              colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.lightText, BlendMode.srcIn))
          .paddingAll(Insets.i14)
          .decorated(
              color: appColor(context).appTheme.stroke, shape: BoxShape.circle),
      Text(language(context, translations!.addAtLeastOneArea),
              textAlign: TextAlign.center,
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.darkText))
          .paddingSymmetric(horizontal: Insets.i30, vertical: Insets.i10),
      ButtonCommon(
          title: "+ ${language(context, translations!.add)}",
          width: Sizes.s63,
          height: Sizes.s34,
          color: appColor(context).appTheme.trans,
          borderColor: appColor(context).appTheme.primary,
          style: appCss.dmDenseMedium12
              .textColor(appColor(context).appTheme.primary),
          onTap: onTap)
    ]);
  }
}
