import '../../../../config.dart';

class ProfileOptionLayout extends StatelessWidget {
  final dynamic data;
  final GestureTapCallback? onTap;
  final List? list;
  final int? index, indexMain;

  const ProfileOptionLayout(
      {super.key,
      this.data,
      this.onTap,
      this.list,
      this.index,
      this.indexMain});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                CommonArrow(
                    arrow: data.icon,
                    color: indexMain == 2
                        ? appColor(context).appTheme.whiteBg
                        : appColor(context).appTheme.fieldCardBg,
                    svgColor: indexMain == 2
                        ? appColor(context).appTheme.red
                        : appColor(context).appTheme.darkText),
                const HSpace(Sizes.s15),
                Text(language(context, data.title),
                    style: appCss.dmDenseMedium14.textColor(indexMain == 2
                        ? appColor(context).appTheme.red
                        : appColor(context).appTheme.darkText))
              ]),
              if (data.isArrow == true)
                SvgPicture.asset(
                    rtl(context) ? eSvgAssets.arrowLeft : eSvgAssets.arrowRight,
                    colorFilter: ColorFilter.mode(
                        appColor(context).appTheme.lightText, BlendMode.srcIn))
            ]),
            if (index != list!.length - 1)
              Divider(
                      height: 0,
                      color: indexMain == 2
                          ? appColor(context).appTheme.red.withOpacity(0.1)
                          : appColor(context).appTheme.fieldCardBg,
                      thickness: 1)
                  .paddingSymmetric(vertical: Insets.i12)
          ])
        ]).inkWell(onTap: onTap);
  }
}
