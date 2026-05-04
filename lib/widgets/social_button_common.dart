import '../config.dart';

class SocialButtonCommon extends StatelessWidget {
  final dynamic data;
  final GestureTapCallback? onTap;
  const SocialButtonCommon({super.key,this.data,this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:  ShapeDecoration(
          color: appColor(context).appTheme.primary.withOpacity(0.1),

          shape:  SmoothRectangleBorder(
              side: BorderSide(color: appColor(context).appTheme.primary),
              borderRadius: const SmoothBorderRadius.all(
                  SmoothRadius(
                      cornerRadius: AppRadius.r8,
                      cornerSmoothing: 1)))),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(data["image"],colorFilter: ColorFilter.mode(appColor(context).appTheme.primary, BlendMode.srcIn)),
            const HSpace(Sizes.s4),
            Text(language(context, data["title"]),
                style: appCss.dmDenseMedium12.textColor(
                    appColor(context).appTheme.primary))
          ]).paddingSymmetric(vertical: Insets.i10,horizontal: Insets.i15),
    ).inkWell(onTap: onTap);
  }
}
