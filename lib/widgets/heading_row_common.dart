import '../config.dart';

class HeadingRowCommon extends StatelessWidget {
  final String? title;
  final GestureTapCallback? onTap;
  final bool isViewAllShow;

  const HeadingRowCommon(
      {super.key, this.title, this.onTap, this.isViewAllShow = true});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
          width: Sizes.s200,
          child: Text(language(context, title!),
              overflow: TextOverflow.ellipsis,
              style: appCss.dmDenseBold18
                  .textColor(appColor(context).appTheme.darkText))),
      if (isViewAllShow)
        Text(language(context, translations!.viewAll),
                style: appCss.dmDenseRegular14
                    .textColor(appColor(context).appTheme.primary))
            .inkWell(onTap: onTap)
    ]);
  }
}