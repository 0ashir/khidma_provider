import '../config.dart';

class UploadImageLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? title;
  const UploadImageLayout({super.key, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
            color: appColor(context).appTheme.stroke,
            borderType: BorderType.RRect,
            radius: const Radius.circular(AppRadius.r10),
            child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.r8)),
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: appColor(context).appTheme.whiteBg,
                    child: Column(children: [
                      SvgPicture.asset(eSvgAssets.upload),
                      const VSpace(Sizes.s6),
                      Text(
                          language(
                              context, title ?? translations!.uploadLogoImage),
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).appTheme.lightText))
                    ]).paddingSymmetric(vertical: Insets.i15))))
        .paddingSymmetric(horizontal: Insets.i20)
        .inkWell(onTap: onTap);
  }
}
